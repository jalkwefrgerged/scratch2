' ======================================================================
'  StructuringAnalysisMacro.bas  (v2 – Cost Center support)
'  One‑click VBA macro to generate the full cash‑structuring analytics for
'  an AML investigation, now using the **Cost Center** column to measure
'  branch dispersion if a dedicated Branch ID field is absent.
' ----------------------------------------------------------------------
'  INPUT  : Active worksheet = raw ISS Posting extract (all channels).
'           Required columns (case‑insensitive matches accepted):
'              • Date (posting date)
'              • Type (Cash / Check / ACH ...)
'              • Amount  –or– Credit / Debit pair
'              • Cost Center  (used for branch dispersion)
'  OUTPUT :
'           • Duplicate sheet “CICO_Work” with helper columns added
'           • Pivot sheet “Structuring_Pivots” containing:
'               – Daily net‑cash pivot (Date × Net Cash)
'               – 8‑10 K bucket pivot
'               – 48‑hour velocity pivot (cash‑in vs cash‑out)
'               – Cost‑Center dispersion pivot
'           • Summary Metrics block (ready to paste into MOC Findings):
'               ▸ % of deposits in the 8‑10 K bucket
'               ▸ Cash‑out ratio
'               ▸ # and $ of recycling windows (≤ 48 hrs)
'               ▸ # of Cost Centers with ≥ 1 cash txn
' ----------------------------------------------------------------------
Option Explicit

' ========= CONFIGURABLE COLUMN HEADERS =================================
Const COL_DATE$        = "Date"          ' Posting Date
Const COL_TYPE$        = "Type"          ' Cash / Check / ACH / ...
Const COL_AMT$         = "Amount"        ' Single amount column (pos/neg)
Const COL_CREDIT$      = "Credit"        ' If separate credit & debit cols
Const COL_DEBIT$       = "Debit"         '  …
Const COL_BRANCH$      = "Cost Center"   ' Use Cost Center for branch dispersion

