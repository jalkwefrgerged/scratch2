Requirement: Scope must be commensurate with risk tier; MRM verifies tier during planning

MVR summary (paraphrased).
For ValuationNet v2.7.3.0, MRM began planning with the model classified as High per the Risk Tiering Template and, after completing the review, affirmed that High remains appropriate. The report attributes this chiefly to materiality—VN generates valuation and market-risk metrics used across the retained portfolio and enterprise processes, with portfolio duration subject to management/Board limits and monitored by FHFA—and to complexity, given VN’s role as an integrator of term-structure, mortgage-rate, and prepayment components using Monte Carlo/lattice methods with broad upstream/downstream interconnectivity. Residual model risk remains High. Consistent with that tier, MRM executed a full-scope validation of the integrator model and limited implementation testing to elements changed in this release, and it notes the tier will be revisited if model usages change.

Rationale — Meets Expectations.
The standard requires MRM to verify tier appropriateness during planning and to set scope/rigor that match that tier. The MVR does both: it explicitly reconfirms High and ties that rating to clear drivers of materiality and complexity, then applies a High-tier scope (broad domain coverage with targeted implementation testing for deltas). Keeping residual risk at High further substantiates the choice. One enhancement for future cycles would be to capture a brief “planning challenge” note that spells out what evidence could change the tier, but the requirement as written is satisfied.


Requirement: The scope of Full-Scope Initial Validation/Revalidation must cover Section 5.4 areas; for Targeted-Scope, the Lead Validator must determine and document the scope

MVR summary (paraphrased).
For ValuationNet v2.7.3.0, the Lead Validator set and documented a High-tier full-scope validation of the integrator model, covering the Section 5.4 domains: model data, conceptual soundness, code review, model development evidence, model limitations and compensating controls, model implementation, model performance monitoring, model interconnectivity, model risk tier and residual risk, and model governance. Within that framework, the model implementation review was targeted to changes introduced in v2.7.3.0, with implementation requirements, solutions, acceptance criteria, and testing results recorded in Jira.

Rationale — Meets Expectations.
The standard requires Section 5.4 coverage for full-scope work and explicit scoping by the Lead Validator when targeting; the MVR does both. It documents a full-scope assessment across the prescribed areas and clearly limits the implementation testing to the release deltas, with supporting evidence traceable in Jira—demonstrating the LV determined and recorded scope boundaries during planning. Given the model’s High tier, a full-scope review of the integrator plus a targeted implementation slice is appropriate and consistent with the Standard. A minor enhancement for clarity would be a brief “Section 5.4 crosswalk” in the scope paragraph, but the requirement as written is satisfied.



Requirement: The MDD must let unfamiliar parties understand the model (operation, limitations, assumptions) and also mitigate key-person risk, enable proper operation, facilitate independent review with minimal assistance, and reduce change-implementation risk

MVR summary (paraphrased).
MRM reviewed ValuationNet’s documentation and confirmed the MDD meets the Model Development Standard, with all required approvals in place. The package—MDD, operations/runbook, architecture and data-flow overviews, stated assumptions and limitations, input/output specifications, descriptions of controls/quality checks, release/testing evidence, and a dated revision history current through April 30, 2025—provides sufficient detail for a knowledgeable reader to understand how the model operates and where its boundaries are.

Rationale — Meets Expectations.
The validation did what the Standard requires: MRM assessed the MDD against the Development Standard and explicitly attested it meets the content and sufficiency criteria, with current, approved documentation that enables understanding, independent review with minimal assistance, and proper operation. While the MVR separately notes a few enhancements elsewhere in the report, those do not alter the conclusion that the MDD, as validated, complies with the Standard.




Requirement: Validator confirms the MDD uses the standard template, is properly populated/approved; performs a deeper validation-phase assessment for comprehensiveness/clarity; and evaluates model-inventory completeness/accuracy and consistency with the MDD

MVR summary (paraphrased).
MRM reviewed ValuationNet’s MDD for VN v2.7.3.0 and confirmed it meets the Model Development Standard with all required 1LoD approvals. The Lead Validator used the model documentation assessment template and the validation challenge log to drive a deeper validation-phase review and updates to the MDD for comprehensiveness and clarity. MRM also evaluated the model inventory against the MDD and found it largely consistent, while documenting specific mismatches (e.g., MU01473 inactive in MUSE but listed in the MDD; MU01429 mapped to PRIMA in the MDD vs HAO in MUSE; usage-owner name mismatch) and recommending a monthly MDD↔inventory sync (and at least prior to each annual review/revalidation). The documentation set includes a dated revision history through April 30, 2025, evidencing currency/version control.

Rationale — Meets Expectations.
The validator confirmed template/approval compliance, conducted a deeper validation-phase assessment using the assessment template and challenge process, and checked inventory completeness/accuracy against the MDD, recording concrete exceptions and the housekeeping action. This matches the Standard’s procedural requirements; the noted discrepancies are captured as part of the consistency check and do not detract from validation conformity.


