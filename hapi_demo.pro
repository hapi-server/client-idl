; .compile hapi_demo.pro
print,'How to list servers'
servers = hapi()
goto, skip
iserver = 0
print,'list of servers'
for i=0,N_ELEMENTS(servers)-1 do print,i,' ', servers[i]
print,'input index of server for which to retrieve its catalog'
read, iserver
print,' How to retrieve the HAPI catalog with info'
catalog = hapi( servers[iserver])
print, ' list of datasets on server ', servers[iserver]
for i=0,N_ELEMENTS(catalog)-1 do print,i,' ', catalog[i]
stop
print,' specific example'
icat =3
print,' How to retrieve information on a HAPI dataset'
print,' server:', servers[iserver]
print,' dataset:', catalog[icat]
info = hapi(servers[iserver], catalog[icat]) ; request info on variables for id in catalogue
help, info,/str
stop
print,'Example for retrieving a data set'
varnames = ['B_GSM', 'position_GSM']
dates=['1999-07-01T00:00:00.000','1999-07-01T12:00:00.000']
d = hapi( servers[iserver],catalog[icat],varnames, dates[0], dates[1])
help, d,/str
help, d.data, d.meta,d.info,/str
window,/free
date_label = LABEL_DATE(DATE_FORMAT = $
   ['%H:%I'])
plot, cmb_epoch2jd( d.data.epoch), d.data.b_gsm[0] $
	, ytitle='BxGSM (nT)', yr= [-1,1]*20.,title=d.info.id $
	, XTICKFORMAT = 'LABEL_DATE', pos =[.1,.1,.9,.9]

;
skip:
print,' example where user can explore datasets'

iserver = 0
print,'list of servers'
for i=0,N_ELEMENTS(servers)-1 do print,i,' ', servers[i]
print,'input index of server for which to retrieve its catalog'
read, iserver
print,' How to retrieve the HAPI catalog with info'
catalog = hapi( servers[iserver])

print, ' list of datasets on server ', servers[iserver]
catsearch=''
refinecat:

if catsearch ne '' and catsearch ne ' ' then begin
  ip = strpos( strlowcase(catalog), strlowcase(catsearch))
  ip = where( ip ge 0)
  if ip[0] eq -1 then begin
    print,'bad search criteria, redo: ', catsearch
    read,'input search string (i.e. mms etc.):', catsearch
    goto, refinecat
  endif
  catalog = catalog[ip]
endif
for i=0,N_ELEMENTS(catalog)-1 do print,i,' ', catalog[i]
read,' input index of dataset or -1 to refine catalog list:', icat
if icat eq -1 then begin
  read,'input search string (i.e. mms etc.):', catsearch
  goto, refinecat
endif
info = hapi(servers[iserver], catalog[icat]) ; request info on variables for id in catalogue
help, info,/str
help, info.HAPIDATASETINFO
date0 = info.HAPIDATASETINFO.startdate
date1 = info.HAPIDATASETINFO.stopdate
date0 = '' & date1 = ''
date0 = info.HAPIDATASETINFO.startdate
ep0 = sab_string2epoch(date0)
ep1 = ep0+ long64(1*3600d9)
date0 = cmb_date(ep0)
date1 = cmb_date(ep1)
date_check:
;read,'input start date in form yyyy-mm-ddThh:mm:ss.sss: ', date0
;read,'input stop date in form yyyy-mm-ddThh:mm:ss.sss: ', date1
dates = [date0, date1]

print,' dates: ', dates
;print,'input if the dates are correct ', icheck
;if icheck ne 1 then goto, date_check
print,'server: ', servers[iserver]
print,'dataset: ', catalog[icat]

varnames = cmb_hapi_varnames_from_meta(info) ; to get variable names
nvarnames = n_elements( varnames)
print,'this dataset has ', nvarnames, ' variables'
read,'input 1 to load all variables available or 0 to select subset:', ichoice
if ichoice eq 1 then begin
    d = hapi( servers[iserver],catalog[icat],varnamesdummy, dates[0], dates[1]) ;loading all variables, varnamesdummy is undefined
endif else begin
    print,'list of variables'
    for i=0, nvarnames-1 do print, i,' ', varnames[i]
    sivar = ''
    read,'input numbers of variables to load comma (,) delimited:', sivar
    sivar = '[' + sivar + ']'
    help, execute( 'ivar=' + sivar )
    print, 'loading variables:',   varnames[ivar]
    d = hapi( servers[iserver],catalog[icat],varnames[ivar], dates[0], dates[1])
    ;d = hapi( servers[iserver],catalog[icat],varnames[0:nvarnames/2], dates[0], dates[1]) ;loading subset of variables
ENDELSE
print,'server: ', servers[iserver]
print,'dataset: ', catalog[icat]
print,'dates:', dates
help, d,/str
help, d.data, d.meta,d.info,/str
print,'variables: ', tag_names(d.data)
end
