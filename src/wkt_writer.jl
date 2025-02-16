module WKTWriter

using DataDeps
using CoordRefSystems
using CoordRefSystems: CRS

export wkt

"""
    CoordRefSystems.wkt(crs::CRS)::AbstractString

Convert a `CRS` object into an OGC WKT-CRS 2 formatted string.
"""
function wkt(crs::CRS)::AbstractString
    epsg_code = try
        CoordRefSystems.code(crs)
    catch
        nothing
    end

    if epsg_code !== nothing
        return fetch_wkt_from_epsg(epsg_code)
    else
        return construct_wkt_from_metadata(crs)
    end
end

"""
    fetch_wkt_from_epsg(epsg_code::Integer)::AbstractString

Fetch the OGC WKT 2 string for a CRS using its EPSG code from a local database.
"""
function fetch_wkt_from_epsg(epsg_code::Integer)::AbstractString
    db_path = datadep"EPSG_WKT2_DB/epsg.wkt"

    if isfile(db_path)
        open(db_path, "r") do file
            for line in eachline(file)
                if occursin("EPSG[\"$epsg_code\"", line)
                    return line
                end
            end
        end
    end

    error("EPSG code $epsg_code not found in local database")
end

"""
    construct_wkt_from_metadata(crs::CRS)::AbstractString

Construct an OGC WKT-CRS 2 string manually from the CRS object’s metadata.
"""
function construct_wkt_from_metadata(crs::CRS)::AbstractString
    wkt = """
    PROJCRS["$(crs.name)",
        BASEGEOGCRS["$(crs.datum)",
            DATUM["$(crs.datum)",
                ELLIPSOID["$(crs.ellipsoid)", $(crs.ellipsoid_major_axis), $(crs.ellipsoid_flattening),
                    LENGTHUNIT["metre", 1]
                ]
            ],
            PRIMEM["$(crs.prime_meridian)", 0, ANGLEUNIT["degree", 0.0174532925199433]]
        ],
        CONVERSION["$(crs.projection)",
            METHOD["$(crs.projection_method)"]
    """

    if hasproperty(crs, :parameters)
        for param in crs.parameters
            wkt *= """,
            PARAMETER["$(param.name)", $(param.value)]"""
        end
    end

    wkt *= """
        ],
        CS[Cartesian, 2],
        AXIS["E", east, ORDER[1], LENGTHUNIT["metre", 1]],
        AXIS["N", north, ORDER[2], LENGTHUNIT["metre", 1]],
        USAGE[SCOPE["General purpose CRS"]],
        ID["EPSG", $(crs.epsg)]
    ]
    """

    return wkt
end

"""
    register_epsg_database()

Registers the EPSG WKT2 database using `DataDeps.jl` for offline storage.
"""
function register_epsg_database()
    register(DataDep(
        "EPSG_WKT2_DB",
        """
        This is the EPSG WKT2 Database, which contains a collection of WKT representations
        of coordinate reference systems. The database is sourced from epsg.io.
        """,
        "https://github.com/OSGeo/PROJ-data/releases/latest/download/epsg.wkt",
        fetch_method = :download
    ))
end

register_epsg_database()

end
