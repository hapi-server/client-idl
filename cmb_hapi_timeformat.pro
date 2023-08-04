function cmb_hapi_timeformat, timestring
;PURPOSE: return time given by timestring as NSSDC epoch in TT2000
;HAPI allows to two time formats
; yyy-mm-ddThh:mm:ss.sssZ
; yyyy-dddThh:mm:ss.sssZ
; where .sss can be fractional seconds beyond 3 digits

; determine if timestring is day of year or month, day of month
itest = n_elements( strsplit( timestring[0],'-',/ext) )
if itest ne 3 then begin ;doy
if itest ne 2 then message, 'cmb_hapi_timeformat, time string error:', timestring[0]
it= strpos( timestring[0],'T')
tod  = strmid( timestring, it)
date = strmid( timestring,0, it)
im= strpos( date[0],'-')
year = long(strmid( date,0, im))
adoy = long(strmid( date,im+1))
cdf_epoch,/comp, ep0, year
ep = ep0 + (adoy-1)*24l*3600d3; + 60d3
cdf_epoch,/break, ep, iyear,month, dom
timestring1 = string(year,format='(i4.4)') + '-' + string(month,format='(i2.2)') + '-' + string(dom,format='(i2.2)') +tod
return, CDF_PARSE_TT2000(timestring1)
endif
return, CDF_PARSE_TT2000(timestring) ; return NSSDC in TT2000
end
