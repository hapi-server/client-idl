# idl-client
IDL client for obtaining data from a HAPI server
Both the IDL source code and .sav file of code available for IDL 8.5 or greater.
For demo see hapi_demo.pro

Example usage

server = 'http://datashop.elasticbeanstalk.com/hapi'
dataset = 'CASSINI_LEMMS_PHA_CHANNEL_1_SEC'

dates=['2002-01-02T00:00:00.000','2002-01-02T06:00:00.000'  ]

varnames = ['time_array_0', 'A', 'E', 'F1','A_uncert', 'E_uncert', 'F1_uncert', 'Bx_SZS', 'By_SZS', 'Bz_SZS', 'PA_for_LEMMS_LET', 'SunAngle_for_LEMMS_LET']

d = hapi( server, dataset,varnames, dates[0], dates[1])

help, d,/str

help, d.data, d.meta,d.info,/str
