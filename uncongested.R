#  https://www.kaggle.com/lemur78/random-forest-on-h2o

#################### load packages and data
library(randomForest)
library(h2o)
library(tidyverse)
library(data.table)
library(ranger)
library(lubridate)

CRTOTALpython <- fread('C:/Users/yzy67/Desktop/PSU/research2/RESEARCHDATA/GData2/12thData/CRTOTALpython.csv')
CRTOTALpython$V1 <- NULL
setnames(CRTOTALpython, old=c("May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
                                        "15PM","16PM","45mph","50mph","55mph","65mph","70mph","Altoona GreenWESTBOUND",
                                        "Altoona GreenEASTBOUND","Altoona OrangeNORTHBOUND",
                                        "Altoona OrangeSOUTHBOUND","Lancaster BlueEASTBOUND",
                                        "Lancaster BlueWESTBOUND","Lancaster OrangeEASTBOUND",
                                        "Lancaster OrangeWESTBOUND","Meadville BlueNORTHBOUND",
                                        "Meadville BlueSOUTHBOUND","Meadville RedNORTHBOUND",
                                        "Meadville RedSOUTHBOUND","Pocono BlackEASTBOUND",
                                        "Pocono BlackWESTBOUND","Pocono BlueEASTBOUND",
                                        "Pocono BlueWESTBOUND","Williamsport BlueNORTHBOUND",
                                        "Williamsport BlueSOUTHBOUND","Williamsport GreenNORTHBOUND",
                                        "Williamsport GreenSOUTHBOUND", "precipitation",
                                        "visibility","speed"),
         new=c("May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
               "15PM","16PM","45mph","50mph","55mph","65mph","70mph",
               'Altoona_US22_Exit_Cresson_EAST','Altoona_US22_Exit_Cresson_WEST',
               'Altoona_US219_Exit_Ebensburg_NORTH','Altoona_US219_Exit_Ebensburg_SOUTH',
               'Lancaster_PA283_MtJoy_772_EAST','Lancaster_PA283_MtJoy_772_WEST',
               'Lancaster_US30_Exit_Wrightville_EAST','Lancaster_US30_Exit_Wrightville_WEST',
               'Meadville_I79_Exit_66_NORTH','Meadville_I79_Exit_66_SOUTH',
               'Meadville_I79_Exit_130_NORTH','Meadville_I79_Exit_130_SOUTH',
               'Pocono_I80_Exit_299_EAST','Pocono_I80_Exit_299_WEST',
               'Pocono_US209_Exit_309_EAST','Pocono_US209_Exit_309_WEST',
               'Williamsport_US15_Exit_WhiteDeer_NORTH','Williamsport_US15_Exit_WhiteDeer_SOUTH',
               'Williamsport_I180_Exit_13_NORTH','Williamsport_I180_Exit_13_SOUTH',
               "precipitation","visibility",'speed'))
                                        

#################### data partition
train_index = sample(1:nrow(CRTOTALpython), as.integer(dim(CRTOTALpython)[1]*0.75))
train <- CRTOTALpython[train_index,]
test <- CRTOTALpython[-train_index,]



#################### transform data to h2o data
features <- c("May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
              "15PM","16PM","45mph","50mph","55mph","65mph","70mph",
              'Altoona_US22_Exit_Cresson_EAST','Altoona_US22_Exit_Cresson_WEST',
              'Altoona_US219_Exit_Ebensburg_NORTH','Altoona_US219_Exit_Ebensburg_SOUTH',
              'Lancaster_PA283_MtJoy_772_EAST','Lancaster_PA283_MtJoy_772_WEST',
              'Lancaster_US30_Exit_Wrightville_EAST','Lancaster_US30_Exit_Wrightville_WEST',
              'Meadville_I79_Exit_66_NORTH','Meadville_I79_Exit_66_SOUTH',
              'Meadville_I79_Exit_130_NORTH','Meadville_I79_Exit_130_SOUTH',
              'Pocono_I80_Exit_299_EAST','Pocono_I80_Exit_299_WEST',
              'Pocono_US209_Exit_309_EAST','Pocono_US209_Exit_309_WEST',
              'Williamsport_US15_Exit_WhiteDeer_NORTH','Williamsport_US15_Exit_WhiteDeer_SOUTH',
              'Williamsport_I180_Exit_13_NORTH','Williamsport_I180_Exit_13_SOUTH',
              "precipitation","visibility")

# the entire data:
CRTOTALpython <- CRTOTALpython %>%
  sample_frac(size=1) %>%
  select("May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
         "15PM","16PM","45mph","50mph","55mph","65mph","70mph",
         'Altoona_US22_Exit_Cresson_EAST','Altoona_US22_Exit_Cresson_WEST',
         'Altoona_US219_Exit_Ebensburg_NORTH','Altoona_US219_Exit_Ebensburg_SOUTH',
         'Lancaster_PA283_MtJoy_772_EAST','Lancaster_PA283_MtJoy_772_WEST',
         'Lancaster_US30_Exit_Wrightville_EAST','Lancaster_US30_Exit_Wrightville_WEST',
         'Meadville_I79_Exit_66_NORTH','Meadville_I79_Exit_66_SOUTH',
         'Meadville_I79_Exit_130_NORTH','Meadville_I79_Exit_130_SOUTH',
         'Pocono_I80_Exit_299_EAST','Pocono_I80_Exit_299_WEST',
         'Pocono_US209_Exit_309_EAST','Pocono_US209_Exit_309_WEST',
         'Williamsport_US15_Exit_WhiteDeer_NORTH','Williamsport_US15_Exit_WhiteDeer_SOUTH',
         'Williamsport_I180_Exit_13_NORTH','Williamsport_I180_Exit_13_SOUTH',
         "precipitation","visibility","speed")
