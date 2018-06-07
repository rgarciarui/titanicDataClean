## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
options(OutDec=",")
library(knitr)

## ----set_library_to_plot, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
library(dplyr)
library(data.table)
library(ggplot2)
library(DT)
library(plotly)
library(mice)
library(stringi)

## ----initialization, echo=FALSE------------------------------------------
# Guardamos la dirección del directorio base del trabajo
baseDirectory = getwd()
knitr::opts_knit$set(root.dir = baseDirectory)
csv_dir = paste(baseDirectory, "/", "titanic", sep="")

## ----echo=FALSE----------------------------------------------------------
# cambio directorio para ver datos shp
knitr::opts_knit$set(root.dir = csv_dir)

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

kable(head(titanic_train), caption = "train.csv",digits = 3, padding = 2, align = 'r')
kable(head(titanic_test), caption = "test.csv",digits = 3, padding = 2, align = 'r')

## ----echo=FALSE----------------------------------------------------------
# retornamos al directorio para trabajar con el shp
knitr::opts_knit$set(root.dir = baseDirectory)

## ----class, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
# Tipo de dato asignado a cada campo
kable(sapply(titanic_train, function(x) class(x)), caption = "Tipo de dato asignado a cada campo: train data",digits = 3, padding = 2, align = 'r')

# Tipo de dato asignado a cada campo
kable(sapply(titanic_test, function(x) class(x)), caption = "Tipo de dato asignado a cada campo: test data",digits = 3, padding = 2, align = 'r')

## ----getOut_PassengerId, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
titanic_train <- titanic_train[,-1]

kable(head(titanic_train), caption = "Dataset Titanic sin PassengerId: train data",digits = 3, padding = 2, align = 'r')

kable(head(titanic_test), caption = "Dataset Titanic sin PassengerId: test data",digits = 3, padding = 2, align = 'r')


## ----integer_to_factor---------------------------------------------------

# ajuste en dataset train
titanic_train$Survived <- as.factor(titanic_train$Survived)
class(titanic_train$Survived)
titanic_train$Pclass <- as.factor(titanic_train$Pclass)
class(titanic_train$Pclass)

# ajuste en dataset test
titanic_test$Pclass <- as.factor(titanic_test$Pclass)
class(titanic_test$Pclass)


## ----factor_to_character-------------------------------------------------
titanic_train$Name <- as.character(titanic_train$Name)
class(titanic_train$Name)
titanic_train$Ticket <- as.character(titanic_train$Ticket)
class(titanic_train$Ticket)


## ----factor_to_character_table, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
kable(sapply(titanic_train, function(x) class(x)), caption = "Tipo de dato asignado finalmente a las variables seleccionadas",digits = 3, padding = 2, align = 'l')

## ----set_library_plot----------------------------------------------------

titanic_train$Pclass <- as.factor(titanic_train$Pclass)
summary(titanic_train$Pclass)


## ----set_library_plot2, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
ch <- ggplot(titanic_train, aes(x=Pclass)) + 
  geom_bar(fill=c(colors()[78], colors()[16], 
                  colors()[55]), col=c(colors()[79], colors()[17], colors()[56]), lwd = 2) + 
  labs(x="Class")

ch

