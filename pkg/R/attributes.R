# Purpose        : Convert an attribute table associated with spatial data into an HTML <description> bubble
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl);
# Status         : ready for R-forge
# Note           : required by KML writing functions;

.df_to_kml_html_table <- function(x, columns=TRUE) {
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  
  # if the user passed in TRUE, then we want all of the columns
  if(class(columns) == 'logical')
      columns <- 1:ncol(x) # use all columns from the dataframe row
  
  # otherwise, keep only requested columns
  x <- x[, columns]
  x.names <- names(x)
  
  # empty list to store html elements
  html.list <- list()
  
  # create vector of attribute column names, padded with HTML styling
  att.names <- sapply(x.names, function(i) { paste('<span style="font-weight: bold; color: #000000; padding:3px;">', as.character(i), '</span>:&nbsp;', sep = '') })
 
  # create vector of styled attribute values
  att.values <- sapply(x, function(i) { paste('<span style="color: #000000; padding:3px;">', as.character(i), '</span><br>', sep = '') })
  
  # combine by interleaving:
  att <- paste(att.names, att.values, collapse="\n")
  
  # format the output: consider adding a heuristic for adjusting ballon div width
  html.list <- append(html.list, '<description><![CDATA[')
  html.list <- append(html.list, '<div line-height:1.25; style="width:600px; border:1px solid; padding:3px ">')
  html.list <- append(html.list, att)
  html.list <- append(html.list, '</div>')
  html.list <- append(html.list, ']]></description>\n')

  cat(paste(html.list, collapse = "\n"), file = file.connection, append = TRUE)
}

# end of script;
