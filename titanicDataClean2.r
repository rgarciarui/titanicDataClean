## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
options(OutDec=",")
library(knitr)

## ----set_library_to_plot, echo=FALSE, cache=FALSE, results = 'asis', message=FALSE, comment=FALSE, warning=FALSE----
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

## ----read_dataset, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE----
titanic_train <- read.csv("train.csv", header = TRUE)
titanic_test <- read.csv("test.csv", header = TRUE)
titanic_test.label <- read.csv("gender_submission.csv", header = TRUE)
titanic_test <- merge(titanic_test, titanic_test.label, by="PassengerId")
titanic_test = titanic_test[,c(1,12,2:11)]

titanic_train <- as.data.table(titanic_train)
titanic_test <- as.data.table(titanic_test)

kable(head(titanic_train), caption = "train.csv",digits = 3, padding = 2, align = 'r')
kable(head(titanic_test), caption = "test.csv",digits = 3, padding = 2, align = 'r')

## ----echo=FALSE----------------------------------------------------------
# retornamos al directorio para trabajar con el shp
knitr::opts_knit$set(root.dir = baseDirectory)

## ----class, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE----
# Tipo de dato asignado a cada campo
kable(sapply(titanic_train, function(x) class(x)), caption = "Tipo de dato asignado a cada campo: train data",digits = 3, padding = 2, align = 'r')

# Tipo de dato asignado a cada campo
kable(sapply(titanic_test, function(x) class(x)), caption = "Tipo de dato asignado a cada campo: test data",digits = 3, padding = 2, align = 'r')

## ----getOut_PassengerId, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE----
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

## ----plot23, echo = FALSE, message=FALSE---------------------------------
s1 <- ggplot(aes(x = factor(ticketlength), fill = factor(Survived)), data = titanic_train) + geom_bar(stat='count', position='dodge') + labs(title="Ticket Number Length")
s1

f1 <- ggplot(aes(x = factor(ticketlength), y=Fare, fill = factor(Survived)), data = titanic_train) + geom_boxplot() + labs(title="Ticket Number Length")
f1

## ----plot2, echo = FALSE, fig.height=20, message=FALSE-------------------
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

## ----message=FALSE-------------------------------------------------------
length(unique(titanic_train$Fare))

## ----message=FALSE-------------------------------------------------------
titanic_train %>% group_by(Pclass) %>% summarise_each(funs(min, max, mean, median),Fare) 

## ----message=FALSE-------------------------------------------------------
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

## ----cab, echo = FALSE, message=FALSE------------------------------------
titanic_train[grep("*^B", titanic_train$Cabin),] %>% group_by(Embarked) %>% summarize_each(funs(mean),Fare)

## ----mcab, echo = FALSE, message=FALSE-----------------------------------
titanic_train[grep("*^B", titanic_train$Cabin),] %>% group_by(Embarked) %>% summarize_each(funs(median),Fare)

## ----bark, echo = FALSE, message=FALSE-----------------------------------
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

## ----train_var_selector--------------------------------------------------
df = titanic_train[,c(1,2,4,5,11)]

## ----df_age_split--------------------------------------------------------
df$Age[df$Age <= 18] = "child"
df$Age[(df$Age > 18) & (df$Age <= 60) & (df$Age != "child")] = "adult"
df$Age[(df$Age != "child") & (df$Age != "adult")] = "senior"
df$Age = as.factor(df$Age)

## ----class_2, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
kable(head(df), caption = "Data set seleccionado",digits = 3, padding = 2, align = 'r')
datatable(df)

## ------------------------------------------------------------------------
summary(df)

## ------------------------------------------------------------------------
summary(df)

## ------------------------------------------------------------------------
barplot(table(df$Pclass), xlab="Class", ylab="Frequency", main="Histogram of Passenger Class")
barplot(table(df$Sex), xlab="Sex", ylab="Frequency", main="Histogram of Sex")
barplot(table(df$Age), xlab="Age", ylab="Frequency", main="Histogram of Age")
barplot(table(df$Embarked), xlab="Port of Embarkment", ylab="Frequency", main="Histogram of Port of Embarkment")

