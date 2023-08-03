# idl-client

IDL client for obtaining data from a HAPI server.

Note that there is also another IDL client that is a part of SPEDAS; see https://github.com/hapi-server/client-idl-spedas

Both the IDL source code and .sav file of code available for IDL 8.5 or greater.

For a demo see [hapi_demo.pro](https://github.com/hapi-server/client-idl/blob/master/hapi_demo.pro).

## Installation
```
Download file: hapi.sav and place in your idl path or current working directory.

Download file: hapi_demo.pro, note not necessary to run hapi, but demonstrates how to use hapi.
```
## Example usage

```
; start IDL session
server = 'https://cdaweb.gsfc.nasa.gov/hapi'

dataset = 'WI_H2_MFI'

dates=['1994-11-13T15:50:26.000Z','1994-11-13T16:50:26.000Z']

varnames = ['BF1', 'BGSM']

d = hapi( server, dataset,varnames, dates[0], dates[1])

;**** NOTE to load all variables in a dataset **** use this command 
;     d = hapi( server, dataset,'', dates[0], dates[1]) ; this will load all the variables


; hapi returns structure d: data is in structure d.data, description of data is in structure d.meta
help, d, /str

; contents of data, meta, and info structure
help, d.data, d.meta, d.info, /str

; information on specific variable
help, d.data.bx_sso, d.meta.bx_sso, /str

; time tag of data is in cdf_epoch
help, d.data.epoch

; to plot Bx of BGSM component

dummy = LABEL_DATE(DATE_FORMAT=['%H:%I'])  
apt = plot( CDF_EPOCH_TOJULDAYS(d.data.epoch), d.data.bgsm[0], $
           ytitle= d.meta.bgsm.name + '_X, ' + d.meta.bgsm.units, $
           XTICKFORMAT='LABEL_DATE', $
           xtitle='HH:MM', title= dataset + '!c ' + dates[0] + ' to ' + dates[1] )


; Note hapi appends the url called by hapi.pro to a local file called: hapidatarequests.txt
; this file can be deleted and doesn't affect how the code runs
; $ cat hapidatarequests.txt
; http://datashop.elasticbeanstalk.com/hapi/data?id=CASSINI_MAG_HI_RES&time.min=2004-183T00:00:00.000Z&time.max=2004-184T00:00:00.000Z&include=header&format=csv&parameters=Bx_SSO,By_SSO,Bz_SSO




```
## Example usage 2
```
; to list servers
servers = hapi()
for i=0,n_elements(servers)-1 do print,i,' ', servers[i]

; to list datasets on a server
catalog = hapi( servers[1]) 
help, catalog

; to list information about a dataset on a server
info = hapi(servers[1], catalog[3])
help, info
```
