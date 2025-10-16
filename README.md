# Spotify Analysis using SQL
![spotify_logo](https://github.com/user-attachments/assets/a19e5ccf-1fc9-4aca-81cf-0afcc2fe11be)
## Overview
This project involves a comprehensive analysis of **Spotify** data using **SQL**. The goal is to extract valuable insights and answer various business questions based on the dataset.
## Business Problems and Solutions

### 1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
	select track
	from [spotify_db].[dbo].[cleaned_dataset]
	where stream>1000000000
```

**Objective:** These are super popular tracks with over 1 billion streams, showing they are global hits or top-trending songs.

### 2. List all albums along with their respective artists.

```sql
	select 
	distinct album, Artist
	from [spotify_db].[dbo].[cleaned_dataset]
	order by album
```

**Objective:** Shows all unique and artists, helping identify each artist’s released albums

### 3.Get the total number of comments for tracks where licensed = TRUE.

```sql
  select sum(comments) as total_comments
	from [spotify_db].[dbo].[cleaned_dataset]
	where Licensed='True'
```

**Objective:** Shows the total number of comments on all licensed tracks, helping measure audience engagement for authorized music.

### 4. Find all tracks that belong to the album type single.

```sql
	select track
	from [spotify_db].[dbo].[cleaned_dataset]
	where Album_type='single'
```

**Objective:** Lists all tracks released as singles

### 5.Count the total number of tracks by each artist.

```sql
  select artist,
	count(distinct(track)) as total_tracks
	from [spotify_db].[dbo].[cleaned_dataset]
	group by Artist
```

**Objective:** Shows how many tracks each artist has, identify the most productive

### 6. Calculate the average danceability of tracks in each album.

```sql
	select album,
	avg(danceability) as avg_danceability
	from [spotify_db].[dbo].[cleaned_dataset]
	group by album
	order by avg_danceability desc
```

**Objective:** Shows the average danceability score for each album, helping identify which albums are the most danceable overall.

### 7. Find the top 5 tracks with the highest energy values.

```sql
	select top 5
	track,
	Energy
	from [spotify_db].[dbo].[cleaned_dataset]
	order by Energy desc
```

**Objective:** Shows the top 5 tracks with the highest energy, highlighting the most energetic and lively songs.

### 8.List all tracks along with their views and likes where official_video = TRUE.

```sql
select
	Track,
	sum(views) as total_views,
	sum(likes) as total_like
	from [spotify_db].[dbo].[cleaned_dataset]
	where official_video='True'
	group by track
```

**Objective:** Shows each track’s total views and likes from official videos, helping identify which official releases gained the most audience engagement.

### 9. For each album, calculate the total views of all associated tracks.

```sql
select album,
	track,
	sum(views) as Total_view
	from [spotify_db].[dbo].[cleaned_dataset]
	group by album,track
	order by Total_view desc
```

**Objective:** Shows the most viewed tracks within each album, helping identify which songs are the most popular per album.

### 10.Retrieve the track names that have been streamed on Spotify more than YouTube.

```sql
	with temp as(
		select 
		track,
		COALESCE(sum(case when most_playedon='Youtube' then Stream end),0) as streamed_on_youtube,
		COALESCE(sum(case when most_playedon='Spotify' then Stream end),0) as streamed_on_spotify
		from [spotify_db].[dbo].[cleaned_dataset]
		group by track
	) 
	select 
	track 
	from temp
	where streamed_on_spotify>streamed_on_youtube
	and streamed_on_youtube <> 0
```

**Objective:** Shows tracks that are more streamed on Spotify than on YouTube, indicating they are more popular among Spotify users even though they also have YouTube streams.

### 11.Find the top 3 most-viewed tracks for each artist using window functions.

```sql
 with temp as(
		 select track,
		 artist,
		 views,
		 dense_rank() over(partition by artist order by views desc) as rn
		 from [spotify_db].[dbo].[cleaned_dataset]
	 )
	 select 
		 artist,track,views,
		 rn as rank_views
	 from temp
	 where rn<=3
	 order by artist,views desc
```

**Objective:** Shows the top 3 most-viewed tracks per artist, helping identify each artist’s most popular songs based on view count.

### 12.Write a query to find tracks where the liveness score is above the average.

```sql
  select 
	track, artist, Liveness
	from [spotify_db].[dbo].[cleaned_dataset]
	where Liveness>(select avg(liveness) from [spotify_db].[dbo].[cleaned_dataset])
```

**Objective:** Shows tracks with liveness above average, meaning these songs sound more like live performance.

### 13. .Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

```sql
	with temp as(
		select 
		album,
		max(energy) as highest_energy,
		min(energy) as lowest_energy
		from [spotify_db].[dbo].[cleaned_dataset]
		group by Album
	)
	select 
		album,
		highest_energy- lowest_energy as diff_energy
		from temp
		order by diff_energy desc
```

**Objective:** Shows the energy range (difference between highest and lowest energy) for each album, helping identify albums with the greatest variation in song intensity.

### 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

```sql
  select track,
  (energy/Liveness) as energy_to_liveness_ratio
	from [spotify_db].[dbo].[cleaned_dataset]
	where liveness<>0 and
	(energy/Liveness)>1.2
```

**Objective:** Shows tracks with an energy-to-liveness ratio above 1.2, meaning they are high-energy songs that feel less live

### 15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions

```sql
  select
	track,views,likes,
	sum(likes) over (order by views) AS cumulative_likes
	from [spotify_db].[dbo].[cleaned_dataset]
	order by likes desc
```
**Objective:** Shows each track’s likes and views along with a running total of likes ordered by views, helping reveal how audience engagement accumulates as view counts increase.

## Findings and Conclusion

### Findings
- Some tracks achieved over 1 billion streams, proving massive global popularity.
- Official and licensed songs get higher engagement (likes, comments, views).
- Singles are common, showing artists often test the market with individual releases.
- High-energy and danceable tracks attract more listeners.
- Top 3 tracks per artist reveal their key hits driving fame.
- Albums with wide energy range show strong musical diversity.
- Spotify vs. YouTube results indicate different audience preferences — Spotify for polished sound, YouTube for visual or live vibes.

### Conclusion
- High-energy, danceable, and officially licensed songs tend to achieve greater popularity and user interaction.
- Spotify favors intense, studio-quality tracks, while YouTube audiences often respond better to live or visual-driven performances.
- Artists with a diverse energy range across albums and consistent production show stronger listener retention.