## ------------------------------------------------------------------------
old_df = df
df$Pclass = as.integer(df$Pclass)
df$Sex = as.integer(df$Sex)
df$Age = as.integer(df$Age)
df$Embarked = as.integer(df$Embarked)
df$Survived = as.integer(df$Survived)
head(df)

## ------------------------------------------------------------------------
me_pclass = c(0,0,0)
me_pclass[1] = mean(df$Survived[df$Pclass==1])
me_pclass[2] = mean(df$Survived[df$Pclass==2])
me_pclass[3] = mean(df$Survived[df$Pclass==3])
plot(me_pclass, type="o", main="Main Effect of Passenger Class", xlab="Passenger Class", ylab="Main Effect",
     xaxt="n")
axis(1, at=c(1,2,3), labels=c("1st", "2nd", "3rd"))

## ------------------------------------------------------------------------
me_sex = c(0,0)
me_sex[1] = mean(df$Survived[df$Sex==1])
me_sex[2] = mean(df$Survived[df$Sex==2])
plot(me_sex, type="o", main="Main Effect of Sex", xlab="Sex", ylab="Main Effect", xaxt="n")
axis(1, at=c(1,2), labels=c("Female", "Male"))

## ------------------------------------------------------------------------
me_age = c(0,0,0)
me_age[1] = mean(df$Survived[df$Age==1])
me_age[2] = mean(df$Survived[df$Age==2])
me_age[3] = mean(df$Survived[df$Age==3])
plot(me_age, type="o", main="Main Effect of Age", xlab="Age", ylab="Main Effect", xaxt="n")
axis(1, at=c(1,2,3), labels=c("Adult", "Children", "Senior Citizen"))

## ------------------------------------------------------------------------
me_emb = c(0,0,0)
me_emb[1] = mean(df$Survived[df$Embarked==1])
me_emb[2] = mean(df$Survived[df$Embarked==2])
me_emb[3] = mean(df$Survived[df$Embarked==3])
plot(me_emb, type="o", main="Main Effect of Port of Embarkment", xlab="Port of Embarkment", ylab="Main Effect",
     xaxt="n")
axis(1, at=c(1,2,3), labels=c("Cherbourg", "Queenstown", "Southampton"))

## ------------------------------------------------------------------------
interaction.plot(df$Pclass, df$Sex, df$Survived, xlab="Passenger Class", ylab="Mean number of Survivors",
                  main="Interaction Effect between Passenger Class and Sex", legend=FALSE)
legend("topright", c("Female","Male"), lty=c("dashed", "solid"), title="Sex")

## ------------------------------------------------------------------------
interaction.plot(df$Pclass, df$Age, df$Survived, xlab="Passenger Class", ylab="Mean number of Survivors",
                 main="Interaction Effect between Passenger Class and Age", legend=FALSE)
legend("topright", c("Adult","Child", "Senior"), lty=c("dashed", "solid", "dotted"), title="Age")

## ------------------------------------------------------------------------
interaction.plot(df$Pclass, df$Embarked, df$Survived, xlab="Passenger Class", ylab="Mean number of Survivors",
                 main="Interaction Effect between Passenger Class and Port of Embarkment", legend=FALSE)
legend("topright", c("Cherbourg","Queenstown","Southampton"), lty=c("dashed", "solid", "dotted"),
       title="Port of Embarkment")

## ------------------------------------------------------------------------
interaction.plot(df$Sex, df$Age, df$Survived, xlab="Sex", ylab="Mean number of Survivors",
                 main="Interaction Effect between Sex and Age", legend=FALSE, xtick=FALSE, xaxt="n")
axis(1, c(1,2), labels=c("Female", "Male"))
legend("topright", c("Adult","Child", "Senior"), lty=c("dashed", "solid", "dotted"), title="Age")

## ------------------------------------------------------------------------
interaction.plot(df$Sex, df$Embarked, df$Survived, xlab="Sex", ylab="Mean number of Survivors", 
                 main="Interaction Effect between Sex and Port of Embarkment", legend=FALSE, xtick = FALSE, xaxt="n")
axis(1, c(1,2), labels=c("Female", "Male"))
legend("topright", c("Cherbourg","Queenstown","Southampton"), lty=c("dashed", "solid", "dotted"),
       title="Port of Embarkment")

