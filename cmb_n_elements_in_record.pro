function cmb_n_elements_in_record, rec
; nrec = cmb_n_elements_in_record( rec)
ntags = n_tags(rec)
nrec =0l
for i=0l, ntags-1 do nrec = nrec + n_elements(rec.(i))
return, nrec
end
