

options(OutDec=",")
# Guardamos la dirección del directorio base del trabajo
baseDirectory = getwd()
csv_dir = paste(baseDirectory, "/", "titanic", sep="")

# cambio directorio para ver datos shp
setwd(csv_dir)

titanic <- read.csv("train.csv", header = TRUE)
head(titanic[,1:5])

# retornamos al directorio para trabajar con el shp
setwd(baseDirectory)

sapply(titanic, function(x) class(x))

titanic <- titanic[,-1]

titanic$Age <- as.integer(titanic$Age)

titanic$Name <- as.character(titanic$Name)
class(titanic$Name)
titanic$Ticket <- as.character(titanic$Ticket)
class(titanic$Ticket)
titanic$Cabin <- as.character(titanic$Cabin)
class(titanic$Cabin)

sapply(titanic, function(x) class(x))