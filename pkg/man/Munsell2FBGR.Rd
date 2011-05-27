\name{Munsell2FBGR}
\alias{Munsell2FBGR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Munsell2FBGR}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Munsell2FBGR(x, Munsell, transp)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{Munsell}{
%%     ~~Describe \code{Munsell} here~~
}
  \item{transp}{
%%     ~~Describe \code{transp} here~~
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
function(x, Munsell, transp) {
# Munsell = munsell color codes column;
# merge munsell color codes in format "7.5R_2_4" and RGB values:
if(missing(transp)) { transp <- "dd" }
for(i in 1:length(x[,Munsell])){
x[i, "Hue"] <- strsplit(as.character(x[i, Munsell]), "_")[[1]][1]
x[i, "Chroma"] <- as.numeric(strsplit(as.character(x[i, Munsell]), "_")[[1]][2]) 
x[i,"Value"] <- as.numeric(strsplit(as.character(x[i, Munsell]), "_")[[1]][3])
  }
mcolor.RGB <- munsell2rgb(the_hue=x$Hue, the_chroma=x$Chroma, the_value=x$Value, return_triplets=TRUE)
mcolor.RGB$Rc <- round(mcolor.RGB$r*100, 0)
mcolor.RGB$Gc <- round(mcolor.RGB$g*100, 0)
mcolor.RGB$Bc <- round(mcolor.RGB$b*100, 0)
# reformat colors suited for Google Earth:
Bc <- ifelse(mcolor.RGB$Bc<10, paste("0", mcolor.RGB$Bc, sep=""), ifelse(mcolor.RGB$Bc==100, "ff", mcolor.RGB$Bc))
Gc <- ifelse(mcolor.RGB$Gc<10, paste("0", mcolor.RGB$Gc, sep=""), ifelse(mcolor.RGB$Gc==100, "ff", mcolor.RGB$Gc))
Rc <- ifelse(mcolor.RGB$Rc<10, paste("0", mcolor.RGB$Rc, sep=""), ifelse(mcolor.RGB$Rc==100, "ff", mcolor.RGB$Rc))
FBGR <- paste(transp, Bc, Gc, Rc, sep="")
return(FBGR)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
