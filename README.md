# Bakta Annotation Nextflow Pipeline

A Nextflow pipeline for annotating bacterial genome assemblies with [Bakta](https://github.com/oschwengers/bakta).

## Requirements

- [Nextflow](https://www.nextflow.io/) (>=23.04)
- [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/singularity/)
- A [Bakta database](https://github.com/oschwengers/bakta#database)

## Usage

```bash
nextflow run main.nf \
    -profile docker \
    --fasta '/path/to/genomes/*.fasta.gz' \
    --bakta_database /path/to/bakta/db \
    --genus Staphylococcus \
    --outdir results
```

Bakta accepts compressed FASTA files.

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--fasta` | Glob pattern for input FASTA files (required) | - |
| `--bakta_database` | Path to Bakta database directory (required) | - |
| `--genus` | Genus name for annotation (required) | - |
| `--outdir` | Output directory | `results` |

## Output

```
results/
  bakta/           # Per-genome annotation output (.fna, .gff3, etc.)
```

## Profiles

| Profile | Description |
|---------|-------------|
| `docker` | Run with Docker containers |
| `singularity` | Run with Singularity containers |
| `conda` | Run with Conda environments |
| `slurm` | Submit jobs to a SLURM cluster |
| `test` | Use test data in `tests/` |

Profiles can be combined, e.g. `-profile singularity,slurm` for Singularity on a SLURM cluster.

## Resource Configuration

The BAKTA process uses the `process_high` label (4 CPUs, 8 GB RAM, 4h timeout) by default. Override in `nextflow.config` as needed.

## Resuming

Nextflow caches completed tasks. If a run is interrupted, resume from where it left off:

```bash
nextflow run main.nf -resume [same parameters as before]
```
