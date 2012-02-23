\name{eberg}
\docType{data}
\encoding{latin1}
\alias{eberg}
\alias{eberg_grid}
\alias{eberg_zones}
\alias{eberg_contours}
\title{Ebergotzen --- Digital Soil Mapping case study}
\description{\enc{Ebergötzen}{Ebergoetzen} is 10 by 10 km study area in the vicinity of the city of \enc{Göttingen}{Goettingen} in Central Germany. This area has been extensively surveyed over the years, mainly for the purposes of developing operational digital soil mapping techniques (Gehrt and \enc{Böhner}{Boehner}, 2001). \cr
\code{eberg} table contains 2937 observations (augers) of soil textures and soil types. \code{eberg_grid} contains three gridded maps that can be used as covariates for spatial prediction of soil variables. \code{eberg_zones} is a polygon map showing the distribution of parent material (Silt and sand, Sandy material, Clayey derivats, Clay and loess). \code{eberg_contours} shows contour lines derived from the 25 m DEM of the area using 10 m equidistance.}
\usage{data(eberg)}
\format{
The \code{eberg} data frame (irregular points) contains the following columns:
  \describe{
	\item{\code{ID}}{universal identifier}
	\item{\code{X}}{a numeric vector; x-coordinate (m) in DHDN / Gauss-Krueger zone 3 (German coordinate system) }
	\item{\code{Y}}{a numeric vector; y-coordinate (m) in DHDN / Gauss-Krueger zone 3 (German coordinate system) }
	\item{\code{SAND}}{topsoil sand content estimated by hand; see Ad-hoc-AG Boden (2005) }
	\item{\code{SILT}}{topsoil silt content estimated by hand }
	\item{\code{CLAY}}{topsoil clay content estimated by hand }
	\item{\code{SOILTYPE}}{a vector containing factors; soil classes according to the German soil classification system (13 classes in this data set)}
} 
The \code{eberg_grid} data frame (regular grid at 100 m resolution) contains the following columns:
  \describe{
  \item{\code{DEM}}{elevation values from the topographic map }
  \item{\code{TWI}}{Topographic Wetness Index derived using the SAGA algorithm }
  \item{\code{Z}}{containing factors; four soil topographic/geological units (soil mapping units) }
	\item{\code{x}}{a numeric vector; x-coordinate (m) in DHDN / Gauss-Krueger zone 3 (German coordinate system) }
	\item{\code{y}}{a numeric vector; y-coordinate (m) in DHDN / Gauss-Krueger zone 3 (German coordinate system) } 
} 
} 
\author{The \enc{Ebergötzen}{Ebergoetzen} dataset is courtesy of Gehrt Ernst (\email{Ernst.Gehrt@niedersachsen.de}), the State Authority for Mining, Energy and Geology, Hannover, Germany and Olaf Conrad, University of Hamburg (\email{conrad@geowiss.uni-hamburg.de}). The data set has been prepared for this exercise by Tomislav Hengl (\email{tom.hengl@wur.nl}).}
\references{
\itemize{ 
\item Ad-hoc-AG Boden, (2005) Bodenkundliche Kartieranleitung. 5th Ed, Bundesanstalt fur Geowissenschaften und Rohstoffe und \enc{Niedersächsisches}{Niedersaechsisches} Landesamt \enc{für}{fur} Bodenforshung, Hannover, p. 423.
\item \enc{Böhner}{Boehner}, J., McCloy, K. R. and Strobl, J. (Eds), (2006) \href{http://saga-gis.org/en/about/references.html}{SAGA --- Analysis and Modelling Applications}. \enc{Göttinger}{Goettinger} Geographische Abhandlungen, Heft 115. Verlag Erich Goltze GmbH, \enc{Göttingen}{Goettingen}, 117 pp.
\item Gehrt, E., \enc{Böhner}{Boehner}, J., (2001) Vom punkt zur flache --- probleme des `upscaling' in der bodenkartierung. In: Diskussionsforum Bodenwissenschaften: Vom Bohrstock zum Bildschirm. FH, \enc{Osnabrück}{Osnabruck}, pp. 17-34.
\item Skaggs, T. H., Arya, L. M., Shouse, P. J., Mohanty, B. P., (2001) \href{https://www.soils.org/publications/sssaj/articles/65/4/1038}{Estimating Particle-Size Distribution from Limited Soil Texture Data}. Soil Science Society of America Journal 65 (4): 1038-1044.
\item  \url{http://geomorphometry.org/content/ebergotzen}
}
}
\note{ Texture by hand method can be used to determine the content of soil earth fractions only to an accuracy of \enc{±}{+-}5-10\% (\href{https://www.soils.org/publications/sssaj/articles/65/4/1038}{Skaggs et al. 2001}). A surveyor distinguishes to which of the 32 texture classes a soil samples belongs to, and then estimates the content of fractions. E.g. texture class \code{St2} has 10\% clay, 25\% silt and 65\% sand (Ad-hoc-AG Boden, 2005). 
}
\examples{
data(eberg)
data(eberg_grid)
data(eberg_zones)
data(eberg_contours)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
coordinates(eberg_grid) <- ~x+y
gridded(eberg_grid) <- TRUE
proj4string(eberg_grid) <- CRS("+init=epsg:31467")
\dontrun{
l.sp <- list("sp.lines", eberg_contours, col="black")
spplot(eberg_grid["DEM"], col.regions = SAGA_pal[[1]], sp.layout=l.sp)
spplot(eberg_zones, sp.layout=list("sp.points", eberg, col="black", pch="+"))
}
}
\keyword{datasets}
