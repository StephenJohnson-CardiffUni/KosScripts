clearscreen.

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
	}

WHEN STAGE:DELTAV:CURRENT < 1 THEN {
	print "Staging".
	stage.
	wait 1.
	preserve.	
}.


print "Guidence systems active".
until SHIP:APOAPSIS > 100000 {
	IF SHIP:VELOCITY:SURFACE:MAG < 100 {

	set mysteer to heading(90,90). //heading(dir,alt)
	lock steering to mysteer.

	} else if SHIP:VELOCITY:SURFACE:MAG > 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {

	set mysteer to heading(90,70). 
	lock steering to mysteer.
	

	} else if SHIP:VELOCITY:SURFACE:MAG > 200 and SHIP:VELOCITY:SURFACE:MAG < 1000{

	set steering to SRFPROGRADE.

	} else if SHIP:VELOCITY:SURFACE:MAG > 1000 {

	set steering to prograde.
	
	}.
}.


PRINT "AP Reached".
LOCK throttle to 0.0.


UNTIL SHIP:PERIAPSIS >= 99999 {

	if ETA:APOAPSIS > 15 and ETA:APOAPSIS < 300 {

	set steering to prograde.

	} else if ETA:APOAPSIS < 15 and ETA:Apoapsis > 10 {
	
	set steering to prograde.
	set throttle to 0.5.
	wait 0.1.
	
	} else if ETA:APOAPSIS < 10 and ETA:Apoapsis > 0 {
	
	set steering to prograde.
	set throttle to 1.0.
	wait 0.1.
	
	} else if ETA:APOAPSIS > 300 {

	set steering to heading(90,10).
	set throttle to 1.0.

	}.

}.

LOCK throttle to 0.0.
print "Circular".
unlock all.