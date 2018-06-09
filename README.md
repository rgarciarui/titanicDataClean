# videogamesScraper
Extrae los datos de video juegos desde el año 1976 a 2018 aproximadamente

# Práctica 1: Web scraping

## Descripción

Esta práctica se ha realizado bajo el contexto de la asignatura _Tipología y ciclo de vida de los datos_, perteneciente al Máster en Ciencia de Datos de la Universitat Oberta de Catalunya. 

El objetivo de esta actividad será el tratamiento de un dataset, que puede ser el creado en la práctica 1 o bien cualquier dataset libre disponible en Kaggle (https://www.kaggle.com).
Algunos ejemplos de dataset con los que podéis trabajar son:
* Red Wine Quality (https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009)
* Titanic: Machine Learning from Disaster (https://www.kaggle.com/c/titanic)
* Predict Future Sales (https://www.kaggle.com/c/competitive-data-sciencepredict-future-sales/).
  
Los últimos dos ejemplos corresponden a competiciones activas de Kaggle de manera que, opcionalmente, podríais aprovechar el trabajo realizado durante la práctica para entrar en alguna de estas competiciones.  

Siguiendo las principales etapas de un proyecto analítico, las diferentes tareas a realizar (y justificar) son las siguientes:  

1. Descripción del dataset. ¿Por qué es importante y qué pregunta/problema pretende responder?
2. Integración y selección de los datos de interés a analizar.
3. Limpieza de los datos:  
    3.1. ¿Los datos contienen ceros o elementos vacíos? ¿Cómo gestionarías cada uno de estos casos?
    3.2. Identificación y tratamiento de valores extremos.
4. Análisis de los datos.  
    4.1. Selección de los grupos de datos que se quieren analizar/comparar (planificación de los análisis a aplicar).  
    4.2. Comprobación de la normalidad y homogeneidad de la varianza.  
    4.3. Aplicación de pruebas estadísticas para comparar los grupos de datos. En función de los datos y el objetivo del estudio, aplicar pruebas de contraste de hipótesis, correlaciones, regresiones, etc.
5. Representación de los resultados a partir de tablas y gráficas.
6. Resolución del problema. A partir de los resultados obtenidos, ¿cuáles son las conclusiones? ¿Los resultados permiten responder al problema?
7. Código: Hay que adjuntar el código, preferiblemente en R, con el que se ha realizado la limpieza, análisis y representación de los datos. Si lo preferís, también podéis trabajar en Python.  

El conjunto de datos de análisis escogido ha sido finalmente el Titanic de Kaggle [https://www.kaggle.com/c/titanic/data].

## Miembros del equipo

La actividad ha sido realizada de manera individual por **Ricardo García Ruiz**.

## Licencia

La licencia utilizada finalmente ha sido la _CC BY-NC-SA 4.0 International_.
La licencia CC BY-NC-SA 4.0 International es una licencia de software libre muy utilizada y constituye un documento fundamental para el movimiento de software libre.
CC BY-NC-SA 4.0 International es una licencia acorde al marco internacional de derechos de autor y al nacional en España, siendo flexible y compatible con otras licencias de software libre.

Se permite con nuestro trabajo y la base de datos extraída de la web:  

* *Compartir* — copiar y redistribuir el material en cualquier medio o formato
* *Adaptar* — remezclar, transformar y crear a partir del material

Por otro lado, la licencia activa las siguientes restricciones:  

* **Reconocimiento**: Debe reconocer adecuadamente la autoría, proporcionar un enlace a la licencia e indicar si se han realizado cambios. Puede hacerlo de cualquier manera razonable, pero no de una manera que sugiera que tiene el apoyo del licenciador o lo recibe por el uso que hace.
* **NoComercial**: No puede utilizar el material para una finalidad comercial.
* **CompartirIgual**: Si remezcla, transforma o crea a partir del material, deberá difundir sus contribuciones bajo la misma licencia que el original.
* **No hay restricciones adicionales**: No puede aplicar términos legales o medidas tecnológicas que legalmente restrinjan realizar aquello que la licencia permite.

## Ficheros del código fuente

* **src/videogamesScraper**: Es el código de entrada al scraping y contiene el código principal utilizado para gestionar el trabajo de compilación de toda la base de datos retro de videojuegos de la web **RetroCollect**.
* **src/getPlatformDB**: Contiene el código fuente de la función **getPlatformDB()**. Esta función accede a la web de RetroCollet y obtiene un data frame con los códigos numérícos y sus equivalencias en texto de los nombres de las Plataformas disponibles en RetroCollect. Con esta función se puede realizar un filtro por tipo de plataforma, o bien toda la base de datos de videojuegos (por defecto).
* **src/searchPaginationDB**: Contiene el código fuente de la función **searchPaginationDB()**. La función realiza una búsqueda en la web localizando la página web última en la que se deben buscar los datos de scraping, devolviendo un valor numérico con la última página que se debe acceder. Los paramétros son los siguientes:
  + **url_base**: La dirección web generalde acceso a RetroCollect
  + **listview**: Sistema de visualización, por defecto *'list'*
  + **modeview**:   Por defecto se buscan *'games'*
  + **plataforma**: La plataforma de filtro, por defecto = 0, todas sin excepcion
  + **sort**:       Esquema de ordenación, puede tomar 4 parámetros:
    + *'title'*, es el defectivo y es igual a **NA**
    + *'system'*, organiza por S.O. y es igual a *"platform"*
    + *'publisher'*, organiza por cia. de publicación y es igual a *"publisher"*
    + *'year'*, organiza por año de publicación y es igual a *"year"*
  + **filas**:      Indica el numero de filas de visualización por página, defecto = 20
  + **verbose**:    Indica si se desea o no información de progreso, defecto = *TRUE*
* **src/accessVideoGameDatabase**: Contiene el código fuente de la función **accessVideoGameDatabase()**. La función realiza un web scrapin en RetroCollect, posibilitando un acceso dinamico a la misma y configurando algunos parametros de control en la llamada a la pagina web de RetroCollect indicando algunas variables de carga y control de visualización. Los paramétros son los siguientes:
  + **url_base**: La dirección web generalde acceso a RetroCollect
  + **listview**: Sistema de visualización, por defecto *'list'*
  + **modeview**:   Por defecto se buscan *'games'*
  + **plataforma**: La plataforma de filtro, por defecto = 0, todas sin excepcion
  + **sort**:       Esquema de ordenación, puede tomar 4 parámetros:
    + *'title'*, es el defectivo y es igual a **NA**
    + *'system'*, organiza por S.O. y es igual a *"platform"*
    + *'publisher'*, organiza por cia. de publicación y es igual a *"publisher"*
    + *'year'*, organiza por año de publicación y es igual a *"year"*
  + **filas**:      Indica el numero de filas de visualización por página, defecto = 20
  + **verbose**:    Indica si se desea o no información de progreso, defecto = *TRUE*

## Recursos

1. Simon Munzert, Christian Rubba, Peter Meißner, Dominic Nyhuis. (2015). _Automated Data Collection with R: A Practical Guide to Web Scraping and Text Mining._ John Wiley & Sons
2. Garcia Ruiz, Ricardo. (2014). _Estudio y caracterización de marcas de videojuegos mediante análisis de la producción de patentes y el desarrollo técnico de software para plataformas de videojuegos._ Universitat Internacional de Catalunya, DOI: 10.13140/2.1.5162.0166. 