h2o.init(nthreads = -1)
CRTOTALpython_h2o <- as.h2o(CRTOTALpython) # convert to h2o data
# first random forest model with the entire data
rf_total_h2o <- h2o.randomForest(y='speed',x=features, 
                                 training_frame = CRTOTALpython_h2o,
                                 ntree=250)
print(rf_total_h2o)
h2o.r2(rf_total_h2o)


# data partition
train_frac <- train %>%
  sample_frac(size=1) %>%
  select( "May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
          "15PM","16PM","45mph","50mph","55mph","65mph","70mph",
          'Altoona_US22_Exit_Cresson_EAST','Altoona_US22_Exit_Cresson_WEST',
          'Altoona_US219_Exit_Ebensburg_NORTH','Altoona_US219_Exit_Ebensburg_SOUTH',
          'Lancaster_PA283_MtJoy_772_EAST','Lancaster_PA283_MtJoy_772_WEST',
          'Lancaster_US30_Exit_Wrightville_EAST','Lancaster_US30_Exit_Wrightville_WEST',
          'Meadville_I79_Exit_66_NORTH','Meadville_I79_Exit_66_SOUTH',
          'Meadville_I79_Exit_130_NORTH','Meadville_I79_Exit_130_SOUTH',
          'Pocono_I80_Exit_299_EAST','Pocono_I80_Exit_299_WEST',
          'Pocono_US209_Exit_309_EAST','Pocono_US209_Exit_309_WEST',
          'Williamsport_US15_Exit_WhiteDeer_NORTH','Williamsport_US15_Exit_WhiteDeer_SOUTH',
          'Williamsport_I180_Exit_13_NORTH','Williamsport_I180_Exit_13_SOUTH',
          "precipitation","visibility","speed")
h2o.init(nthreads = -1)   # connect to h2o server
h2o_train <- as.h2o(train_frac)



################### run random forest on training set
rf_sub_h2o <- h2o.randomForest(y='speed',x=features, 
                                 training_frame = h2o_train,
                                 ntree=300)



####################  run random forest on testing set
h2o_test <- test %>%
  select("May","Jun","Jul","Aug","Sep","Oct","10AM","11AM","12PM","13PM","14PM",
         "15PM","16PM","45mph","50mph","55mph","65mph","70mph",
         'Altoona_US22_Exit_Cresson_EAST','Altoona_US22_Exit_Cresson_WEST',
         'Altoona_US219_Exit_Ebensburg_NORTH','Altoona_US219_Exit_Ebensburg_SOUTH',
         'Lancaster_PA283_MtJoy_772_EAST','Lancaster_PA283_MtJoy_772_WEST',
         'Lancaster_US30_Exit_Wrightville_EAST','Lancaster_US30_Exit_Wrightville_WEST',
         'Meadville_I79_Exit_66_NORTH','Meadville_I79_Exit_66_SOUTH',
         'Meadville_I79_Exit_130_NORTH','Meadville_I79_Exit_130_SOUTH',
         'Pocono_I80_Exit_299_EAST','Pocono_I80_Exit_299_WEST',
         'Pocono_US209_Exit_309_EAST','Pocono_US209_Exit_309_WEST',
         'Williamsport_US15_Exit_WhiteDeer_NORTH','Williamsport_US15_Exit_WhiteDeer_SOUTH',
         'Williamsport_I180_Exit_13_NORTH','Williamsport_I180_Exit_13_SOUTH',
         "precipitation","visibility")



################### make prediction using testing set
pred <- h2o.predict(rf_sub_h2o, as.h2o(h2o_test))
pred <- as.data.frame(pred)




###################
pdp_pre_vis <- h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('visibility', 'precipitation'))

pdp_vis <- h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('visibility'))

pdp_pre <- h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('precipitation'))

h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('visibility', 'precipitation'), plot_stddev = FALSE)

h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('visibility'))

h2o.partialPlot(object=rf_total_h2o, data=CRTOTALpython_h2o,
                cols=c('precipitation'))







################### Partial Dependence Plot: (With one variable)
library(pdp)
library(ggplot2)
pdp_rf_pre <- partial(rf_sub_h2o, pred.var = c('precipitation'), chull = TRUE)
pdp_plot_rf_pre <- autoplot(pdp_rf_pre, contour=TRUE)
print(pdp_plot_rf_pre)

pdp_rf_vis <- partial(rf_sub_h2o, pred.var = c('visibility'), chull = TRUE)
pdp_plot_rf_vis <- autoplot(pdp_rf_vis, contour=TRUE)
print(pdp_plot_rf_vis)


##### Partial dependence Plot: (With two variables)
pdp_rf_pre_vis <- partial(rf, pred.var = c('precipitation', 'visibility'), chull=TRUE)
pdp_plot_rf_pre_vis <- autoplot(pdp_rf_pre_vis, contour=TRUE,
                                legend.title = 'Partial Dependence')
print(pdp_plot_rf_pre_vis)



















