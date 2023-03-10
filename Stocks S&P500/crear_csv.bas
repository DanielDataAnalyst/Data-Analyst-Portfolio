Attribute VB_Name = "crear_ficheros_csv"
Sub CrearLibros()

Dim rangoNombres As Range
Set rangoNombres = Worksheets("Stock_List").Range("A2:A504") 'Cambia "Stock_List" por el nombre de la hoja donde está tu tabla

'Colocar direccion de almacenamiento de los .csv 
rutaDestino = "" 

'Fecha inicial y final para obtener los valores diarios
fechaInicial = "1-1-2010"
fechaFinal = "12-31-2022"
Rango = 0

'Bucle para la creacion de los archivos .csv  
For Each celda In rangoNombres
    Workbooks.Add
    Range("A1").Select
    ActiveCell.Formula = "=STOCKHISTORY(""" & celda.Value & """, """ & fechaInicial & """, """ & fechaFinal & """,0,0,0,2,1,4,3,5)"
    ActiveCell.Replace What:="@", Replacement:="", LookAt:=xlPart, _
    SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
    ReplaceFormat:=False, FormulaVersion:=xlReplaceFormula2
    Range("A1").Select
    Range("A2").Select
    Application.Wait (Now + TimeValue("00:00:03"))
    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Range("A1").Value = celda.Value
    Range("A1").Select
    ultimaFila = ActiveSheet.Cells(Rows.Count, 2).End(xlUp).Row
    Range("A1").Select
    Selection.AutoFill Destination:=Range("A1:A" & ultimaFila)
    Columns("C:G").Select
    Selection.NumberFormat = "0.00"
    Columns("G:G").Select
    Selection.NumberFormat = "0"
    ActiveWorkbook.SaveAs Filename:=rutaDestino & celda.Value & ".csv", FileFormat:=xlCSV
    ActiveWorkbook.Close
Next

End Sub
