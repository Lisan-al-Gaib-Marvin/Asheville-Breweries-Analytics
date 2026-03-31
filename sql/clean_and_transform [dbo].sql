SELECT brewery_type, COUNT(*) AS COUNT
FROM dbo.breweries
GROUP BY brewery_type
ORDER BY COUNT DESC;

SELECT brewery_name, brewery_type
FROM dbo.breweries
WHERE brewery_type IS NULL;

UPDATE dbo.breweries
SET brewery_type = 'Taproom'
WHERE brewery_name = 'The Whale :: South Slope'
    AND brewery_type IS NULL;

-- First add the column to the table
ALTER TABLE dbo.breweries
ADD neighborhood NVARCHAR(50) NULL;

-- Then fill it in based on latitude/longitude ranges
UPDATE dbo.breweries
SET neighborhood = CASE
    WHEN latitude > 35.605                                              THEN 'North Asheville'
    WHEN latitude < 35.510                                              THEN 'Biltmore Park'
    WHEN longitude < -82.575 AND latitude >= 35.568                    THEN 'West Asheville'
    WHEN longitude >= -82.575 AND longitude < -82.558
         AND latitude >= 35.578 AND latitude <= 35.598                 THEN 'River Arts District'
    WHEN longitude >= -82.558 AND longitude < -82.543
         AND latitude >= 35.583                                        THEN 'South Slope'
    WHEN longitude >= -82.525 AND latitude >= 35.540                   THEN 'East Asheville'
    WHEN latitude >= 35.510 AND latitude < 35.580
         AND longitude >= -82.568 AND longitude < -82.528              THEN 'Biltmore Village'
    ELSE 'South Slope'
END;


-- Count breweries per neighborhood
SELECT 
    neighborhood,
    COUNT(*) AS brewery_count,
    ROUND(AVG(google_rating), 2)       AS avg_rating,
    SUM(google_review_count)           AS total_reviews,
    ROUND(AVG(CAST(craft_beer_total AS FLOAT)), 1) AS avg_beer_menu
FROM dbo.breweries
GROUP BY neighborhood
ORDER BY brewery_count DESC;

CREATE VIEW dbo.vw_breweries_clean AS
SELECT
    brewery_id,
    brewery_name,
    brewery_type,
    neighborhood,
    city,
    state,
    latitude,
    longitude,
    website_url,
    google_rating,
    google_review_count,
    craft_beer_total,
    data_status
FROM dbo.breweries
WHERE data_status = 'ACTIVE';

SELECT * 
FROM dbo.vw_breweries_clean;

