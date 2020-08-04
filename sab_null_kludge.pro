function sab_null_kludge, xin
x=xin
; y = sab_null_kludge( a.centers)
; y = sab_null_kludge( a.ranges)
m = n_elements(x[0])
n = n_elements(x)
if m eq 1 then begin
  k=where( x eq !NULL )
  if k[0] eq -1 then return, x
  x[k] = 0.
  for i=0,n-1 do x[i] = x[i]*1.0
  x[k] = !values.f_nan
endif else BEGIN
  nullfound=0
  for i=0,n-1 do BEGIN
  k=where( x[i] eq !NULL )
  j=where( x[i] ne !NULL )
  if j[0]ne -1 then for l =0,N_ELEMENTS(j)-1 do (x[i])[j[l]] = (x[i])[j[l]]*1.0
  if k[0]ne -1 then nullfound =1
  if k[0]ne -1 then for l =0,N_ELEMENTS(k)-1 do (x[i])[k[l]] = !values.f_nan
  endfor
  if nullfound eq 0 then return,xin
endelse
return, x
end
