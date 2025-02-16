@testset "WKT-CRS 2 Writer" begin
    crs1 = LatLon(45.0, 90.0)

    crs2 = utm(33, true, 500000.0, 4649776.22482)

    wkt_crs1 = wkt(crs1)
    wkt_crs2 = wkt(crs2)

    @test occursin("PROJCRS", wkt_crs1)
    @test occursin("BASEGEOGCRS", wkt_crs1)
    @test occursin("DATUM", wkt_crs1)
    @test occursin("ELLIPSOID", wkt_crs1)

    @test occursin("PROJCRS", wkt_crs2)
    @test occursin("CONVERSION", wkt_crs2)
    @test occursin("METHOD", wkt_crs2)
    @test occursin("Transverse Mercator", wkt_crs2)

    @test occursin("ID[\"EPSG\", 4326]", wkt_crs1)
    @test occursin("ID[\"EPSG\", 32633]", wkt_crs2)

    @test occursin("AXIS[\"Latitude\", NORTH]", wkt_crs1)
    @test occursin("AXIS[\"Longitude\", EAST]", wkt_crs1)
    @test occursin("LENGTHUNIT[\"metre\", 1]", wkt_crs2)

    @test occursin("PARAMETER[\"Latitude of Origin\", 0.0]", wkt_crs2)
    @test occursin("PARAMETER[\"Central Meridian\", 15.0]", wkt_crs2)
    @test occursin("PARAMETER[\"Scale Factor\", 0.9996]", wkt_crs2)
    @test occursin("PARAMETER[\"False Easting\", 500000.0]", wkt_crs2)
    @test occursin("PARAMETER[\"False Northing\", 0.0]", wkt_crs2)
end
