\name{fit.gstatModel-methods}
\docType{methods}
\alias{fit.gstatModel-methods}
\alias{fit.gstatModel}
\alias{fit.gstatModel,SpatialPointsDataFrame,formula,SpatialPixelsDataFrame-method}
\title{Methods to fit a regression-kriging model}
\description{Tries to automatically fit a regression-kriging model for a given set of points and covariates (object of type \code{"SpatialPixelsDataFrame"}; 2-dimensional objects only applicable). It runs GLM following the \code{formulaString} model and then fits variogram for residuals usign the \code{fit.variogram} method from the package gstat. Creates an output object of class \code{\link{gstatModel-class}}.}
\usage{
fit.gstatModel(observations, formulaString, covariates, \dots )
}
\arguments{
  \item{observations}{object of type \code{"SpatialPointsDataFrame"}}
  \item{formulaString}{object of type \code{"formula"} or a character}
  \item{covariates}{object of type \code{"SpatialPixelsDataFrame"}}
  \item{\dots}{other optional arguments that can be passed to \code{glm} and/or \code{fit.variogram}}
}
\details{Optional arguments are \code{vgmFun} --- variogram model type passed from gstat; \code{family} --- character string defyning the GLM family (for more info see \code{stats::glm}); \code{stepwise} --- specifies wether to run step-wise regression on top of GLM to get an optimal subset of predictors. The method by default assumes that the target variable follows a log-normal distribution \code{family = gaussian(log)}, i.e. that the target variable is \emph{definite positive}. For a binomial variable use \code{family = binomial(logit)}; for a poisson-type variable use \code{family = poisson(log)}; otherwise use \code{family = gaussian} to fit a simple multiple linear regression model. }
\references{
\itemize{
\item Hengl, T. (2009) \href{http://spatial-analyst.net/book/}{A Practical Guide to Geostatistical Mapping}, 2nd Edt. University of Amsterdam, www.lulu.com, 291 p.
}
}
\author{ Tomislav Hengl}
\seealso{ \code{\link{gstatModel-class}}, \code{stats::glm}, \code{gstat::fit.variogram}
}
\examples{
data(meuse)
coordinates(meuse) <- ~x+y
# load grids:
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
# fit a model:
omm <- fit.gstatModel(observations = meuse, formulaString = om~dist, covariates = meuse.grid)
show(omm@regModel)
om.sp <- SpatialPointsDataFrame(omm@sp, data = omm@regModel$model)
\dontrun{
# plot a variogram:
plot(variogram(om~1, om.sp))
}
}
\keyword{ regression-kriging}
