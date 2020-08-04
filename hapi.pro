function hapi, server, dataset, parameters, starttime, stoptime, opts=opts, format=format
; possible calls
; a = hapi() ; lists servers
; a = hapi(server) ; lists datasets on server
; a = hapi(server, dataset, parameters, starttime, stoptime) ; retreives data for parameters
;       if parameter = '' or undefined all parameters in dataset will be returned.
icase = n_params()
if KEYWORD_SET(format) eq 0 then format= 'csv'
print,'idl-client version 0.1'
case icase  OF
0:return, cmb_hapi_listofservers1(/list)
;1:return, cmb_hapidatashop_capabilities( server)
1:return, cmb_hapidatashop_catalog( server, plusinfo=info)
2:return, cmb_hapidatashop_info(dataset, server)
else:begin
    if n_elements(starttime) eq 0 or n_elements(stoptime) eq 0 then message,'start/stop times must be specified:'
    dates = [starttime,stoptime]
    help, server, dataset, dates
	url = cmb_hapi_form_data_request_url( server, dataset, dates, format, parameters) ; data request URL
	case format OF
	'csv': begin
			sdata = cmb_hapi_csv( url, header=head, j= j)
			meta = cmb_hapivarinfo(dataset,head,info=info)
		end
	'binary': BEGIN
			sdata = cmb_hapi_binary( url, header=head, j= j)
			meta = cmb_hapivarinfo(dataset,head,info=info)
		end
		else :begin
		   MESSAGE,' format not found: '+ format
		   return,0
		   end
	ENDCASE
	return, {data:sdata, meta: meta, info:info}
	END
ENDCASE
end


pro test_hapi_client
;servers = hapi()
;vnames = hapi('http://datashop.elasticbeanstalk.com/hapi','Wind_EPACT_LEMT_Events_OMNI_5min_NE')
datasetid='WEYGAND_GEOTAIL_MAG_GSM'
parameters = ['B_GSM', 'position_GSM']
dates=['1999-07-01','1999-07-01T12:00:00.000'  ]
server = 'http://datashop.elasticbeanstalk.com/hapi'
d = hapi(server, datasetid, parameters, dates[0], dates[1])
;help, d
;fillval = d.meta.b_gsm.fill
;i=where( d.data.b_gsm[0] ne fillval)
;timesec = d.data.epoch & timesec = (timesec-timesec[0])/1d3
; ik = plot( timesec[i],(d.data.b_gsm[0])(i), ytitle='Bx', xtitle='TIME (s)')
stop
end
