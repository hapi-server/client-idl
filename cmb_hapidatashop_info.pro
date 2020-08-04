function cmb_hapidatashop_info,id,server
; info = cmb_hapidatashop_info(id, server)
; info = cmb_hapidatashop_info(id, cmb_hapi_listofservers(serverid))
; return, CREATE_STRUCT( 'hapidatasetinfo', 'ERRROR')
	getinfo = server + '/info?id=' + id
	stringinfo  = wget(getinfo,/string)
	j = JSON_PARSE(cmb_str_flatten(stringinfo), /tostruct)
	print,' for datasetid of ', id
	print,'time range:', j.startdate, ' to ' , j.stopdate
	print,' variable name, units'
	for i = 0, n_elements(j.parameters) -1 do BEGIN
	    units =''
	    if cmb_tag_name_exists('units', j.parameters[i]) then units = j.parameters[i].units
	    print, j.parameters[i].name, ' ', units
	endfor
	meta = cmb_hapivarinfo(id,stringinfo)
	np = n_elements(j.parameters)
	vnames = strarr(np)
	for i=0l,np-1 do vnames[i] = j.parameters[i].name
	return, cmb_hapivarinfo(id, stringinfo)
end