## ------------------------------------------------------------------------
interaction.plot(df$Age, df$Embarked, df$Survived, xlab="Age", ylab="Mean number of Survivors", 
                 main="Interaction Effect between Age and Port of Embarkment", legend=FALSE, xtick = FALSE, xaxt="n")
axis(1, c(1,2,3), labels=c("Adults", "Children", "Senior Citizens"))
legend("topright", c("Cherbourg","Queenstown","Southampton"), lty=c("dashed", "solid", "dotted"),
       title="Port of Embarkment")

## ------------------------------------------------------------------------
me1 = aov(df$Survived ~ df$Pclass)
anova(me1)

me2 = aov(df$Survived ~ df$Sex)
anova(me2)

me3 = aov(df$Survived ~ df$Age)
anova(me3)

me4 = aov(df$Survived ~ df$Embarked)
anova(me4)


## ------------------------------------------------------------------------
ie12 = aov(df$Survived ~ df$Pclass * df$Sex)
anova(ie12)

ie13 = aov(df$Survived ~ df$Pclass * df$Age)
anova(ie13)

ie14 = aov(df$Survived ~ df$Pclass * df$Embarked)
anova(ie14)

ie23 = aov(df$Survived ~ df$Sex * df$Age)
anova(ie23)

ie24 = aov(df$Survived ~ df$Sex * df$Embarked)
anova(ie24)

ie34 = aov(df$Survived ~ df$Age * df$Embarked)
anova(ie34)


## ------------------------------------------------------------------------
qqnorm(residuals(me1))
qqline(residuals(me1))

plot(fitted(me1), residuals(me1))

qqnorm(residuals(me2))
qqline(residuals(me2))

plot(fitted(me2), residuals(me2))

qqnorm(residuals(me3))
qqline(residuals(me3))

plot(fitted(me3), residuals(me3))

qqnorm(residuals(me4))
qqline(residuals(me4))

plot(fitted(me4), residuals(me4))

qqnorm(residuals(ie12))
qqline(residuals(ie12))

plot(fitted(ie12), residuals(ie12))

qqnorm(residuals(ie13))
qqline(residuals(ie13))

plot(fitted(ie13), residuals(ie13))

qqnorm(residuals(ie14))
qqline(residuals(ie14))

plot(fitted(ie14), residuals(ie14))

qqnorm(residuals(ie23))
qqline(residuals(ie23))

plot(fitted(ie23), residuals(ie23))

qqnorm(residuals(ie24))
qqline(residuals(ie24))

plot(fitted(ie24), residuals(ie24))

qqnorm(residuals(ie34))
qqline(residuals(ie34))

plot(fitted(ie34), residuals(ie34))


## ----datasetTrain_del_redundant------------------------------------------
# se eliminan variables redundantes
datasetTrain <- titanic_train[,c(-3, -8, -10, -11, -c(12:23))]

datasetTrain$Pclass = as.integer(datasetTrain$Pclass)
datasetTrain$Age = as.integer(datasetTrain$Age)
#datasetTrain$Survived = as.integer(datasetTrain$Survived)
# sumario
summary(datasetTrain)
sapply(datasetTrain, class)

## ----datasetTrain_class--------------------------------------------------
# class distribution
cbind(freq=table(datasetTrain$Survived), percentage=prop.table(table(datasetTrain$Survived))*100)

## ----datasetTrain_corr---------------------------------------------------
datasetTrain[,3] <- as.numeric((datasetTrain[,3]))
complete_cases <- complete.cases(datasetTrain)

kable(cor(datasetTrain[complete_cases,2:5]), caption = "Correlación del conjunto de datos",digits = 3, padding = 2, align = 'r')
#cor(datasetTrain[complete_cases,2:5])

## ----datasetTrain_plot_01------------------------------------------------
# barplot of males and females who survived
barplot(table(datasetTrain$Survived, datasetTrain[,3]))
legend("topleft", legend = c("Mueren", "Sobreviven"), fill=c("black","grey"))

## ----set_library_to_plot_2, echo=FALSE, cache=FALSE, results = 'asis', warning=FALSE, comment=FALSE, warning=FALSE----
library(caret)
library(corrplot)

## ----datasetTrain_hardness-----------------------------------------------
# 10-fold cross validation with 3 repeats
trainControl <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"

