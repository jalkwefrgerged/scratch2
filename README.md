Q: Did you do any independent model output replication in addition to the code review? It wasn’t obvious in the Validation Report.
A: No full independent re-implementation for the VN integrator in this release. Changes were minor; fully replicating VN would be a huge effort, so the team reviewed code and developer reconciliation tests instead. They intentionally focused implementation testing on what changed in 27.3. Under strict MMLC this wouldn’t be “full scope”; the VP approved the limited scope.

Q: Could your data checks (e.g., feeding bad inputs to see “computer says no”) count as a form of independent output replication, or do you need to replicate the whole code?
A: It’s a limited form of output testing (not full replication). For the money-market yield change, the calc is simple/transparent and was shown in spreadsheets; writing separate code would add little value.

Q: For unchanged components, can you rely on past output-replication work and state it remains valid?
A: Partly. There is some prior replication (e.g., a spreadsheet calc in Section 6.1 around spreads over the base curve). Not everything is replicated; full re-implementation is impractical, so they limit to what’s feasible and what changed—per the stated scope.


Q: What’s your plan to onboard all VN-4345 component models to the new standards?
A: Yes—there’s a plan. Onboarding spans Stages 1–5 and will occur at each model’s scheduled revalidation. For each model, the owner will prepare an MDD and NPM plan aligned to the new standards, and validation will be performed under those standards. This is a multi-year effort following the existing revalidation calendar, with higher-risk models naturally prioritized because they are revalidated more frequently.

Q: Appendix C lists independent testing requirements by risk tier. How do you decide which independent tests (e.g., backtesting, sensitivity, independent benchmark) you’ll actually do?
A: Feasibility drives the choice. Independent benchmark: generally not feasible—would require a full alternative stack (term structure → prepayment). Since first line already benchmarks (e.g., YourBook), adding a second benchmark is heavy overhead. Backtesting & sensitivity: Yes, where feasible using available VN functionality.
