# Data package for _Drosophila melanogaster_ RNA-seq

## Sources

* Original data source: [GSE60314](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE60314)
* Original citation:
  * Lin Y, Golovnina K, Chen ZX, Lee HN et al. Comparison of normalization and differential expression analyses using RNA-Seq data from 726 individual Drosophila melanogaster. _BMC Genomics_ 2016 Jan 5;17:28. PMID: [26732976](https://www.ncbi.nlm.nih.gov/pubmed/26732976)
  
## Usage

Install the package, import the library and load the data set

```R
devtools::install_github('ttdtrang/data-rnaseq-Dmel')
library(data.rnaseq.Dmel)
data(dmel.rnaseq)
dim(dmel.rnaseq@assayData$exprs)
```
