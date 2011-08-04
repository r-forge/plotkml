# convert an attribute table associated with spatial data into an HTML <description> bubble
# for use within Google Earth
.df_to_kml_html_table <- function(df, n_digits_max = 3) {
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  # Rounding the numeric fields for display
  df <- round(df[which(sapply(df, class) == "numeric")], digits = n_digits_max)

  # empty list to store html elements
  html.list <- list()

  # create header
  table.head <- c('<tr style="background-color: #D3D3D3; font-weight: bold; text-align: center; color: #000000;">', paste('<td>', names(df), '</td>', sep=''), "</tr>")

  # create the body
  table.body <- apply(df, 1, .df_row_to_html_row)

  # make the table
  html.list <- append(html.list, '<description><![CDATA[')
  html.list <- append(html.list, '<table border="0" padding="2" spacing="1">')
  html.list <- append(html.list, paste(table.head, collapse = ''))
  html.list <- append(html.list, paste(table.body, collapse = ''))
  html.list <- append(html.list, '</table>')
  html.list <- append(html.list, ']]></description>\n')

  cat(paste(html.list, collapse = "\n"), file = file.connection, append = TRUE)
}

# convert each DF row into a table row and apply default styling
.df_row_to_html_row <- function(x)
  paste(c('<tr style="background-color: #E9E9E9; color: #000000;">', paste('<td>', x, '</td>', sep = ''), '</tr>'), collapse = '')
