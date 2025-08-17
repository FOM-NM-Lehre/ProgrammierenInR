# install.package("RPostgrSQL")
library(DBI)
library(dplyr)
#library(dbplyr)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 host = "192.168.2.200",
                 port = 5432,
                 user = "postgres",
                 password = "postgresdemo",
                 dbname = "netflix")

tabellen_namen <- dbListTables(con)
print(tabellen_namen)

tv_show <- tbl(con, "tv_show")
season <- tbl(con, "season")
movie <- tbl(con, "movie")
view_summary <- tbl(con, "view_summary")

colnames(tv_show)
colnames(season)
colnames(movie)
colnames(view_summary)

# -- Movies released since 2024-01-01
# SQL:
# select id, title, runtime from movie where release_date >= '2024-01-01';

movie |>
    filter(release_date >= "2024-01-01") |>
    select(id, title, runtime)

### Zugänglich machen der PostgreSQL Datenbanken

#- TV Show Seasons released since 2024-01-01
# SQL:
# select s.id, s.title as season_title, s.season_number, t.title as tv_show, s.runtime
# from season s left join tv_show t on t.id = s.tv_show_id
# where s.release_date >= '2024-01-01';

left_join(season, tv_show, by="id") |>
    filter(release_date.x >= "2024-01-01") |>
    select(id, title.x, season_number, title.y)

season |> full_join(tv_show, by="id") |>
    filter(release_date.x >= "2024-01-01") |>
    select(id, title.x, season_number, title.y)

left_join(season, tv_show, by="id", suffix = c(".s", ".t")) |>
    filter(release_date.s >= "2024-01-01") |>
    select(id, title.s, season_number, title.t)


# -- Top 10 movies (English)
# select v.view_rank, m.title, v.hours_viewed, m.runtime, v.views, v.cumulative_weeks_in_top10
# from view_summary v
# inner join movie m on m.id = v.movie_id
# where duration = 'WEEKLY'
# and end_date = '2025-06-29'
# and m.locale = 'en'
# order by v.view_rank;

# Beachte den Unterschied von:
movie %>%
    filter(!is.na(original_title)) %>%
    count()

# und:
movie %>%
    filter(!is.na("original_title")) %>%
    count()


movie %>%
    filter(!is.na(original_title)) %>%
    filter(runtime < 40) %>%
    filter(runtime > 20) %>%
    select(title, runtime) %>% show_query()

movie %>%
    filter(!is.na(original_title)) %>%
    filter(runtime < 40 & runtime > 20) %>%
    select(title, runtime) %>% show_query()

movie %>%
    filter(!is.na(original_title) & runtime < 40 & runtime > 20) %>%
    select(title, runtime) %>% show_query() %>% collect()

