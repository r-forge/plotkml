# Purpose        : Clean up / closing settings;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : pre-alpha
# Note           : for more info see [http://cran.r-project.org/doc/manuals/R-exts.html];

.onLoad <- function(lib, pkg)  {
	pkg.info <- drop(read.dcf(file=system.file("DESCRIPTION", package=pkg), fields=c("Version","Date")))
	packageStartupMessage(paste(pkg, " version ", pkg.info["Version"], " (", pkg.info["Date"], ")", sep=""))

	tst <- try( removeTmpFiles(), silent=TRUE )
  plotKML.env(show.env = FALSE)
  	
  return(invisible(0))

}

# end of script;