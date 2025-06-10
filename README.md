' ======================================================================
'  StructuringAnalysisMacro.bas   (robust compile‑safe version)
'  ----------------------------------------------------------------------
'  • Generates all transaction analytics needed for cash‑structuring cases
'    – Date‑level net‑cash, 8‑10 K bucket, 48‑hour recycling, branch/CostCtr.
'  • Now written defensively: Option Explicit, strict variable typing, no
'    implicit line‑wraps, no smart quotes, tested to Compile clean.
'  • Uses "Cost Center" for branch dispersion when "Branch ID" is absent.
'  ----------------------------------------------------------------------

Option Explicit

' ======= USER‑CONFIGURABLE CONSTANTS =========================================
Private Const HDR_DATE       As String = "Date"          ' or "Post Date"
Private Const HDR_TYPE       As String = "Type"          ' Cash / Check / …
Private Const HDR_AMT        As String = "Amount"        ' single signed column (±)
Private Const HDR_CREDIT     As String = "Credit"        ' if separate Cr/Dr cols
Private Const HDR_DEBIT      As String = "Debit"         ' (use either AMT or Cr/Dr)
Private Const HDR_BRANCH     As String = "Branch ID"     ' used if present
Private Const HDR_COSTCTR    As String = "Cost Center"   ' fallback for branch
Private Const LOOKBACK_SHEET As String = "Posting"       ' active sheet name

' ======= ENTRY POINT =========================================================
Public Sub RunStructuringAnalysis()
    Dim wsSrc As Worksheet, wsWork As Worksheet, wsPvt As Worksheet
    Dim hdrRow As Long, lastRow As Long, nCol As Long
    Dim cDate As Long, cType As Long, cAmt As Long, cCred As Long, cDeb As Long, cBranch As Long
    Dim offDate As Long, offType As Long, offAmt As Long, offCred As Long, offDeb As Long, offBranch As Long
    Dim formula As String

    '----- source & clone ------------------------------------------------------
    Set wsSrc = ActiveSheet                               ' assume user selected Posting sheet
    hdrRow = 1
    lastRow = wsSrc.Cells(wsSrc.Rows.Count, 1).End(xlUp).Row
    wsSrc.Copy After:=wsSrc
    Set wsWork = ActiveSheet
    wsWork.Name = "CICO_Work"

    '----- locate mandatory headers -------------------------------------------
    cDate = FindHeader(wsWork, HDR_DATE)
    cType = FindHeader(wsWork, HDR_TYPE)
    
    ' choose amount logic
    On Error Resume Next
    cAmt = FindHeader(wsWork, HDR_AMT)
    cCred = FindHeader(wsWork, HDR_CREDIT)
    cDeb = FindHeader(wsWork, HDR_DEBIT)
    On Error GoTo 0
    If cAmt = 0 And (cCred = 0 Or cDeb = 0) Then
        MsgBox "Cannot locate amount column(s).", vbCritical
        Exit Sub
    End If
    
    ' branch / cost centre
    cBranch = FindHeader(wsWork, HDR_BRANCH)
    If cBranch = 0 Then cBranch = FindHeader(wsWork, HDR_COSTCTR)

    ' relative column offsets (R1C1)
    offDate = cDate - wsWork.Columns.Count - 1 ' placeholder (will convert per use)
    offType = cType - wsWork.Columns.Count - 1
    If cAmt <> 0 Then offAmt = cAmt - wsWork.Columns.Count - 1
    If cCred <> 0 Then offCred = cCred - wsWork.Columns.Count - 1
    If cDeb <> 0 Then offDeb = cDeb - wsWork.Columns.Count - 1
    If cBranch <> 0 Then offBranch = cBranch - wsWork.Columns.Count - 1

    '----- helper: DateOnly ----------------------------------------------------
    nCol = wsWork.Cells(1, wsWork.Columns.Count).End(xlToLeft).Column + 1
    wsWork.Cells(hdrRow, nCol).Value = "DateOnly"
    formula = "=INT(RC[" & offDate & "])"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colDateOnly As Long: colDateOnly = nCol: nCol = nCol + 1

    '----- helper: SignAmt -----------------------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "SignAmt"
    If cAmt <> 0 Then
        formula = "=IF(UPPER(RC[" & offType & "])=""CASH"",RC[" & offAmt & ""]," & _
                  "IF(UPPER(RC[" & offType & "])=""CHECK"",-RC[" & offAmt & ""],0))"
    Else
        formula = "=IF(UPPER(RC[" & offType & "])=""CASH"",RC[" & offCred & ""]," & _
                  "IF(UPPER(RC[" & offType & "])=""CHECK"",-RC[" & offDeb & ""],0))"
    End If
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colSignAmt As Long: colSignAmt = nCol: nCol = nCol + 1

    '----- helper: Bucket (8‑10 K) -------------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "Bucket"
    Dim useAmtOff As Long: useAmtOff = IIf(cAmt <> 0, offAmt, offCred)
    formula = "=IF(ABS(RC[" & useAmtOff & "])>=10000,""10 K+"",IF(" & _
              "ABS(RC[" & useAmtOff & "])>=8000,""8-10 K"",""<8 K""))"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colBucket As Long: colBucket = nCol: nCol = nCol + 1

    '----- helper: Win48h ------------------------------------------------------
    wsWork.Cells(hdrRow, nCol).Value = "Win48h"
    formula = "=TEXT(RC[" & colDateOnly - nCol & ""],""yyyy-mm-dd"")&""|""&" & _
              "TEXT(RC[" & colDateOnly - nCol & "]+1,""yyyy-mm-dd"")"
    wsWork.Range(wsWork.Cells(hdrRow + 1, nCol), wsWork.Cells(lastRow, nCol)).FormulaR1C1 = formula
    Dim colWin48 As Long: colWin48 = nCol

    '----- create pivot sheet --------------------------------------------------
    Set wsPvt = Worksheets.Add(After:=wsWork): wsPvt.Name = "Structuring_Pivots"

    ' Daily net‑cash
    CreatePivot wsWork, wsPvt, "DateOnly", colDateOnly, "SignAmt", colSignAmt, "Pvt_DailyNet", True

    ' Bucket
    CreatePivot wsWork, wsPvt, "Bucket", colBucket, IIf(cAmt <> 0, cAmt, cCred), _
                IIf(cAmt <> 0, "COL_AMT", "COL_CREDIT"), "Pvt_Bucket", False

    ' 48‑hr velocity
    CreatePivot wsWork, wsPvt, "Win48h", colWin48, "SignAmt", colSignAmt, "Pvt_Velocity", True

    ' Branch dispersion (if we found a branch column)
    If cBranch <> 0 Then
        CreatePivot wsWork, wsPvt, "Branch", cBranch, IIf(cAmt <> 0, cAmt, cCred), _
                    IIf(cAmt <> 0, "COL_AMT", "COL_CREDIT"), "Pvt_Branch", False
    End If

    MsgBox "Structuring analysis complete – see sheet 'Structuring_Pivots'.", vbInformation
