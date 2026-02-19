#!/usr/bin/env nextflow

process BAKTA {

    tag "${fasta.simpleName}"
    label 'process_high'

    container 'oschwengers/bakta:latest'
    containerOptions '--entrypoint ""'

    publishDir "${params.outdir}/bakta", mode: 'copy'

    errorStrategy { task.attempt <= 3 ? 'retry' : 'ignore' }
    maxRetries 3

    input:
    path fasta
    path bakta_database

    output:
    tuple path("${fasta.simpleName}/*.fna"),
          path("${fasta.simpleName}/*.gff3"),
          path("${fasta.simpleName}/*.faa"),
          emit: bakta_out

    script:
    def timeout_secs = task.time ? task.time.toSeconds() : 14400
    """
    timeout ${timeout_secs} \
    bakta --output ${fasta.simpleName} \
        --genus ${params.genus} \
        --compliant \
        --threads ${task.cpus} \
        --prefix ${fasta.simpleName} \
        --db ${bakta_database} \
        ${fasta}
    """
}
