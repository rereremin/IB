URL = "http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR170/001/SRR1705851/SRR1705851.fastq.gz"
URL1 = "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR170/008/SRR1705858/SRR1705858.fastq.gz"
URL2 = "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR170/009/SRR1705859/SRR1705859.fastq.gz"
URL3 = "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR170/000/SRR1705860/SRR1705860.fastq.gz"

rule sample_download:
    output:
        "roommate.fastq.gz"
    shell:
        "wget -O {output} {URL}"

rule control1_download:
    output:
        "control1.fastq.gz"
    shell:
        "wget -O {output} {URL1}"

rule control2_download:
    output:
        "control2.fastq.gz"
    shell:
        "wget -O {output} {URL2}"

rule control3_download:
    output:
        "control3.fastq.gz"
    shell:
        "wget -O {output} {URL3}"

rule sample_unzip:
    input:
        "{sample}.fastq.gz"
    output:
        "{sample}.fastq"
    shell:
        "gunzip -c {input} > {output}"

rule bwa_index:
    input:
        "/Users/sofiya/IB/practice/project2_new/reference.fasta"
    output:
        "{reference}.fasta.amb",
        "{reference}.fasta.ann",
        "{reference}.fasta.bwt",
        "{reference}.fasta.pac",
        "{reference}.fasta.sa"
    shell:
        "bwa index {input}"

rule bwa_align:
    input:
        "{reference}.fasta.amb",
        "{reference}.fasta.ann",
        "{reference}.fasta.bwt",
        "{reference}.fasta.pac",
        "{reference}.fasta.sa",
        ref="{reference}.fasta",
        reads="{sample}.fastq.gz"
    output:
        "{reference}.{sample}.unsorted.bam"
    shell:
        "bwa mem {input.ref} {input.reads} | samtools view -b > {output}"

rule bam_sort:
    input:
        "{reference}.{sample}.unsorted.bam"
    output:
        protected("{reference}.{sample}.sorted.bam")
    shell:
        "samtools sort {input} > {output}"