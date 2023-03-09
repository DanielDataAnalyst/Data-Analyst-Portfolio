Attribute VB_Name = "convertir_CSV_historicos"
Sub Abrir_Cerrar_Archivos()
    Dim strRuta As String
    Dim strNombreArchivo As String
    strRuta = "C:\Users\Daniel\OneDrive - SOC. COM. LERPAIN LTDA\Daniel\PERSONAL\Estudio\Proyecto\STOCKS\Sin Encabezados\" 'Reemplazar con la ruta de la carpeta donde se encuentran los archivos de Excel
    strNombreArchivo = Dir(strRuta & "*.xls*")
    Do While strNombreArchivo <> ""
        Workbooks.Open (strRuta & strNombreArchivo)
        Columns("A:A").Select
        Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
        Range("A1").Select
        ultimaFila = ActiveSheet.Cells(Rows.Count, 2).End(xlUp).Row
        strNombreArchivoSinFormato = Left(strNombreArchivo, Len(strNombreArchivo) - 5)
        Range("A1").Select
        ActiveCell.Value = strNombreArchivoSinFormato
        Selection.AutoFill Destination:=Range("A1:A" & ultimaFila)
        Columns("C:G").Select
        Selection.NumberFormat = "0.00"
        Columns("G:G").Select
        Selection.NumberFormat = "0"
        ActiveWorkbook.SaveAs Filename:=strRuta & "CSV\" & strNombreArchivoSinFormato & ".csv", FileFormat:=xlCSV
        ActiveWorkbook.Close
        strNombreArchivo = Dir()
    Loop
End Sub
