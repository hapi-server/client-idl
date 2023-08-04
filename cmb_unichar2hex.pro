; .compile cmb_unichar2hex.pro
function cmb_unichar2hex, vname, character_type
; USEAGE: vnameout = cmb_unichar2hex(vname,character_type)
; PURPOSE: test if variable name is not ascii, if not replace with hexdecimal equivalent.
character_type='ascii'
b = byte(vname)
i=where( b gt 127b ) ; test if in unicode range
if i[0] eq -1 then return, vname

character_type='unicode' ; out side of ascii range
hexmap = [string(lindgen(10), format='(i1)'), 'A','B','C','D','E','F']
h0 = b/16
h1 = b-h0*16
vnamehex = 'U_'
x= hexmap[h0] + hexmap[h1]
for i=0, n_elements(b)-1 do vnamehex = vnamehex + x[i]
return, vnamehex
end

pro test_cmb_unichar2hex
vname = 'Mary had a little lamb!'
print, 'input variable name : ', vname
print, 'output variable name: ', cmb_unichar2hex(vname, character_type),' ', character_type
print,' '
vname = '角度'
print, 'input variable name : ', vname
print, 'output variable name: ', cmb_unichar2hex(vname, character_type),' ', character_type
end
