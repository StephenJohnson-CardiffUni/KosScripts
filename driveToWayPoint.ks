//brakes on.  brakes off. toggle brakes.
//set wheelthrottle to 0-1.

brakes on.
sas off.


//find waypoint
set fullList to allwaypoints().
set filteredList to fulllist:copy.

//removing all the stock waypoints
for point in fulllist{
   if point:name = "Island Airfield" {
      filteredList:remove(filteredList:find(point)).
   } else if point:name = "KSC" {
      filteredList:remove(filteredList:find(point)).
   } else if point:name = "Woomerang Launch Site"  {
      filteredList:remove(filteredList:find(point)).
   } else if point:name = "Dessert Airfield" {
      filteredList:remove(filteredList:find(point)).
   } else if point:name = "Dessert Launch Site" {
      filteredList:remove(filteredList:find(point)).
   } else if point:name = "Cove Launch Site" {
      filteredList:remove(filteredList:find(point)).
   }
}


lock wheelsteering to filteredList[0]:geoposition:heading.
brakes off.
until filteredList:length = 0 {

   clearscreen.
   print filteredlist[0].
   print "Distance to target:".
   print filteredList[0]:geoposition:distance.
   print "heading: " + filteredList[0]:geoposition:heading.
   print "facing:  " + SHIP:FACING
   
   if filteredList[0]:geoposition:distance  > 10 { 
      brakes off.
      if SHIP:GROUNDSPEED < 30 {set wheelthrottle to 0.5.}
      else if  SHIP:GROUNDSPEED > 40 {Brakes on.}
      else {set wheelthrottle to 0.}

   }else if filteredList[0]:geoposition:distance  < 10 {
      set wheelthrottle to 0. 
      brakes on. 
      filteredList:remove(0).
   }
   wait(0.01).
}

//crashes when last item removed. 
//Also wild hunting behaviour from locking steering to heading