## ----set_library_to_plot_3, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE, message=FALSE----
library(caret)
library(corrplot)
library(MASS)
library(glmnet)
library(Matrix)
library(foreach)
library(rpart)
library(klaR)
library(kernlab)

## ----datasetTrain_Spot-Check, warning=FALSE, comment=FALSE, message=FALSE----
# LG
set.seed(7)
fit.glm <- train(Survived~., data=datasetTrain, method="glm", metric=metric, 
                 trControl=trainControl)

# LDA
set.seed(7)
fit.lda <- train(Survived~., data=datasetTrain, method="lda", metric=metric, 
                 trControl=trainControl)

# GLMNET
set.seed(7)
fit.glmnet <- train(Survived~., data=datasetTrain, method="glmnet", metric=metric,
                    trControl=trainControl)

# KNN
set.seed(7)
fit.knn <- train(Survived~., data=datasetTrain, method="knn", metric=metric, 
                 trControl=trainControl)

# CART
set.seed(7)
fit.cart <- train(Survived~., data=datasetTrain, method="rpart", metric=metric,
                  trControl=trainControl)

# Naive Bayes
set.seed(7)
fit.nb <- train(Survived~., data=datasetTrain, method="nb", metric=metric, 
                trControl=trainControl)

# SVM
set.seed(7)
fit.svm <- train(Survived~., data=datasetTrain, method="svmRadial", metric=metric,
                 trControl=trainControl)


## ----datasetTrain_compare, warning=FALSE, comment=FALSE, message=FALSE----
# Compare algorithms
results <- resamples(list(LG=fit.glm, LDA=fit.lda, GLMNET=fit.glmnet, KNN=fit.knn,
    CART=fit.cart, NB=fit.nb, SVM=fit.svm))
summary(results)

## ----datasetTrain_compare_plot, warning=FALSE, comment=FALSE, message=FALSE----
dotplot(results)

## ----datasetTrain_evaluate, warning=FALSE, comment=FALSE, message=FALSE----
# Compare algorithms
# 10-fold cross validation with 3 repeats
trainControl <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"
# LG
set.seed(7)
fit.glm <- train(Survived~., data=datasetTrain, method="glm", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl)
# LDA
set.seed(7)
fit.lda <- train(Survived~., data=datasetTrain, method="lda", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl)
# GLMNET
set.seed(7)
fit.glmnet <- train(Survived~., data=datasetTrain, method="glmnet", metric=metric,
    preProc=c("BoxCox"), trControl=trainControl)
# KNN
set.seed(7)
fit.knn <- train(Survived~., data=datasetTrain, method="knn", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl)
# CART
set.seed(7)
fit.cart <- train(Survived~., data=datasetTrain, method="rpart", metric=metric,
    preProc=c("BoxCox"), trControl=trainControl)
# Naive Bayes
set.seed(7)
fit.nb <- train(Survived~., data=datasetTrain, method="nb", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl)
# SVM
set.seed(7)
fit.svm <- train(Survived~., data=datasetTrain, method="svmRadial", metric=metric,
    preProc=c("BoxCox"), trControl=trainControl)
# Compare algorithms
transformResults <- resamples(list(LG=fit.glm, LDA=fit.lda, GLMNET=fit.glmnet, KNN=fit.knn,
    CART=fit.cart, NB=fit.nb, SVM=fit.svm))
summary(transformResults)

## ----datasetTrain_evaluate_plot, warning=FALSE, comment=FALSE, message=FALSE----
dotplot(transformResults)

## ----datasetTrain_precission, warning=FALSE, comment=FALSE, message=FALSE----
# 10-fold cross validation with 3 repeats
trainControl <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"
set.seed(7)
grid <- expand.grid(.sigma=c(0.025, 0.05, 0.1, 0.15), .C=seq(1, 10, by=1))
fit.svm <- train(Survived~., data=datasetTrain, method="svmRadial", metric=metric, tuneGrid=grid,
    preProc=c("BoxCox"), trControl=trainControl)
print(fit.svm)

## ----datasetTrain_precission_plot, warning=FALSE, comment=FALSE, message=FALSE----
plot(fit.svm)

## ----set_library_to_plot_4, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE, message=FALSE----
library(ipred)
#library(plyr)
library(e1071)
library(randomForest)
library(gbm)
library(survival)
library(splines)
library(parallel)

