@testset "WKT-CRS 2 Writer" begin
    crs1 = LatLon(45.0, 90.0)  # Latitude 45.0, Longitude 90.0 (EPSG: 4326)

    crs2 = CoordRefSystems.CRS(
        name = "UTM Zone 33N",
        datum = "WGS 84",
        ellipsoid = "WGS 84",
        ellipsoid_major_axis = 6378137.0,
        ellipsoid_flattening = 298.257223563,
        prime_meridian = "Greenwich",
        projection = "Transverse Mercator",
        projection_method = "Transverse Mercator",
        parameters = [
            (name = "Latitude of Origin", value = 0.0),
            (name = "Central Meridian", value = 15.0),
            (name = "Scale Factor", value = 0.9996),
            (name = "False Easting", value = 500000.0),
            (name = "False Northing", value = 0.0)
        ],
        epsg = 32633
    )

    wkt_crs1 = wkt(crs1)
    wkt_crs2 = wkt(crs2)

    @test occursin("PROJCRS", wkt_crs1)  # Ensure OGC WKT2 format
    @test occursin("BASEGEOGCRS", wkt_crs1)
    @test occursin("DATUM", wkt_crs1)
    @test occursin("ELLIPSOID", wkt_crs1)

    @test occursin("PROJCRS", wkt_crs2)
    @test occursin("CONVERSION", wkt_crs2)
    @test occursin("METHOD", wkt_crs2)
    @test occursin("Transverse Mercator", wkt_crs2)  # Ensure projection name is correct

    @test occursin("ID[\"EPSG\", 4326]", wkt_crs1)  # WGS 84 LatLon
    @test occursin("ID[\"EPSG\", 32633]", wkt_crs2)  # UTM Zone 33N

    @test occursin("AXIS[\"Latitude\", NORTH]", wkt_crs1)
    @test occursin("AXIS[\"Longitude\", EAST]", wkt_crs1)
    @test occursin("LENGTHUNIT[\"metre\", 1]", wkt_crs2)

    @test occursin("PARAMETER[\"Latitude of Origin\", 0.0]", wkt_crs2)
    @test occursin("PARAMETER[\"Central Meridian\", 15.0]", wkt_crs2)
    @test occursin("PARAMETER[\"Scale Factor\", 0.9996]", wkt_crs2)
    @test occursin("PARAMETER[\"False Easting\", 500000.0]", wkt_crs2)
    @test occursin("PARAMETER[\"False Northing\", 0.0]", wkt_crs2)
end