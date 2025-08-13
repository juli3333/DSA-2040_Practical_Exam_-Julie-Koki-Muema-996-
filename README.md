## TASK 1
# Explain why you chose star schema over snowflake (2-3 sentences). 
- Because a star schema reduces the need for joins and speeds up queries, it simplifies analytics by connecting fact tables directly to denormalized dimensions.  Additionally, analysts find it easier to use, and query optimizers find it simpler.  Through normalization, a snowflake schema would save some storage, but it would introduce needless complexity and offer no discernible performance improvements for this application.

# Star Schema Design 

- Facts: FactSales (grain: one row per transaction line) measures: quantity, unit_price, discount_amount, sales_amount.

- FactInventorySnapshot (grain: one row per product–store–day) measures: on_hand_qty, on_order_qty, safety_stock, reorder_point.

- Dimensions: DimDate, DimProduct, DimCustomer, DimStore.

- Diagram: see Star Schema Diagram.png (exported from Mermaid file).

- DDL: see retail_dw.sqbpro 

# The project covers the following objectives:

- Preprocess and clean data for machine learning tasks.

- Explore data to understand distributions, correlations, and potential outliers.

- Apply unsupervised learning (K-Means) and evaluate cluster quality.

- Train supervised learning models (Decision Tree, KNN) and compare performance.

- Perform association rule mining to uncover co-occurrence patterns in transactions.



# Step 1: Data Preprocessing
Objective: Prepare the dataset for machine learning tasks.

Methods:

Load the Iris dataset into a pandas DataFrame.

Checked for missing values and handled them (none in Iris, but procedure demonstrated).

Normalized features using Min-Max scaling.

Encoded class labels (one-hot or numeric encoding for supervised models).

Outcome: Data ready for analysis, ensuring models perform correctly without bias from scale or missing values.

# Step 2: Data Exploration
Objective: Understand feature distributions, relationships, and potential anomalies.

Methods:

Computed summary statistics (mean, std, min, max) using df.describe().

Visualized feature relationships using a pairplot.

Checked correlations with a heatmap.

Detected outliers with boxplots.

Split the dataset into training (80%) and testing (20%) sets.

Outcome: Identified key patterns, correlations, and potential data issues before modeling.

# Step 3: Clustering (Unsupervised Learning)
Objective: Group data points without using class labels.

Methods:

Applied K-Means clustering with k=3 (matching Iris species).

Compared predicted clusters with true labels using Adjusted Rand Index (ARI).

Experimented with k=2 and k=4, plotted an elbow curve to justify the optimal number of clusters.

Visualized clusters using scatter plots (petal length vs petal width).

Outcome: Clusters closely matched actual species; visualization and ARI confirmed cluster quality.

# Step 4: Classification (Supervised Learning)
Objective: Predict species labels using features.

Methods:

Trained a Decision Tree classifier and predicted on the test set.

Calculated accuracy, precision, recall, and F1-score.

Visualized the decision tree structure using plot_tree.

Trained a KNN classifier (k=5) and compared metrics with Decision Tree.

Outcome: Both models performed well; Decision Tree chosen for interpretability and insight into feature importance.

# Step 5: Association Rule Mining
Objective: Discover patterns of co-occurring items in transactional data.

Methods:

Generated synthetic transactional data (20–50 transactions, 3–8 items each).

Applied Apriori algorithm with min_support=0.2 and min_confidence=0.5.

Sorted rules by lift and displayed top 5 rules.

Analyzed one rule and discussed its real-world implications for retail, such as product placement or promotions.

Outcome: Demonstrated how association rule mining can reveal actionable insights for marketing or sales strategy.

