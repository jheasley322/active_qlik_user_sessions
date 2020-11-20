##  MAKE SURE TO REVIEW THIS AND REPLACE THE PLACE HOLDER TEXT WITH
##  THE VALUES THAT ARE RELEVANT TO YOUR DEPLOYMENT!!!


## enter the path for your certificate, the central node, and api service account user here
Get-PfxCertificate CERTIFICATE_PATH | Connect-Qlik -computername NODE.DOMAIN.COM -username DOMAIN\SERVICE_ACCT -TrustAllCerts -verbose

## enter a list of nodes that you want to check for activity
$nodes = @('node1','node2','node3')

## enter a filepath to where you want the CSV stored
$storepath = '\\path_of_file\folder\folder\'
$timeval =  get-date -format "MMddyyyyHHmm"

[System.Collections.ArrayList]$sessions = @()
foreach ($i in $nodes) {
## need to enter your domain here (i had trouble getting it to work with a variable)
    foreach ($user in Invoke-QlikGet -path https://$i.DOMAIN.COM:4747/engine/sessions | select-object -property userid,state,appid ) {
        $s = [PSCustomObject]@{
            Index              = "[$($sessions.Count+1)]" 
            ## UserId          = $user.UserId
            directory          = (($user.UserId.Split(";"))[0].Split("="))[1]
            user               = (($user.UserId.Split(";"))[1].Split("="))[1]
            state              = $user.state
            App                = $user.appid
            Server             = $i
            CallTime           = get-date -format "MM/dd/yyyy HH:mm"
        }
        $sessions.Add($s) | Out-Null
    } 
}

## here we are reducing the array to ONLY include users that are not from the INTERNAL udc
$updated_sessions = $sessions | Where-Object {$_.directory -notlike "*INTERNAL"}
$usercount = $updated_sessions.count 

## this displays the count of user sessions AND displays the array as a table
$usercount
$updated_sessions | Format-Table

## optional section, if there are more than 0 user sessions, write out the list to a CSV file for later analysis
if ( $usercount -ne 0 )
{
    $updated_sessions | export-csv -path $storepath\Sessions_$timeval_$usercount.csv
}
