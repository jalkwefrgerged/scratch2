'--- Helper column: Bucket (CTR-avoidance sizing) ------------------------------
wsWork.Cells(hdrRow, nCol).Value = "Bucket"
Dim amtColOff As Long: amtColOff = IIf(offAmt <> 0, offAmt, offCred)    'choose the amount column

formula = "=IF(ABS(RC[" & amtColOff & "])>=10000,""10 K+""," & _
          "IF(AND(ABS(RC[" & amtColOff & "])>=8000,ABS(RC[" & amtColOff & "])<10000),""8-10 K"",""<8 K""))"

wsWork.Cells(lastRow, nCol).FormulaR1C1 = formula
nCol = nCol + 1
'-------------------------------------------------------------------------------
