# idl-client

IDL client for obtaining data from a HAPI server

Both the IDL source code and .sav file of code available for IDL 8.5 or greater.

For a demo see [hapi_demo.pro](https://github.com/hapi-server/client-idl/blob/master/hapi_demo.pro).

## Installation
```
Download file: hapi.sav and place in your idl path or current working directory.

Download file: hapi_demo.pro
```
## Example usage

```
; start IDL session
server = 'http://datashop.elasticbeanstalk.com/hapi'

dataset = 'CASSINI_MAG_HI_RES'

dates=['2004-183T00:00:00.000Z','2004-184T00:00:00.000Z']

varnames = ['Bx_SSO', 'By_SSO', 'Bz_SSO']

d = hapi( server, dataset,varnames, dates[0], dates[1])

; hapi returns structure d: data is in structure d.data, description of data is in structure d.meta
help, d,d.data, /str

;contents of data and meta structure
help, d,d.data, d.meta,d.info, /str

; information of specific variable
help, d.data.bx_sso, d.meta.bx_sso, /str

; time tag of data is in cdf_epoch
help, d.data.epoch

; to plot Bx component

dummy = LABEL_DATE(DATE_FORMAT=['%H:%I'])  
apt = plot(CDF_EPOCH_TOJULDAYS(d.data.epoch), d.data.bx_sso, ytitle= d.meta.bx_sso.name + ', ' + d.meta.bx_sso.units, XTICKFORMAT='LABEL_DATE', xtitle='HH:MM', title= dataset + '!c ' + dates[0] + ' to ' + dates[1] )

```
## Example usage 2
```
; to list servers
servers = hapi()

; to list datasets on a server
catalog = hapi( servers[1]) 

; to list information about a dataset on a server
info = hapi(servers[1], catalog[0])

```
