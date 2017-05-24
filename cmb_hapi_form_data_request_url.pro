function cmb_hapi_form_data_request_url, server, id, dates, format, varnames
; url = cmb_hapi_form_data_request_url( server, id, dates, format, varnames)
; PURPOSE: construct HAPI server data request URL.
; url examples
;url = 'http://datashop.elasticbeanstalk.com/hapi/data?id=CASSINI_LEMMS_PHA_CHANNEL_1_SEC&time.min=2002-01-02T00:00:00.000&time.max=2002-01-02T06:00:00.000&format=binary&include=header'

getdata = server + '/data?id=' + id $
        + '&time.min=' $
        + dates[0] + '&time.max=' $
        + dates[1]
getdata = getdata  + '&include=header' 
getdata = getdata  + '&format=' + format

if 1 and n_elements(varnames) ne 0 then BEGIN
   if varnames[0] ne '' or varnames[0] ne ' ' then begin
	getdata = getdata + '&parameters=' + varnames[0]
	nvars = n_elements(varnames)
	for ivar = 1l, nvars-1 do getdata = getdata + ','+varnames[ivar]
   endif
endif
;for debugging
openw,/append,/GET_LUN, lun, 'hapidatarequests.txt'
printf,lun, getdata
FREE_LUN, lun
return, getdata
end
