#!/bin/bash

#actual run:

mkdir -p temp/binner/louse_outbred_customdb

/data1/jbrown/local_programs/Taxonomer_from_aurelie/Taxonomer_201602/bin_reads scripts/binner/louse_outbred_customdb.conf -c 0.3 >  temp/binner/louse_outbred_customdb/louse_outbred_customdb.log 2>&1

################################################################################
################################################################################

#info from Aurelie:

#path to the "wd" binner *(= the one with refseq genomes):
#/data1/akapusta/binner/binner_wdV1_c5_21

#path to sample config file:
#/data1/akapusta/shapiro_louse/louse.raw.180.wd_binned.out_0.3.wd-binner.conf

#note: fastq files must be unzipped to run!

#to run binning, just input the config file:
#nohup /home/akapusta/Taxonomer_201602/bin_reads louse.raw.180.wd_binned.out_0.3.wd-binner.conf > louse.raw.180.wd_binned.out_0.3.wd-binner.log &
#this may take a while

#to parse the output and get a summary:
#nohup python parse_binner_output.v2.py -i louse.raw.180.wd_binned.out_0.3.fq.wd-binner.out -c 0.3 > louse.raw.180.wd_binned.out_0.3.fq.wd-binner.out.parse0.3.log &

################################################################################
################################################################################

#part 2: the mini binner with only 3 genomes in it (with all known kmers)

#to make the database, run as follows:
#nohup ~/Taxonomer_20160/build_binner_db Cliv-Hsap_buildbinner.conf > Cliv-Hsap_buildbinner.conf.log &

#to run a file against it, just run the correct config file:
#/home/akapusta/Taxonomer_201602/bin_reads /data1/akapusta/shapiro_louse/louse.raw.180.wd_binned.out_0.3.Cliv-binner.conf

#Let's check the file parsed0.3
#To run a file against it, same deal, configuration file
#/home/akapusta/Taxonomer_201602/bin_reads /data1/akapusta/shapiro_louse/louse.raw.180.wd_binned.out_0.3.Cliv-binner.conf

#Now parse, same level of filtering, to get numbers that bin as these 3 genomes
#I copied the parsing script because the bins are hard coded in it (should load a file, but this was faster given my python skills).
#nohup python parse_Cliv-binner_output.v2.py -i louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out -c 0.3 > louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out.parse0.3.log &
#The summary output:
##bin_id    bin_description    number_of_sequences_binned    percentage_of_sequences_binned    length_of_sequences_binned
#1    Hs_louse    1837780     4.176526    229722500
#2    pigeon      3109765     7.067231    388720625
#4    human       5582059    12.685749    697757375
#The reason why there are still reads mapped to human or pigeon is because the big binner does not contain all possible kmers. 
#Now, because this binner does have all possible kmers, let's check with 0.5, just in case (it is more stringent: 50% of the kmers need to be binned to a bin to call that that a read belongs to a bin)
#nohup python parse_Cliv-binner_output.v2.py -i louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out -c 0.5 > louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out.parse0.5.log &
#bin_id    bin_description    number_of_sequences_binned    percentage_of_sequences_binned    length_of_sequences_binned
#1    Hs_louse    1754756     3.987847    219344500
#2    pigeon      2793145     6.347682    349143125
#4    human       5574447    12.668450    696805875
#Not a huge difference - makes me think that the calls for human are pretty confident. let's check 0.9:
#nohup python parse_Cliv-binner_output.v2.py -i louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out -c 0.9 > louse.raw.180.wd_binned.out_0.3.fq.Cliv-binner.out.parse0.9.log &
#bin_id    bin_description    number_of_sequences_binned    percentage_of_sequences_binned    length_of_sequences_binned
#1    Hs_louse    1481005     3.365722    185125625
#2    pigeon      2601253     5.911590    325156625
#4    human       5346822    12.151151    668352750
