```         
# set working directory to R project for nmdp.asom app
# working directory should be wherever app.R is housed:
mydir <- "Z:/consulting/Logan_Brent/nmdp.asom"
setwd(mydir)

list.files(mydir)

# make sure that model objects deadcounter.rds and efscounter.rds are saved in data folder:
list.files(paste0(mydir, "/data"))

# To run the app:
# Note the model objects are large and the initial load could take a long time:
library(shiny)
# Run and time startup
Sys.time()
shiny::runApp()
Sys.time()

# you should see a message in the console if the app is successfully loading: 'Loading nmdp.asom'

# Dependent packages should automatically be installed/loaded but just in case,
# app dependencies (also noted in NAMESPACE):
# import(bslib)
# import(flextable)
# import(ggplot2)
# import(nftbart)
# import(shiny)
# import(shinyBS)
# import(shinyjs)
# import(waiter)
# importFrom(golem,activate_js)
# importFrom(golem,add_resource_path)
# importFrom(golem,bundle_resources)
# importFrom(golem,favicon)
# importFrom(golem,with_golem_options)
# importFrom(shiny,HTML)
# importFrom(shiny,NS)
# importFrom(shiny,column)
# importFrom(shiny,shinyApp)
# importFrom(shiny,tagAppendAttributes)
# importFrom(shiny,tagList)
# importFrom(shiny,tags)
```
