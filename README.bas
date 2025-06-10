' ======================================================================
'  StructuringAnalysisMacro.bas   (self‑contained, compile‑ready)
'  ----------------------------------------------------------------------
'  Generates all quantitative analytics for cash‑structuring AML cases.
'  ‑ Daily net‑cash pivot
'  ‑ 8‑10 K bucket pivot
'  ‑ 48‑hour cash‑in / cash‑out velocity pivot
'  ‑ Branch / Cost‑Center dispersion
'  Outputs a tidy “Summary Metrics” block under the pivots.
'  ----------------------------------------------------------------------
'  HOW TO USE
'    1. Open Posting extract ► Alt+F11 ► Insert ► Module ► paste this file.
'    2. Save workbook as .xlsm ► Alt+F8 ► RunStructuringAnalysis.
' ======================================================================

Option Explicit

' ===== USER‑CONFIGURABLE CONSTANTS ======================================
Private Const HDR_DATE           As String = "Date"          ' or "Post Date"
Private Const HDR_TYPE           As String = "Type"          ' Cash / Check / …
Private Const HDR_AMT            As String = "Amount"        ' single signed column (+ / –)
Private Const HDR_CREDIT         As String = "Credit"        ' if separate Cr/Dr cols
Private Const HDR_DEBIT          As String = "Debit"
Private Const HDR_BRANCH         As String = "Branch ID"     ' used if present
Private Const HDR_COSTCTR        As String = "Cost Center"   ' fall‑back for branch
Private Const LOOKBACK_SHEETNAME As String = "Posting"       ' active sheet name
' =======================================================================

' === ENTRY POINT ========================================================
Public Sub RunStructuringAnalysis()
    Dim wsSrc As Worksheet, wsWork As Worksheet, wsPvt As Worksheet
    Dim hdrRow As Long, lastRow As Long, nCol As Long
    Dim cDate As Long, cType As Long, offAmt As Long, offCred As Long, _
        offDeb As Long, offBranch As Long
    Dim formula As String

    '‑‑ source & clone ---------------------------------------------------
    Set wsSrc = ActiveSheet                     ' assume user selected Posting sheet
    hdrRow = 1
    lastRow = wsSrc.Cells(wsSrc.Rows.Count, 1).End(xlUp).Row
    wsSrc.Copy After:=wsSrc
    Set wsWork = ActiveSheet
    wsWork.Name = "CICO_Work"

    '‑‑ locate mandatory headers ----------------------------------------
    cDate = FindHeader(wsWork, HDR_DATE)
    cType = FindHeader(wsWork, HDR_TYPE)
    offAmt = ColOffset(wsWork, HDR_AMT, True)      ' may return 0 if not found
    offCred = ColOffset(wsWork, HDR_CREDIT, True)
    offDeb = ColOffset(wsWork, HDR_DEBIT, True)
    If offAmt = 0 And (offCred = 0 Or offDeb = 0) Then
        MsgBox "Could not locate Amount or Credit/Debit columns", vbCritical
        Exit Sub
    End If
    offBranch = ColOffset(wsWork, HDR_BRANCH, True)
    If offBranch = 0 Then offBranch = ColOffset(wsWork, HDR_COSTCTR, True)

    nCol = wsWork.Cells(1, wsWork.Columns.Count).End(xlToLeft).Column + 1

    '‑‑ DateOnly helper ---------------------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "DateOnly"
    formula = "=INT(RC[" & ColOffset(wsWork, HDR_DATE) & "])"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colDateOnly As Long: colDateOnly = nCol
    nCol = nCol + 1

    '‑‑ SignAmt helper (+ cash, – checks) ---------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "SignAmt"
    If offAmt <> 0 Then
        formula = "=IF(UPPER(RC[" & ColOffset(wsWork, HDR_TYPE) & "])=""CASH"",RC[" & offAmt & " ],IF(UPPER(RC[" & ColOffset(wsWork, HDR_TYPE) & "])=""CHECK"",-RC[" & offAmt & " ],0))"
    Else
        formula = "=IF(UPPER(RC[" & ColOffset(wsWork, HDR_TYPE) & "])=""CASH"",RC[" & offCred & " ],IF(UPPER(RC[" & ColOffset(wsWork, HDR_TYPE) & "])=""CHECK"",-RC[" & offDeb & " ],0))"
    End If
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colSignAmt As Long: colSignAmt = nCol
    nCol = nCol + 1

    '‑‑ Bucket helper (8‑10 K etc.) --------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "Bucket"
    Dim amtColOff As Long: amtColOff = IIf(offAmt <> 0, offAmt, offCred)
    formula = "=IF(ABS(RC[" & amtColOff & "])>=10000,""10 K+"",IF(AND(ABS(RC[" & amtColOff & "])>=8000,ABS(RC[" & amtColOff & "])<10000),""8‑10 K"",""<8 K""))"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colBucket As Long: colBucket = nCol
    nCol = nCol + 1

    '‑‑ 48‑hour Window helper --------------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "Win48h"
    formula = "=TEXT(RC[" & colDateOnly & " ],""yyyy‑mm‑dd"")&""|""&TEXT(RC[" & colDateOnly & " ]+1,""yyyy‑mm‑dd"")"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colWin48 As Long: colWin48 = nCol

    '‑‑ create pivot sheet ----------------------------------------------
    Set wsPvt = Worksheets.Add(After:=wsWork): wsPvt.Name = "Structuring_Pivots"

    ' Daily net‑cash pivot
    CreatePivot wsWork, wsPvt, "DateOnly", colDateOnly, "SignAmt", colSignAmt, "Pvt_DailyNet", True

    ' Bucket pivot
    CreatePivot wsWork, wsPvt, "Bucket", colBucket, IIf(offAmt <> 0, HDR_AMT, HDR_CREDIT), IIf(offAmt <> 0, offAmt, offCred), "Pvt_Bucket", False

    ' 48‑hr velocity pivot
    CreatePivot wsWork, wsPvt, "Win48h", colWin48, "SignAmt", colSignAmt, "Pvt_Velocity", True

    ' Branch dispersion pivot (if available)
    If offBranch <> 0 Then CreatePivot wsWork, wsPvt, "Branch", offBranch, "SignAmt", colSignAmt, "Pvt_Branch", False

    '‑‑ summary metrics block -------------------------------------------
    Call WriteSummary(wsPvt, wsWork, colBucket, offAmt, offCred, offDeb, colSignAmt, colWin48, offBranch)
    MsgBox "Structuring analysis complete – see sheet ‘Structuring_Pivots’.", vbInformation
