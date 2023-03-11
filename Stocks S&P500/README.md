# Historial de precios de acciones del S&P500

## 1. Obtención de datos en formato .csv

Para la obtención de los valores históricos de las acciones del S&P 500 se utilizó la función de Excel **STOCKHISTORY** combinada con una macro, la que toma de una tabla del libro [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) los tickers de cada una de las acciones de este índice, le aplica la funcion **STOCKHISTORY** en un período de tiempo comprendido entre el 01-01-2002 y el 31-12-2022 y genera un archivo .csv por cada stock en un formato adecuado para su manipulación posterior.
Se generan los siguientes campos con registros diarios en el periodo antes mencionado: 

*Ticker accion* *fecha* , *Precio apertura*, *Precio cierre*, *Máximo*, *Mínimo*, *Volumen*

El código de esta macro se encuentra disponible en los archivos del repositorio con el nombre [crear_csv.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/crear_csv.bas)

*Nota: La macro se creó considerando que los .csv se almacenarían en un carpeta de OneDrive donde no es necesario confirmar el guardado.*


## 2. Importación y limpieza de datos

### 2.1 Creación de base de datos e importación de registros desde los ficheros .csv

Se creó un base de datos SQL (PostgreSQL) en donde se realizaron los procesos de importación y limpieza de los archivos .csv, a ésta se nombró *sp500* y dentro del esquema *public* de la misma se generó una tabla con el siguiente código para almacenar los datos:

```SQL
--Creación de la tabla para almacenar los archivos. csv

CREATE TABLE IF NOT EXISTS public.historic_values
(
	Ticker_Stock      VARCHAR(6) NOT NULL,
	Fecha             VARCHAR(25) NOT NULL,
	Precio_apertura   VARCHAR(25), 
	Precio_cierre     VARCHAR(25),
	Minimo            VARCHAR(25),
	Maximo            VARCHAR(25), 
	Volumen           VARCHAR(25),
	CONSTRAINT historic_values_fecha_simbolo PRIMARY KEY (Ticker_Stock, Fecha)
)
```
En una primera instancia el tipo de dato de los campos fueron definidos como varchar para poder cargar los datos y realizar la limpieza.

Para la importación de los .csv trabajamos con el código:

```SQL 

COPY public.historic_values(Ticker_Stock,Fecha,Precio_apertura,Precio_cierre,Minimo,Maximo,Volumen) from 'D:\CSV_2002-2022\"Ticker de la accion".csv' WITH DELIMITER ',' CSV;

```

Al ser más de 500 ficheros .csv se trabajó con el libro [Listado_Stock_SP500 v2.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/Listado_Stock_SP500%20v2.xlsm) que fue creado a partir de [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) haciendo uso de concatenación de textos para obtener una columna donde en cada fila contiene el código anterior con el ticker correspondiente del stock. 

### 2.2 Busqueda de valores nulos

La búsqueda de los valores nulos se realizo con el siguiente código:

```SQL

SELECT * FROM public.historic_values
WHERE fecha = '#N/A' OR precio_apertura = '#N/A' OR precio_cierre = '#N/A' OR minimo = '#N/A' OR minimo = '#N/A' OR maximo = '#N/A' OR volumen = '#N/A'

```
De este se obtuvieron 2368 registros 
