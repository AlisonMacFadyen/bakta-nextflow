#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { BAKTA } from './modules/bakta'

/*
 * Input validation
 */
def validateParams() {
    if (!params.fasta) {
        error """
        ERROR: No input genomes provided.
        Please specify input FASTA files with --fasta '/path/to/*.fasta.gz'
        """.stripIndent().trim()
    }
    if (!params.bakta_database) {
        error """
        ERROR: No Bakta database provided.
        Please specify --bakta_database '/path/to/bakta/db'
        """.stripIndent().trim()
    }
    if (!params.genus) {
        error """
        ERROR: No genus provided.
        Please specify --genus 'GenusName'
        """.stripIndent().trim()
    }
}

/*
 * Main workflow
 *
 * Annotate genome assemblies with Bakta.
 *
 *   nextflow run main.nf --fasta '*.fasta.gz' --bakta_database /path/to/db --genus Staphylococcus
 */
workflow {

    validateParams()

    fasta_ch = Channel
        .fromPath(params.fasta, checkIfExists: true)

    BAKTA(fasta_ch, file(params.bakta_database))
}

/*
 * Completion summary
 */
workflow.onComplete {
    log.info """
    ================================================
      Bakta Annotation Pipeline Complete
    ================================================
      Duration : ${workflow.duration}
      Success  : ${workflow.success}
      Results  : ${params.outdir}
    ================================================
    """.stripIndent()
}
