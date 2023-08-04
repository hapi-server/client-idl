
;Caveat Emptor: this code was written by Scott Boardsen, Heliophysics Division, NASA/GSFC and UMBC/GEST.
function cmb_epoch0,yr0,doy0,tod0,skipy2k=skipy2k
; also see sab_epoch.pro which superceeds epoch0.pro
;return nssdc definition of epoch
;yr -4 digit year , this routine will not work for years lt 1950
;doy-doy of year (Jan 1 = 1)
;tod0 -time of day in seconds
yr=yr0
doy=doy0
if n_elements(tod0) eq 0 then tod0 = 0d0
tod=tod0
yr = yr mod 1900
if n_elements(skipy2k) eq 0 then begin 
   ii=where(yr lt 50) 
   if ii(0) ne -1 then yr(ii) = yr(ii) + 100 ;y2k modification
endif
;ep0 is epoch at start of 20th cent.
ep0 = 5.99582304d13
return,(yr*365d0 + fix((yr-1)/4)+ doy-1)*8.64d7 +tod*1000d0 + ep0
end

;pro cmb_epoch_test
;year = 2015
;month = 12
;dom = 30
;hour = 22
;minute = 26
;sec = 28.18
;cdf_epoch,/comp, ep0, year, month, dom, hour, minute, floor(sec), (sec-floor(sec))*1000.
;ep1 = cmb_epoch0(year,cmb_comp_doy(year, month,dom),cmb_tod1(hour,minute,sec))
;print, cmb_date(ep0,format='yyyy ddd (mm/dd) hh:mm:ss.sss')
;print, cmb_date(ep1,format='yyyy ddd (mm/dd) hh:mm:ss.sss')
;end
