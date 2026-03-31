# Last Call or First Mover?

### Brewery Market Saturation & Opportunity Index for Asheville, NC

![Python](https://img.shields.io/badge/Python-pandas%20|%20scikit--learn-3776AB?logo=python&logoColor=white)
![Azure SQL](https://img.shields.io/badge/Azure%20SQL-Cloud%20Database-0078D4?logo=microsoftazure&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-Dashboard-E97627?logo=tableau&logoColor=white)
![ArcGIS](https://img.shields.io/badge/ArcGIS-Geospatial%20Map-2C7AC3?logo=arcgis&logoColor=white)
![JMP](https://img.shields.io/badge/JMP-Statistical%20Analysis-007ACC)
![SQL](https://img.shields.io/badge/SQL-Azure%20Data%20Studio-CC2927?logo=microsoftsqlserver&logoColor=white)

---

**Marvin Pears** · UNC Charlotte · M.S. Data Science & Business Analytics · 2026

A data-driven analysis of 32 breweries in Asheville, NC to determine which neighborhoods are oversaturated and which represent the best opportunity for a new brewery. Built using Python, SQL, Tableau, ArcGIS, and JMP across a full pipeline from raw data to interactive dashboards.

---

## Table of Contents

- [Data](#data)
- [Methodology](#methodology)
- [Project Structure](#project-structure)
- [Key Findings](#key-findings)
- [Data Limitations](#data-limitations)
- [How to Reproduce](#how-to-reproduce)
- [Tools](#tools)
- [Live Links](#live-links)
- [Acknowledgements](#acknowledgements)

---

## Data

**Final dataset:** 32 active breweries within Asheville city limits.

| Source | Description |
|--------|-------------|
| NC Brewery Excel File | Starting point — 284 rows of NC breweries, filtered to 32 |
| Google Maps | Google ratings and review counts for each brewery |
| Brewery Websites | `craft_beer_total` — manually counted from each brewery's menu page |
| City of Asheville Open Data | City limits boundary shapefile from `gis.ashevillenc.gov` |

**Final columns:** `brewery_name`, `brewery_type`, `neighborhood`, `cluster`, `market_signal`, `saturation_rank`, `city`, `state`, `latitude`, `longitude`, `google_rating`, `google_review_count`, `craft_beer_total`, `beer_menu_tier`, `website_url`, `data_status`

---

## Methodology

### Step 1 — Data Collection

Started with a raw NC brewery file containing 284 rows. Filtered down to only breweries physically inside Asheville city limits using verified GPS coordinates and the official city boundary shapefile. Removed closed breweries, venues without a website or active social media, and locations outside the boundary (Salt Face Mule, Whistle Hop, Zillicoah, Riverside Rhapsody, Foggy Mountain). Manually collected `craft_beer_total` from each brewery's website. Final count: 32 active breweries.

### Step 2 — Data Cleaning (Python)

Used pandas to fix a duplicate/corrupted brewery name, convert `craft_beer_total = 0` to NULL (meaning "not listed on website," not truly zero beers), and fill in 2 missing `brewery_type` values. Output: `asheville_breweries_clean.csv`.

### Step 3 — Azure SQL Ingestion

Created a `dbo.breweries` table in an Azure SQL database (`avl_brews`). Used Python with SQLAlchemy and pyodbc to load the CSV, authenticating through Microsoft Entra (Azure AD token injection) since the UNCC Azure environment blocks traditional SQL authentication. Required installing `unixodbc` and `msodbcsql18` via Homebrew on Mac.

### Step 4 — SQL Cleaning & Transformation

Ran SQL queries in Azure Data Studio to verify brewery types, fix one remaining NULL, add a `neighborhood` column using CASE WHEN logic on latitude/longitude coordinates (7 zones), and create a clean view (`dbo.vw_breweries_clean`) for downstream tools.

### Step 5 — Geospatial Mapping (ArcGIS Online)

Uploaded 3 GeoJSON files to ArcGIS Online: the city boundary polygon, brewery point locations, and neighborhood zone polygons. Styled brewery dots by neighborhood color and sized them by `google_review_count`. Neighborhood zones are colored by market signal — red for Hypersaturated, orange for Highly Saturated, and green for High Opportunity.

### Step 6 — Tableau Dashboard

Built a 4-chart interactive dashboard connected by a neighborhood filter:

1. **Neighborhood Performance** — Average Google rating by neighborhood with a fleet average reference line
2. **Menu Size vs Rating** — Scatter plot of `craft_beer_total` vs `google_rating` with bubble size by review count
3. **Brewery Type by Neighborhood** — Stacked bar showing the mix of Brewpubs, Taprooms, and Regional Breweries
4. **Review Volume Ranking** — Horizontal bar chart of all 32 breweries sorted by `google_review_count`

### Step 7 — Statistical Analysis (JMP)

Ran four formal statistical tests:

| Test | Variables | Result | Interpretation |
|------|-----------|--------|----------------|
| Correlation | `google_rating` vs `craft_beer_total` | r = −0.013 | No relationship — menu size doesn't affect ratings |
| ANOVA | `google_rating` by `neighborhood` | p = 0.245 | Not significant — all 7 neighborhoods perform equally |
| ANOVA | `google_rating` by `brewery_type` | p = 0.107 | Not significant — Taprooms, Brewpubs, and Regional Breweries earn similar ratings |
| ANOVA | `google_review_count` by `brewery_type` | p = 0.018 ✅ | **Significant** — Regional Breweries average 1,879 reviews vs Taprooms at 434 |

---

## Project Structure

```
avl_brews/
│
├── data/
│   ├── raw/
│   │   └── asheville_brews.xlsx              # Original 284-row NC brewery file
│   ├── clean/
│   │   ├── asheville_breweries_clean.csv      # 32-row cleaned dataset
│   │   └── asheville_tableau.csv              # Tableau-ready file with derived columns
│   └── geojson/
│       ├── asheville_breweries_points.geojson  # 32 brewery point features
│       └── asheville_neighborhoods.geojson     # 7 neighborhood zone polygons
│
├── sql/
│   ├── create_table.sql                       # DDL for dbo.breweries
│   └── clean_and_transform.sql                # Neighborhood assignment + clean view
│
├── notebooks/
│   └── transfer_code.ipynb                    # Python → Azure SQL ingestion script
│
├── tableau/
│   └── Asheville_Brewery_Market_Analysis.twb  # Tableau workbook (4-chart dashboard)
│
├── screenshots/
│   ├── tableau_dashboard.png
│   ├── tableau_south_slope.png
│   ├── tableau_north_asheville.png
│   ├── tableau_river_arts.png
│   ├── tableau_biltmore_park.png
│   ├── tableau_review_ranking.png
│   ├── tableau_menu_vs_rating.png
│   ├── tableau_type_by_neighborhood.png
│   ├── tableau_neighborhood_performance.png
│   ├── jmp_correlation_matrix.png
│   ├── jmp_anova_rating_by_neighborhood.png
│   ├── jmp_anova_rating_by_neighborhood_tukey.png
│   ├── jmp_anova_rating_by_type.png
│   ├── jmp_anova_rating_by_type_plot.png
│   ├── jmp_anova_reviews_by_type.png
│   └── jmp_anova_reviews_by_type_plot.png
│
└── README.md
```

---

## Key Findings

1. **Beer menu size has no effect on Google rating** (r = −0.013). Having more beers on tap does not make customers rate a brewery higher.

2. **Neighborhood location does not affect Google rating** (p = 0.245). All 7 neighborhoods maintain a strong 4.50–4.75 average. Even the most crowded area (South Slope, 4.50) is statistically tied with the least-served area (East Asheville, 4.70).

3. **Brewery format does not affect Google rating** (p = 0.107). Taprooms, Brewpubs, and Regional Breweries all earn similar ratings.

4. **Brewery format DOES affect review volume** (p = 0.018). Regional Breweries average 4× more reviews than Taprooms (1,879 vs 434), suggesting larger-format breweries generate significantly more customer engagement.

5. **South Slope is hypersaturated** — 12 breweries packed into less than 0.4 square miles. Any new entrant needs a completely unique concept to stand out.

6. **East Asheville and North Asheville are the biggest opportunity zones** — only 2 breweries each cover these entire residential corridors.

7. **DBSCAN clustering identified 4 natural brewery clusters:** South Slope (13), West Asheville (6), River Arts District (4), and Biltmore Village (3) — plus 7 outlier locations.

8. **Archetype Brewing leads the fleet with 71 beers on menu** — 3.4× the average of 21. This is a differentiation strategy based on variety, but it doesn't translate to higher ratings.

**Bottom line:** Asheville's brewery market is so mature that format, location, and menu size no longer separate quality — every brewery performs at a high level just to survive. The real opportunity gap is geographic. East Asheville and North Asheville are underserved not because they are lower-quality markets, but because no brewery has claimed those neighborhoods yet.

---

## Data Limitations

- `craft_beer_total` may mix draft beers and canned/bottled inventory because brewery websites don't always separate them
- Ben's Tune Up and The Brew Pump had no beer menu listed on their websites (recorded as NULL)
- Sample size is 32 breweries — statistical tests have low power, especially for small groups like Regional Brewery (n = 2)
- Google ratings are compressed in a narrow range (4.2–4.9), which limits what statistical tests can detect

---

## How to Reproduce

**1. Clone the repository**
```bash
git clone https://github.com/your-username/avl_brews.git
cd avl_brews
```

**2. Install Python dependencies**
```bash
pip install pandas sqlalchemy pyodbc azure-identity scikit-learn
```

**3. Install ODBC drivers (Mac only)**
```bash
brew install unixodbc
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew install msodbcsql18
```

**4. Load data into Azure SQL**

Open `notebooks/transfer_code.ipynb` and update the `SERVER`, `DATABASE`, and CSV path variables. Run the notebook — it will open a browser window for Microsoft Entra authentication.

**5. Run SQL transformations**

Open `sql/clean_and_transform.sql` in Azure Data Studio and execute each block sequentially to add the `neighborhood` column and create the clean view.

**6. Build the Tableau dashboard**

Open `tableau/Asheville_Brewery_Market_Analysis.twb` in Tableau Desktop or Tableau Public. Point the data source to `data/clean/asheville_tableau.csv`.

**7. Upload GeoJSON files to ArcGIS Online**

Upload the three files from `data/geojson/` to an ArcGIS Online map and style according to the `market_signal` and `neighborhood` fields.

---

## Tools

| Tool | Purpose |
|------|---------|
| Python (pandas, scikit-learn, numpy) | Data cleaning, DBSCAN clustering |
| Azure SQL Database | Cloud data storage and SQL transformation |
| Azure Data Studio | SQL query editor |
| SQLAlchemy + pyodbc | Python-to-Azure SQL connection |
| Microsoft Entra (Azure AD) | Authentication via token injection |
| JMP Student Edition 19 | Correlation analysis and ANOVA tests |
| ArcGIS Online | Interactive geospatial brewery map |
| Tableau Public | 4-chart interactive dashboard |
| GitHub | Version control and project repository |

---

## Live Links

| Resource | Link |
|----------|------|
| ArcGIS Map | [arcg.is/1SOibL1](https://arcg.is/1SOibL1) |
| Tableau Dashboard | *[Add Tableau Public link here]* |
| GitHub Repository | *[Add GitHub link here]* |

---

## Acknowledgements

Built as a portfolio project for the M.S. in Data Science & Business Analytics program at **UNC Charlotte**. Special thanks to the DSBA faculty for the tools, access, and guidance that made this project possible.
