"""
AdventureWorks Sales Analytics — Python Cleaning Script
Stage 1 of 4: Data Cleaning & Feature Engineering
Author: [Your Name]
"""

import pandas as pd
import numpy as np
import os

os.makedirs("data", exist_ok=True)

# ─────────────────────────────────────────
# 1. LOAD & COMBINE ALL 3 YEARS
# ─────────────────────────────────────────
sales_2020 = pd.read_csv("AdventureWorks Sales Data 2020.csv")
sales_2021 = pd.read_csv("AdventureWorks Sales Data 2021.csv")
sales_2022 = pd.read_csv("AdventureWorks Sales Data 2022.csv")

# Tag each year before combining
sales_2020["Year"] = 2020
sales_2021["Year"] = 2021
sales_2022["Year"] = 2022

df = pd.concat([sales_2020, sales_2021, sales_2022], ignore_index=True)
print(f"✅ Combined shape: {df.shape}")
print(f"   2020: {len(sales_2020)} rows")
print(f"   2021: {len(sales_2021)} rows")
print(f"   2022: {len(sales_2022)} rows")


# ─────────────────────────────────────────
# 2. LOAD LOOKUP TABLES
# ─────────────────────────────────────────
customers   = pd.read_csv("AdventureWorks Customer Lookup.csv", encoding="latin1")
products    = pd.read_csv("AdventureWorks Product Lookup.csv", encoding="latin1")
categories  = pd.read_csv("AdventureWorks Product Categories Lookup.csv", encoding="latin1")
subcategories = pd.read_csv("AdventureWorks Product Subcategories Lookup.csv", encoding="latin1")
territories = pd.read_csv("AdventureWorks Territory Lookup.csv", encoding="latin1")
returns     = pd.read_csv("AdventureWorks Returns Data.csv", encoding="latin1")
calendar    = pd.read_csv("AdventureWorks Calendar Lookup.csv", encoding="latin1")

print(f"\n✅ Lookup tables loaded:")
print(f"   Customers:      {customers.shape}")
print(f"   Products:       {products.shape}")
print(f"   Categories:     {categories.shape}")
print(f"   Subcategories:  {subcategories.shape}")
print(f"   Territories:    {territories.shape}")
print(f"   Returns:        {returns.shape}")
print(f"   Calendar:       {calendar.shape}")


# ─────────────────────────────────────────
# 3. CLEAN SALES DATA
# ─────────────────────────────────────────

# Parse dates
df["OrderDate"] = pd.to_datetime(df["OrderDate"])
df["StockDate"] = pd.to_datetime(df["StockDate"])

# Extract date parts
df["OrderYear"]    = df["OrderDate"].dt.year
df["OrderMonth"]   = df["OrderDate"].dt.month
df["OrderMonthName"] = df["OrderDate"].dt.strftime("%B")
df["OrderQuarter"] = df["OrderDate"].dt.quarter
df["OrderDayOfWeek"] = df["OrderDate"].dt.strftime("%A")

# Days between stock and order (lead time)
df["StockToOrderDays"] = (df["OrderDate"] - df["StockDate"]).dt.days

# Drop duplicates
before = len(df)
df.drop_duplicates(inplace=True)
print(f"\n✅ Removed {before - len(df)} duplicate rows")

# Check nulls
print(f"\nNull values:\n{df.isnull().sum()}")


# ─────────────────────────────────────────
# 4. ENRICH WITH LOOKUP DATA
# ─────────────────────────────────────────

# Merge products
print(f"\nProduct columns: {products.columns.tolist()}")
product_key_col = [c for c in products.columns if "key" in c.lower()][0]
products_slim = products[[product_key_col,
                           [c for c in products.columns if "name" in c.lower() or "Name" in c][0],
                           [c for c in products.columns if "price" in c.lower() or "Price" in c or "Cost" in c.lower()][0]
                          ]].copy()
products_slim.columns = ["ProductKey", "ProductName", "ProductPrice"]
df = df.merge(products_slim, on="ProductKey", how="left")

# Merge territories
print(f"Territory columns: {territories.columns.tolist()}")
territory_key_col = [c for c in territories.columns if "key" in c.lower()][0]
territory_region_col = [c for c in territories.columns if "region" in c.lower() or "Region" in c or "country" in c.lower()][0]
territories_slim = territories[[territory_key_col, territory_region_col]].copy()
territories_slim.columns = ["TerritoryKey", "Region"]
df = df.merge(territories_slim, on="TerritoryKey", how="left")

# Calculate revenue
df["Revenue"] = df["ProductPrice"] * df["OrderQuantity"]

print(f"\n✅ Enriched dataframe shape: {df.shape}")
print(f"   Total Revenue: ${df['Revenue'].sum():,.2f}")
print(f"   Total Orders: {df['OrderNumber'].nunique():,}")
print(f"   Total Quantity Sold: {df['OrderQuantity'].sum():,}")


# ─────────────────────────────────────────
# 5. CLEAN RETURNS DATA
# ─────────────────────────────────────────
returns["ReturnDate"] = pd.to_datetime(returns[returns.columns[0]], errors="coerce")
returns.columns = [c.strip() for c in returns.columns]
print(f"\n✅ Returns columns: {returns.columns.tolist()}")


# ─────────────────────────────────────────
# 6. EXPORT CLEAN FILES
# ─────────────────────────────────────────
df.to_csv("data/aw_sales_clean.csv", index=False)
customers.to_csv("data/aw_customers_clean.csv", index=False)
products.to_csv("data/aw_products_clean.csv", index=False)
territories.to_csv("data/aw_territories_clean.csv", index=False)
returns.to_csv("data/aw_returns_clean.csv", index=False)
categories.to_csv("data/aw_categories_clean.csv", index=False)
subcategories.to_csv("data/aw_subcategories_clean.csv", index=False)

print(f"\n{'='*50}")
print("FINAL SUMMARY")
print(f"{'='*50}")
print(f"Total Sales Records: {len(df):,}")
print(f"Date Range: {df['OrderDate'].min().date()} to {df['OrderDate'].max().date()}")
print(f"Total Revenue: ${df['Revenue'].sum():,.2f}")
print(f"Unique Products: {df['ProductKey'].nunique():,}")
print(f"Unique Customers: {df['CustomerKey'].nunique():,}")
print(f"Unique Territories: {df['TerritoryKey'].nunique():,}")
print(f"\n✅ All clean files saved to data/ folder")
print("Ready for Stage 2 — SQL Analysis!")






import pandas as pd

df = pd.read_csv("data/aw_sales_clean.csv", encoding="utf-8-sig")

# Export with pipe delimiter instead of comma
df.to_csv("data/aw_sales_clean.csv", index=False, sep="|", encoding="utf-8")
print("✅ Exported with pipe delimiter")
print(df[["ProductName", "ProductPrice", "Revenue"]].head(3))





import pandas as pd

df = pd.read_csv("data/aw_sales_final.csv", sep="|", encoding="utf-8")

# Check the actual bytes in Revenue
sample = df["Revenue"].iloc[0]
print(f"Value: {sample}")
print(f"Type: {type(sample)}")
print(f"Repr: {repr(sample)}")
print(f"Bytes: {sample.encode('utf-8') if isinstance(sample, str) else 'not string'}")