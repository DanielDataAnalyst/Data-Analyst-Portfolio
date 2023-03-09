Attribute VB_Name = "crear_ficheros_csv"
Sub CrearLibros()

Dim rangoNombres As Range
Set rangoNombres = Worksheets("Stock_List").Range("A2:A504") 'Cambia "Stock_List" por el nombre de la hoja donde está tu tabla

'Colocar entre comillas la direccion donde se encuentre el fichero .xlsm que contiene la tabla con el listado de acciones 
rutaDestino = "" 

'Fecha inicial y final para obtener los valores diarios
fechaInicial = "1-1-2010"
fechaFinal = "1-26-2023"
Rango = 0

'Bucle para la creacion de los archivos .csv  
For Each celda In rangoNombres
    Workbooks.Add
    Range("A1").Select
    ActiveCell.Formula = "=STOCKHISTORY(""" & celda.Value & """, """ & fechaInicial & """, """ & fechaFinal & """,0,0,0,2,1,4,3,5)"
    ActiveCell.Replace What:="@", Replacement:="", LookAt:=xlPart, SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, ReplaceFormat:=False, FormulaVersion:=xlReplaceFormula2
    Range("A1").Select
    Range("A2").Select
    Application.Wait (Now + TimeValue("00:00:02"))
    ActiveWorkbook.SaveAs Filename:=rutaDestino & celda.Value & ".xlsx"
    ActiveWorkbook.Close
Next

End Sub

