function  cmb_hapidatashop_capabilities, server
; capabilities = cmb_hapidatashop_capabilities( server)
; capabilities = cmb_hapidatashop_capabilities(cmb_hapi_listofservers(serverid) )
if N_ELEMENTS( server) eq 0 then server = cmb_hapi_listofservers()
capabilities = server + '/capabilities'
a = wget(capabilities,/string)
j = JSON_PARSE(cmb_str_flatten(a)+',', /tostruct, /toarray)
print,'list of formats supported by server:', server
cmb_string_list,  j.outputformats
return, j.outputformats
end
