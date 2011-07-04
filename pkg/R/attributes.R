

  
# convert an attribute table associated with spatial data into an HTML <description> bubble
# for use within Google Earth
.df_to_kml_html_table <- function(x, file)
  {
  # empty list to store html elements
  html.list <- list()
  
  # create header
  table.head <- c('<tr style="background-color: #D3D3D3; font-weight: bold; text-align: center; color: #000000;">', paste('<td>', names(x), '</td>', sep=''), "</tr>")
  
  # create the body
  table.body <- apply(x, 1, .df_row_to_html_row)
  
  # make the table
  html.list[1] <- '<description><![CDATA['
  html.list[2] <- '<table border="0" padding="2" spacing="1">'
  html.list[3] <- paste(table.head, collapse='')
  html.list[4] <- paste(table.body, collapse='')
  html.list[5] <- '</table>'
  html.list[5] <- ']]></description>\n'
  
  cat(paste(html.list, collapse="\n"), file=file, append=TRUE)
  }
  

# convert each DF row into a table row and apply default styling
.df_row_to_html_row <- function(x)
  paste(c('<tr style="background-color: #E9E9E9; color: #000000;">', paste('<td>', x, '</td>', sep=''), '</tr>'), collapse='')
  
