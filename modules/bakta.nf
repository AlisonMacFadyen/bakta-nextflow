#!/usr/bin/env nextflow

process BAKTA {

    tag "${fasta.simpleName}"
    label 'process_high'

    container 'oschwengers/bakta:latest'
    containerOptions '--entrypoint ""'

    publishDir "${params.outdir}/bakta", mode: 'copy'

    input:
    path fasta
    path bakta_database

    output:
    tuple path("${fasta.simpleName}/*.fna"),
          path("${fasta.simpleName}/*.gff3"),
          emit: bakta_out

    script:
    """
    bakta --output ${fasta.simpleName} \
        --genus ${params.genus} \
        --compliant \
        --threads ${task.cpus} \
        --prefix ${fasta.simpleName} \
        --db ${bakta_database} \
        ${fasta}
    """
}
