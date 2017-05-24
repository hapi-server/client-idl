# idl-client
IDL client for obtaining data from a HAPI server
Both the IDL source code and .sav file of code available for IDL 8.5 or greater.
For demo see demo_hapi.pro

Example usage

id='WEYGAND_GEOTAIL_MAG_GSM'
varnames = ['B_GSM', 'position_GSM']
dates=['1999-07-01','1999-07-01T12:00:00.000'  ]
d = cmb_hapidatashop( id,varnames, dates, serverid = 'van')
help, d,/str
help, d.data, d.meta,d.info,/str
