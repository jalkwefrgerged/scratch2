INVESTIGATION OUTCOME  
The case auto-promoted from three system alerts:  
• CSH-ATMLGDEPPV03 – ATM Large Cash Deposits  
• CSH-LRGCSHPERV04 – Large Cash Deposits (Personal)  
• CSH-CSHSTRDPPV01 – Structured Cash Deposits (Personal Parties)  

Manual review uncovered two additional red-flag patterns:  
(i) self-funding Zelle credits from an external account in the customer’s own name, and  
(ii) high-value transfers to related BofA consumer accounts.  

Bank of America, N.A. (“BANA”) therefore files this SAR on **BAOLIANG SHANG** (Party ID 15011736604, primary DDA [LAST-4]) for:  

• Structuring – cash deposits deliberately kept below the USD 10 000 CTR threshold  
• Money-laundering / Unusual P2P credits with an unknown source of funds  

------------------------------------------------------------
1) CASH DEPOSITS  
Structuring cluster (17–19 Mar 2025) — two sub-USD 10 000 deposits aggregate to USD 11 100 within 48 hours  
• 17 Mar 2025 [HH:MM] – USD 8 400 – [ATM_OR_FC#1]/[ZIP1] – TXN [TXN_ID_1]  
• 19 Mar 2025 [HH:MM] – USD 2 700 – [ATM_OR_FC#2]/[ZIP2] – TXN [TXN_ID_2]  

Other large-cash deposits (alert CSH-LRGCSHPERV04)  
• 03 Mar 2025 [HH:MM] – USD 3 400 – [ATM_OR_FC#1]/[ZIP1] – TXN [TXN_ID_3]  
  — Exceeds BANA’s USD 3 000 high-cash trigger; no payroll or legitimate source, therefore included as suspicious.  
• 05 Feb 2025 [HH:MM] – USD 9 200 – [ATM_OR_FC#3]/[ZIP3] – TXN [TXN_ID_4] (context only)

------------------------------------------------------------
2) P2P CREDITS (SUSPICIOUS INFLOWS)

Self-funding Zelle credits (external account titled to customer)  
• 04 Mar 2025 CR USD 1 200 – “Baoliang Shang” – [OTHER_BANK] – TXN [TXN_ID_5]  
• 18 Mar 2025 CR USD 2 500 – “Baoliang Shang” – [OTHER_BANK] – TXN [TXN_ID_6]  
• 21 Mar 2025 CR USD 2 800 – “Baoliang Shang” – [OTHER_BANK] – TXN [TXN_ID_7]  
**Subtotal self-funding:** [SELF_P2P_COUNT] credits / USD [SELF_P2P_TOTAL]  

*Why suspicious:* Funds originate from an external account bearing the customer’s own name; combined with unemployed status this indicates circular self-funding and layering of structured cash.

Unrelated P2P credits (no verifiable connection)  
• 09 Mar 2025 CR USD [AMT_EX_1] – “[OTHER_NAME]” – [SENDER_BANK] – TXN [TXN_ID_8]  
• 16 Mar 2025 CR USD [AMT_EX_2] – “[OTHER_NAME]” – [SENDER_BANK] – TXN [TXN_ID_9]  
**Subtotal unrelated:** [UNREL_P2P_COUNT] credits / USD [UNREL_P2P_TOTAL]  

*Why suspicious:* Sender is neither a documented relative nor business counter-party; no supporting memo or KYC rationale. Volume (≈ USD [UNREL_P2P_TOTAL]) exceeds 10 % of total inflows and lacks any lawful purpose.

------------------------------------------------------------
3) INTERNAL TRANSFERS TO RELATED BofA ACCOUNTS  
• 14 Mar 2025 DR USD 4 200 “Transfer to [RELATED_NAME] x-[LAST4]” – TXN [TXN_ID_A]  
• 19 Mar 2025 DR USD 3 750 “Transfer to [RELATED_NAME] x-[LAST4]” – TXN [TXN_ID_B]  
• 25 Mar 2025 DR USD 2 980 “Transfer to [RELATED_NAME] x-[LAST4]” – TXN [TXN_ID_C]  

Subtotal (Party ID [RELATED_ID]): [INT_TRF_COUNT] debits / USD 75 472  
Additional transfers under review involve Party ID [RELATED2_ID] (account x-[LAST4_2]); sampling pending.  

*Why suspicious:* Largest outflow category; funds move rapidly to related accounts, further obscuring the origin of structured cash and self-funding P2P inflows.

------------------------------------------------------------
4) KYC & SOURCE-OF-FUNDS ANALYSIS  
• Unemployed; address Gaorong Xiaoqu 3-2307 Lane 661 Wanhangdu Rd, Shanghai; WA phone +1-425-615-5397  
• No sanctions/adverse media; [N_DISSOLVED_SHOPS] dissolved e-commerce shops in Haikou.  
• Income check (120-day look-back) – cash credits USD [CASH_TOTAL] + Zelle credits USD [SELF_P2P_TOTAL + UNREL_P2P_TOTAL] vs ACH income USD [ACH_TOTAL] (negligible).  
• Cash withdrawals USD [CASH_WD_TOTAL] (e.g., USD [WD_EX1] on [WD_DATE1]).  
➜ Inflows far exceed legitimate income; dissolved entities suggest shell use.

------------------------------------------------------------
5) INFLOWS VS OUTFLOWS (OVERVIEW)  
• Inflows dominated by self-funding Zelle credits and March structured cash deposits.  
• Outflows dominated by internal transfers to related BofA accounts (USD 75 472 YTD); ACH bill-pays and card spend are minor.  
➜ Rapid pass-through behaviour with related parties reinforces Structuring, Unusual P2P, and Unknown Source typologies.

