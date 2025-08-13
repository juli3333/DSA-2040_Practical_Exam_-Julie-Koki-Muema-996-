PRAGMA foreign_keys = ON;

-- ========================
-- DIMENSIONS
-- ========================
CREATE TABLE IF NOT EXISTS DimDate (
    date_key        INTEGER PRIMARY KEY,             -- e.g., 20250415
    full_date_iso   TEXT    NOT NULL,                -- 'YYYY-MM-DD'
    day_of_month    INTEGER NOT NULL CHECK(day_of_month BETWEEN 1 AND 31),
    month_num       INTEGER NOT NULL CHECK(month_num BETWEEN 1 AND 12),
    month_name      TEXT    NOT NULL,
    quarter         INTEGER NOT NULL CHECK(quarter BETWEEN 1 AND 4),
    year            INTEGER NOT NULL,
    is_weekend      INTEGER NOT NULL CHECK(is_weekend IN (0,1))
);

CREATE UNIQUE INDEX IF NOT EXISTS ix_DimDate_full_date_iso
    ON DimDate(full_date_iso);

CREATE TABLE IF NOT EXISTS DimProduct (
    product_key     INTEGER PRIMARY KEY,
    product_sku     TEXT    NOT NULL,
    product_name    TEXT    NOT NULL,
    category        TEXT    NOT NULL,
    subcategory     TEXT,
    brand           TEXT,
    unit_of_measure TEXT,
    unit_cost       REAL,
    active_flag     TEXT    DEFAULT 'Y'              -- 'Y'/'N'
);

CREATE INDEX IF NOT EXISTS ix_DimProduct_category
    ON DimProduct(category, subcategory);

CREATE TABLE IF NOT EXISTS DimCustomer (
    customer_key    INTEGER PRIMARY KEY,
    customer_id_bk  TEXT    NOT NULL,                -- business key from source
    full_name       TEXT,
    gender          TEXT,                            -- e.g., 'F','M','Other','N/A'
    birth_date_iso  TEXT,                            -- 'YYYY-MM-DD'
    age_years       INTEGER,
    city            TEXT,
    region          TEXT,
    country         TEXT
);

CREATE INDEX IF NOT EXISTS ix_DimCustomer_geo
    ON DimCustomer(country, region, city);

CREATE TABLE IF NOT EXISTS DimStore (
    store_key   INTEGER PRIMARY KEY,
    store_id_bk TEXT    NOT NULL,
    store_name  TEXT,
    city        TEXT,
    region      TEXT,
    country     TEXT
);

CREATE INDEX IF NOT EXISTS ix_DimStore_geo
    ON DimStore(country, region, city);

-- ========================
-- FACTS
-- ========================
CREATE TABLE IF NOT EXISTS FactSales (
    sales_id        INTEGER PRIMARY KEY,
    date_key        INTEGER NOT NULL,
    product_key     INTEGER NOT NULL,
    customer_key    INTEGER,
    store_key       INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK(quantity >= 0),
    unit_price      REAL    NOT NULL CHECK(unit_price >= 0.0),
    discount_amount REAL    NOT NULL DEFAULT 0.0 CHECK(discount_amount >= 0.0),
    sales_amount    REAL    NOT NULL,                -- ETL: quantity*unit_price - discount_amount

    FOREIGN KEY(date_key)    REFERENCES DimDate(date_key)       ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(product_key) REFERENCES DimProduct(product_key) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(customer_key)REFERENCES DimCustomer(customer_key)ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(store_key)   REFERENCES DimStore(store_key)     ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS ix_FactSales_date    ON FactSales(date_key);
CREATE INDEX IF NOT EXISTS ix_FactSales_prod    ON FactSales(product_key);
CREATE INDEX IF NOT EXISTS ix_FactSales_store   ON FactSales(store_key);
CREATE INDEX IF NOT EXISTS ix_FactSales_cust    ON FactSales(customer_key);

-- Inventory snapshot fact for trends over time
CREATE TABLE IF NOT EXISTS FactInventorySnapshot (
    snapshot_id     INTEGER PRIMARY KEY,
    date_key        INTEGER NOT NULL,
    product_key     INTEGER NOT NULL,
    store_key       INTEGER NOT NULL,
    on_hand_qty     INTEGER NOT NULL CHECK(on_hand_qty >= 0),
    on_order_qty    INTEGER NOT NULL DEFAULT 0 CHECK(on_order_qty >= 0),
    safety_stock    INTEGER,
    reorder_point   INTEGER,

    FOREIGN KEY(date_key)    REFERENCES DimDate(date_key)       ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(product_key) REFERENCES DimProduct(product_key) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(store_key)   REFERENCES DimStore(store_key)     ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_InvSnap_day_prod_store
    ON FactInventorySnapshot(date_key, product_key, store_key);

CREATE INDEX IF NOT EXISTS ix_InvSnap_prod    ON FactInventorySnapshot(product_key);
CREATE INDEX IF NOT EXISTS ix_InvSnap_store   ON FactInventorySnapshot(store_key);
CREATE INDEX IF NOT EXISTS ix_InvSnap_date    ON FactInventorySnapshot(date_key);
