;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

; .compile cmb_epoch_modify.pro
function cmb_epoch_modify, epoch_in, cdfepochtypeout=cdfepochtypeout, tt2000output = tt2000output, idebug=idebug
; Example usage
; ;
; epoch_out = cmb_epoch_modify(epoch_in)
; epoch_out = cmb_epoch_modify(epoch_in, cdfepochtypeout='CDF_EPOCH16')
; epoch_out = cmb_epoch_modify(epoch_in, cdfepochtypeout='CDF_TIME_TT2000')
;
; if keyword cdfepochtypeout is set then convert epoch_in to epoch of type cdfepochtypeout
;INPUT
; epoch_in is an NSSDC epoch of three possible types:['CDF_EPOCH','CDF_EPOCH16','CDF_TIME_TT2000']
;KEYWORDS
; cdfepochtypeout can have a value of ['CDF_EPOCH','CDF_EPOCH16','CDF_TIME_TT2000']
; whose idl type is ['DOUBLE','LONG64','DCOMPLEX']

; if cdfepochtypeout is not set then
;convert epoch_in to standard epoch CDF_EPOCH which is double precision.
;if cdftype is CDF_TIME_TT2000 then return nssdc epoch as long64
;if cdftype is CDF_EPOCH16 then return nssdc epoch as double precision complex
;return nssdc epoch as the standard double precision value

if n_params() ne 1 then begin
   print,'USAGE of cmb_epoch_modify'
   print,'     epoch_out = cmb_epoch_modify(epoch_in,cdfepochtypeout=cdfepochtypeout)'
   print,'     If keyword cdfepochtypeout set, it must be set to one of the following values:'
   print,"        'CDF_EPOCH','CDF_EPOCH16','CDF_TIME_TT2000'"
   print,'     If keyword tt2000output set then output will be in CDF_TIME_TT2000'
   return,'INPUT VARIABLES NEEDED FOR cmb_epoch_modify'
endif
cdfepochtypein = cmb_epoch_type(epoch_in)
if KEYWORD_SET(idebug) then stop
if KEYWORD_SET( tt2000output ) then cdfepochtypeout = 'CDF_TIME_TT2000'
if keyword_set( cdfepochtypeout ) then begin

  if cdfepochtypein eq cdfepochtypeout then return, epoch_in

  case cdfepochtypein of
  'CDF_EPOCH':begin
      cdf_epoch,epoch_in,yr,month,dom,hr,minu,sec,msec, /break
      end
  'CDF_TIME_TT2000':begin
      CDF_TT2000,epoch_in,yr,month,dom,hr,minu,sec,msec,microsec,nanosec, /break
      end
  'CDF_EPOCH16':begin
      cdf_epoch16,epoch_in,yr,month,dom,hr,minu,sec,msec,microsec,nanosec, picosec, /break
      end
  endcase

  if n_elements(microsec) eq 0 then microsec=msec*0
  if n_elements(microsec) eq 0 then microsec=msec*0
  if n_elements(nanosec) eq 0 then nanosec = msec*0
  if n_elements(picosec) eq 0 then picosec=msec*0

;help, cdfepochtypein, cdfepochtypeout, yr, month, dom, hr, minu, sec, msec, microsec, nanosec, picosec & stop

  case cdfepochtypeout of
  'CDF_EPOCH':begin
      cdf_epoch, epoch, yr, month, dom, hr, minu, sec, msec, /comp
      end
  'CDF_TIME_TT2000':begin
      CDF_TT2000, epoch , yr , month, dom, hr, minu, sec, msec, microsec, nanosec, /comp
      end
  'CDF_EPOCH16':begin
      cdf_epoch16, epoch, yr, month, dom, hr, minu, sec, msec, microsec, picosec, /comp
      end
  endcase
  return,epoch
endif

ich = (cmb_var_type(epoch_in) eq 'LONG64') or  (cmb_var_type(epoch_in) eq 'DCOMPLEX')
if ich eq 0 then return,epoch_in

case cmb_var_type(epoch_in) of
'LONG64':begin
    CDF_TT2000,epoch_in,yr,month,dom,hr,minu,sec,msec,microsec,nanosec, /break
;    cdf_epoch,epoch,yr,month,dom,hr,minu,sec,msec,/comp
;    epoch1 = epoch + (microsec+nanosec/1d3)/1d3
if n_elements(picosec) eq 0 then picosec=msec*0
; help, yr, month, dom, hr, minu, sec, msec, microsec, nanosec, picosec

    epoch = sab_cdf_epoch(yr,month,dom,hr,minu,sec,msec,microsec,nanosec)
end
'DCOMPLEX':begin
    cdf_epoch16,epoch_in,yr,month,dom,hr,minu,sec,msec,microsec,nanosec, picosec, /break
    cdf_epoch,epoch,yr,month,dom,hr,minu,sec,msec+(microsec+nanosec/1d3 + picosec/1d6)/1d3,/comp
end
endcase
return,epoch
end
