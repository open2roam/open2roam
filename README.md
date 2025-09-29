<!-- PROJECT LOGO -->
<p align="center">
  <a href="https://github.com/open2roam/open2roam">
   <img src="https://avatars.githubusercontent.com/u/209021647?s=200&v=4" alt="Logo">
  </a>

  <h3 align="center">open2roam</h3>
</p>


## About the project
open2roam is a non-profit platform helping people to explore the world.

## Docs for development, deployment and maintainance

- [Secrets](docs/SECRETS.md)

## Generate Countries CSV from Overture Maps

Create the CSV file with country codes and WKT geometries:
```bash
duckdb -c "
    COPY (
        SELECT
            country as id,
            ST_AsText(geometry) as wkt
        FROM read_parquet('s3://overturemaps-us-west-2/release/2025-09-24.0/theme=divisions/type=division_area/*', filename=true, hive_partitioning=1)
        WHERE subtype = 'country' AND class = 'land'
        ORDER BY country
    ) TO 'countries.csv' (HEADER, DELIMITER ';')
"
```

## License
[AGPLv3](LICENSE).