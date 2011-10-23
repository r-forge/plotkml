\name{worldgrids_pal}
\alias{color_palettes}
\title{Standard global color palettes for factor variables}
\description{
10 color palettes used to visualize various environmental categorical / factor variables: land cover classes, water types, anthroms, soil types and similar. Each colour palette consists of a number of colours in the hexadecimal system. 
}
\format{
  The list contains:
  \describe{
    \item{anthroms}{Color palette used for the global map of anthroms (Ellis and Ramankutty, 2008).}
    \item{bodemfgr}{A simplified color palette for soil types.}
     \item{corine2k}{Color palette used in the Corine 2000 project for land cover classes (\enc{Büttner}{Buttner}, et al., 2002).}
     \item{glc2000}{Color palette used for the Global Land Cover 2000 mapping project (Global Land Cover 2000).}
     \item{globcov}{Color palette used for the ENVISAT-based Global Land Cover map at resolution of 300 m (GlobCover Land Cover version V2.2).}
     \item{gtkaart}{Color palette used for the Ground water levels map of the Netherlands (Gaast et al. 2005).}
     \item{IGBP}{Color palette for 17 land cover classes defined by the International Geosphere Biosphere Programme (IGBP).}
     \item{lgn3}{Color palette used for the Dutch land use map (Hazeu, 2005).}
     \item{t250vlak}{Color palette used for the most general land use classes at scale 1:250k (TOP250NL).}
     \item{watert}{Color palette used for the water types (generalized) in the Netherlands.}
  }
}
\usage{
data(worldgrids_pal)
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\references{
Bicheron, P. et al. (2008) \href{http://ionia1.esrin.esa.int}{GLOBCOVER: Products Description and Validation Report}. MEDIAS France, Toulouse, 47 p.\cr
\enc{Büttner}{Buttner}, G. et al. (2002) \href{http://terrestrial.eionet.europa.eu/CLC2000}{Corine Land Cover update 2000, Technical guidelines}. EEA (European Environment Agency), Kopenhagen. \cr
Ellis, E.C., Ramankutty, N. (2008) \href{http://www.eoearth.org/article/Anthropogenic_biome_maps}{Putting people in the map: anthropogenic biomes of the world}. Frontiers in Ecology and the Environment, Vol. 6, No. 8, pp. 439-447.\cr
Fritz, S. et al. (2003) \href{http://bioval.jrc.ec.europa.eu/products/glc2000/glc2000.php}{Harmonisation, mosaicing and production of the Global Land Cover 2000 database}. JRC report EUR 20849 EN, Luxembourg, 41 p.\cr
Gaast, J.W.J. van der, H.R.J. Vroon en M. Pleijter, (2006) De grondwaterdynamiek in het waterschap Regge en Dinkel. Wageningen, Alterra-rapport 1335.\cr 
Hazeu, G.W., (2005) Landelijk Grondgebruiksbestand Nederland (LGN5). Vervaardiging, nauwkeurigheid en gebruik. Wageningen, Alterra. Alterra-report 1213, 92 pp. \url{http://lgn.nl}\cr 
Puijenbroek, P. van; Clement, J., (2008) Het oppervlaktewater getypeerd: de eerste Nederlandse watertypenkaart. Agro informatica 21(3): 21-25.
}
\note{These colour palettes are only valid for factor-type variables. The names of classes used in the legend can be obtained by loading the palette list.}
\seealso{\link{SAGA_pal}, \link{R_pal}}
\keyword{colour palletes}
\examples{
data(worldgrids_pal)
display.pal(worldgrids_pal)
dev.off()
## globcov palette with class names:
display.pal(worldgrids_pal, sel=5, names=TRUE)
}
