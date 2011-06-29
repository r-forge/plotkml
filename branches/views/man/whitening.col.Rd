\name{whitening.col}
\alias{whitening.col}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
whitening.col(x, var.name, error.name, z.lim, e.lim, global.var, col.type)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{var.name}{
%%     ~~Describe \code{var.name} here~~
}
  \item{error.name}{
%%     ~~Describe \code{error.name} here~~
}
  \item{z.lim}{
%%     ~~Describe \code{z.lim} here~~
}
  \item{e.lim}{
%%     ~~Describe \code{e.lim} here~~
}
  \item{global.var}{
%%     ~~Describe \code{global.var} here~~
}
  \item{col.type}{
%%     ~~Describe \code{col.type} here~~
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
function(x, var.name, error.name, z.lim, e.lim, global.var, col.type){
# var.name = name of the column with target variable
# error.name = name of the column with associated variance
# col.type = output col.type can be "RGB" or "hex" 
if(class(x)[1]=="data.frame"){
if(missing(z.lim)) { z.lim <- c(min(x[,var.name], na.rm=TRUE), max(x[,var.name], na.rm=TRUE)) }
if(missing(e.lim)) { e.lim <- c(.4,1) }
if(missing(col.type)) { col.type <- "RGB" }
if(missing(global.var)&is.numeric(x[,var.name])) { global.var <- var(x[,var.name], na.rm=TRUE) }
# Derive the normalized error:
x$er <- sqrt(x[,error.name])/sqrt(global.var)
# Strech the values (z) to the inspection range:
x$tmpz <- (x[,var.name]-z.lim[1])/(z.lim[2]-z.lim[1])
x$tmpzc <- ifelse(x$tmpz<=0, 0, ifelse(x$tmpz>1, 1, x$tmpz))
# Derive the Hue image:
x$tmpf1 <- -90-x$tmpzc*300
x$tmpf2 <- ifelse(x$tmpf1<=-360, x$tmpf1+360, x$tmpf1)
x$H <- ifelse(x$tmpf2>=0, x$tmpf2, (x$tmpf2+360))
# Strech the error values (e) to the inspection range:
x$tmpe <- (x$er-e.lim[1])/(e.lim[2]-e.lim[1])
x$tmpec <- ifelse(x$tmpe<=0, 0, ifelse(x$tmpe>1, 1, x$tmpe))
# Derive the saturation and intensity images:
x$S <- 1-x$tmpec
x$V <- 0.5*(1+x$tmpec)
# Convert the HSV values to RGB and put them as R, G, B bands:
if(col.type=="hex"){
out.cols <- hex(HSV(x$H, x$S, x$V))
return(out.cols)
  }
else { 
out.cols <- as(HSV(x$H, x$S, x$V), "RGB")
return(out.cols)
  } 
  } 
else { stop("data.frame object expected") } 
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
