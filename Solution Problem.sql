--Table
select * from [spotify_db].[dbo].[cleaned_dataset]

-- Solution Problem
--1.Retrieve the names of all tracks that have more than 1 billion streams.
	select track
	from [spotify_db].[dbo].[cleaned_dataset]
	where stream>1000000000



--2.List all albums along with their respective artists.
	select 
	distinct album, Artist
	from [spotify_db].[dbo].[cleaned_dataset]
	order by album



--3.Get the total number of comments for tracks where licensed = TRUE.
	select sum(comments) as total_comments
	from [spotify_db].[dbo].[cleaned_dataset]
	where Licensed='True'



--4.Find all tracks that belong to the album type single.
	select track
	from [spotify_db].[dbo].[cleaned_dataset]
	where Album_type='single'



--5.Count the total number of tracks by each artist.
	select artist,
	count(distinct(track)) as total_tracks
	from [spotify_db].[dbo].[cleaned_dataset]
	group by Artist



--6.Calculate the average danceability of tracks in each album.
	select album,
	avg(danceability) as avg_danceability
	from [spotify_db].[dbo].[cleaned_dataset]
	group by album
	order by avg_danceability desc



--7.Find the top 5 tracks with the highest energy values.
	select top 5
	track,
	Energy
	from [spotify_db].[dbo].[cleaned_dataset]
	order by Energy desc



--8.List all tracks along with their views and likes where official_video = TRUE.
	select
	Track,
	sum(views) as total_views,
	sum(likes) as total_like
	from [spotify_db].[dbo].[cleaned_dataset]
	where official_video='True'
	group by track



--9.For each album, calculate the total views of all associated tracks.
	select album,
	track,
	sum(views) as Total_view
	from [spotify_db].[dbo].[cleaned_dataset]
	group by album,track
	order by Total_view desc



--10.Retrieve the track names that have been streamed on Spotify more than YouTube.
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
 


 --11.Find the top 3 most-viewed tracks for each artist using window functions.
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



--12.Write a query to find tracks where the liveness score is above the average.
	select 
	track, artist, Liveness
	from [spotify_db].[dbo].[cleaned_dataset]
	where Liveness>(select avg(liveness) from [spotify_db].[dbo].[cleaned_dataset])



--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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



--14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
	select track,
		(energy/Liveness) as energy_to_liveness_ratio
	from [spotify_db].[dbo].[cleaned_dataset]
	where liveness<>0 and
	(energy/Liveness)>1.2



--15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
	select
	track,views,likes,
	sum(likes) over (order by views) AS cumulative_likes
	from [spotify_db].[dbo].[cleaned_dataset]
	order by likes desc
