# Introducción

El índice Standard & Poor's 500 (Standard & Poor's 500 Index), también conocido como S&P 500, es uno de los índices bursátiles más importantes de Estados Unidos. Se le considera el índice más representativo de la situación real del mercado. Se basa en la capitalización bursátil de 503 grandes empresas que poseen acciones que cotizan en las bolsas NYSE o NASDAQ, y captura aproximadamente el 80% de toda la capitalización de mercado en Estados Unidos. 
En este proyecto trabajaremos con los datos de las cotizaciones diarias de este índice en un período de 20 años comprendido entre los años 2002-2022. A partir de estos datos y haciendo uso de varias herramientas para su manipulacion y transformacion llegaremos a una serie de conclusiones.

## 1. Obtención de datos en formato .csv

Para la obtención de los valores históricos de las acciones del S&P 500 se utilizó la función de Excel **STOCKHISTORY** combinada con una macro, la que toma de una tabla del libro [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) los tickers de cada una de las acciones de este índice, le aplica la funcion **STOCKHISTORY** en un período de tiempo comprendido entre el 01-01-2002 y el 31-12-2022 y genera un archivo .csv por cada stock en un formato adecuado para su manipulación posterior. De este proceso se obtuvieron 503 ficheros .csv, uno por cada acción del índice, cada uno con los siguientes campos con registros diarios en el periodo antes mencionado: 

*Ticker accion*, *fecha* , *Precio apertura*, *Precio cierre*, *Máximo*, *Mínimo*, *Volumen*

El código de esta macro se encuentra disponible en los archivos del repositorio con el nombre [crear_csv.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/crear_csv.bas)

*Nota: La macro se creó considerando que los .csv se almacenarían en un carpeta de OneDrive donde no es necesario confirmar el guardado.*


## 2. Importación y limpieza de datos

### 2.1 Importación de registros desde los ficheros .csv y creación de base de datos

Para la importación de los .csv trabajamos con el código:

```SQL 

COPY public.historic_values(Ticker_Stock,Fecha,Precio_apertura,Precio_cierre,Minimo,Maximo,Volumen) from 'D:\CSV_2002-2022\"Ticker de la accion".csv' WITH DELIMITER ',' CSV;

```

Al ser más de 500 ficheros .csv se trabajó con el libro [Listado_Stock_SP500 v2.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/Listado_Stock_SP500%20v2.xlsm) que fue creado a partir de [Listado_Stock_SP500.xlsm](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/tree/main/Stocks%20S%26P500) haciendo uso de concatenación de textos para obtener una columna donde en cada fila contiene el código anterior con el ticker correspondiente del stock. 

 Además se creó una base de datos SQL (PostgreSQL) en donde se realizaron los procesos de importación y limpieza de los archivos .csv, la que se nombró *sp500* y dentro del esquema *public* de la misma se generó una tabla con el siguiente código para almacenar los datos:

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

