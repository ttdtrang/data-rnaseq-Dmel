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

The package includes 2 data sets resulted from alignment to 2 different versions of _D. melanogaster_ genome, version 5.57 and 6.01.

For the version 6.01

```R
data(dmel.rnaseq)
```

For the version 5.57

```R
data(dmel.rnaseq.5.57)
```

All data sets

```
|-- v 5.57
  |-- dmel.rnaseq.full.5.57 (17238 genes x 851 samples)
  |-- dmel.rnaseq.78A.5.57 (ERCC pool 78A: 356 samples)
  |-- dmel.rnaseq.78B.5.57 (ERCC pool 78B: 247 samples)
|-- v 6.01
  |-- dmel.rnaseq.full (17119 genes x 851 samples)
  |-- dmel.rnaseq.78A (ERCC pool 78A)
  |-- dmel.rnaseq.78A (ERCC pool 78B)
```
## Steps to re-produce data curation

1. `cd data-raw`
2. Download the [metadata in SOFT format](ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE60nnn/GSE60314/soft/GSE60314_family.soft.gz) from GEO entry GSE60317
3. Set the environment variable `DBDIR` to point to the path containing said file
4. Run the R notebook `parse_metadata.Rmd` to generate `samples_metadata.RDS`.
5. Run the R notebook `make-data-package.Rmd` to assemble parts into `ExpressionSet` objects.

 You may need to change some code chunk setting from `eval=FALSE` to `eval=TRUE` to make sure all chunks would be run. These chunks are disabled to avoid overwriting existing data files in the folder.
