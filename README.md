# active_qlik_user_sessions
powershell script using qlik-cli to get a list of curently active user sessions (excludes service accounts)

##  this script was developed as a lightweight and fast way of knowing
##  what users are are currently online, and how many sessions they 
##  currently have active.  the moitoring apps can do this as well, but 
##  are typically a little bit behind what an actual real-time request 
##  would show.  there is also an option to write out a simple CSV so
##  that lightweight user activity apps can be built in conjunction
##  with what this script can see.  when using the CSV output function, 
##  this script becomes particularly useful if placed on a machine that
##  can have it run on a schedule, then tie the output files to a 
##  qlik app. feel fre to use this as you see fit and alo to send me
##  feedback on it!
