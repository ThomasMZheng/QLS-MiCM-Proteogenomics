#Written by Thomas Zheng
#For QLS-MiCM Proteogenomics- the creation of the toy genetic dataset

install.packages("genio")
library(genio)

# (here we create a small example with random data)

#We have 163 individuals, and I want 10,000 SNPs per individual

n_ind <- 163
n_snps <- 10000

# Create random genotype matrix (MAFs vary)
X <- matrix(
  c(
    rbinom(n_ind * n_snps, 2, runif(n_snps, 0.05, 0.5))
  ),
  nrow = n_snps, ncol = n_ind, byrow = TRUE
)

dim(X)


# Label columns as individuals
colnames(X) <- paste0("Ind", 1:n_ind)

# Generate SNP positions for chr 1 (completely arbitrary for toy data)
positions <- sample(1:250000000, n_snps)  # Chr1 is ~249 Mb
positions[1] <- 182853362
positions <- positions[order(positions)]
snp_names <- paste0("1:", positions)

rownames(X) <- snp_names

#For SNP 1:182853362

which(rownames(X) == "1:182853362")

table(X[7338,])

colnames(X)[which(X[7338,] == 2)] <- paste0("Ind",toy[1:16,1])
colnames(X)[which(X[7338,] == 1)] <- paste0("Ind",toy[17:72,1])
colnames(X)[which(X[7338,] == 0)] <- paste0("Ind",toy[73:163,1])

bim <- data.frame(
  chr    = 1,
  id     = rownames(X),
  posg     = 0,
  pos    = positions,
  ref     = "C",
  alt     = "T"
)

Sex <- match(colnames(X), paste0("Ind",toy[,1]))
tester <- toy
tester[,2] <- ifelse(tester[, 2] == "M", 1, 2)
fam <- data.frame(
  fam  = colnames(X),
  id  = colnames(X),
  pat  = 0,
  mat  = 0,
  sex  = tester[Sex,2],
  pheno = -9
)


write_plink('ToyData', X, fam = fam, bim = bim)

### same thing in separate steps:

# create default tables to go with simulated genotype data
fam <- make_fam(n = 2)
bim <- make_bim(n = 5)
# overwrite with simulated phenotype
fam$pheno <- pheno

# write simulated data to BED/BIM/FAM separately (one command each)
# extension can be omitted and it still works!
write_bed('random', X)
write_fam('random', fam)
write_bim('random', bim)