#!/usr/bin/env nextflow

// MAIN PARAMETERS
//      FastQ
if (params.fastq instanceof Boolean){
    exit 1, "'fastq' must be a path pattern. Provided value:'$params.fastq'"
    }
if (!params.fastq){ exit 1, "'fastq' parameter missing"}
// size: -1 -> allows for single and paired-end files to be passed through. Change if necessary
IN_fastq_raw = Channel.fromFilePairs(params.fastq, size: -1).ifEmpty {
    exit 1, "No fastq files provided with pattern:'${params.fastq}'" }


// PreProcessing
process fastp {

    tag { sample_id }

    input:
    set sample_id, file(fastq_pair) from IN_fastq_raw

    output:
    set sample_id, file("*trim_*.fq.gz") into OUT_fastp

    script:
    """
    a=(${fastq_pair})

    if ((\${#a[@]} > 1));
    then
        fastp -i ${fastq_pair[0]} -o ${sample_id}_trim_1.fq.gz -I ${fastq_pair[1]} -O ${sample_id}_trim_2.fq.gz 
    else
        fastp -i ${fastq_pair} -o ${sample_id}_trim_1.fq.gz 
    fi
    """
}

// Taxonomic Profile
process kraken2 {

    tag { sample_id }

    publishDir "results/kraken/"

    input:
    set sample_id, file(fastq_pair) from OUT_fastp

    output:
    set sample_id, file("*_kraken_report.txt") into OUT_KRAKEN

    script:
    """
    a=(${fastq_pair})

    if ((\${#a[@]} > 1));
    then
        kraken2 --memory-mapping --threads $task.cpus --report ${sample_id}_kraken_report.txt --db minikraken2_v1_8GB --paired --gzip-compressed ${fastq_pair[0]} ${fastq_pair[1]}
    else
        kraken2 --memory-mapping --threads $task.cpus --report ${sample_id}_kraken_report.txt --db minikraken2_v1_8GB --single --gzip-compressed ${fastq_pair}
    fi
    """
}

// Visualisation
process krona{

    tag { sample_id }

    publishDir "results/MultiQC/"

    input:
    set sample_id, file(report) from OUT_KRAKEN

    output:
    file("*html")

    script:
    """
    ktImportTaxonomy -q 2 -t 3 ${report} -o multiqc_report.html
    """
}