Requirement: Scope must be commensurate with risk tier; MRM verifies tier during planning

MVR summary (paraphrased).
In planning for ValuationNet v2.7.3.0, MRM verified via the Risk Tiering Template that the model is High tier and, after completing the validation, confirmed the tier remains appropriate; residual model risk also remains High. The basis for the High tier is made explicit: on materiality, VN produces enterprise-level valuation and market-risk metrics for the retained portfolio, with duration subject to management/Board limits and FHFA oversight; on complexity, VN operates as a multi-model integrator (term structure, mortgage-rate, prepayment) using Monte Carlo/lattice methods with broad upstream/downstream interconnectivity. Consistent with that rating, the validator executed a full-scope review of the integrator model and limited implementation testing to items changed in this release, and noted the tier will be revisited if model usages change.

Rationale — Meets Expectations.
This complies with the Standard: the validator re-verified the risk tier during planning and set/documented scope and rigor commensurate with that tier, linking the High rating to clear drivers of materiality and complexity and applying a matching High-tier scope (broad domain coverage with targeted implementation testing for release deltas). Requirement satisfied. As a non-rating observation, the report does not include a formal “effective challenge” memo of the tiering rationale; adding a brief planning note on evidence considered and triggers for re-tiering would improve traceability without affecting conformance.





Requirement: The scope of Full-Scope Initial Validation/Revalidation must cover Section 5.4 areas; for Targeted-Scope, the Lead Validator must determine and document the scope

MVR summary:
For ValuationNet v2.7.3.0, the Lead Validator set and documented a High-tier full-scope validation of the integrator model (not the entire application) across all Section 5.4 domains—model data, conceptual soundness, code review, model development evidence, model limitations and compensating controls, model implementation, model performance monitoring, model interconnectivity, model risk tier and residual risk, and model governance. Implementation testing was intentionally limited to items changed in v2.7.3.0, consistent with the risk-based approach; the MVR’s Model Implementation section lists the specific deltas and test evidence and records exclusions for components/calculations unchanged by the release, with requirements, acceptance criteria, and test results maintained in Jira. Implementation testing was targeted to v2.7.3.0 code changes, while all other Section 5.4 areas for the integrator model were reviewed on a full-scope basis.

Rationale — Meets Expectations.
This complies with the Standard: the validator covered the Section 5.4 areas for the full-scope portion and determined and documented a targeted implementation slice limited to the release deltas, with explicit exclusions and a traceable evidence trail in Jira. The targeting is risk-based and anchored to the independently re-verified High tier, which is how the Standard expects scope and rigor to be set. The report also includes current documentation with revision history (through April 30, 2025), reinforcing that the scoping decision and supporting evidence were procedurally sound and up-to-date.






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


