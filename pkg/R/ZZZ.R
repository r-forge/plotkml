# Purpose        : Clean up / closing settings;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : tested
# Note           : for more info see [http://cran.r-project.org/doc/manuals/R-exts.html];

# load plotKML.opts with some basic information
plotKML.env(show.env = FALSE)
# (!) this will not attempt to locate external software because this could be time consuming;

## R color palettes
# Standard soil vars color legends
# e.g. soil organic carbon:
soc.pal <- mix5cols(color1=RGB(0.706, 0.804, 0.804), color2=RGB(0.663, 0.663, 0.663), color3=RGB(0, 0.392, 0), color4=RGB(0.0,0.1,0.0), color5=RGB(0,0,0), break1=.2, break2=.4, break3=.6, no.col=20)
# soil pH:
pH.pal <- hsv(seq(0,1,by=1/27))[1:20]
# texture fractions:
tex.pal <- mix3cols(color1=RGB(1,0.843,0), color2=RGB(0.5451,0.353,0.169), color3=RGB(0,0,0), break1=.6, no.col=20)
## HCL examples from [http://cran.r-project.org/web/packages/colorspace/vignettes/hcl-colors.pdf]
blue_grey_red <- diverge_hcl(20, c = c(100, 0), l = c(50, 90), power = 1.3)
grey_black <- rev(sequential_hcl(20, c = 0, power = 2.2))

# Other popular R palletes for continuous variables:
R_pal <- NULL
R_pal[[1]] <- rev(rainbow(27)[1:20]) 
R_pal[[2]] <- rev(heat.colors(20))
R_pal[[3]] <- terrain.colors(20)
R_pal[[4]] <- topo.colors(20)
R_pal[[5]] <- rev(bpy.colors(20))
R_pal[[6]] <- soc.pal
R_pal[[7]] <- pH.pal
R_pal[[8]] <- tex.pal
R_pal[[9]] <- blue_grey_red
R_pal[[10]] <- grey_black

names(R_pal) <- c("rainbow_75", "heat_colors", "terrain_colors", "topo_colors", "bpy_colors", "soc_pal", "pH_pal", "tex_pal", "blue_grey_red", "grey_black")

# end of script;