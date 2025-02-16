@testset "WKT-CRS 2 Writer" begin
    crs1 = CRS(name="WGS 84", datum="World Geodetic System 1984", 
               ellipsoid="WGS 84", ellipsoid_major_axis=6378137, ellipsoid_flattening=298.257223563,
               prime_meridian="Greenwich", projection="LatLon", parameters=[],
               epsg=4326)

    crs2 = CRS(name="UTM Zone 33N", datum="WGS 84",
               ellipsoid="WGS 84", ellipsoid_major_axis=6378137, ellipsoid_flattening=298.257223563,
               prime_meridian="Greenwich", projection="Transverse Mercator",
               projection_method="Transverse Mercator", 
               parameters=[(name="Latitude of Origin", value=0.0), 
                           (name="Central Meridian", value=15.0),
                           (name="Scale Factor", value=0.9996),
                           (name="False Easting", value=500000.0),
                           (name="False Northing", value=0.0)],
               epsg=32633)

    @test occursin("PROJCRS", wkt(crs1))  # Ensures OGC WKT2 format is used
    @test occursin("BASEGEOGCRS", wkt(crs1))
    @test occursin("DATUM", wkt(crs1))
    @test occursin("ELLIPSOID", wkt(crs1))

    @test occursin("PROJCRS", wkt(crs2))
    @test occursin("CONVERSION", wkt(crs2))
    @test occursin("METHOD", wkt(crs2))
    @test occursin("Transverse Mercator", wkt(crs2))

    epsg_wkt_4326 = wkt(crs1)
    epsg_wkt_32633 = wkt(crs2)

    @test occursin("ID[\"EPSG\", 4326]", epsg_wkt_4326)
    @test occursin("ID[\"EPSG\", 32633]", epsg_wkt_32633)

    @test occursin("PARAMETER[\"Latitude of Origin\"", wkt(crs2))
    @test occursin("PARAMETER[\"Central Meridian\"", wkt(crs2))
    @test occursin("PARAMETER[\"Scale Factor\"", wkt(crs2))
    @test occursin("PARAMETER[\"False Easting\"", wkt(crs2))
    @test occursin("PARAMETER[\"False Northing\"", wkt(crs2))
end