End Sub

' === SUPPORT FUNCTIONS ==================================================
Private Function FindHeader(ws As Worksheet, hdrName As String) As Long
    Dim c As Range
    Set c = ws.Rows(1).Find(What:=hdrName, LookAt:=xlWhole, MatchCase:=False)
    If c Is Nothing Then
        MsgBox "Header ‘" & hdrName & "’ not found", vbCritical
        End
    Else
        FindHeader = c.Column
    End If
End Function

Private Function ColOffset(ws As Worksheet, hdrName As String, Optional AllowMissing As Boolean = False) As Long
    Dim c As Range
    Set c = ws.Rows(1).Find(What:=hdrName, LookAt:=xlWhole, MatchCase:=False)
    If c Is Nothing Then
        If AllowMissing Then
            ColOffset = 0
        Else
            MsgBox "Header ‘" & hdrName & "’ not found", vbCritical
            End
        End If
    Else
        ColOffset = c.Column
    End If
End Function

Private Sub CreatePivot(wsSrc As Worksheet, wsDest As Worksheet, _
                        RowName As String, RowCol As Long, _
                        DataName As String, DataCol As Long, _
                        pvtName As String, Optional ShowSum As Boolean = True)
    Dim pc As PivotCache, pvt As PivotTable, rng As Range
    Dim lastRow As Long: lastRow = wsSrc.Cells(wsSrc.Rows.Count, 1).End(xlUp).Row
    Set rng = wsSrc.Range(wsSrc.Cells(1, 1), wsSrc.Cells(lastRow, DataCol))
    Set pc = ThisWorkbook.PivotCaches.Create(xlDatabase, rng)
    Set pvt = pc.CreatePivotTable(TableDestination:=wsDest.Cells(1, wsDest.Columns.Count).End(xlToLeft).Offset(0, 2), _
                                  TableName:=pvtName)
    With pvt
        .PivotFields(RowName).Orientation = xlRowField
        .PivotFields(RowName).Position = 1
        .AddDataField .PivotFields(DataName), "Sum " & DataName, xlSum
        If Not ShowSum Then .PivotFields("Sum " & DataName).Caption = "Count"
    End With
End Sub

Private Sub WriteSummary(wsPvt As Worksheet, wsWork As Worksheet, _
                          colBucket As Long, offAmt As Long, offCred As Long, offDeb As Long, _
                          colSign As Long, colWin48 As Long, offBranch As Long)
    Dim lastRow As Long, cashIn As Double, cashOut As Double, rng As Range
    lastRow
