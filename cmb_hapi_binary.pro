; .compile cmb_hapi_binary

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
; s = cmb_hapi_binary2structure( rec, bindata )
;;si = n_tags(rec,/length) & si= si-1 ;Why I don't know
;;nrec = n_elements(bindata)*1./si
nrec = n_elements(bindata)*1./n_tags(rec,/data_length)
s = replicate(rec,nrec)
ntags = N_TAGS( rec)
i0 = 0l
for irec =0l, nrec-1 do begin
for it=0l, ntags-1 do BEGIN
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
   ;help, string(rec.time),rec,/str & stop
ENDFOR
return, s
end


function cmb_hapi_binary, server, dataset, parameters_in, dates, header=header, j= j
; s = cmb_hapi_binary( server, dataset, parameters, dates, header=header, j= j))
help, server, dataset, parameters, dates
urlheader = server + '/info?id=' + dataset
if N_ELEMENTS(parameters_in) ne 0 then BEGIN
	parameters=''
 for i=0, N_ELEMENTS(parameters_in)-1 do parameters = parameters +',' + parameters_in[i]
 parameters = strmid(parameters,1)
 urlheader = urlheader + '&parameters=' + parameters
endif
openw,/get_lun,/append,lun,'hapidatarequests.txt'
	printf,lun, urlheader
free_lun,lun
header = wget(urlheader,/string)

url = cmb_hapi_form_data_request_url( server, dataset, dates, 'binary', parameters, /noheader) ; data request URL

openw,/get_lun,/append,lun,'hapidatarequests.txt'
	printf,lun, url
free_lun,lun

case 1 of
0: bindata = wget(url,/buffer)
1: begin
    fbin = 'data_' + dataset + '_' + cmb_date( systime(/jul), /time_in_julday, format='yyyymmddhhmmss.sss' )
    dummy = wget(url, file=fbin)
		bindata = read_binary(fbin)
		help, fbin
		;help, bindata, fbin & stop
		; then delete
   end
endcase
;

j = JSON_PARSE(cmb_str_flatten(header) + ',', /tostruct)
rec = cmb_datastring2structrecord( header,/noepoch)
ip = strpos(string(bindata[0:40]),'Z') ; end of time tag
rec = create_struct('time',(BYTARR(ip+1)),rec)
s = cmb_hapi_binary2structure( rec, bindata )
rec1 = {epoch:long64(0), epochstring:''} ; remove bin time and add times in cdf_epoch and string
tnames = tag_names(s)
for i=1, n_tags(s[0])-1 do rec1 = CREATE_STRUCT( rec1, tnames[i], s[0].(i) )
s1 = REPLICATE(rec1, N_ELEMENTS(s))
s1.epochstring = string(s.(0))
;s1.epoch  = cmb_timestring2nssdcepoch( s1.epochstring)
;s1.epoch =  CDF_PARSE_TT2000(s1.epochstring)
s1.epoch = cmb_hapi_timeformat(s1.epochstring)
; cmb_string_list, s1.epochstring + ' ' + cmb_date(s1.epoch, format='yyyy ddd (mm/dd) hh:mm:ss.sss') ; check
for itag = 1, n_tags(s[0])-1 do s1.(itag+1) = s.(itag)
return,s1
end
