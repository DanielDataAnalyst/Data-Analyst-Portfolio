Attribute VB_Name = "Módulo1"
Sub CrearLibros()

Dim rangoNombres As Range
Set rangoNombres = Worksheets("Stock_List").Range("A2:A504") 'Cambia "Hoja1" por el nombre de la hoja donde está tu tabla

'Establece la ruta de destino
rutaDestino = "C:\Users\Daniel\OneDrive - SOC. COM. LERPAIN LTDA\Daniel\PERSONAL\Estudio\Proyecto\STOCKS\" 'por la ruta de destino deseada

'Fecha inicial y final
fechaInicial = "1-1-2010"
fechaFinal = "1-26-2023"
Rango = 0

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
    ActiveWorkbook.SaveAs Filename:=rutaDestino & celda.Value & ".xlsx"
    ActiveWorkbook.Close
Next

End Sub

