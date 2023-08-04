function cmb_datastring2structrecord, head,m, meta=meta, noepoch=noepoch, itest=itest
; rec = cmb_datastring2structrecord( head, m, meta=meta)
; PURPOSE
; .compile cmb_datastring2structrecord
; convert data header string from HAPI to a structure record
; INPUT
; head - data header stripped form the data string from HAPI with leading '#' stripped.
; OUTPUT
; rec - is a structure of variable names with their variable type
j = JSON_PARSE(cmb_str_flatten(head), /tostruct)
np = n_elements(j.parameters)
if KEYWORD_SET(noepoch) eq 0 then begin
   ;rec= CREATE_STRUCT('epoch', 0d0) ; CDF_EPOCH
   rec= CREATE_STRUCT('epoch', long64(0))  ; TT2000
   i0 = 0
endif else i0 = 1
for iv=i0, np -1 do BEGIN
    a = j.parameters[iv]
    vname = cmb_valid_var_name( a.name )
    if  iv eq 0 then vname = 'epochstring'
    if cmb_tag_name_exists('type',a) then type = a.type else type ='undefined'
	if cmb_tag_name_exists('size', a) then BEGIN
	   n = n_elements(a.size)
	   k = lonarr(n)
	   for ix=0,n-1 do k[ix] = a.size[ix]
	   k = reverse(k)
	   x = make_array(k) ; floating array
     ;help,vname, x & print,a & stop
	endif else BEGIN
	   if type  eq 'isotime' then x = '' else x = 0.
	endelse
	if strlowcase(type) eq 'double' then  x = double(x)
  if strlowcase(type) eq 'integer' then  x = long(x)
	if strlowcase(type) eq 'string' then  x = string(x)
	;help,vname,x , type
    if N_ELEMENTS(rec) eq 0 then rec= CREATE_STRUCT(vname, x ) else rec= CREATE_STRUCT(rec, vname, x )
endfor
return, rec
end