También se importó a Excel una tabla, obtenida de la [Wikipedia](https://en.wikipedia.org/wiki/List_of_S%26P_500_companies) que contiene el ticker de la acción (Primary Key), el nombre, el sector y subsector a que pertenece la empresa, el .csv obtenido fue importado a tabla *stock_list* creada dentro de la base de datos con la que se ha estado trabajando. El codigo se muestra a continuacion:

```SQL

CREATE TABLE IF NOT EXISTS public.stock_list
(
	Ticker_Stock      VARCHAR(6) NOT NULL PRIMARY KEY,
	Nombre            VARCHAR(50) NOT NULL,
	Sector            VARCHAR(50) NOT NULL,
	Subsector         VARCHAR(50) NOT NULL,
	Ubicacion         VARCHAR(50) NOT NULL,
	Ciudad            VARCHAR(50) NOT NULL
)

```


### 2.2 Búsqueda de valores nulos

La búsqueda de los valores nulos se realizó con los siguientes códigos:

```SQL

--Cantidad de registros
SELECT COUNT(*) AS cant_total_registros
FROM public.historic_values

-- Busqueda de valores nulos
SELECT * 
FROM public.historic_values
WHERE fecha = '#N/A' OR precio_apertura = '#N/A' OR precio_cierre = '#N/A' OR minimo = '#N/A' OR minimo = '#N/A' OR maximo = '#N/A' OR volumen = '#N/A'
ORDER BY ticker_stock

--- Busqueda de valores nulos agrupados
SELECT ticker_stock, COUNT(ticker_stock) AS cantidad_nulos
FROM public.historic_values
WHERE fecha = '#N/A' OR precio_apertura = '#N/A' OR precio_cierre = '#N/A' OR minimo = '#N/A' OR maximo = '#N/A' OR volumen = '#N/A'
GROUP BY ticker_stock
ORDER BY cantidad_nulos

```

Se obtuvieron 2368 registros nulos de un total de 2359346 lo cual representa un 0.1% del total, la siguiente tabla muestra la distribucion de cada uno:

|	ticker_stock	|	cantidad_nulos	|                       
|	:---:	|	:---:	|                                       
|	BIIB	|	1	|                                       
|	CARR	|	1	|                                       
|	CDAY	|	1	|                                                         
|	DVA	|	1	|                                       
|	FDS	|	1	|                                       
|	IEX	|	1	|                                       
|	L	|	1	|                                       
|	MPWR	|	1	|                                                                       
|	NVR	|	1	|                                       
|	OTIS	|	1	|
|	TYL	|	1	|
|	FOX	|	3	|
|	GEHC	|	3	|
|	FOXA	|	4	|
|	CTVA	|	4	|
|	DOW	|	7	|
|	EVRG	|	49	|
|	CBOE	|	140	|
|	UAL	|	145	|
|	LIN	|	191	|
|	LIN	|	191	| 
|	LIN	|	191	|
|	REG	|	195	|
|	TER	|	205	|
|	NWL	|	214	|
|	LNT	|	229	|
|	LHX	|	349	|


Los valores nulos, hasta el ticker **EVRG**, fueron buscados en Yahoo Finance y sustituidos. De **CBOE** en adelante al ser una cantidad mayor fueron eliminados al no representar registros significativos para los analisis que se realizarán. 


### 2.3 Búsqueda de valores atípicos

- #### Volumenes atipicos

Para realizar este proceso se ejecutó una consulta que mostrara los registros con valores por encima 1.000.000.000 de acciones transadas en un día, un número muy pocas veces alcanzado. 

```SQL

SELECT *
FROM public.historic_values
WHERE volumen > 1000000000
ORDER BY volumen DESC

```

Obteniendo la siguiente tabla:

|	ticker_stock	|	cantidad_nulos	|                       
|	:---:	|	:---:	|       
|AIG	|1|
|BAC	|3|
|C|	60|

De los 2 primeros se comprobaron las fechas y coincidieron con los volumenes correspondientes. Por otra parte, se encontró que la accion C del Citybank presentaba un error en el origen de los datos en que todos sus valores tenian un 0 de más, situación esta que fue corregida en el .csv.

- #### Ticker no válidos

Al realizar la unión de las tablas *stock_list* e *historic_values*  se generaban varios registros con campos nulos con ticker de las iniciales de los meses del año en inglés (JAN, FEB,...., DEC). Después de una búsqueda en los 503 origenes de datos con ayuda de la macro [buscarValoresJAN.bas](https://github.com/DanielDataAnalyst/Data-Analyst-Portfolio/blob/main/Stocks%20S%26P500/buscarValoresJAN.bas) se encontró que el .csv con nombre *MAR* cuando fue creado Excel considero que se trataba del mes Marzo e hizo un autorellenado con las iniciales de los meses del año. Lo anterior se modifico en el origen.

## 3. Análisis de los datos 

- #### Participación por sector

Mediante la siguiente consulta obtenemos la cantidad de empresas que existe en cada sector del indice así como el porcentaje que representa cada una del total.

```SQL

SELECT  RANK () OVER (ORDER BY COUNT(ticker_stock) DESC) AS Ranking,
		sector, 
		COUNT(ticker_stock) AS Total,
		CONCAT(ROUND((COUNT(ticker_stock) * 100/SUM(COUNT(ticker_stock)) OVER()),2),'%') AS Porcentaje_total
FROM public.stock_list
GROUP BY sector
ORDER BY Total DESC

```

Con lo que obtenemos la tabla:

|    ranking	|	sector	                |	total	|  porcentaje_total	|
|	:---:	|	:---:	                |	:---:	|	:---:	|      
|	1	|	Information Technology	|	75	|	14.91%	|
|	2	|	Industrials	        |	69	|	13.72%	|
|	3	|	Financials	        |	66	|	13.12%	|
|	4	|	Health Care	        |	64	|	12.72%	|
|	5	|	Consumer Discretionary	|	51	|	10.14%	|
|	6	|	Consumer Staples	|	33	|	6.56%	|
|	7	|	Utilities	        |	30	|	5.96%	|
|	8	|	Materials	        |	29	|	5.77%	|
|	8	|	Real Estate	        |	29	|	5.77%	|
|	10	|	Communication Services	|	25	|	4.97%	|
|	11	|	Energy	                |	23	|	4.57%	|
|	12	|	 Inc.	                |	9	|	1.79%	|

Como se observa el primer lugar se lo lleva el sector de las TI con 75 empresas participantes en el índice que representa casi el 15% del total, le sigue el sector Industrial con 69 empresas (13.72%) y las empresas financieras (13.12%) con 66.

- #### Ubicación

Ahora veamos como agrupan por ubicación geografica. Para ellos usamos la consulta:

```SQL

SELECT  DENSE_RANK () OVER (ORDER BY COUNT(ticker_stock) DESC) AS Ranking,
		ciudad AS Estado,
		COUNT(ticker_stock) AS Total,
		CONCAT(ROUND((COUNT(ticker_stock) * 100/SUM(COUNT(ticker_stock)) OVER()),2),'%') AS Porcentaje_total
FROM public.stock_list
GROUP BY ciudad
ORDER BY Total DESC

```


|	ranking	|	estado	|	total	|	porcentaje_total	|
|	:---:	|	:---:	                |	:---:	|	:---:	|   
|	1	|	California	|	70	|	13.92%	|
|	2	|	New York	|	54	|	10.74%	|
|	3	|	Texas	|	45	|	8.95%	|
|	4	|	Illinois	|	34	|	6.76%	|
|	5	|	Foreign	|	22	|	4.37%	|
|	6	|	Massachusetts	|	21	|	4.17%	|
|	7	|	Ohio	|	20	|	3.98%	|
|	8	|	Pennsylvania	|	19	|	3.78%	|
|	9	|	Georgia	|	18	|	3.58%	|
|	10	|	North Carolina	|	16	|	3.18%	|
|	10	|	Florida	|	16	|	3.18%	|
|	11	|	New Jersey	|	15	|	2.98%	|
|	11	|	Virginia	|	15	|	2.98%	|
|	12	|	Minnesota	|	14	|	2.78%	|
|	13	|	Washington	|	13	|	2.58%	|
|	13	|	Connecticut	|	13	|	2.58%	|
|	14	|	Michigan	|	11	|	2.19%	|
|	15	|	Arizona	|	8	|	1.59%	|
|	15	|	Tennessee	|	8	|	1.59%	|
|	15	|	Indiana	|	8	|	1.59%	|
|	16	|	Colorado	|	7	|	1.39%	|
|	16	|	Wisconsin	|	7	|	1.39%	|
|	16	|	Maryland	|	7	|	1.39%	|
|	17	|	Missouri	|	6	|	1.19%	|
|	18	|	Oklahoma	|	4	|	0.80%	|
|	18	|	Nevada	|	4	|	0.80%	|
|	18	|	Rhode Island	|	4	|	0.80%	|
|	19	|	Kentucky	|	3	|	0.60%	|
|	19	|	Arkansas	|	3	|	0.60%	|
|	19	|	Louisiana	|	3	|	0.60%	|
|	20	|	Utah	|	2	|	0.40%	|
|	20	|	Nebraska	|	2	|	0.40%	|
|	20	|	Alabama	|	2	|	0.40%	|
|	20	|	Delaware	|	2	|	0.40%	|
|	20	|	Washington D. C.	|	2	|	0.40%	|
|	20	|	Idaho	|	2	|	0.40%	|
|	21	|	Maine	|	1	|	0.20%	|
|	21	|	Oregon	|	1	|	0.20%	|
|	21	|	Iowa	|	1	|	0.20%	|

*Nota: Foreign agrupa todas las empresas con sede fuera de Estados Unidos*


- #### Volumenes de operaciones por año 

Para conocer como se ha comportado este indicador en el transcurso de los años del periodo analizado usaremos la siguiente consulta:

```SQL
SELECT EXTRACT(YEAR FROM fecha) AS Year,
	   SUM(volumen) AS Total_volumen,
	   CONCAT(ROUND((SUM(volumen) - LAG(SUM(volumen)) OVER())*100/SUM(volumen),2),'%') AS variacion_anual
FROM public.historic_values
GROUP BY Year
ORDER BY Year
```

Con la que obtenemos la tabla:

|	Year	|	Total_volumen	         | Variación interanual |                      
|	:---:	|	:---:	                 |     :---:    |
|	2002	|	 281,190,169,546.00 	 | 	0	|
|	2003	|	 272,024,315,460.00 	 | 	-3.37%	|
|	2004	|	 276,523,779,778.00 	 | 	1.63%	|
|	2005	|	 310,307,351,829.00 	 | 	10.89%	|
|	2006	|	 366,315,903,245.00 	 | 	15.29%	|
|	2007	|	 469,490,993,130.00 	 | 	21.98%	|
|	2008	|	 697,485,733,792.00 	 | 	32.69%	|
|	2009	|	 826,500,004,993.00 	 | 	15.61%	|
|	2010	|	 680,019,690,476.00 	 | 	-21.54%	|
|	2011	|	 643,688,377,219.00 	 | 	-5.64%	|
|	2012	|	 543,318,220,788.00 	 | 	-18.47%	|
|	2013	|	 486,073,539,984.00 	 | 	-11.78%	|
|	2014	|	 451,361,974,939.00 	 | 	-7.69%	|
|	2015	|	 483,421,643,634.00 	 | 	6.63%	|
|	2016	|	 512,547,685,899.00 	 | 	5.68%	|
|	2017	|	 443,798,112,921.00 	 | 	-15.49%	|
|	2018	|	 522,601,711,960.00 	 | 	15.08%	|
|	2019	|	 476,334,658,884.00 	 | 	-9.71%	|
|	2020	|	 680,950,127,933.00 	 | 	30.05%	|
|	2021	|	 549,577,711,672.00 	 | 	-23.90%	|
|	2022	|	 625,236,404,255.00 	 | 	12.10%	|

Para tener una visión más clara se graficará esta tabla.

![image](https://user-images.githubusercontent.com/125587676/226775438-d008e204-9476-4c64-87d6-cd8a7e450a75.png)

Como se observa hubo un aumento considerable de los volumenes de operaciones desde el año 2007 alcanzando su pick en el año 2009, motivado fundamentalmente por la crisis financiera de estos años y todo lo que generó en los mercados financieros. También vemos otro máximo en el año 2020 producido por la crisis pandemica. 

- Que empresas tuvieron los mayores volumenes por año
- Mayores aumento de precios desde el inicio
- Analisis de Tesla TSLA
