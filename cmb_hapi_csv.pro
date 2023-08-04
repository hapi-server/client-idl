function cmb_hapi_csv, url, header=head, j= j
; s = cmb_hapi_csv( url, header=header, j= j)
		data = wget( url, /string)
		; separate header from data
		ip = where( strmid(data,0,1) eq '#')
		head = data[ip]
		head = strmid(head,1) ; remove '#'
		if max(ip) +1 gt N_ELEMENTS(data) then begin ; no data for requested time range'
			smessage = 'For id: '+ id + ' no data returned for requested time range:' $
					 + dates[0] + ' to ' + dates[1]
			return, smessage
		endif
		data = data[ max(ip) +1:*]
	    sdata = cmb_datastring2struct(data, head)
return, sdata
end
