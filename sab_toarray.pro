
function sab_type_null, v
u = list()
for i=0, n_elements(v)-1 do begin
    case v[i] OF
    'LIST': u.add,obj_new()
    'STRING':u.add,''
    'DOUBLE':u.add,-1d31
    'FLOAT':u.add, 1e31
    'INT':u.add, -9999
    'LONG':u.add, -9999l
    ENDCASE
endfor
return,u
end

function sab_toarray, a
; a = sab_toarray(bins)
n= n_elements(a)
vnames = ''
vtypes = ''
for i=0, n-1 do BEGIN
   c= a[i]
   t = TAG_NAMES(c)
   for j=0,N_ELEMENTS(t)-1 do  vtypes = [vtypes, typename(c.(j))]
   vnames = [vnames, t]
endfor
vtypes = vtypes[1:*]
vnames = vnames[1:*]
;print, vtypes
;print, vnames
is = sort(vnames)
is = is[uniq(vnames[is])]
vnames = vnames[is]
vtypes = vtypes[is]
u = sab_type_null(vtypes)

rec = create_struct(vnames[0], u[0])
for i =1, n_elements(is) -1 do rec = create_struct(rec,vnames[i], u[i])
s =replicate(rec,n)
for i=0, n-1 do BEGIN
   c= a[i]
   t = TAG_NAMES(c)
   for j=0,N_ELEMENTS(t)-1 do BEGIN
       k=where( t[j] eq vnames)
       if k[0] ne -1 then s[i].(k) = c.(j)
   ENDFOR
ENDFOR
return,s
end
