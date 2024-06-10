# Power BI Semantic Model Partitions Extractor
This repository contains scripts useful to export M code behind Power BI semantic models leveraging Tabular Editor 2 and its Command Line interface.
Read the full story at https://medium.com/riccardo-perico/bulk-extract-m-code-from-power-bi-semantic-models-600e934bd087.

# Prerequisites
- Power BI Desktop
- Tabular Editor 2
- Power BI tenant
- SPN created and setup in AAD
- Enabled APIs use at Power BI tenant level for SPN

# extract_partitions.cs
Script executed by TE2 command line to extract M code from a local model.

# extractor_spn_auth.ps1
Script executed by TE2 commnad line to extract M code from a published semantic model leveraging SPN login.

