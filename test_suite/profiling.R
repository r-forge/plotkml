# simple profiling of some functions
library(plotKML)
library(profr)
library(RColorBrewer)
library(lattice)

# 1. simple points along a regular grid: 135 seconds on windows
d <- expand.grid(x=0:90, y=0:90)
d$id <- factor(sample(letters[1:5], nrow(d), replace=TRUE))
d$z <- runif(nrow(d))

coordinates(d) <- ~ x + y 
proj4string(d) <- CRS('+proj=longlat +datum=WGS84')
p <- profr(kml(d, file='test_1.kml', colour=z, overwrite=TRUE))

# default output from profr plot method
plot(p, cex=0.5, minlabel=0.01)

# more useful, univariate summary
p.sum <- ddply(p, .(f), .fun=summarise, total_time=sum(time))
p.sum <- p.sum[order(p.sum$total_time, decreasing=TRUE), ]
p.sum$prop <- p.sum$total_time / p.sum$total_time[1]
p.sum.10 <- head(p.sum[-1, ], 10)
p.sum.10$f <- factor(p.sum.10$f, levels=p.sum.10$f[order(p.sum.10$total_time)])

dotplot(f ~ total_time, data=p.sum.10)


# multi-variate summary:

