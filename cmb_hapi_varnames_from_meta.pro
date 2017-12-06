function cmb_hapi_varnames_from_meta, meta

nt = n_tags(meta) & nt = nt -1
; the first and last entries in the structure meta are not HAPI variables.

varnames = strarr( nt-1)

for it =1,nt-1 do varnames[it-1] = meta.(it).name

return, varnames
end
