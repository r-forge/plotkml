\name{write.legend.gif}
\alias{write.legend.gif}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
write.legend.gif(x, var.type, var.name, legend.file.name, legend.pal, z.lim, factor.labels)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{var.type}{
%%     ~~Describe \code{var.type} here~~
}
  \item{var.name}{
%%     ~~Describe \code{var.name} here~~
}
  \item{legend.file.name}{
%%     ~~Describe \code{legend.file.name} here~~
}
  \item{legend.pal}{
%%     ~~Describe \code{legend.pal} here~~
}
  \item{z.lim}{
%%     ~~Describe \code{z.lim} here~~
}
  \item{factor.labels}{
%%     ~~Describe \code{factor.labels} here~~
}
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
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(x, var.type, var.name, legend.file.name, legend.pal, z.lim, factor.labels) {
if(class(x)[1]=="SpatialGridDataFrame"|class(x)[1]=="SpatialPixelsDataFrame"|class(x)[1]=="SpatialPolygonsDataFrame"|class(x)[1]=="SpatialLinesDataFrame"){
if(missing(var.type)) { var.type <- "numeric" }
if(missing(legend.file.name)) { legend.file.name <- paste(var.name, "_legend.png", sep="") }
if(missing(legend.pal)) { col.no <- 48; legend.pal <- rev(rainbow(65)[1:col.no]) }
if(missing(z.lim)&var.type=="numeric") { z.lim <- c(quantile(x@data[,var.name], 0.025, na.rm=TRUE), quantile(x@data[,var.name], 0.975, na.rm=TRUE)) }
if(var.type=="factor") {
if(missing(factor.labels)){ col.no <- length(levels(as.factor(x@data[,var.name])))  }
else { col.no <- length(factor.labels) }
if(missing(factor.labels)) {
### NOTE : This is a not a perfect implementation for long text levels!
leg.width <- max(nchar(levels(as.factor(x@data[,var.name]))))*5+70  # 5 pix per character
leg.height <- length(levels(as.factor(x@data[,var.name])))*40 # 20 pix per class
  }
else {
leg.width <- max(nchar(factor.labels))*10+70  # 10 pix per character
leg.height <- length(factor.labels)*40 # 20 pix per class
  }
png(file=legend.file.name, width=leg.width, height=leg.height, bg="transparent", pointsize=14)
# c(bottom, left, top, right)
par(mar=c(.5,0,.5,1))
plot(x=rep(1, col.no), y=1:col.no, axes=FALSE, xlab='', ylab='', pch=15, cex=4, col=legend.pal)
if(missing(factor.labels)) {
text(x=rep(1, col.no), y=1:col.no, labels=levels(as.factor(x@data[,var.name])), cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
  }
else { 
text(x=rep(1, col.no), y=1:col.no, labels=factor.labels, cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
  }
dev.off()
  }
else {
png(file=legend.file.name, width=120, height=240, bg="transparent", pointsize=14)
par(mar=c(.5,0,.5,4))
plot(x=0:5, y=0:5, asp=3, type="n", axes=FALSE, xlab='', ylab='')
colno <- legend.pal
# get the 2-4 significant digits
lower.lim <- z.lim[1]
upper.lim <- z.lim[2]
col.labels <- signif(c(lower.lim, (upper.lim-lower.lim)/2, upper.lim), 2)
color.legend(xl=0, yb=0, xr=5, yt=5, legend=col.labels, rect.col=colno, gradient="y", align="rb", cex=1.4, col=rgb(0.99,0.99,0.99))
dev.off()
  }
  }
else { stop("first argument should be of class sp (Grid, Pixel, Polygons, Lines)") } 
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
