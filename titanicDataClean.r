library(mice)
library(randomForest)

options(OutDec=",")
# Guardamos la dirección del directorio base del trabajo
baseDirectory = getwd()
csv_dir = paste(baseDirectory, "/", "titanic", sep="")

# cambio directorio para ver datos shp
setwd(csv_dir)

titanic_train <- read.csv("train.csv", header = TRUE)
head(titanic_train[,1:5])

# retornamos al directorio para trabajar con el shp
setwd(baseDirectory)

sapply(titanic_train, function(x) class(x))

titanic_train <- titanic_train[,-1]

#titanic_train$Age <- as.integer(titanic_train$Age)

#titanic_train <- titanic_train[,-10]

titanic_train$Survived <- as.factor(titanic_train$Survived)
class(titanic_train$Survived)
titanic_train$Pclass <- as.factor(titanic_train$Pclass)
class(titanic_train$Pclass)

summary(titanic_train$Pclass)
plot(c(titanic_train$Pclass,titanic_train$Survived))

library(VIM)
aggr_plot <- aggr(titanic_train, col=c('navyblue','red'), 
                  numbers=TRUE, 
                  sortVars=TRUE, 
                  labels=names(titanic_train), 
                  cex.axis=.7, gap=3, 
                  ylab=c("Histograma datos ausentes","Patrón"))

marginplot(titanic_train[c(1,5)])

titanic_train$Name <- as.character(titanic_train$Name)
class(titanic_train$Name)
titanic_train$Ticket <- as.character(titanic_train$Ticket)
class(titanic_train$Ticket)

sapply(titanic_train, function(x) class(x))

tempDataSet = titanic_train[!is.na(titanic_train$Age),]

# media de hombre
globalMeanMen = mean(tempDataSet$Age[tempDataSet$Sex == "male"])
# media de mujeres
globalMeanWomen = mean(tempDataSet$Age[tempDataSet$Sex == "female"])

md.pattern(titanic_train)

#Imputing the missing age values with the MICE package
impute <- mice(titanic_train[, !names(titanic_train) %in% 
                       c('Name','Ticket','Cabin','Survived', 
                         'Assigned','FL','FT','ticketlength','one','two','three',
                         'four','five','six','seven')], method='pmm')

trained_mouse <- complete(impute)

# media de hombre
globalMeanMen_2 = mean(trained_mouse$Age[trained_mouse$Sex == "male"])
# media de mujeres
globalMeanWomen_2 = mean(trained_mouse$Age[trained_mouse$Sex == "female"])



purl("titanicDataClean.rmd", output = "titanicDataClean2.r", documentation = 1)


# cambio directorio para ver datos shp
setwd(csv_dir)

## ----read_dataset, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
titanic_train <- read.csv("train.csv", header = TRUE)
titanic_test <- read.csv("test.csv", header = TRUE)
titanic_test.label <- read.csv("gender_submission.csv", header = TRUE)
titanic_test <- merge(titanic_test, titanic_test.label, by="PassengerId")
titanic_test = titanic_test[,c(1,12,2:11)]

titanic_train <- as.data.table(titanic_train)
titanic_test <- as.data.table(titanic_test)

# retornamos al directorio para trabajar con el shp
setwd(baseDirectory)



