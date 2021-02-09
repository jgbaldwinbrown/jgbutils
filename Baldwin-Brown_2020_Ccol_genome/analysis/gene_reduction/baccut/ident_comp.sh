bash get_clean_ccol.sh
rsync -avP ../original_run/ ./ --files-from rslist.txt && {
    echo "opsin"
    grep -f dmel_lists/flybase_opsin_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_opsin_idents.txt
    grep -f dmel_lists/flybase_opsin_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_opsin_idents.txt
    grep -f c2d_opsin_idents.txt p2d_opsin_idents.txt  | wc -l
    wc -l c2d_opsin_idents.txt 
    wc -l p2d_opsin_idents.txt 
    wc -l dmel_lists/flybase_opsin_prots.txt
    
    echo "gpcr"
    grep -f dmel_lists/flybase_gpcr_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_gpcr_idents.txt
    grep -f dmel_lists/flybase_gpcr_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_gpcr_idents.txt
    grep -f c2d_gpcr_idents.txt p2d_gpcr_idents.txt  | wc -l
    wc -l c2d_gpcr_idents.txt 
    wc -l p2d_gpcr_idents.txt 
    wc -l dmel_lists/flybase_gpcr_prots.txt
    
    echo "olfac"
    grep -f dmel_lists/flybase_olfac_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_olfac_idents.txt
    grep -f dmel_lists/flybase_olfac_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_olfac_idents.txt
    grep -f c2d_olfac_idents.txt p2d_olfac_idents.txt  | wc -l
    wc -l c2d_olfac_idents.txt 
    wc -l p2d_olfac_idents.txt 
    wc -l dmel_lists/flybase_olfac_prots.txt
    
    echo "taste"
    grep -f dmel_lists/flybase_taste_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_taste_idents.txt
    grep -f dmel_lists/flybase_taste_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_taste_idents.txt
    grep -f c2d_taste_idents.txt p2d_taste_idents.txt  | wc -l
    wc -l c2d_taste_idents.txt 
    wc -l p2d_taste_idents.txt 
    wc -l dmel_lists/flybase_taste_prots.txt
    
    echo "odorantbinding"
    grep -f dmel_lists/flybase_odorantbinding_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_odorantbinding_idents.txt
    grep -f dmel_lists/flybase_odorantbinding_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_odorantbinding_idents.txt
    grep -f c2d_odorantbinding_idents.txt p2d_odorantbinding_idents.txt  | wc -l
    wc -l c2d_odorantbinding_idents.txt 
    wc -l p2d_odorantbinding_idents.txt 
    wc -l dmel_lists/flybase_odorantbinding_prots.txt
    
    echo "insulin"
    grep -f dmel_lists/flybase_insulin_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_insulin_idents.txt
    grep -f dmel_lists/flybase_insulin_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_insulin_idents.txt
    grep -f c2d_insulin_idents.txt p2d_insulin_idents.txt  | wc -l
    wc -l c2d_insulin_idents.txt 
    wc -l p2d_insulin_idents.txt 
    wc -l dmel_lists/flybase_insulin_prots.txt
    
    echo "tor"
    grep -f dmel_lists/flybase_tor_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_tor_idents.txt
    grep -f dmel_lists/flybase_tor_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_tor_idents.txt
    grep -f c2d_tor_idents.txt p2d_tor_idents.txt  | wc -l
    wc -l c2d_tor_idents.txt 
    wc -l p2d_tor_idents.txt 
    wc -l dmel_lists/flybase_tor_prots.txt
    
    echo "chemo"
    grep -f dmel_lists/flybase_chemo_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_chemo_idents.txt
    grep -f dmel_lists/flybase_chemo_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_chemo_idents.txt
    grep -f c2d_chemo_idents.txt p2d_chemo_idents.txt  | wc -l
    wc -l c2d_chemo_idents.txt 
    wc -l p2d_chemo_idents.txt 
    wc -l dmel_lists/flybase_chemo_prots.txt
    
    echo "detox"
    grep -f dmel_lists/flybase_detox_prots.txt full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_detox_idents.txt
    grep -f dmel_lists/flybase_detox_prots.txt full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_detox_idents.txt
    grep -f c2d_detox_idents.txt p2d_detox_idents.txt  | wc -l
    wc -l c2d_detox_idents.txt 
    wc -l p2d_detox_idents.txt 
    wc -l dmel_lists/flybase_detox_prots.txt
    
    echo "all"
    cat full_recip_phum2dmel.txt | grep -o 'FBpp[0-9]*' > p2d_idents.txt
    cat full_recip_ccol2dmel.txt | grep -o 'FBpp[0-9]*' > c2d_idents.txt
    grep -f c2d_idents.txt p2d_idents.txt  | wc -l
    wc -l c2d_idents.txt 
    wc -l p2d_idents.txt 
    cat dmel-all-translation-r6.34.fasta | grep ">" | wc -l
} | \
paste - - - - - | \
sed 's/ \+/	/g' | \
awkf '{print $1, $2, $3, $5, $7}' | \
tee ident_tab.txt | \
tab2table \
> ident_table.txt

cat ident_tab.txt | \
awkf '{print $1, $5, $3, $4, $2}' | \
tee ident_tab_reorder.txt | \
tab2table \
> ident_table_reorder.txt

