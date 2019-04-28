
  
# https://www.kaggle.com/lemur78/random-forest-on-h2o

#################### load packages and data
library(randomForest)
library(h2o)
library(tidyverse)
library(data.table)
library(ranger)
library(lubridate)

TTRAFFICREMOVE_RFpython <- fread('C:/Users/yzy67/Desktop/PSU/research2/RESEARCHDATA/GData3/11thData/TTRAFFICREMOVE_RFpython.csv')
TTRAFFICREMOVE_RFpython$V1 <- NULL
setnames(TTRAFFICREMOVE_RFpython, old=c("May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
                                        "45mph","50mph","55mph","65mph","AM","PM","avpblackNORTHBOUND",
                                        "avpblackSOUTHBOUND","avppurpleNORTHBOUND","avppurpleSOUTHBOUND","phl1blueEASTBOUND",
                                        "phl1blueWESTBOUND","phl1orangeEASTBOUND","phl1orangeWESTBOUND",
                                        "phl1purpleEASTBOUND","phl1purpleWESTBOUND","phl1redNORTHBOUND","phl1redSOUTHBOUND",
                                        "phl2blueNORTHBOUND","phl2blueSOUTHBOUND","phl2greenNORTHBOUND","phl2greenSOUTHBOUND",
                                        "phl2orangeNORTHBOUND","phl2orangeSOUTHBOUND", "pit1blueNORTHBOUND",
                                        "pit1blueSOUTHBOUND","pit1orangeNORTHBOUND","pit1orangeSOUTHBOUND","pit1purpleNORTHBOUND",
                                        "pit1purpleSOUTHBOUND","pit1redNORTHBOUND","pit1redSOUTHBOUND","pit2blueEASTBOUND",
                                        "pit2blueWESTBOUND","pit2redEASTBOUND","pit2redWESTBOUND", "precipitation",
                                        "visibility","speed"), 
         new=c("May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
               "45mph","50mph","55mph","65mph","AM","PM",
               "Scranton_US11_Exit_9B_NORTH",'Scranton_US11_Exit_9B_SOUTH',
               "Scranton_I81_Exit_180_NORTH","Scranton_I81_Exit_180_SOUTH",
               'Philadelphia_I76_Exit_337_EAST','Philadelphia_I76_Exit_337_WEST',
               'Philadelphia_I95_Exit_9B_EAST','Philadelphia_I95_Exit_9B_WEST',
               'Philadelphia_I95_Exit_30_EAST','Philadelphia_I95_Exit_30_WEST',
               'Philadelphia_I476_Exit_5_NORTH','Philadelphia_I476_Exit_5_SOUTH',
               'Philadelphia_I95_Exit_25_NORTH','Philadelphia_I95_Exit_25_SOUTH',
               'Philadelphia_I76_Exit_346_NORTH','Philadelphia_I76_Exit_346_SOUTH',
               'Philadelphia_US1_Exit_5thSt_NORTH','Philadelphia_US1_Exit_5thSt_SOUTH',
               'Pittsburgh_I279_Exit_12_NORTH','Pittsburgh_I279_Exit_12_SOUTH',
               'Pittsburgh_I376_Exit_9_NORTH','Pittsburgh_I376_Exit_9_SOUTH',
               'Pittsburgh_I376_Exit_64A_NORTH','Pittsburgh_I376_Exit_64A_SOUTH',
               'Pittsburgh_US22_OAKDALE_RD_NORTH','Pittsburgh_US22_OAKDALE_RD_SOUTH',
               'Pittsburgh_I279_Exit_4_EAST','Pittsburgh_I279_Exit_4_WEST',
               'Pittsburgh_I279_Exit_9_EAST','Pittsburgh_I279_Exit_9_WEST',
               "precipitation","visibility",'speed'))


#################### data partition
train_index = sample(1:nrow(TTRAFFICREMOVE_RFpython), as.integer(dim(TTRAFFICREMOVE_RFpython)[1]*0.75))
train <- TTRAFFICREMOVE_RFpython[train_index,]
test <- TTRAFFICREMOVE_RFpython[-train_index,]



