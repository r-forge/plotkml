# convert an attribute table associated with spatial data into an HTML <description> bubble
# for use within Google Earth
.df_to_kml_html_table <- function(x, columns=TRUE) {
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  
  # if the user passed in TRUE, then we want all of the columns
  if(class(columns) == 'logical')
      columns <- 1:ncol(x) # use all columns from the dataframe row
  
  # otherwise, keep only requested columns
  x <- x[, columns]

  # empty list to store html elements
  html.list <- list()

  # create header
  table.head <- c('<tr style="background-color: #D3D3D3; font-weight: bold; text-align: center; color: #000000;">', paste('<td>', names(x), '</td>', sep=''), "</tr>\n")

  # create the body
  table.body <- paste(sapply(x, function(i) { paste('<td style="width:auto;">', as.character(i), '</td>', sep = '') }), collapse='')
  table.body <- paste('<tr style="background-color: #E9E9E9; color: #000000;">', table.body, "</tr>", collapse = '')
    
  # make the table
  html.list <- append(html.list, '<description><![CDATA[')
  html.list <- append(html.list, '<table border="0" padding="2" spacing="1" style="width:600px;>')
  html.list <- append(html.list, paste(table.head, collapse = ''))
  html.list <- append(html.list, paste(table.body, collapse = ''))
  html.list <- append(html.list, '</table>')
  html.list <- append(html.list, ']]></description>\n')

  cat(paste(html.list, collapse = "\n"), file = file.connection, append = TRUE)
}


