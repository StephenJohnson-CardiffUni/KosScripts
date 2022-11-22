clearscreen.

             //User extraction

print "Welcome user!"
print "Please remain calm during this information extraction process".
wait(2).

//build a gui box

LOCAL ControlBox is GUI(200).

LOCAL label is ControlBox:ADDLABEL("Desired AP").
set label:style:align to "center".

local textBoxAP is ControlBox:addTextField("Ap in Km").
local textBoxInc is ControlBox:addTextField("Inclination in Degrees").

LOCAL confirm is ControlBox:addButton("Confirm").

ControlBox:show().

local hasPress is FALSE.

function confirmPressed {//need many error checks must be number
   set desiredAP to textBoxAP:text:tonumber().
   set desiredInc to textBoxInc:text:tonumber().
   print "Pressed".
   set hasPress to TRUE.
}

set Confirm:onclick to confirmPressed@. 

wait until hasPress.

ControlBox:hide().
ControlBox:Dispose().


                 //launch prep

lock throttle to 1.0.


print "Counting Down..".
from {local countdown is 5.} until countdown = 0 step{set countdown to countdown -1.} do {
	print countdown.
	wait 1.	
}


//if on pad, stage

IF SHIP:STATUS = "PRELAUNCH" {
	print "Staging".
	stage.
}


//global staging
WHEN STAGE:SOLIDFUEL < 0.001 THEN {
	print "Solids done".
	stage.
	wait 1.
	IF STAGE:SOLIDFUEL > 0.001 {
		PRESERVE.
		print "Next Solid Stage Found".
		}
	}

WHEN STAGE:DELTAV:CURRENT < 1 THEN {
	print "Staging".
	stage.
	wait 1.
	preserve.	
}.


print "Guidence systems active".
until SHIP:APOAPSIS > desiredAP {
	IF SHIP:VELOCITY:SURFACE:MAG < 100 {

	set mysteer to heading(desiredInc,90). //heading(dir,alt)
	lock steering to mysteer.

	} else if SHIP:VELOCITY:SURFACE:MAG > 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {

	set mysteer to heading(desiredInc,70). 
	lock steering to mysteer.
	

	} else if SHIP:VELOCITY:SURFACE:MAG > 200 and SHIP:VELOCITY:SURFACE:MAG < 1000{

	set steering to SRFPROGRADE.

	} else if SHIP:VELOCITY:SURFACE:MAG > 1000 {

	set steering to prograde.
	
	}.
}.


PRINT "AP Reached".
LOCK throttle to 0.0.

set desiredAPTol to desiredAP - 1.

UNTIL SHIP:PERIAPSIS >= desiredAPTol {

	if ETA:APOAPSIS > 15 and ETA:APOAPSIS < 3000 {

	set steering to prograde.

	} else if ETA:APOAPSIS < 15 and ETA:Apoapsis > 10 {
	
	set steering to prograde.
	set throttle to 0.5.
	wait 0.1.
	
	} else if ETA:APOAPSIS < 10 and ETA:Apoapsis > 0 {
	
	set steering to prograde.
	set throttle to 1.0.
	wait 0.1.
	
	} else if ETA:APOAPSIS > 3000 {

	set steering to heading(desiredInc,10).
	set throttle to 1.0.

	}.

}.

LOCK throttle to 0.0.
print "Circular".
unlock all.