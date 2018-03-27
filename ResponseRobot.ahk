Pause
loop 
{
Random, r_num, 1, 2
if r_num=1
  Butt=Left
else
  Butt=Right

Send {%Butt% down}
sleep 50
Send {%Butt% up}
sleep 200

Send {Space down}
sleep 50
Send {Space up}
sleep 200
}


F1::Pause
^w::Reload 
^E::ExitApp
; MsgBox %Butt%
;return
; ListVars
; Pause