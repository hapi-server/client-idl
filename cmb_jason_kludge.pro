function cmb_null_value, v
case cmb_var_type(v) of 
'STRING': return,''
else:return,0
ENDCASE
end

function cmb_jason_kludge,a
; a  is a string in jason format
; workaround for j = JSON_PARSE(strjoin(a), /tostruct,/toarray)
j = JSON_PARSE(strjoin(a), /tostruct)
tnames =  tag_names(j)
for itag0=0, n_elements(tnames)-1 do begin
	print, TYPENAME(j.(itag0))
	case TYPENAME(j.(itag0)) of
	'LIST':begin
		v =j.(itag0)
		n = n_elements(v)
		rec = v[0]
		; find all tag names within []
		for ik=0,n-1 do BEGIN
			tnv = tag_names(rec)
			tnames0 = tag_names(v[ik])
			v0 = v[ik]
			for jk=0, N_ELEMENTS(tnames0)-1 do begin
				 k=where( tnames0[jk] eq tnv)            
				 if k[0] eq -1 then rec = CREATE_STRUCT(rec,tnames0[jk], (v0.(jk))) 
			endfor
		endfor
		;set rec to fill (null) values
		for irec = 0l, N_TAGS( rec)-1 do rec.(irec) = cmb_null_value(rec.(irec)) 
		value = replicate(rec, n)
		;populate value
		tnv = tag_names(value)
		for ik=0,n-1 do BEGIN
			tnames0 = tag_names(v[ik])
			v0 = v[ik]
			for jk=0, N_ELEMENTS(tnames0)-1 do begin
				 k=where( tnames0[jk] eq tnv)            
				 if k[0] ne -1 then value[ik].(k[0]) =  v0.(jk)
			endfor
		endfor
		end
	ELSE: value = j.(itag0)
	ENDCASE
	if N_ELEMENTS(b) eq 0 then b = CREATE_STRUCT(  tnames[itag0], value) $
	                      else b = CREATE_STRUCT(b,tnames[itag0], value)
endfor
return, b
end


;IDL> j = JSON_PARSE(strjoin(a), /tostruct,/toarray)
;IDL> help,j
;** Structure <207f5e8>, 4 tags, length=472, data length=472, refs=1:
;   HAPI            STRING    '1.1'
;   CATALOG         STRUCT    -> <Anonymous> Array[13]
;   STATUS          STRUCT    -> <Anonymous> Array[1]
;   X_DEPLOYEDAT    STRING    '2017-02-21T12:23:53.323Z'
;IDL> help,j.status
;** Structure <2082768>, 2 tags, length=24, data length=24, refs=2:
;   CODE            LONG64                      1200
;   MESSAGE         STRING    'OK request successful'
;IDL> help,j.catalog
;<Expression>    STRUCT    = -> <Anonymous> Array[13]
