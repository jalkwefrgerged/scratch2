'--- Helper column: SignAmt  (+ for cash deposits, – for checks) --------------
If offAmt <> 0 Then
    formula = "=IF(UPPER(RC[" & offType & "])=""CASH"",RC[" & offAmt & "]," & _
              "IF(UPPER(RC[" & offType & "])=""CHECK"",-RC[" & offAmt & "],0))"
Else
    formula = "=IF(UPPER(RC[" & offType & "])=""CASH"",RC[" & offCred & "]," & _
              "IF(UPPER(RC[" & offType & "])=""CHECK"",-RC[" & offDeb & "],0))"
End If
wsWork.Cells(lastRow, nCol).FormulaR1C1 = formula
nCol = nCol + 1
'-------------------------------------------------------------------------------
