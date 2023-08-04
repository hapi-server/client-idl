; .compile nyquist_frequency
function nyquist_frequency, epoch, dt = dt, timeunits=  timeunits, idebug=idebug
; fnyquist = nyquist_frequency(epoch,dt=dtmedian)
if n_elements(epoch) lt 2 then begin
	print,'not enough data points to compute nyquist frequency returning NAN'
	return, !values.f_nan
endif

dts = dt_calc(epoch)
dt = median(dts )
if cmb_var_type(epoch) eq 'LONG64' then cal = 1d9 else cal = 1d3
if KEYWORD_SET(timeunits) then begin
   case STRLOWCASE( timeunits) OF
   'sec': cal =1d0
   'msec': cal = 1d3
   'nsec': cal= 1d9
   ENDCASE
endif
print, 'time conversion cal=', cal
fnyquist = 1.0/(2*dt/cal) ;HZ
dt = dt/cal
print,'min, max, mean, median of dts:', min(dts), max(dts), mean(dts), median(dts)
print,'Nyquist Frequency: ', fnyquist, ' Hz', ' dt =', dt, ' sec'
if KEYWORD_SET(idebug) then message,'nyquist_frequency: stopped because idebug set'
return, fnyquist
end
