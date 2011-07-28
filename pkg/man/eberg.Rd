\name{eberg}
\alias{eberg}
\title{Ebergotzen -- soil observations (augers)}
\description{
The table contains 2937 observations (augers) of soil textures and soil types. 
Eberg\"{o}tzen is 10 by 10 km study area in the vicinity of the city of G\"{o}ttingen in Central
Germany. This area has been
extensively surveyed over the years, mainly for the purposes of developing operational
digital soil mapping techniques (Gehrt and B\"{o}hner, 2001). 
}
\format{
  The data frame contains the following columns:
  \describe{
    \item{ID}{universal identifier}
    \item{X}{a numeric vector; x-coordinate (m)
	in DHDN / Gauss-Krueger zone 3 (German coordinate system) }
     \item{Y}{a numeric vector; y-coordinate (m)
	in DHDN / Gauss-Krueger zone 3 (German coordinate system) }
	\item{SAND}{topsoil sand content estimated by hand; see Ad-hoc-AG Boden (2005) }
  \item{SILT}{topsoil silt content estimated by hand }
	\item{CLAY}{topsoil clay content estimated by hand }
	\item{SOILTYPE}{a vector containing factors; soil classes according to the German soil classification system (13 classes in this data set)}
  } 
} 
\usage{
data(eberg)
}
\author{ The Eberg\"{o}tzen dataset is courtesy of \href{mailto:Ernst.Gehrt@niedersachsen.de}{Gehrt Ernst}, the State Authority
for Mining, Energy and Geology,
Hannover, Germany. The data set has been prepared for this exercise by Tomislav Hengl. }
\references{ 
Ad-hoc-AG Boden, 2005. Bodenkundliche Kartieranleitung. 5th Ed, Bundesanstalt fur Geowissenschaften und Rohstoffe und Nieders\"{a}chsisches Landesamt f\"{u}r Bodenforshung, Hannover, p. 423.

Gehrt, E., B\"{o}hner, J., 2001. Vom punkt zur flache --- probleme des ``upscaling'' in der bodenkartierung. In: Diskussionsforum Bodenwissenschaften: Vom Bohrstock zum Bildschirm. FH, Osnabr\"{u}ck, pp. 17–34.

Skaggs, T. H., Arya, L. M., Shouse, P. J., Mohanty, B. P., 2001. Estimating Particle-Size Distribution from Limited Soil Texture Data. Soil Science Society of America Journal 65 (4): 1038–1044.

\url{http://geomorphometry.org/content/ebergotzen}
}
\note{ Texture by hand method (Ad-hoc-AG Boden, 2005) can be used to determine the content of soil
earth fractions only to an accuracy of +-5-–10\% (Skaggs et al. 2001). A surveyor distinguishes to which of the 32 texture classes a soil samples belongs to, and then
estimates the content of fractions. E.g. texture class \code{St2} has 10\% clay, 25\% silt and 65\% sand. 
}
\seealso{\link{eberg_grid}}
\keyword{datasets}
\examples{
data(eberg)
str(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
}
