\name{kml_open}
\alias{kml_open}

\title{Opens a KML file}

\description{
Opens a KML file in write mode and initiates the KML header. It is then setting up a file connection accessible by other kml_*() function such as kml_layer() and kml_close() to create personalised, multi-layered KML files.
}

\usage{
kml_open(file, name = file, overwrite = FALSE, kml.url = "http://www.opengis.net/kml/2.2")
}

\arguments{
  \item{file}{either a character string naming a file.}
  \item{name}{A name for the KML file to be created.}
  \item{overwrite}{Logical. If ‘TRUE’, "name" will be overwritten if it exists}
  \item{kml.url}{URL of the KML standard to be used.}
}

\details{
%%  ~~ If necessary, more details than the description above ~~
}

\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}

\references{
%% ~put references to the literature/web site here ~
}

\author{Pierre Roudier and Dylan Beaudette}

\note{}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{kml}}, \code{\link{kml_close}}, \code{\link{kml_layer}}
}

\examples{
}

\keyword{hplot}