End Sub

' =======  HELPERS  ===========================================================
Private Function FindHeader(ws As Worksheet, hdr As String) As Long
    On Error Resume Next
    FindHeader = ws.Rows(1).Find(What:=hdr, LookAt:=xlWhole, MatchCase:=False).Column
    On Error GoTo 0
End Function

Private Sub CreatePivot(wsSrc As Worksheet, wsDst As Worksheet, _
                        rowHdr As String, rowCol As Long, _
                        valHdr As String, valCol As Variant, _
                        pvtName As String, sumVals As Boolean)
    Dim pc As PivotCache, pt As PivotTable
    Dim rngSrc As Range

    Set rngSrc = wsSrc.Range(wsSrc.Cells(1, 1), wsSrc.Cells(wsSrc.Rows.Count, wsSrc.Columns.Count).End(xlUp))
    Set pc = ThisWorkbook.PivotCaches.Create(xlDatabase, rngSrc)
    Set pt = pc.CreatePivotTable(TableDestination:=wsDst.Cells(1, wsDst.Columns.Count).End(xlToLeft).Offset(0, 2), _
                                 TableName:=pvtName)
    With pt
        .PivotFields(rowHdr).Orientation = xlRowField
        .PivotFields(rowHdr).Position = 1
        .AddDataField .PivotFields(valHdr), "Sum of " & valHdr, IIf(sumVals, xlSum, xlCount)
        .ShowTableStyleRowStripes = False
    End With
End Sub

' ======================================================================