#################### transform data to h2o data
features <- c("May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
              "45mph","50mph","55mph","65mph","AM","PM",
              "Scranton_US11_Exit_9B_NORTH",'Scranton_US11_Exit_9B_SOUTH',
              "Scranton_I81_Exit_180_NORTH","Scranton_I81_Exit_180_SOUTH",
              'Philadelphia_I76_Exit_337_EAST','Philadelphia_I76_Exit_337_WEST',
              'Philadelphia_I95_Exit_9B_EAST','Philadelphia_I95_Exit_9B_WEST',
              'Philadelphia_I95_Exit_30_EAST','Philadelphia_I95_Exit_30_WEST',
              'Philadelphia_I476_Exit_5_NORTH','Philadelphia_I476_Exit_5_SOUTH',
              'Philadelphia_I95_Exit_25_NORTH','Philadelphia_I95_Exit_25_SOUTH',
              'Philadelphia_I76_Exit_346_NORTH','Philadelphia_I76_Exit_346_SOUTH',
              'Philadelphia_US1_Exit_5thSt_NORTH','Philadelphia_US1_Exit_5thSt_SOUTH',
              'Pittsburgh_I279_Exit_12_NORTH','Pittsburgh_I279_Exit_12_SOUTH',
              'Pittsburgh_I376_Exit_9_NORTH','Pittsburgh_I376_Exit_9_SOUTH',
              'Pittsburgh_I376_Exit_64A_NORTH','Pittsburgh_I376_Exit_64A_SOUTH',
              'Pittsburgh_US22_OAKDALE_RD_NORTH','Pittsburgh_US22_OAKDALE_RD_SOUTH',
              'Pittsburgh_I279_Exit_4_EAST','Pittsburgh_I279_Exit_4_WEST',
              'Pittsburgh_I279_Exit_9_EAST','Pittsburgh_I279_Exit_9_WEST',
              "precipitation","visibility")

# the entire data:
TTRAFFICREMOVE_RFpython <- TTRAFFICREMOVE_RFpython %>%
  sample_frac(size=1) %>%
  select("May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
         "45mph","50mph","55mph","65mph","AM","PM",
         "Scranton_US11_Exit_9B_NORTH",'Scranton_US11_Exit_9B_SOUTH',
         "Scranton_I81_Exit_180_NORTH","Scranton_I81_Exit_180_SOUTH",
         'Philadelphia_I76_Exit_337_EAST','Philadelphia_I76_Exit_337_WEST',
         'Philadelphia_I95_Exit_9B_EAST','Philadelphia_I95_Exit_9B_WEST',
         'Philadelphia_I95_Exit_30_EAST','Philadelphia_I95_Exit_30_WEST',
         'Philadelphia_I476_Exit_5_NORTH','Philadelphia_I476_Exit_5_SOUTH',
         'Philadelphia_I95_Exit_25_NORTH','Philadelphia_I95_Exit_25_SOUTH',
         'Philadelphia_I76_Exit_346_NORTH','Philadelphia_I76_Exit_346_SOUTH',
         'Philadelphia_US1_Exit_5thSt_NORTH','Philadelphia_US1_Exit_5thSt_SOUTH',
         'Pittsburgh_I279_Exit_12_NORTH','Pittsburgh_I279_Exit_12_SOUTH',
         'Pittsburgh_I376_Exit_9_NORTH','Pittsburgh_I376_Exit_9_SOUTH',
         'Pittsburgh_I376_Exit_64A_NORTH','Pittsburgh_I376_Exit_64A_SOUTH',
         'Pittsburgh_US22_OAKDALE_RD_NORTH','Pittsburgh_US22_OAKDALE_RD_SOUTH',
         'Pittsburgh_I279_Exit_4_EAST','Pittsburgh_I279_Exit_4_WEST',
         'Pittsburgh_I279_Exit_9_EAST','Pittsburgh_I279_Exit_9_WEST',
         "precipitation","visibility","speed")
h2o.init(nthreads = -1)
TTRAFFICREMOVE_RFpython_h2o <- as.h2o(TTRAFFICREMOVE_RFpython) # convert to h2o data
# first random forest model with the entire data
rf_total_h2o <- h2o.randomForest(y='speed',x=features, 
                                 training_frame = TTRAFFICREMOVE_RFpython_h2o,
                                 ntree=250)
print(rf_total_h2o)
h2o.r2(rf_total_h2o)


