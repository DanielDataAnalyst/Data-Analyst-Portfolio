# Historial de precios de acciones del S&P500

## 1. Obtención de datos en formato .csv

Para la obtención de los valores históricos de las acciones del S&P 500 se utilizó la función de Excel **STOCKHISTORY** combinada con una macro, la que toma de una tabla del libro [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) los tickers de cada una de las acciones de este índice, le aplica la funcion **STOCKHISTORY** en un período de tiempo comprendido entre el 01-01-2002 y el 31-12-2022 y genera un archivo .csv por cada stock en un formato adecuado para su manipulación posterior.
Se generan los siguientes campos con registros diarios en el periodo antes mencionado: 

*Ticker accion* *fecha* , *Precio apertura*, *Precio cierre*, *Máximo*, *Mínimo*, *Volumen*

El código de esta macro se encuentra disponible en los archivos del repositorio con el nombre [crear_csv.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/crear_csv.bas)

*Nota: La macro se creó considerando que los .csv se almacenarían en un carpeta de OneDrive donde no es necesario confirmar el guardado.*


## 2. Importación y limpieza de datos

### 2.1 Importación de registros desde los ficheros .csv y creación de base de datos

Para la importación de los .csv trabajamos con el código:

```SQL 

COPY public.historic_values(Ticker_Stock,Fecha,Precio_apertura,Precio_cierre,Minimo,Maximo,Volumen) from 'D:\CSV_2002-2022\"Ticker de la accion".csv' WITH DELIMITER ',' CSV;

```

Al ser más de 500 ficheros .csv se trabajó con el libro [Listado_Stock_SP500 v2.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/Listado_Stock_SP500%20v2.xlsm) que fue creado a partir de [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) haciendo uso de concatenación de textos para obtener una columna donde en cada fila contiene el código anterior con el ticker correspondiente del stock. 

 Además se creó un base de datos SQL (PostgreSQL) en donde se realizaron los procesos de importación y limpieza de los archivos .csv, la que se nombró *sp500* y dentro del esquema *public* de la misma se generó una tabla con el siguiente código para almacenar los datos:

```SQL
--Creación de la tabla para almacenar los archivos. csv

CREATE TABLE IF NOT EXISTS public.historic_values
(
	Ticker_Stock      VARCHAR(6) NOT NULL,
	Fecha             DATE NOT NULL,
	Precio_apertura   NUMERIC(8,2), 
	Precio_cierre     NUMERIC(8,2),
	Minimo            NUMERIC(8,2),
	Maximo            NUMERIC(8,2), 
	Volumen           INTEGER,
	CONSTRAINT historic_values_fecha_simbolo PRIMARY KEY (Ticker_Stock, Fecha)
)
```
Esta tabla tuvo que modificarse para la limpieza con otra donde los tipos de datos fueran varchar en todos los campos a raiz de un error producido por la presencia de valores nulos en varios registros. Posterior a la limpieza fue eliminada esta última tabla y sustituida por la mostrada con los tipos de datos adecuados. 


### 2.2 Busqueda de valores nulos

La búsqueda de los valores nulos se realizo con el siguiente código:

```SQL

SELECT * FROM public.historic_values
WHERE fecha = '#N/A' OR precio_apertura = '#N/A' OR precio_cierre = '#N/A' OR minimo = '#N/A' OR minimo = '#N/A' OR maximo = '#N/A' OR volumen = '#N/A'

```

Se obtuvieron 2368 registros de un total de 2359346 lo cual representa un 0.1% del total, la siguiente tabla muestra la distribucion de cada uno:

|	ticker_stock	|	cantidad_nulos	|                       |	ticker_stock	|	cantidad_nulos	|            
|	:---:	|	:---:	|                                       |	:---:	|	:---:	|
|	BIIB	|	1	|                                       |	CBOE	|	140	|
|	CARR	|	1	|                                       |	UAL	|	145	|
|	CDAY	|	1	|                                       |	LIN	|	191	|                  
|	DVA	|	1	|                                       |	REG	|	195	|
|	FDS	|	1	|                                       |	TER	|	205	|
|	IEX	|	1	|                                       |	NWL	|	214	|
|	L	|	1	|                                       |	LNT	|	229	|
|	MPWR	|	1	|                                       |	LHX	|	349	|                                

|	NVR	|	1	|                                       
|	OTIS	|	1	|
|	TYL	|	1	|
|	FOX	|	3	|
|	GEHC	|	3	|
|	FOXA	|	4	|
|	CTVA	|	4	|
|	DOW	|	7	|
|	EVRG	|	49	|