------------------------------------------------------------
SUMMARY OF SUSPICIOUS ACTIVITY  
1. Structuring – two cash deposits within 48 hours aggregate > USD 10 000  
2. Large-cash deposits – single deposits ≥ USD 3 000 (8 400, 3 400, 9 200)  
3. Self-funding Zelle credits – inbound from same-owner external account  
4. Unrelated P2P credits – no documented relationship or lawful purpose  
5. Internal transfers – USD 75 472 sent to related BofA accounts ([RELATED_ID], [RELATED2_ID])  
6. Unknown source – unemployed, no payroll/business income

------------------------------------------------------------
AGGREGATE SUSPICIOUS AMOUNT  
  Structured cash-deposit credits:            USD 14 500  
  Large-cash deposit (03 Mar 25):             USD 3 400  
  Additional large-cash (05 Feb 25):          USD 9 200  
  Self-funding Zelle credits:                 USD [SELF_P2P_TOTAL]  
  Unrelated P2P credits:                      USD [UNREL_P2P_TOTAL]  
  Internal transfers to related parties:      USD 75 472  
  ------------------------------------------------------  
  **Total suspicious amount:**                USD [SAR_AMOUNT]  

Only transactions identified as suspicious (03 Mar 2025 – 22 Mar 2025) are included; routine ACH, retail-card payments, and outbound Zelle debits were excluded.

------------------------------------------------------------
SAR BOX-TICK GUIDE  
• Structuring → “Transactions below CTR threshold”  
• Money-Laundering → “Unusual P2P activity” and “Unknown Source of Funds”  
• Other → “Suspicious use of multiple accounts (related by owner)”  
• Product Type → DDA – Consumer Checking (plus any linked savings)  
• Date range → 03 Mar 2025 – 22 Mar 2025  
• Suspicious amount → USD [SAR_AMOUNT]

------------------------------------------------------------
EVIDENCE ATTACHMENTS  
• ISS export (cash, Zelle credits, internal transfers)  
• Teller image for USD 8 400 deposit, 17 Mar 2025  
• Screenshot/PDF of Weixin advert linking phone number to “cross-state cash top-ups”  
• PDF of KYC research worksheet  

Prepared 11 Jun 2025 — replace bracketed placeholders with final ledger data and IDs before submission.
