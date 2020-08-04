;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_tag_name_exists, tag_name, s, i0
; istat = cmb_tag_name_exists(tag_name, s, i0)
;determine if structure 's' contains tag name 'tag_name'
i0 = -1 ; ; added SAB 2018/10/01
if N_PARAMS() lt 2 then $
    message, 'cmb_tag_name_exists, tag_name, s,i0; the first 2 variable must be specified, stopping code' ; added SAB 2018/09/26
if cmb_var_type(tag_name) ne 'STRING' then $ ; SAB 2018/09/30
    message,'cmb_tag_name_exists, tag_name, s,i0; tag_name must be a string, stopping code'; ; added SAB 2018/09/26, 2018/10/03 
if cmb_var_type(s) ne 'STRUCT' then begin ; added SAB 2018/10/01
   ;print, 'In cmb_tag_name_exists, tag_name, s; s is not a structure, returning 0'  ; 
   return,0
endif
 name = strlowcase(tag_name)
 names = strlowcase(tag_names(s))
 i0 =(where( name eq names) )(0)
if i0 ne -1 then return,1
return,0
end
