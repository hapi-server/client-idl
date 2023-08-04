; .compile cmb_hapi_listofservers

function cmb_hapi_listofservers, name, listservers =listservers, select=select, info=info, ver=ver
; servers = cmb_hapi_listofservers()
; url to currently known HAPI servers
url = 'https://github.com/hapi-server/servers/blob/master/all.txt'

; convoluted way to extract urls to each server
d = wget(url,/string)
j = strpos(d,'rawLines')
a = strmid(d,j)
k0 = strpos(a,'[')
k1 = strpos(a,']')
c = strmid(a,k0,k1-k0+1)
servers = strsplit(c,'[]",',/extract)

if keyword_set(listservers) then return, servers

if KEYWORD_SET( select) or N_ELEMENTS(name) eq 0 then begin
   cmb_string_list,servers
   read,'select index of server:', ip
   server = servers[ip]
endif

return, server
end
