; .compile cmb_hapi_binary.pro

function cmb_hapi_bytes_for_var_type, type, var
; nbytes = cmb_hapi_bytes_for_var_type( type, var)
	case type OF
	    'STRING': return, STRLEN(var)
		'BYTE': return,1
		'DOUBLE': return,8
		'FLOAT': return,4
		'INT': return,2
		'LONG': return,4
	endcase
end

function cmb_hapi_binary2structure, rec, bindata 
; not certain if tranpose and endian checks are needed
; s = cmb_hapi_binary2rec( rec, bindata )
si = n_tags(rec,/length) & si= si-1 ;Why I don't know
nrec = n_elements(bindata)*1./si
s = replicate(rec,nrec)
nt = N_TAGS( rec)
i0 = 0l
for irec =0l, nrec-1 do begin
for it=0l, nt-1 do BEGIN
    type = cmb_var_type( rec.(it))
    si = N_ELEMENTS(rec.(it))
    nbytes = cmb_hapi_bytes_for_var_type(type,rec.(it) )*si
    i1 = i0 + nbytes-1
    ;print,' irec,it =', irec,it,' i0,i1=',i0,i1,' ', 'type=',type,' bytes=',nbytes & stop
	case type OF
	    'STRING': rec.(it) = string( bindata[i0:i1])
		'BYTE': rec.(it) = bindata[i0:i1]
		'DOUBLE':rec.(it) = double( bindata[i0:i1] ,0,si )  
		;double( reform( data[i0:i1], [8,55] ), 0,55)
		'FLOAT':rec.(it) = float( bindata[i0:i1] ,0,si )
		'INT':rec.(it) = fix( bindata[i0:i1] ,0,si )
		'LONG':rec.(it) = long( bindata[i0:i1] ,0,si )
	endcase
    i0 = i1 + 1
    s[irec] = rec
ENDFOR
   help, string(rec.time) ;,rec,/str & stop
ENDFOR
return, s
end

function cmb_hapi_binary, url, header=header, j= j
; s = cmb_hapi_binary( url, header=header, j= j)
;url = 'http://datashop.elasticbeanstalk.com/hapi/data?id=CASSINI_LEMMS_PHA_CHANNEL_1_SEC&time.min=2002-01-02T00:00:00.000&time.max=2002-01-02T06:00:00.000&format=binary&include=header'
c = wget(url,/buffer)
;find end of header
bsearch = byte('"format": "binary"')
ii=where( bsearch[0] eq c)
help,ii
for i=1,n_elements(bsearch)-1 do begin
	k=where( bsearch[i] eq c[ii+1])
	ii = ii[k]+1
	help,ii
endfor
; end of header found
header = strsplit(string(c[0:ii]),'#',/ext)
bindata = c[ii+4:*]
j = JSON_PARSE(cmb_str_flatten(header) + ',', /tostruct)
;j = JSON_PARSE(cmb_str_flatten(header), /tostruct)
;for i=0,n_elements(j.parameters)-1 do print, j.parameters[i].type
rec = cmb_datastring2structrecord( header,/noepoch)
rec = create_struct('time',(BYTARR(j.parameters[0].length)),rec)
s = cmb_hapi_binary2structure( rec, bindata )
rec1 = {epoch:0d0, epochstring:''} ; remove bin time and add times in cdf_epoch and string
tnames = tag_names(s)
for i=1, n_tags(s[0])-1 do rec1 = CREATE_STRUCT( rec1, tnames[i], s[0].(i) )
s1 = REPLICATE(rec1, N_ELEMENTS(s))
s1.epochstring = string(s.(0))
s1.epoch  = cmb_timestring2nssdcepoch( s1.epochstring)
; cmb_string_list, s1.epochstring + ' ' + cmb_date(s1.epoch, format='yyyy ddd (mm/dd) hh:mm:ss.sss') ; check
for itag = 1, n_tags(s[0])-1 do s1.(itag+1) = s.(itag)
return,s1
end

;pro test_hapi_binary
;url = 'http://datashop.elasticbeanstalk.com/hapi/data?id=CASSINI_LEMMS_PHA_CHANNEL_1_SEC&time.min=2002-01-02T00:00:00.000&time.max=2002-01-02T06:00:00.000&format=binary&include=header'
;s = cmb_hapi_binary( url, header=header, j= j)
;
;id = 'CASSINI_LEMMS_PHA_CHANNEL_1_SEC'
;vars = ['A']
;dates = ['2015-11-01T00:00:00.000Z', '2015-11-02T00:00:00.000Z']
;dates = ['2002-01-02T00:00:00.000', '2002-01-02T06:00:00.000']
;d1 = cmb_hapidatashop( id,vars, dates, serverid='van', head=head,format='binary')
;
;d1 = cmb_hapidatashop( id,vars, dates, serverid='van', head=head,format='binary')
;d = cmb_hapidatashop( id,vars, dates, serverid='van') ; head=head, format='csv')
;help, d.data,d1.data, s,/str,head
;print, max(abs(s.a-d.data.a) ), max(abs(s.a-d1.data.a) )
;print, max(abs((s.a-d.data.a)/((s.a+d.data.a)>0.001)) ), max(abs((s.a-d1.data.a)/((s.a+d1.data.a)>0.001)) )                                       
;stop
;end
