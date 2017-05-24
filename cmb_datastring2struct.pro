function cmb_datastring2struct,data, head
; sdata = cmb_datastring2struct(data, head)
; PURPOSE
; convert data, header string arrays from HAPI to a structure of data values
; INPUT
; head - data header stripped form the data string from HAPI with leading '#' stripped.
; data - string array of data values
; OUTPUT
; sdata - is a structure of data values

n = n_elements(data)
m = n_elements(strsplit( data[0],',',/ext))
rec = cmb_datastring2structrecord( head,m)
nrec = cmb_n_elements_in_record( rec)
sdata = replicate(rec,n)
for i =0, n-1 do begin
    x = strsplit( data[i],',',/ext)
    ;help, x, data & stop
    x = ['0d0',x]
    nx = n_elements(x)
    if nx ne nrec then x = [x, strarr(abs(nrec-nx)) + '0d0'] ; kludgd due to error in header information
    reads,x, rec    ;for j =0,m-1 do rec.(j) = x[j]
    ;help,x, rec, /str & stop ; debug 
    sdata[i] = rec
endfor
sdata.epoch = cmb_timestring2nssdcepoch( sdata.epochstring)
return, sdata
end
