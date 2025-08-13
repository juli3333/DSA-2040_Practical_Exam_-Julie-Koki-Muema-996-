## TASK 1
# Explain why you chose star schema over snowflake (2-3 sentences). 
- Because a star schema reduces the need for joins and speeds up queries, it simplifies analytics by connecting fact tables directly to denormalized dimensions.  Additionally, analysts find it easier to use, and query optimizers find it simpler.  Through normalization, a snowflake schema would save some storage, but it would introduce needless complexity and offer no discernible performance improvements for this application.

# Star Schema Design 

- Facts: FactSales (grain: one row per transaction line) measures: quantity, unit_price, discount_amount, sales_amount.

- FactInventorySnapshot (grain: one row per product–store–day) measures: on_hand_qty, on_order_qty, safety_stock, reorder_point.

- Dimensions: DimDate, DimProduct, DimCustomer, DimStore.

- Diagram: see Star Schema Diagram.png (exported from Mermaid file).

- DDL: see retail_dw.sqbpro 