' ========= MAIN ENTRY ===================================================
Sub RunStructuringAnalysis()
    Dim wsRaw As Worksheet, wsWork As Worksheet, wsPvt As Worksheet
    Dim lastRow As Long, hdrRow As Long: hdrRow = 1
    '--- identify active sheet ---
    Set wsRaw = ActiveSheet
    lastRow = wsRaw.Cells(wsRaw.Rows.Count, 1).End(xlUp).Row

    '--- duplicate sheet ---
    wsRaw.Copy After:=wsRaw
    Set wsWork = ActiveSheet
    wsWork.Name = "CICO_Work"

    '--- add helper columns ---
    Dim colIdx As Long, nCol As Long
    nCol = wsWork.Cells(1, wsWork.Columns.Count).End(xlToLeft).Column + 1

    ' DateOnly
    wsWork.Cells(hdrRow, nCol).Value = "DateOnly"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = "=INT(RC[" & ColOffset(wsWork, COL_DATE) & "])"
    Dim colDateOnly As Long: colDateOnly = nCol: nCol = nCol + 1

    ' SignAmt
    wsWork.Cells(hdrRow, nCol).Value = "SignAmt"
    Dim offType As Long: offType = ColOffset(wsWork, COL_TYPE)
    Dim offAmt As Long:  offAmt = ColOffset(wsWork, COL_AMT)
    Dim offCred As Long: offCred = ColOffset(wsWork, COL_CREDIT, True)
    Dim offDeb As Long:  offDeb = ColOffset(wsWork, COL_DEBIT, True)
    Dim formula As String
    If offAmt <> 0 Then
        formula = "=IF(UPPER(RC[" & offType & "])=\"CASH\",RC[" & offAmt & ""],IF(UPPER(RC[" & offType & "])=\"CHECK\",-RC[" & offAmt & ""],0))"
    Else
        formula = "=IF(UPPER(RC[" & offType & "])=\"CASH\",RC[" & offCred & ""],IF(UPPER(RC[" & offType & "])=\"CHECK\",-RC[" & offDeb & ""],0))"
    End If
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).Formula = formula
    Dim colSignAmt As Long: colSignAmt = nCol: nCol = nCol + 1

    ' Bucket (8‑10 K)
    wsWork.Cells(hdrRow, nCol).Value = "Bucket"
    Dim amtColOff As Long: amtColOff = IIf(offAmt <> 0, offAmt, offCred)
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).Formula = _
        "=IF(AND(ABS(RC[" & amtColOff & "])>=8000,ABS(RC[" & amtColOff & "])<10000),\"8-10 K\",IF(ABS(RC[" & amtColOff & "])>=10000,\"10 K+\",\"<8 K\"))"

    ' 48‑hr Window key
    wsWork.Cells(hdrRow, nCol + 1).Value = "Win48h"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol + 1), wsWork.Cells(lastRow, nCol + 1)).Formula = _
        "=TEXT(RC[" & (colDateOnly - (nCol + 1)) & ""],\"yyyy-mm-dd\")&\"|\"&TEXT(RC[" & (colDateOnly - (nCol + 1)) & "]+1,\"yyyy-mm-dd\")"

    '--- create pivot sheet ---
    Set wsPvt = Worksheets.Add(After:=wsWork): wsPvt.Name = "Structuring_Pivots"

    ' Daily net‑cash pivot
    CreatePivot wsWork, wsPvt, "DateOnly", colDateOnly, "SignAmt", colSignAmt, "Pvt_DailyNet", True

    ' Bucket pivot
    CreatePivot wsWork, wsPvt, "Bucket", ColOffset(wsWork, "Bucket"), IIf(offAmt <> 0, COL_AMT, COL_CREDIT), IIf(offAmt <> 0, offAmt, offCred), "Pvt_Bucket", False, True

    ' 48‑hr velocity pivot
    CreatePivot wsWork, wsPvt, "Win48h", ColOffset(wsWork, "Win48h"), "SignAmt", colSignAmt, "Pvt_Velocity", True

    ' Cost Center pivot (branch dispersion)
    If ColOffset(wsWork, COL_BRANCH, True) <> 0 Then
        CreatePivot wsWork, wsPvt, COL_BRANCH, ColOffset(wsWork, COL_BRANCH, True), IIf(offAmt <> 0, COL_AMT, COL_CREDIT), IIf(offAmt <> 0, offAmt, offCred), "Pvt_CostCenter", False, True
    End If

    '--- summary metrics ---
    Dim nextRow As Long: nextRow = wsPvt.Cells(wsPvt.Rows.Count, 1).End(xlUp).Row + 2
    wsPvt.Cells(nextRow, 1).Value = "Summary Metrics"
    wsPvt.Cells(nextRow, 1).Font.Bold = True

    ' 8‑10 K %
    wsPvt.Cells(nextRow + 1, 1).Value = "% deposits 8‑10 K"
    wsPvt.Cells(nextRow + 1, 2).Formula = "=GETPIVOTDATA(\"Count of " & IIf(offAmt <> 0, COL_AMT, COL_CREDIT) & "\",$A$3,\"Bucket\",\"8-10 K\")/GETPIVOTDATA(\"Count of " & IIf(offAmt <> 0, COL_AMT, COL_CREDIT) & "\",$A$3)"

    ' Cash‑out ratio (total checks ÷ total cash‑in)
    wsPvt.Cells(nextRow + 2, 1).Value = "Cash‑out ratio"
    wsPvt.Cells(nextRow + 2, 2).FormulaArray = "=ABS(SUMIF(" & wsWork.Range(ColLetter(offType) & "2:" & ColLetter(offType) & lastRow).Address & ",\"CHECK\"," & wsWork.Range(ColLetter(IIf(offAmt <> 0, offAmt, offDeb)) & "2:" & ColLetter(IIf(offAmt <> 0, offAmt, offDeb)) & lastRow).Address & "))/SUMIF(" & wsWork.Range(ColLetter(offType) & "2:" & ColLetter(offType) & lastRow).Address & ",\"CASH\"," & wsWork.Range(ColLetter(IIf(offAmt <> 0, offAmt, offCred)) & "2:" & ColLetter(IIf(offAmt <> 0, offAmt, offCred)) & lastRow).Address & ")"

    ' Recycling windows count
    wsPvt.Cells(nextRow + 3, 1).Value = "≤48h recycling windows (count)"
    wsPvt.Cells(nextRow + 3, 2).Formula = "=COUNTIF(Pvt_Velocity!" & wsPvt.PivotTables("Pvt_Velocity").DataBodyRange.Address & ",">=-2000")-COUNTIF(Pvt_Velocity!" & wsPvt.PivotTables("Pvt_Velocity").DataBodyRange.Address & ",">2000")"

    ' Branch dispersion (# Cost Centers)
    If ColOffset(wsWork, COL_BRANCH, True) <> 0 Then
        wsPvt.Cells(nextRow + 4, 1).Value = "Cost Centers with cash txns"
        wsPvt.Cells(nextRow + 4, 2).Formula = "=COUNTA(Pvt_CostCenter!" & wsPvt.PivotTables("Pvt_CostCenter").DataBodyRange.Columns(1).Address & ")"
    End If

End Sub

' ========= HELPER: create a PivotTable ==================================
Sub CreatePivot(wsSrc As Worksheet, wsDest As Worksheet, _
                rowField As String, rowColOff As Long, _
                valField As String, valColOff As Long, _
                pvtName As String, Optional sumSignAmt As Boolean = False, _
                Optional showBothVal As Boolean = False)
    Dim pc As PivotCache, pt As PivotTable, destRng As Range
    Set pc = ActiveWorkbook.PivotCaches.Create(xlDatabase, wsSrc.Range("A1").CurrentRegion)
    Set destRng = wsDest.Cells(wsDest.Rows.Count, 1).End(xlUp).Offset(2, 0)
    Set pt = pc.CreatePivotTable(TableDestination:=destRng, TableName:=pvtName)
    With pt
        .PivotFields(rowField).Orientation = xlRowField
        .PivotFields(rowField).Position = 1
        .AddDataField .PivotFields(valField), "Sum of " & valField, xlSum
        If showBothVal Then .AddDataField .PivotFields(valField), "Count of " & valField, xlCount
        .RowAxisLayout xlTabularRow
        .ColumnGrand = False: .RowGrand = False
    End With
End Sub

' ========= UTILITIES =====================================================
Function ColOffset(ws As Worksheet, hdr As String, Optional silent As Boolean = False) As Long
    Dim rng As Range
    Set rng = ws.Rows(1).Find(What:=hdr, LookIn:=xlValues, LookAt:=xlWhole, MatchCase:=False)
    If rng Is Nothing Then
        If Not silent Then MsgBox "Column '" & hdr & "' not found", vbExclamation
        ColOffset = 0
    Else
        ColOffset = rng.Column - ws.Range("A1").Column
    End If
End Function

Function ColLetter(colNum As Long) As String
    ColLetter = Split(Cells(1, colNum).Address(True, False), "$"…
