function cmb_hapivarinfo,id, head, info=info
; meta = cmb_hapivarinfo(id, head)
j = JSON_PARSE(cmb_str_flatten(head) + ',', /tostruct)
np = n_elements(j.parameters)
tagnames = TAG_NAMES(j)
;meta = CREATE_STRUCT('id', id,'firstdate', j.firstdate, 'lastdate', j.lastdate)

info = CREATE_STRUCT('hapiversion',j.hapi, 'id', id,'startdate', j.startdate, 'stopdate', j.stopdate)

fields =['sampleStartDate','sampleStopDate','description', 'resourceURL', 'resourceID',  'creationDate','modificationDate','cadence','format','contact','contactID']
for i=0,n_elements(fields)-1 do $
  if cmb_tag_name_exists(fields[i], j,ip) then info = CREATE_STRUCT(info, fields[i], j.(ip))

recepoch = {var_type:'cdf_epoch',units:'ms'}
;recepoch = 'double precision in ms'
meta = CREATE_STRUCT( 'epoch', recepoch )
;meta = CREATE_STRUCT(meta, 'epochstring', j.parameters[i])
for i=0l,np-1 do begin 
    vname = j.parameters[i].name
    vinfo = j.parameters[i]
    if strlowcase(vinfo.type) eq 'isotime' and i eq 0 then vname = 'epochstring'
    ;if vname eq 'epoch' then vname = 'epochstring'
    ;if vname eq 'Epoch' then vname = 'Epoch11' ; Kludge due duplicate names.
    cmb_hapiextractbins, vinfo
    meta = CREATE_STRUCT(meta, vname, vinfo)
endfor
return, meta
end