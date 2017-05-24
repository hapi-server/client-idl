; .compile cmb_hapidatashop.pro
function cmb_hapidatashop, id, varnames, dates, $
    serverid = serverid, $
    format= format, $
    listservers = listservers, $
    info = info, $
    capabilities=capabilities, $
    catalog = catalog, $
    data=data, head=head
; USAGE
; data = cmb_hapidatashop( id, varnames, dates, serverid = serverid)
; servers = cmb_hapidatashop( /listservers)
; capabilities = cmb_hapidatashop( /capabilities)
; catalog = cmb_hapidatashop(/catalog, /info)
; catalog = cmb_hapidatashop(id, serverid=serverid /info)
; INPUT
; dataset id  ; from http://datashopserver40.us-east-1.elasticbeanstalk.com/hapi
; varnames   ; list of variable names to request data for, if not specified data for all variable names will be downloaded.
; dates ; start/stop time of data to download in ZULU time i.e. 1999-07-01, 1999-07-01T12:00:00.000, 
; OUTPUT
; data ; structure whose elements are the variable names, which contain the data.
;      ; if not data exists for specified time range then a string message is returned
; KEYWORDS
;  serverid - if set specifies the server currently the first 3 intitial of the host's lastname.
;  catalogonly if set return lists of dataset ids
;  getinfo if set return structue of meta for the variable names for dataset id
;NOTES
;getdata='http://datashopserver40.us-east-1.elasticbeanstalk.com/hapi/data?id=ACE_4_MIN_MERGED_PLASMA&time.min=1999-07-01&time.max=1999-07-01T12:00:00.000&include=header'
;TYPES OF REQUESTS: /catalog, /info, /data
;REQUEST FIELDS: time.min, time.max, id=, include=header, parameters=
; hapidatashop.pro

if KEYWORD_SET(format) eq 0 then format= 'csv'
print,'idl-client version 0.1'

if KEYWORD_SET(listservers) then return, cmb_hapi_listofservers(/list)

server = cmb_hapi_listofservers(serverid)

if KEYWORD_SET(capabilities) then return, cmb_hapidatashop_capabilities( server)

if KEYWORD_SET(id) and KEYWORD_SET(info) then return, cmb_hapidatashop_info(id, server)

if KEYWORD_SET(catalog) then return, cmb_hapidatashop_catalog( server, plusinfo=info)

if n_elements(id) eq 0 then MESSAGE,' dataset id not specified'

url = cmb_hapi_form_data_request_url( server, id, dates, format, varnames) ; data request URL

case format OF
'csv': begin
        sdata = cmb_hapi_csv( url, header=head, j= j)
	    meta = cmb_hapivarinfo(id,head,info=info)
	end
'binary': BEGIN
		sdata = cmb_hapi_binary( url, header=head, j= j)
		meta = cmb_hapivarinfo(id,head,info=info)
	end
	else :begin
	   MESSAGE,' format not found: '+ format
	   return,0
	   end
ENDCASE

return, {data:sdata, meta: meta, info:info}
end
