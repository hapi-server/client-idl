function cmb_datastring2structrecord, head,m, noepoch=noepoch
; rec = cmb_datastring2structrecord( head)
; PURPOSE
; convert data header string from HAPI to a structure record
; INPUT
; head - data header stripped form the data string from HAPI with leading '#' stripped.
; OUTPUT
; rec - is a structure of variable names with their variable type
j = JSON_PARSE(cmb_str_flatten(head), /tostruct)
np = n_elements(j.parameters)
if KEYWORD_SET(noepoch) eq 0 then begin
   rec= CREATE_STRUCT('epoch', 0d0)
   i0 = 0
endif else i0 = 1
for i=i0, np -1 do BEGIN
    vname = j.parameters[i].name
    if  i eq 0 then vname = 'epochstring'
    if cmb_tag_name_exists('type',j.parameters[i]) then type = j.parameters[i].type else type ='undefined'
	if cmb_tag_name_exists('size', j.parameters[i]) then BEGIN
	   n = n_elements(j.parameters[i].size)
	   k = lonarr(n)
	   for ix=0,n-1 do k[ix] = j.parameters[i].size[ix]
	   k = reverse(k)
	   x = make_array(k) ; floating array
	endif else BEGIN
	   if type  eq 'isotime' then x = '' else x = 0.	
	endelse 
	if strlowcase(type) eq 'double' then  x = double(x)
	if strlowcase(type) eq 'string' then  x = string(x)
	help,vname,x , type     
    if N_ELEMENTS(rec) eq 0 then rec= CREATE_STRUCT(vname, x ) else rec= CREATE_STRUCT(rec, vname, x )
endfor
return, rec
end