ggplot(titanic_train, aes(x = Pclass, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') 

## ----var_name------------------------------------------------------------
# Resumen de las longitudes del nombre
summary(sapply(as.character(unique(titanic_train$Name)),nchar))

## ----var_sex-------------------------------------------------------------
#Casi el doble de hombres
summary(titanic_train$Sex)
sb <- ggplot(titanic_train, aes(x=Sex)) + 
  geom_bar(fill=c(colors()[542], colors()[121]), 
           col=c(colors()[543], colors()[123]), lwd = 2) + 
  labs(x="Class")
sb

## ----var_age-------------------------------------------------------------
# # 177 NA's, la edad media es 28 años aka nacido en 1884 (inicio de la entrada)
summary(titanic_train$Age)

ap <- ggplot(titanic_train, aes(x=Age))+geom_density(adjust=.5)
ap


## ----var_spouses---------------------------------------------------------
unique(titanic_train$SibSp)
# Max Spouse es 1, crea datos de hermanos
# Max parents is 2, create children data
# Recopilar datos de riqueza de los puntos de embarque
titanic_train$SibSp <- as.integer(titanic_train$SibSp) #posiblemente solo frente a variable familiar
summary(titanic_train$SibSp) #mediana es 0

dim(titanic_train[titanic_train$SibSp > 0,])
dim(titanic_train[titanic_train$SibSp == 0,])

ggplot(titanic_train, aes(x = SibSp, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:7)) +
  labs(x = 'SibSp')

## ----echo=FALSE----------------------------------------------------------
ggplot(titanic_train, aes(x = SibSp, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:7)) +
  labs(x = 'SibSp')+ ylim(0,115)

## ----var_parch-----------------------------------------------------------
unique(titanic_train$Parch) 
summary(titanic_train$Parch) 

## ----var_parch_2---------------------------------------------------------
dim(titanic_train[titanic_train$Parch > 0,]) 

## ----var_parch_3---------------------------------------------------------
dim(titanic_train[titanic_train$Parch == 0,])

## ----echo=FALSE----------------------------------------------------------
ggplot(titanic_train, aes(x = Parch, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:7)) +
  labs(x = 'Parch')

## ----echo=FALSE----------------------------------------------------------
ggplot(titanic_train, aes(x = Parch, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:7)) +
  labs(x = 'Parch')+ ylim(0,65)

## ----Ticket, echo = FALSE------------------------------------------------
length(unique(titanic_train$Ticket)) 


## ----tplot, echo = FALSE-------------------------------------------------
titanic_train$FL <- stri_extract_first_regex(titanic_train$Ticket, "[A-Z]+") #Grabs first Text occurence
titanic_train$FT <- stri_extract_first_regex(titanic_train$Ticket, "[0-9][0-9]+") #Grabs ticket number
titanic_train[is.na(titanic_train$FL),]$FL <- "NA"

## ----plot, echo = FALSE--------------------------------------------------
tpref <- titanic_train[!titanic_train$FL=="NA",]
gg <- ggplot(aes(y = Fare, x = FL), data = tpref) + geom_boxplot() + labs(title="Ticket Prefix")
gg

## ----ticketplot, echo = FALSE--------------------------------------------
p2 <- ggplot(aes(x = FL, fill = factor(Survived)), data = tpref) + geom_bar(stat='count', position='dodge') + labs(title="Ticket Prefix")
p2


## ----dig-----------------------------------------------------------------
tfix <- tpref[tpref$FL %in% c("A", "CA", "Soton", "W"),]
summary(sapply(as.character(titanic_train$FT),nchar))
summary(sapply(as.character(tfix$FT), nchar))

## ----numlength-----------------------------------------------------------
titanic_train$ticketlength <- sapply(as.character(titanic_train$FT),nchar)

## ----plot23, echo = FALSE------------------------------------------------
s1 <- ggplot(aes(x = factor(ticketlength), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count', position='dodge') + labs(title="Ticket Number Length")
s1

f1 <- ggplot(aes(x = factor(ticketlength), y=Fare, fill = factor(Survived)), data = titanic_train) + geom_boxplot() + labs(title="Ticket Number Length")
f1

## ----plot2, echo = FALSE, fig.height=20----------------------------------
library(gridExtra)
titanic_train$one <- sapply(titanic_train$FT, function(x){substr(x,1,1)})
titanic_train$two <- sapply(titanic_train$FT, function(x){substr(x,2,2)})
titanic_train$three <- sapply(titanic_train$FT, function(x){substr(x,3,3)})
titanic_train$four <- sapply(titanic_train$FT, function(x){substr(x,4,4)})
titanic_train$five <- sapply(titanic_train$FT, function(x){substr(x,5,5)})
titanic_train$six <- sapply(titanic_train$FT, function(x){substr(x,6,6)})
titanic_train$seven <- sapply(titanic_train$FT, function(x){substr(x,7,7)})

titanic_train$one <- as.factor(titanic_train$one)
titanic_train$two <- as.factor(titanic_train$two)
titanic_train$three <- as.factor(titanic_train$three)
titanic_train$four <- as.factor(titanic_train$four)
titanic_train$five <- as.factor(titanic_train$five)
titanic_train$six <- as.factor(titanic_train$six)
titanic_train$seven <- as.factor(titanic_train$seven)

onep <- ggplot(aes(y = Fare, x = factor(one)), data = titanic_train) + geom_boxplot() + labs(title="First Digit Price")
ones <- ggplot(aes(x = factor(one), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Second Digit Survival")


twop <- ggplot(aes(y = Fare, x = factor(two)), data = titanic_train) + geom_boxplot() + labs(title="Second Digit Price")
twos <- ggplot(aes(x = factor(two), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Second Digit Survival")

threep <- ggplot(aes(y = Fare, x = factor(three)), data = titanic_train) + geom_boxplot() + labs(title="Third Digit Price")
threes <- ggplot(aes(x = factor(three), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Third Digit Survival")


fourp <- ggplot(aes(y = Fare, x = factor(four)), data = titanic_train) + geom_boxplot() + labs(title="Fourth Digit Price")
fours <- ggplot(aes(x = factor(four), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Fourth Digit Survival")

fivep <- ggplot(aes(y = Fare, x = factor(five)), data = titanic_train) + geom_boxplot() + labs(title="Fifth Digit Price")
fives <- ggplot(aes(x = factor(five), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Fifth Digit Survival")


sixp <- ggplot(aes(y = Fare, x = factor(six)), data = titanic_train) + geom_boxplot() + labs(title="Sixth Digit Price")
sixs <- ggplot(aes(x = factor(six), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Sixth Digit Survival")

sevenp <- ggplot(aes(y = Fare, x = factor(seven)), data = titanic_train) + geom_boxplot() + labs(title="Seventh Digit Price")
sevens <- ggplot(aes(x = factor(seven), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count') + labs(title="Seventh Digit Survival")

grid.arrange(onep,ones,twop,twos, threep, threes, fourp, fours, fivep, fives, sixp, sixs, sevenp, sevens, ncol=2, nrow =7)

## ----var_fare------------------------------------------------------------
titanic_train[titanic_train$Fare==0,]$Sex

## ------------------------------------------------------------------------
length(unique(titanic_train$Fare))

## ------------------------------------------------------------------------
titanic_train %>% group_by(Pclass) %>% summarise_each(funs(min, max, mean, median),Fare) 

## ------------------------------------------------------------------------
titanic_train %>% group_by(Sex) %>% summarise_each(funs(min, max, mean, median),Fare)

## ----var_cabin-----------------------------------------------------------
length(unique(titanic_train$Cabin))

## ----cabin, echo = FALSE-------------------------------------------------
sum(!substring(titanic_train$Cabin, 1, 1) == "")#Fill in cabin data
datatable(data.frame(summary(titanic_train$Cabin)), colnames=c("Cabin", "Count")) # is it safe to impute cabin data?

## ----CabinLetter---------------------------------------------------------
titanic_train$CL <- substring(titanic_train$Cabin, 1, 1)
titanic_train$CL <- as.factor(titanic_train$CL)
unique(titanic_train$CL)

## ----Csum----------------------------------------------------------------
summary(titanic_train[!substring(titanic_train$Cabin, 1, 1) == "",]$Embarked)
summary(titanic_train[!substring(titanic_train$Cabin, 1, 1) == "",]$Pclass)


## ----cabinsplit, echo = FALSE--------------------------------------------

cabins <- titanic_train[!substring(titanic_train$Cabin, 1, 1) == "",]
cabins$PCL <- interaction(cabins$Pclass, cabins$CL)
gg <- ggplot(aes(y = Fare, x = CL, fill = factor(Survived)), data = cabins) + geom_boxplot()
gg

## ----cabinsplit2, echo=FALSE---------------------------------------------
g2 <- ggplot(aes(x = CL, fill = factor(Survived)), data = cabins) + geom_bar(stat='count')
g2

## ----cabinbin------------------------------------------------------------
titanic_train$Assigned <- 0
titanic_train[!substring(titanic_train$Cabin, 1, 1) == "",]$Assigned <- 1

## ----var_embarked--------------------------------------------------------
unique(titanic_train$Embarked) 
summary(titanic_train$Embarked)

## ----miss, echo = FALSE--------------------------------------------------
datatable(titanic_train[Embarked=="",])

## ----pressure, echo = FALSE----------------------------------------------
apply(titanic_train=="",2, sum)
apply(is.na(titanic_train),2, sum)

## ----pr, results = 'hide'------------------------------------------------
titanic_train <- as.data.frame(titanic_train)
#Imputing the missing age values with the MICE package
impute <- mice(titanic_train[, !names(titanic_train) %in% c('PassengerId','Name','Ticket','Cabin','Survived', 'Assigned','FL','FT','ticketlength','one','two','three','four','five','six','seven')], method='rf')

trained_mouse <- complete(impute)

## ----pplot, echo = FALSE, warning = FALSE--------------------------------
#Plotting Histograms
ap <- ggplot(titanic_train, aes(x=Age))+geom_density(adjust=.5)+labs(title="Original Data")
ap
mp <- ggplot(trained_mouse, aes(x=Age))+geom_density(adjust=.5)+labs(title="Imputed Data")
mp

## ----replace1------------------------------------------------------------
titanic_train$Age <- trained_mouse$Age

## ----Missing Cabin-------------------------------------------------------
unique(titanic_train[grep("*^B", titanic_train$Cabin),]$Embarked)

## ----cab, echo = FALSE---------------------------------------------------
titanic_train[grep("*^B", titanic_train$Cabin),] %>% group_by(Embarked) %>% summarize_each(funs(mean),Fare)

## ----mcab, echo = FALSE--------------------------------------------------
titanic_train[grep("*^B", titanic_train$Cabin),] %>% group_by(Embarked) %>% summarize_each(funs(median),Fare)

## ----bark, echo = FALSE--------------------------------------------------
bark <- titanic_train[grep("*^B", titanic_train$Cabin),] %>% group_by(Embarked)
bark <- bark[!bark$Embarked=="",]
#Also, there a 72.4% change of any passenger embarking from Southampton
ggplot(bark, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
    colour='red', linetype='dashed', lwd=2)

## ----split, echo = FALSE-------------------------------------------------
summary(titanic_train$Embarked)
bark2 <- titanic_train[!titanic_train$Embarked=="",]
ggplot(bark2, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
    colour='red', linetype='dashed', lwd=2)
summary(titanic_train[grep("*^B", titanic_train$Cabin),]$Embarked)

## ----replace-------------------------------------------------------------
titanic_train$Embarked[c(62, 830)] <- 'S'

