
function cmb_hapi_listofservers1, name, listservers =listservers, select=select, info=info, ver=ver
; servers = cmb_hapi_listofservers_newversion()
url = 'https://github.com/hapi-server/servers/blob/master/all.txt'
data = wget( url,/string) 
ip = strpos(data,'LC') & ip=where( ip ge 0) & help,ip 
data = data[ip] 
ip = strpos(data,'http') & ip=where( ip ge 0) & help,ip 
data = data[ip] 
ip = strpos( data[0], 'http')
data = strmid(data,ip)
ip  = strpos(data,'</td>')
print, ' List of HAPI Servers'
for i=0,n_elements(ip)-1 do data[i] = strmid(data[i],0,ip[i])
;data = [data, 'http://jfaden.net:8180/HapiServerDemo/hapi']
data = [data, 'http://jfaden.net/HapiServerDemo/hapi', 'https://cdaweb.sci.gsfc.nasa.gov/hapi']
for i=0,n_elements(data)-1 do print, data[i]
return, data
end


