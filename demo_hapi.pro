; demo_hapi.pro

print,'How to list servers'
servers = cmb_hapidatashop( /listservers) 
stop
print,'How to list capabilities'
capabilities = cmb_hapidatashop( /capabilities)
stop
print,' How to retrieve the HAPI catalog with info'
cat = cmb_hapidatashop( /catalog,/info) ; request catalogue
stop

print,' How to retrieve information on a HAPI dataset'
id='WEYGAND_GEOTAIL_MAG_GSM'
info = cmb_hapidatashop( id,serverid ='van', /info) ; request info on variables for id in catalogue
help, info,/str
stop

print,'Example for retrieving a data set, downing all variables'
id='WEYGAND_GEOTAIL_MAG_GSM'
varnames = ['B_GSM', 'position_GSM']
dates=['1999-07-01','1999-07-01T12:00:00.000'  ]
d = cmb_hapidatashop( id,varnames, dates, serverid = 'van')
help, d,/str
help, d.data, d.meta,d.info,/str
window,/free
date_label = LABEL_DATE(DATE_FORMAT = $
   ['%H:%I'])
plot, cmb_epoch2jd( d.data.epoch), d.data.b_gsm[0] $
	, ytitle='BxGSM (nT)', yr= [-1,1]*20.,title=d.info.id $
	, XTICKFORMAT = 'LABEL_DATE', pos =[.1,.1,.9,.9]

end