* Designed and maintained end-to-end data pipelines for applied economics research, with a focus on taking unstructured, real-world documents (scans, legal text, long filings) and turning them into reliable, analysis-ready datasets. Used LLM-based extraction where it added leverage, and built the surrounding infrastructure (data collection, cleaning, validation, and structured outputs) so results were reproducible and easy for researchers to use.

  * **AI + Zoning:** Uncovered housing supply constraints by processing zoning codes at scale.

    * Built a full workflow to discover historical zoning ordinances buried in newspaper archives, pull the relevant documents, and convert low-quality scans into usable text.
    * Implemented the scraping, parsing, and downstream analysis components, and ran the pipeline on HPC infrastructure to handle large volumes efficiently.

  * **Corporate Agreements:** Extracted pricing terms and covenants from SEC EDGAR filings to enable systematic analysis of credit contracts.

    * Built an automated extraction pipeline that locates and anchors the correct exhibits, identifies and classifies key agreement sections, and converts the relevant content into structured JSON suitable for downstream analytics and modeling.

* Supported multiple applied economics research papers as a statistical programmer, owning key parts of both the econometrics and the data engineering needed to make results credible.

  * Estimated the causal effect of remote-work adoption using difference-in-differences / triple-differences and event-study designs, and extended the analysis with instrumental variables, heterogeneity splits, and robustness checks.
  * Built a large-scale PySpark pipeline on HPC to compute demographic move rates from Infutor household data, reducing ~1.5B raw rows into clean, documented tables that could be used directly in analysis and replication.

* Created an internal “coding agent” workflow to automate common research assistant tasks on top of the Codex SDK, with an emphasis on speeding up iteration cycles.

  * Enabled routine data wrangling, exploratory analysis, and repetitive coding tasks to run unattended (often overnight), freeing up researcher time and making it easier to test ideas quickly without sacrificing structure or reproducibility.
