function cmb_timestring2nssdcepoch, epochstring
; epoch = cmb_timestring2nssdcepoch( epochstring)
; PURPOSE
; convert time as string to NSSDC epoch- CDF_EPOCH
; i.e. epochstring = '1999-182T00:00:00.000', '1966-06-09T00:00:00.000'
; NOTES
; a = strsplit('1999-182T00:00:00.000','-T:',/extract)
n = n_elements( epochstring)
epoch = dblarr(n)
for i=0, n-1 do begin
    a = strsplit(epochstring[i],'-TZ:',/extract)
    case n_elements(a) of
		5: begin ;'1999-182T00:00:00.000'
			cdf_epoch,ep0, long(a[0]),/comp
			ep0 = ep0 + (long(a[1])-1)*24*3600d3 + cmb_tod(a[2], a[3], a[4] )*1d3
		end
		6: begin ; i.e. '1966-06-09T00:00:00.000'		    
			cdf_epoch,ep0, long(a[0]), long(a[1]), long(a[2]), /comp
			ep0 = ep0 + cmb_tod(a[3], a[4], a[5] )*1d3	
		end
		else: ep0 = -1d0
	endcase
	;print, cmb_date(ep0,format='yyyy ddd (mm/dd) hh:mm:ss.sss')	
	;print, epochstring[i]
	epoch[i] = ep0
ENDFOR 
return, epoch
end
