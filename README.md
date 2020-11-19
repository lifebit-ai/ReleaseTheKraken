# ReleaseTheKraken
 Nextflow workflow for taxonomic classification of shotgun metagenomic data with Kraken 2.

 ## Rationale
This workflow performs taxonomic profiling through lowest common ancestor (LCA) positioning approach using [Kraken2](https://github.com/DerrickWood/kraken2). In this approach the pre-aligned sequences are hierarchically classified on a taxonomy tree using a placement algorithm. It requires database for comparison with the appropriate taxonomical information so this workflow comes packaged together with the [MiniKraken Database](ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/).

## Implementation
This workflow is implemented in 3 data processing steps: QC, Taxonomic Profiling and Visualization.
For each step the following tools are used:
- QC: [fastp](https://github.com/OpenGene/fastp)
- Taxonomic profiling: [Kraken 2](https://github.com/DerrickWood/kraken2) with [Minikraken_8GB_202003 database](ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/minikraken_8GB_202003.tgz)
- Visualization: [Krona](https://github.com/marbl/Krona/wiki)

## Usage:
Release the Kraken workflow expects a single sample file (FASTQ), passed with the `--fastq` parameter, and generates an HTML Krona plot with the taxonomic information. The Kraken report is stored under `results/kraken`. 

### Basic run command example
```nextflow main.nf --fastq="test_data/SRR8886136_{1,2}*"```





