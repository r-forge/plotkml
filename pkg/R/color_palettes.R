# Purpose        : Color palettes for visualization of numeric (continuous, binary, ordinary) and categorical variables;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Status         : pre-alpha
# Note           : a gallery of color palettes is visiable from [http://plotkml.r-forge.r-project.org/];

mix3cols <- function(
  color1, 
  color2, 
  color3, 
  break1 = 1/2, 
  no.col = 47
  ){

  if(break1 <= 0 | break1 >= 1) {
  stop('break1 must be in the (0--1) range')
  }
  else {
  # round the breaks:
  no.col1 <- round(break1*no.col, 0)
  if(no.col1==0) {no.col1 <- no.col1+1}
  no.col2 <- round((1-break1)*no.col, 0)
  if(no.col2==no.col) {no.col2 <- no.col2-1}  
  col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
  col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
  mixedcol <- c(col1_2, col2_3)
  return(mixedcol)
  }
}

mix5cols <- function(
  color1, 
  color2, 
  color3, 
  color4, 
  color5, 
  break1 = 1/4, 
  break2 = 2/4, 
  break3 = 3/4, 
  no.col = 47
  ){

  if(break1 <= 0 | break1 >= 1 | break2 <= 0 | break2 >= 1 | break3 <= 0 | break3 >= 1 | break2 > break3 | break1 > break2) {
  stop('breaks must be in the (0--1) range; break3 must be > break2 > break1')
  }
  else {
  # Mixes three RGB colors into a pallette
  no.col1 <- round(break1*no.col, 0)
  if(no.col1==0) {no.col1 <- no.col1+1}
  no.col2 <- round((break2-break1)*no.col, 0)
  if(no.col2==no.col1) {no.col2 <- no.col2+1}
  no.col3 <- round((break3-break2)*no.col, 0)
  if(no.col3==no.col2) {no.col3 <- no.col3+1}
  no.col4 <- round((1-break3)*no.col, 0)
  if(no.col4==no.col) {no.col4 <- no.col4-1} 
  col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
  col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
  col3_4 <- sapply(sapply(seq(0,1,by=1/no.col3)[-no.col3], mixcolor, color3, color4), hex)
  col4_5 <- sapply(sapply(seq(0,1,by=1/no.col4), mixcolor, color4, color5), hex)
  mixedcol <- c(col1_2, col2_3, col3_4, col4_5)
  return(mixedcol)
  }
}

# Display default palettes:
display.pal <- function(pal, sel=1:10, names=FALSE) {
  
  if(missing(pal)) { pal <- SAGA_pal }
  if(names==FALSE){ 
  dev.new(width=2.1, height=length(sel))
	## not needed	
	# fin=c(2.1, length(sel)*.9), 
	par(mfrow=c(length(sel),1), mar=c(1.5,.8,1.5,.5))
	# plot palettes above each other:
	for(j in sel){
	  plot(y=rep(1, length(pal[[j]])), x=1:length(pal[[j]]), axes=FALSE, xlab='', ylab='', pch=15, cex=1.5, col=pal[[j]])
	  mtext(names(pal)[j], cex=.5, side=3)
	}
  } # names == TRUE:
  else {
	sel <- sel[1] # take only the first pallette from the list
	pal.name <- names(pal)[sel]
	pal <- pal[[sel]]
	
	# used to compute plotting region, not figure size
	leg.width <- (max(nchar(names(pal)))*20+150)/100
	leg.height <- length(pal)
	
	par(mar=c(.5,0,1.5,1))
	# plot palette and class names:
	plot(x=rep(1, length(pal)), y=1:length(pal), axes=FALSE, xlab='', ylab='', pch=15, cex=1.5, col=pal, xlim=c(0,.6*leg.width), asp=.6)
	text(x=rep(1, length(pal)), y=1:length(pal), labels=names(pal), cex=.5, pos=4, offset=1)
	mtext(pal.name, cex=.8, side=3)  
  }
}

# end of script;