# data partition
train_frac <- train %>%
  sample_frac(size=1) %>%
  select( "May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
          "45mph","50mph","55mph","65mph","AM","PM",
          "Scranton_US11_Exit_9B_NORTH",'Scranton_US11_Exit_9B_SOUTH',
          "Scranton_I81_Exit_180_NORTH","Scranton_I81_Exit_180_SOUTH",
          'Philadelphia_I76_Exit_337_EAST','Philadelphia_I76_Exit_337_WEST',
          'Philadelphia_I95_Exit_9B_EAST','Philadelphia_I95_Exit_9B_WEST',
          'Philadelphia_I95_Exit_30_EAST','Philadelphia_I95_Exit_30_WEST',
          'Philadelphia_I476_Exit_5_NORTH','Philadelphia_I476_Exit_5_SOUTH',
          'Philadelphia_I95_Exit_25_NORTH','Philadelphia_I95_Exit_25_SOUTH',
          'Philadelphia_I76_Exit_346_NORTH','Philadelphia_I76_Exit_346_SOUTH',
          'Philadelphia_US1_Exit_5thSt_NORTH','Philadelphia_US1_Exit_5thSt_SOUTH',
          'Pittsburgh_I279_Exit_12_NORTH','Pittsburgh_I279_Exit_12_SOUTH',
          'Pittsburgh_I376_Exit_9_NORTH','Pittsburgh_I376_Exit_9_SOUTH',
          'Pittsburgh_I376_Exit_64A_NORTH','Pittsburgh_I376_Exit_64A_SOUTH',
          'Pittsburgh_US22_OAKDALE_RD_NORTH','Pittsburgh_US22_OAKDALE_RD_SOUTH',
          'Pittsburgh_I279_Exit_4_EAST','Pittsburgh_I279_Exit_4_WEST',
          'Pittsburgh_I279_Exit_9_EAST','Pittsburgh_I279_Exit_9_WEST',
          "precipitation","visibility","speed")
h2o.init(nthreads = -1)   # connect to h2o server
h2o_train <- as.h2o(train_frac)



################### run random forest on training set
rf_sub_h2o <- h2o.randomForest(y='speed',x=features, 
                               training_frame = h2o_train,
                               ntree=300)



####################  run random forest on testing set
h2o_test <- test %>%
  select("May","Jun","Jul","Aug","Sep","Oct","7AM","8AM","16PM","17PM","40mph",
         "45mph","50mph","55mph","65mph","AM","PM",
         "Scranton_US11_Exit_9B_NORTH",'Scranton_US11_Exit_9B_SOUTH',
         "Scranton_I81_Exit_180_NORTH","Scranton_I81_Exit_180_SOUTH",
         'Philadelphia_I76_Exit_337_EAST','Philadelphia_I76_Exit_337_WEST',
         'Philadelphia_I95_Exit_9B_EAST','Philadelphia_I95_Exit_9B_WEST',
         'Philadelphia_I95_Exit_30_EAST','Philadelphia_I95_Exit_30_WEST',
         'Philadelphia_I476_Exit_5_NORTH','Philadelphia_I476_Exit_5_SOUTH',
         'Philadelphia_I95_Exit_25_NORTH','Philadelphia_I95_Exit_25_SOUTH',
         'Philadelphia_I76_Exit_346_NORTH','Philadelphia_I76_Exit_346_SOUTH',
         'Philadelphia_US1_Exit_5thSt_NORTH','Philadelphia_US1_Exit_5thSt_SOUTH',
         'Pittsburgh_I279_Exit_12_NORTH','Pittsburgh_I279_Exit_12_SOUTH',
         'Pittsburgh_I376_Exit_9_NORTH','Pittsburgh_I376_Exit_9_SOUTH',
         'Pittsburgh_I376_Exit_64A_NORTH','Pittsburgh_I376_Exit_64A_SOUTH',
         'Pittsburgh_US22_OAKDALE_RD_NORTH','Pittsburgh_US22_OAKDALE_RD_SOUTH',
         'Pittsburgh_I279_Exit_4_EAST','Pittsburgh_I279_Exit_4_WEST',
         'Pittsburgh_I279_Exit_9_EAST','Pittsburgh_I279_Exit_9_WEST',
         "precipitation","visibility")



################### make prediction using testing set
pred <- h2o.predict(rf_sub_h2o, as.h2o(h2o_test))
pred <- as.data.frame(pred)



###################
pdp_pre_vis <- h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                               cols=c('visibility', 'precipitation'), plot_stddev = FALSE)

pdp_vis <- h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                           cols=c('visibility'))

pdp_pre <- h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                           cols=c('precipitation'))

h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                cols=c('visibility', 'precipitation'))

h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                cols=c('visibility'))

h2o.partialPlot(object=rf_total_h2o, data=TTRAFFICREMOVE_RFpython_h2o,
                cols=c('precipitation'))


############### feature importance graph
h2o.varimp_plot(rf_total_h2o, num_of_features = NULL)






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



















