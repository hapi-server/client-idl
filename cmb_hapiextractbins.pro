pro cmb_hapiextractbins,vinfo
; cmb_hapiextractbins,vinfo
if cmb_tag_name_exists('bins',vinfo) eq 0 then return
bins = vinfo.bins
n = n_elements(bins)
;depends_info = bins.ToArray()
depends_info = sab_toarray(bins)
 help, depends_info ;& stop
depends = 'depend' + string(([lindgen(n)+1]),format='(i1)')
for i=0,n-1 do begin
    a = depends_info[i]
    if cmb_tag_name_exists('name',a) then name = a.name else name='notdefined'+ string(i,format='(i3.3)')
    if cmb_tag_name_exists('units',a) then units = a.units else units=''
    if cmb_tag_name_exists('fill',a) then fill = a.fill else fill=''
    if cmb_tag_name_exists('centers',a) then a.centers = sab_null_kludge( a.centers)
    if cmb_tag_name_exists('centers',a) then centers = a.centers.ToArray() else centers=''
    if cmb_tag_name_exists('ranges',a) then a.ranges = sab_null_kludge( a.ranges)
    if cmb_tag_name_exists('ranges',a) then ranges = a.ranges.ToArray() else ranges=''
    rec = {name:name, units:units, fill:fill, centers:centers, ranges:ranges}
    vinfo =CREATE_STRUCT(vinfo, depends[i], rec)
endfor
end
