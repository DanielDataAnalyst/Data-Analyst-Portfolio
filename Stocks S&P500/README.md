# Obtencion de precios historicos de acciones del S&P500

## Obtención de datos en formato .csv

Para la obtencion de los valores historicos de las acciones del S&P 500 se hizo uso de la funcion de Excel **STOCKHISTORY** combinada con una macro de Excel, el codigo de esta macro se encuentra disponible en los archivos del repositorio con el nombre [crear_csv.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/crear_csv.bas)

Este código utiliza como punto de partida el fichero en Excel [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) el que contiene un listado con los simbolos de este índice. La macro toma cada uno de estos, le aplica la funcion **STOCKHISTORY** en un período de tiempo comprendido entre el 01-01-2010 y el 26-01-2023 y genera un archivo .csv por cada uno. El proceso es aplicable a todas los intrumentos que tenga dentro de su base de datos la función, solamnete habria que actualizar las etiquetas de la tabla.
Se generan los siguientes campos con registros diarios en el periodo antes mencionado: 

*fecha* , *Precio apertura*, *Precio cierre*, *Máximo*, *Mínimo*, *Volumen*


## 
