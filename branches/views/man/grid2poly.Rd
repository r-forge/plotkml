\name{grid2poly}
\title{Converts a gridded map to a polygon map}
\description{ Converts a gridded map to a polygon map (one polygon for each cell) and (by default) reprojects polygons to WGS84 geographic coordinates.
}
\usage{
grid2poly(obj, reproject = TRUE, var.name, method = "sp")
}
\arguments{
  \item{obj}{ Object of type "SpatialGridDataFrame"
}
  \item{reproject}{ Reproject to WGS84 geographic coordinates (logical)
}
  \item{var.name}{ Column names (single character or a vector)
}
  \item{method}{ One of the three conversion methods = "sp" (\code{\link{spTransform}}) available in the sp package, "raster" (\code{\link{project}}) available in the raster package, and "SAGA" Grid to Shape function available via SAGA GIS. 
}
}
\details{ To use "SAGA" method, first download and install SAGA GIS from \url{http://www.saga-gis.org}. }

\author{ Tomislav Hengl (tom.hengl@wur.nl) }
\note{ This operation is not recommended for large grids (>>10e4 pixels). SAGA GIS might be the most efficient method for processing larger grids. Likewise, when working with very coarse grids (>10 km grid size), reprojection can lead to deformations (the output structure might not look rectangular).
}

\seealso{ \code{\link{kml_layer.SpatialGrid}}, \code{\link{as.SpatialPolygons.GridTopology}}
}
\examples{
data(eberg_grid)
eberg_grid.pol <- grid2poly(eberg_grid)
}
