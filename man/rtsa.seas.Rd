% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rtsa.seas.R
\name{rtsa.seas}
\alias{rtsa.seas}
\title{Raster time series Seasonal Adjustment analysis using X-11 and X-13ARIMA-SEATS methods}
\usage{
rtsa.seas(rasterts, rastermask = NULL, method = "x11", gapfill = "none",
  cores = 1L, only.statistics = FALSE, keep.original = FALSE,
  verbose = FALSE)
}
\arguments{
\item{rasterts}{Input raster time series as \code{\linkS4class{RasterStackTS}} or \code{\linkS4class{RasterBrickTS}} object.}

\item{rastermask}{Either a \code{\linkS4class{RasterLayer}} or "compute". Raster layer to use as a mask. When "compute" 
is set raster mask is computed to remove all pixels with incomplete time series.}

\item{method}{Character. Defines the method to be used for the Seasonal Adjustment analysis. Accepts argument 'x11' (default) or 'x13'.}

\item{gapfill}{Character. Defines the algorithm to be used to interpolate pixels with incomplete temporal profiles. 
Accepts argument supported as method in function \code{\link[rtsa]{rtsa.gapfill}}.}

\item{cores}{Integer. Defines the number of CPU to be used for multicore processing. Default to "1" core for 
singlecore processing.}

\item{only.statistics}{Logical. If TRUE returns only the statistics from seasonal, trend and remainder components.}

\item{keep.original}{Logical. If TRUE returns the original raster time series values in the 'rts' slot of \code{\link{STDstack-class}} object.}

\item{...}{Additional arguments to be passed through to function \code{\link[seasonal]{seas}}.}
}
\value{
Object of class \code{\link{STDstack-class}} containing the following components:
\tabular{rll}{
\tab \code{std} \tab Seasonal Trend Decomposition method used\cr
\tab \code{mask} \tab Final raster mask of computed pixels as \code{\linkS4class{RasterLayer}} object\cr
\tab \code{seasonal_amplitude} \tab Amplitude of seasonal component (statistic) as \code{\linkS4class{RasterLayer}} object\cr
\tab \code{seasonal_amplitude_stdev} \tab Standard deviation computed from the amplitude of seasonal component (statistic) as \code{\linkS4class{RasterLayer}} object\cr
\tab \code{trend_slope} \tab Trend slope computed from trend component (yearly statistic) as \code{\linkS4class{RasterLayer}} object\cr
\tab \code{residual_stdev} \tab Standard deviation computed from the remainder component (statistics) as \code{\linkS4class{RasterLayer}} object\cr
\tab \code{rts} \tab Input raster time series as \code{\linkS4class{RasterBrickTS}} object (only returned if \code{keep.original = TRUE})\cr
\tab \code{seasonality} \tab Seasonal component as \code{\linkS4class{RasterBrickTS}} object\cr
\tab \code{trend} \tab Trend component as \code{\linkS4class{RasterBrickTS}} object\cr
\tab \code{seasonaladjtrend} \tab Seasonal adjusted trend component as \code{\linkS4class{RasterBrickTS}} object\cr
\tab \code{remainder} \tab Remainder component as \code{\linkS4class{RasterBrickTS}} object\cr
}
}
\description{
This function conducts a Seasonal Adjustment analysis using X-11 and X-13ARIMA-SEATS methods 
from monthly raster time series using "seasonal" and "x13binary" packages.
}
\details{

}
\examples{
\dontrun{
## create raster time series using the 'pacificSST' data from 'remote' package
require(remote)

data(pacificSST)
pacificSST[which(getValues(pacificSST == 0))] <- NA # set NA values
# subset input for faster processing
pacificSST_clip <- crop(pacificSST, extent(260, 290, -15, 15))
# create rts object
rasterts <- rts(pacificSST_clip, seq(as.Date('1982-01-15'), as.Date('2010-12-15'), 'months'))

## generate raster mask
raster_mask <- pacificSST_clip[[1]] # create raster mask
names(raster_mask) <- "mask"
values(raster_mask) <- 1 # set raster mask values
raster_mask[which(is.na(getValues(pacificSST_clip[[1]])))] <- 0 # set raster mask values

## compute Seasonal Adjustment analysis
# use 'x11' (X-11) method to compute only adjusted seasonal trend decomposition statistics
std_x11_stats <- rtsa.seas(rasterts, rastermask=raster_mask, method="x11", only.statistics=TRUE)
# use 'x11' (X-11) method
std_x11_result <- rtsa.seas(rasterts=rasterts, rastermask=raster_mask, method="x11")
# use 'x13' (X-13ARIMA-SEATS) method
std_x13_result <- rtsa.seas(rasterts=rasterts, rastermask=raster_mask, method="x13")
# use 'x11' (X-11) method with multiple cores support and returning the original raster values
std_x11_res <- rtsa.seas(rasterts=rasterts, rastermask=raster_mask, cores=2, keep.original=TRUE)
}

}
\references{
Shiskin, J., Young, A.H., Musgrave, J.C. (1967). The X-11 variant of the Census Method II 
seasonal adjustment program. Technical Paper No. 15, U.S. Department of Commerce, U. S. Census Bureau.

Dagum, E.B. (1978). Modelling, forecasting and seasonally adjusting economic time series with the X-11 ARIMA method. 
Journal of the Royal Statistical Society. Series D (The Statistician), 27(3/4), 203-216.

Comprehensive list of R examples from the X-13ARIMA-SEATS manual: 
\href{http://www.seasonal.website/examples.html}{manual}

Official X-13ARIMA-SEATS manual: 
\href{https://www.census.gov/ts/x13as/docX13ASHTML.pdf}{pdf}
}
\seealso{
\code{\link[seasonal]{seas}}, \code{\link[stlplus]{stlplus}}, \code{\link[rtsa]{rtsa.seas}}, \code{\link[rtsa]{rtsa.gapfill}}, \code{\link[stats]{stl}}, \code{\link[stats]{decompose}}
}
\author{
Federico Filipponi
}
\keyword{adjustment}
\keyword{analysis}
\keyword{seasonal}
\keyword{series}
\keyword{time}
\keyword{x-11}
\keyword{x-13ARIMA-SEATS}
