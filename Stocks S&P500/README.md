# Historial de precios de acciones del S&P500

## Obtención de datos en formato .csv

Para la obtención de los valores históricos de las acciones del S&P 500 se utilizo la funcion de Excel **STOCKHISTORY** combinada con una macro de Excel. 

El código de esta utiliza como punto de partida el fichero en Excel [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) el que contiene un listado con los simbolos de este índice. La macro toma cada uno de estos, le aplica la funcion **STOCKHISTORY** en un período de tiempo comprendido entre el 01-01-2010 y el 26-01-2023 y genera un archivo .csv por cada stock en un formato adecuado para su manipulación posterior.
Se generan los siguientes campos con registros diarios en el periodo antes mencionado: 

*Ticker accion*, *fecha* , *Precio apertura*, *Precio cierre*, *Máximo*, *Mínimo*, *Volumen*

El código de esta macro se encuentra disponible en los archivos del repositorio con el nombre [crear_csv.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/crear_csv.bas)

*Nota: La macro esta creada considerando que los .csv se almacenaran en un carpeta de OneDrive donde no es necesario confirmar el guardado.


## Creación de base de datos SQL (PostgreSQL) e importación de ficheros .csv

Se crea un nueva base de datos con nombre *sp500* y el esquema *public*, dentro del cual se generan una tabla para almacenar los datos con el siguiente código:

```SQL
--Creación de la tabla para almacenar los archivos. csv

CREATE TABLE IF NOT EXISTS public.historic_values
(
	Ticker_Stock      VARCHAR(6) NOT NULL,
	Fecha             DATE NOT NULL,
	Precio_apertura   NUMERIC(8,2), 
	Precio_cierre     NUMERIC(8,2),
	Maximo            NUMERIC(8,2),
	Minimo            NUMERIC(8,2), 
	Volumen           INTEGER,
	CONSTRAINT historic_values_fecha_simbolo PRIMARY KEY (Ticker_Stock, Fecha)
)

```



