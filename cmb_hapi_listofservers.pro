function cmb_hapi_listofservers, name, listservers =listservers, select=select, info=info, ver=ver
; server = cmb_hapi_listofservers(serverid)
; server = cmb_hapi_listofservers(serverid,/select)
; names = cmb_hapi_listofservers(/listservers)
; server = cmb_hapi_listofservers(name, list =list, select=select, info=info, ver=ver)
; list of known servers
;http://jfaden.net:8180/HapiServerDemo/hapi/data?id=Iowa+City+Conditions&time.min=2016-01-01&time.max=2016-01-05&include=header&parameters=Time,Humidity

; http://datashop.elasticbeanstalk.com/hapi
servers = [ $
    'http://datashop.elasticbeanstalk.com/hapi', $
	'http://jfaden.net:8180/HapiServerDemo/hapi', $
;	'http://tsds.org/get/IMAGE/PT1M/hapi', $
	'https://cdaweb.gsfc.nasa.gov/registry/hdp/hapi' $
	]

names = ['van', $
         'fad', $
         ;'wei', $
         'cdaweb']

if keyword_set(listservers) then BEGIN
	print,'list of HAPI server ids and  urls
	for i=0,n_elements(names)-1 do print,'ID:'+names[i], ', URL:'+servers[i], format='(a10,2x,a)'
	return, names
endif

if KEYWORD_SET( select) or N_ELEMENTS(name) eq 0 then begin
   cmb_string_list, names + servers
   read,'select index of server:', ip
   name = names[ip]
endif

ip =where( name eq names) & ip =ip[0]
if ip eq -1 then ip=0
info = wget(servers[ip] + '/capabilities',/string)
ver = strsplit(info[1],':', /extract) & ver = ver[1] & ver = strsplit(ver,'"',/extract) & ver=ver[1]
return, servers[ip]
end
