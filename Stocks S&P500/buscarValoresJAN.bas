Attribute VB_Name = "buscarValoresNA"
Sub Buscar_JAN_en_CSV()

Dim Archivo As String
Dim Ruta As String
Dim celda As Range
Ruta = "" 'Colocar Ruta donde están los archivos .csv
Archivo = Dir(Ruta & "*.csv")

Do While Archivo <> ""
    Workbooks.Open (Ruta & Archivo)
    For Each celda In ActiveSheet.UsedRange.Cells
        If InStr(1, celda.Value, "JAN") Then
            MsgBox "Se encontró JAN en el archivo " & Archivo
            Exit For
        End If
    Next celda
    Workbooks(Archivo).Close False
    Archivo = Dir()
Loop

End Sub

