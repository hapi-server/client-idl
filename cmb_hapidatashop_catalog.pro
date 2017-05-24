function cmb_hapidatashop_catalog,serverid , selectdataset=selectdataset, plusinfo=plusinfo
; cat = cmb_hapidatashop_catalog(serverid, selectdataset=selectdataset)
; cat = cmb_hapidatashop_catalog(serverid, selectdataset=selectdataset,/plusinfo)
server = cmb_hapi_listofservers(serverid)
	cataloga = server + '/catalog'
	a = wget(cataloga,/string)
	j = JSON_PARSE(cmb_str_flatten(a), /tostruct, /toarray)
	ids = j.catalog.id
	print,'HAPI SERVER:', server
	if KEYWORD_SET(plusinfo) then catalog = CREATE_STRUCT('server',server)
	for jd = 0,n_elements(ids)-1 do begin
	    print, ids[jd]
	    if KEYWORD_SET(plusinfo) then BEGIN
	       info = cmb_hapidatashop_info(ids[jd], server)
	       catalog = CREATE_STRUCT(catalog, idl_validname(ids[jd],/convert_all), info)
	       print,'*******'
	    ENDIF
	endfor
	if n_elements(catalog) ne 0 then return, catalog
	if keyword_set( selectdataset) eq 0 then return, ids
	read,'input id no.:', i, ' for more information'
	id = ids[i]
	print, 'selected id:', id
	return,id
end
