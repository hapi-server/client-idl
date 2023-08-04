function hapi, server, dataset, parameters, starttime, stoptime, $
    capabilities=capabilities, opts=opts, format=format
; possible calls
; a = hapi() ; lists servers
; a = hapi(server) ; lists datasets on server
; a = hapi(server, dataset, parameters, starttime, stoptime, format=format) ; retreives data for parameters
;       if parameter = '' or undefined all parameters in dataset will be returned.
icase = n_params()
if KEYWORD_SET(capabilities) then icase =3
if n_params() eq 0 and KEYWORD_SET(capabilities) then icase =4
if KEYWORD_SET(format) eq 0 then format= 'csv' ; format = 'binary', format= 'jason'
;print,'idl-client version 0.1'
case icase  OF
0:return, cmb_hapi_listofservers(/list)
1:return, cmb_hapidatashop_catalog( server, plusinfo=info)
2:return, cmb_hapidatashop_info(dataset, server)
3:return, cmb_hapidatashop_capabilities( server)
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
      sdata = cmb_hapi_binary( server, dataset, parameters, dates, header=head, j= j)
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
; start IDL session
server = 'http://datashop.elasticbeanstalk.com/hapi'

dataset = 'CASSINI_MAG_HI_RES'

dates=['2004-183T00:00:00.000Z','2004-184T00:00:00.000Z']

varnames = ['Bx_SSO', 'By_SSO', 'Bz_SSO']

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

; to plot Bx component

dummy = LABEL_DATE(DATE_FORMAT=['%H:%I'])
apt = plot( CDF_EPOCH_TOJULDAYS(d.data.epoch), d.data.bx_sso, $
           ytitle= d.meta.bx_sso.name + ', ' + d.meta.bx_sso.units, $
           XTICKFORMAT='LABEL_DATE', $
           xtitle='HH:MM', title= dataset + '!c ' + dates[0] + ' to ' + dates[1] )
stop
end
