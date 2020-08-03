# idl-client

IDL client for obtaining data from a HAPI server

Both the IDL source code and .sav file of code available for IDL 8.5 or greater.

For a demo see [hapi_demo.pro](https://github.com/hapi-server/client-idl/blob/master/hapi_demo.pro).

## Installation
Download file: hapi.sav and place in your idl or current working directory.
Download file: hapi_demo.pro
## Example usage

```
; start IDL session
server = 'http://datashop.elasticbeanstalk.com/hapi'

dataset = 'CASSINI_MAG_HI_RES'

dates=['2004-183T00:00:00.000Z','2004-184T00:00:00.000Z']

varnames = ['Bx_SSO', 'By_SSO', 'Bz_SSO']

d = hapi( server, dataset,varnames, dates[0], dates[1])

help, d,/str

help, d.data, d.meta,d.info,/str

```
