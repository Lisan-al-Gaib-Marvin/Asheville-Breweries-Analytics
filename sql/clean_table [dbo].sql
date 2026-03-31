CREATE TABLE [dbo].[breweries] (
    [brewery_id]          INT           IDENTITY(1,1) NOT NULL,  -- auto-number, Azure creates this
    [brewery_name]        NVARCHAR(150) NOT NULL,
    [brewery_type]        NVARCHAR(50)  NULL,
    [city]                NVARCHAR(50)  NULL,
    [state]               NCHAR(2)      NULL,
    [latitude]            DECIMAL(9,6)  NULL,
    [longitude]           DECIMAL(9,6)  NULL,
    [website_url]         NVARCHAR(300) NULL,
    [google_rating]       DECIMAL(3,1)  NULL,
    [google_review_count] INT           NULL,
    [craft_beer_total]    INT           NULL,
    [data_status]         NVARCHAR(20)  NULL,
    CONSTRAINT [PK_breweries] PRIMARY KEY CLUSTERED ([brewery_id] ASC)
);
