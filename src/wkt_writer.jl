module WKTWriter

using JSON
using CoordRefSystems

"""
    CoordRefSystems.wkt(crs::CRS)::AbstractString

Convert a `CRS` object into an OGC WKT-CRS 2 formatted string.
"""
function wkt(crs::CRS)::AbstractString
    if hasproperty(crs, :epsg)
        epsg_code = crs.epsg
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
    db_path = joinpath(@__DIR__, "epsg_wkt2_database.json")

    if isfile(db_path)
        db = JSON.parsefile(db_path)
        if haskey(db, string(epsg_code))
            return db[string(epsg_code)]
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

end
