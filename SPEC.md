# Data collection pipeline
* uses opentofu to create cloudflare r2 buckets and domain names
* install ohsome-planet into github action: https://github.com/GIScience/ohsome-planet
* uses github actions to fetch OSM data for monaco and estonia and converts them to parquet like this:
```sh
curl -O https://download.geofabrik.de/europe/monaco-latest.osm.pbf

ohsome-planet contributions --pbf=monaco-latest.osm.pbf --parallel=$(sysctl -n hw.ncpu) --output monaco

duckdb -c "
    COPY (
        SELECT 
            osm_type::ENUM ('node', 'way', 'relation') AS osm_type,
            osm_id,
            tags,
            bbox,
            ST_GeomFromWKB(geometry) as geometry,
        FROM 'monaco/contributions/latest/*.parquet'
        ORDER BY bbox.xmin, bbox.ymin, bbox.xmax, bbox.ymax
    ) TO 'monaco.osm.parquet' (
        FORMAT PARQUET,
        CODEC 'zstd',
        COMPRESSION_LEVEL 20,
        PARQUET_VERSION v2
    );
"

# And then uploads it to r2 bucket
...
```
* Has duckdb-wasm shell similiarly as https://shell.duckdb.org in the root of
* https://shell.open2roam.org