## ----datasetTrain_ensembles, warning=FALSE, comment=FALSE, message=FALSE----

# 10-fold cross validation with 3 repeats
trainControl <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"

# Bagged CART
set.seed(7)
fit.treebag <- train(Survived~., data=datasetTrain, method="treebag", metric=metric,
    trControl=trainControl)

# Random Forest
set.seed(7)
fit.rf <- train(Survived~., data=datasetTrain, method="rf", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl)

# Stochastic Gradient Boosting
set.seed(7)
fit.gbm <- train(Survived~., data=datasetTrain, method="gbm", metric=metric, preProc=c("BoxCox"),
    trControl=trainControl, verbose=FALSE)

# C5.0
#set.seed(7)
#fit.c50 <- train(Survived~., data=datasetTrain, method="C5.0", metric=metric, preProc=c("BoxCox"),
#    trControl=trainControl)

# Compare results
#ensembleResults <- resamples(list(BAG=fit.treebag, RF=fit.rf, GBM=fit.gbm, C50=fit.c50))
ensembleResults <- resamples(list(BAG=fit.treebag, RF=fit.rf, GBM=fit.gbm))
summary(ensembleResults)

## ----datasetTrain_ensembles_plot, warning=FALSE, comment=FALSE, message=FALSE----
dotplot(ensembleResults)

## ----datasetTrain_final_model, warning=FALSE, comment=FALSE, message=FALSE----
# prepare parameters for data transform
# set.seed(7)
model <- svm(Survived ~ ., data = datasetTrain)

# se eliminan variables redundantes
datasetTrain <- titanic_test[,c(-3, -8, -10, -11, -c(12:23))]

# Se ajustan los datos como en el conjunto de entrenamiennto
datasetTest <- titanic_test
testData <- datasetTest[,c(-1, -4, -9, -11, -12)]

testData$Pclass = as.integer(testData$Pclass)
testData$Age = as.integer(testData$Age)
testData$Sex <- as.numeric(testData$Sex)
testData$Survived <- as.factor(testData$Survived)

preprocessParams <- preProcess(testData, method=c("BoxCox"))
testData$Age[is.na(testData$Age)] <- 0
testData$Fare[is.na(testData$Fare)] <- 0
testData <- predict(preprocessParams, testData)

predictions <- predict(model, testData, type="class")
submit <- data.frame(PassengerId = datasetTest$PassengerId, Survived = predictions)
write.csv(submit, file = "firstSVM.csv", row.names = FALSE)

## ----prediction----------------------------------------------------------
plot(testData)
#plot(predictions)

## ----prediction_02-------------------------------------------------------

predictedTest_mg = merge(x = submit, y = datasetTest,by.x="PassengerId", by.y =  "PassengerId")
predicted_names = names(predictedTest_mg)
predicted_names[2]="Surv. Predicted"
predicted_names[3]="Surv. Original"
names(predictedTest_mg) = predicted_names

wrongSurvivedPred = predictedTest_mg[predictedTest_mg$`Surv. Predicted`!=predictedTest_mg$`Surv. Original`,]
successSurvivedPred = predictedTest_mg[predictedTest_mg$`Surv. Predicted`==predictedTest_mg$`Surv. Original`,]

datatable(wrongSurvivedPred)



## ----prediction_03-------------------------------------------------------

length(wrongSurvivedPred$`Surv. Predicted`)/length(predictedTest_mg$`Surv. Predicted`)

success = length(successSurvivedPred$`Surv. Predicted`)/length(predictedTest_mg$`Surv. Predicted`)
fail = length(wrongSurvivedPred$`Surv. Predicted`)/length(predictedTest_mg$`Surv. Predicted`)

df.pred.results = data.frame(success = success, fail = fail)


## ----prediction_04, echo=FALSE, cache=FALSE, results = 'asis', comment=FALSE, warning=FALSE----
kable(df.pred.results, caption = "Porcentajes de resultados de acierto en la predicción con SVM",digits = 3, padding = 2, align = 'l')


## ----prediciton_plot-----------------------------------------------------
ggplot( aes(x = predictions, fill = factor(predictions))) +
  geom_bar(stat='count', position='dodge') 

