\name{eberg_grid}
\alias{eberg_grid}
\title{Ebergotzen -- soil covariate layers}
\description{
The data set contains a set of grids (DEM --- elevation, TWI --- Topographic Wetness Index, Z --- topographic/geological zones) at resolution of 100 m. 
Eberg\"{o}tzen is 10 by 10 km study area in the vicinity of the city of G\"{o}ttingen in Central
Germany. This area has been
extensively surveyed over the years, mainly for the purposes of developing operational
digital soil mapping techniques (Gehrt and B\"{o}hner, 2001). 
}
\format{
  The \code{SpatialGridDataFrame} contains the following layers:
  \describe{
    \item{DEM}{Elevation values from the topographic map}
    \item{TWI}{Topographic Wetness Index derived using the SAGA algorithm }
     \item{Z}{containing factors; four soil topographic/geological units (soil mapping units) }
  } 
} 
\usage{
data(eberg_grid)
}
\author{ Tomislav Hengl }
\references{ 
B\"{o}hner, J., McCloy, K. R. and Strobl, J. (Eds), 2006. SAGA --- Analysis and Modelling Applications. G\"{o}ttinger Geographische Abhandlungen, Heft 115. Verlag Erich Goltze GmbH, G\"{o}ttingen, 117 pp.

Gehrt, E., B\"{o}hner, J., 2001. Vom punkt zur flache --- probleme des ``upscaling'' in der bodenkartierung. In: Diskussionsforum Bodenwissenschaften: Vom Bohrstock zum Bildschirm. FH, Osnabr\"{u}ck, pp. 17--34.

\url{http://geomorphometry.org/content/ebergotzen}
}
\note{ 
 
}
\seealso{\link{eberg}}
\keyword{datasets}
\examples{
data(eberg_grid)
names(eberg_grid@data)
}
