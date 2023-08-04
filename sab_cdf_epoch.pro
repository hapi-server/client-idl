
; .compile sab_cdf_epoch.pro

function sab_cdf_epoch, yr, month, dom, hr, minu, sec, msec, microsec, nanosec, picosec, idebug=idebug
; purpose add a little ~0.2 millsec more precision to cdf_epoch
; epoch = sab_cdf_epoch(yr,month,dom,hr,minu,sec,msec,microsec,nanosec)
  if n_elements(microsec) eq 0 then microsec=msec*0
  if n_elements(microsec) eq 0 then microsec=msec*0
  if n_elements(nanosec) eq 0 then nanosec = msec*0
  if n_elements(picosec) eq 0 then picosec=msec*0
cdf_epoch, epoch, yr, month, dom, hr, minu, sec, msec,/comp
epoch = epoch + (microsec+nanosec/1d3)/1d3
if KEYWORD_SET(idebug) then stop
return, epoch
end
