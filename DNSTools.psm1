$copywrite = "All Rights Reserved Talkingbytes.co.uk October 2024"
$hyphens = "----------"

function Get-SPF {

<#
.SYNOPSIS
Get-SPF is a quick and easy tool for returning SPF records for domains

.INPUTS
Simply enter get-spf talkingbytes.co.uk

.Description
Get-SPF is part of DNSTools Module, Please see https://www.talkingbytes.co.uk/dnstools for more info.

Get-SPF can be used for returning Sender Policy Framework replies for domains.

Entering for instance:-
get-spf talkingbytes.co.uk
v=spf1 include:_spf.thenetworkisdown.co.uk -all

I'm always looking to expand on these tools so check out talkingbytes.co.uk for more details.

Copyright Talkingbytes.co.uk October 2024, All rights reserved

.link

https://www.talkingbytes.co.uk/dnstools

.example

Get-SPF talkingbytes.co.uk

#>

    param (
        $domain
    )
$spffinal = ""



Try {
$domaintxt = resolve-dnsname -name $domain -type txt -erroraction stop
}
Catch {
				if ($domaintxt -like "*DNS name does not exist*") {
				$domaintxt = "BadDomain"
				}

}






	$count = 0
		for(;;)
		{



				if ($domaintxt -eq $null) {
				break
				}

				if ($domaintxt -like "*BadDomain*"){
				$spf = "Invalid Domain"
				$count = "10"
				break
				}

		$command = $domaintxt[$count].strings
			


				if ($command -like "*v=spf1*"){
				$spf = $command
				$outputdomain = $domaintxt[$count].name
				break
				}
				
				if ($command -like "*,*"){
				$spf = $command
				write-output "SPF has a comma"
				break
				}
	
				if ($count -eq "50") {
				$spf = "No SPF Found"
				break
				}



				$count = $count + 1
		}
write-output $spf
}


function Get-DMARC {


<#

.SYNOPSIS
Get-Dmarc is a quick and easy tool that can query domain DMARC records.

.INPUTS
Usage get-dmarc talkingbytes.co.uk [optional -full 1]

.Description
Get-Dmarc is part of DNSTools Module, Please see https://www.talkingbytes.co.uk/dnstools for more info.


Simply enter "get-dmarc talkingbytes.co.uk" or get-dmarc -domain talkingbytes.co.uk to view DMARC details for a domain.

By Default, get-Dmarc will only return shortened replies:-
Dmarc Reject
Dmarc Quarantine
No Dmarc
Domain exists: Dmarc isn't setup

You can add "-full 1" to the end of the command to display full Dmarc Record

The shorter replies may be useful if you're exporting to CSV for example.

Copyright Talkingbytes.co.uk October 2024, All rights reserved

.link

https://www.talkingbytes.co.uk/dnstools

.example

 get-dmarc talkingbytes.co.uk


This will return a reply like the below (all possible options listed in get-help get-dmarc:-

Dmarc Reject.

.example

get-dmarc talkingbytes.co.uk -full 1


This will Return:-

Dmarc Reject.
v=DMARC1; p=reject; rua=mailto:dmarc_agg@vali.email; ruf=mailto:rufreports@thenetworkisdown.co.uk sp=reject; fo=1 pct=100; adkim=s; aspf=s;






#>




    param (
# Use Get-Dmarc talkingbytes.co.uk.
[parameter(Mandatory=$True)][string]$domain,
#Add -full 1 for full dmarc record. By default we'll return shorter reply.
[parameter(Mandatory=$false)][boolean]$full

#Some text here, wonder what will happen now.
    )



$appendstring = "_dmarc."
$dmarcurl = $appendstring + $domain
$dmarcfinal = ""



			if($full -eq "1") {
write-host -backgroundcolor black -foregroundcolor white "Full DMARC record will be output below"

}

else {
write-host -backgroundcolor black -foregroundcolor white "Try adding -full 1 to your command to show the complete DMARC Record"
}

if ($domain -eq $null) {

write-output "No domain specified. Please check get-help get-dmarc for assistance."
break

}


Try {
$dmarc = resolve-dnsname -name $dmarcurl -type txt -erroraction stop

}
Catch {
				if ($dmarc -like "*DNS name does not exist*") {
				$dmarc = "No DMarc Record"
				#write-output "no dmarc record"
				write-host -backgroundcolor black -foregroundcolor white "No DMARC Record"






				}
}

$dmarcfull = $dmarc



				if ($dmarc -eq $null) {
				#write-output "Domain exists: Dmarc isn't setup"
				$dmarc = "Dmarc Not Setup"
				write-host -backgroundcolor black -foregroundcolor white "Domain Exists: DMARC isn't setup."
				}



				if ($dmarc -like "*DNS name does not exist*") {
				$dmarc = "No DMarc Record"
				#write-output "no dmarc record"
				write-host -backgroundcolor black -foregroundcolor white "No DMARC Record!"



				}


				if ($dmarc.strings -like "* p=reject*") {
				$dmarc = "Dmarc Reject"
				#write-output "Dmarc Reject"
				write-host -backgroundcolor black -foregroundcolor green "Dmarc Reject"

				}


				if ($dmarc.strings -like "* p=quarantine*") {
				$dmarc = "Dmarc Quarantine"
				#write-output "Dmarc Quarantine"
				write-host -backgroundcolor black -foregroundcolor Yellow "Dmarc Quarantine"
						}





				if ($dmarc.strings -like "*p=none*") {
				#write-output "Dmarc Report Only"
				write-host -backgroundcolor black -foregroundcolor red "Dmarc Report Only"
			
				$dmarc = "Dmarc is Report-Only"
				
}else {
				$dmarcfinal = $dmarc.strings
				write-output $dmarcfinal
				$dmarc = "cheese"
				}

			if($full -eq "1") {
			#write-output $dmarcfull.strings
			write-host -backgroundcolor black -foregroundcolor green $dmarcfull.strings
			}



#write-output $dmarc
}


function Get-MX {

<#
.SYNOPSIS
Get-MX, Part of the DNSTools package is designed to be a quick and simple command for obtaining MX records for a domain.

.INPUTS
Simply enter get-MX talkingbytes.co.uk to obtain MX records for talkingbytes.co.uk.

.Description
Get-MX is part of DNSTools Module, Please see https://www.talkingbytes.co.uk/dnstools for more info.

Get-MX can be used for returning MX records for a domain.

Copyright Talkingbytes.co.uk October 2024, All rights reserved

.link

https://www.talkingbytes.co.uk/dnstools

.example

Get-MX talkingbytes.co.uk

#>




    param (
        $domain
    )


write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-output "Obtaining MX Records for domain"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -foregroundcolor Yellow -backgroundcolor black $domain
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
Try {
$domainoutput = resolve-dnsname -name $domain -type mx -erroraction silentlycontinue
}
Catch {
				if ($error -like "*DNS name does not exist*") {
				$domainoutput = "BadDomain"
				}


$type = Resolve-DnsName -type mx -name $domain | select type

if ($type.type -is "*SOA*") {
				$domainoutput = "Only SOA record returned - This domain has no MX Records."
				}

}
Write-output "Domain Output is below"

write-output $domainoutput
}

function get-allemail {

<#
.SYNOPSIS
Get-Allemail allows you to specify a domain and get the response for get-mx, get-spf and get-dmarc from one command.

If you add -full 1 to your command this will be passed through to the get-dmarc command

.INPUTS
Simply enter get-allemail talkingbytes.co.uk to get all relevant dns responses for this domain. As with Get-dmarc, you can add -full 1 to the end to get the full DMARC reply.

.Description
Get-allemail is part of DNSTools Module, Please see https://www.talkingbytes.co.uk/dnstools for more info.

.link

https://www.talkingbytes.co.uk/dnstools
#>
  param (
        $domain,
	[parameter(Mandatory=$false)][boolean]$full
    )
cls
if ($domain) { '' }
else { write-output "No domain specified, We'll use domain talkingbytes.co.uk for example."
			write-output "Please see Get-help get-allemail for information but command usage is 'get-allemail talkingbytes.co.uk' "
			$domain = "talkingbytes.co.uk" }



write-host -backgroundcolor black -foregroundcolor Yellow "Getting DNS Records for:"
write-host -backgroundcolor yellow -foregroundcolor black $domain
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens


write-host -backgroundcolor black -foregroundcolor Green "MX Records:"
get-mx $domain
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "SPF:"
get-spf $domain
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
		

write-host -backgroundcolor black -foregroundcolor Green "DMARC:"

if($full -eq "1") {
			get-dmarc $domain -full 1
			}

else {
get-dmarc $domain
}


write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor yellow -foregroundcolor Black "All completed now, If you've found this useful and have any suggestions for how we can improve this module please email suggestions@talkingbytes.co.uk"
}


function DNSTools {


$yellow = "-backgroundcolor black -foregroundcolor Yellow"

write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Blue "DNSTools includes a number of tools, primarily for email related tasks currently, DMARC, MX records, SPF"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Yellow "MX Record checks"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "Simply type GET-MX talkingbytes.co.uk to see the MX records for this domain"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
get-mx talkingbytes.co.uk
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Yellow "SPF Checks"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "Simply type GET-SPF talkingbytes.co.uk to see the MX records for this domain"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
get-spf talkingbytes.co.uk
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Yellow "DMARC Checks"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "Simply type GET-DMARC talkingbytes.co.uk to see the MX records for this domain"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
get-dmarc talkingbytes.co.uk
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "Note: By Default Get-Dmarc will simply return a summary, such as DMARC not applied, or domain doesn't exist."
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "We can add -full 1 to the end of the command to return the complete output"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
get-dmarc talkingbytes.co.uk -full 1
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Yellow "All emails checks"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens
write-host -backgroundcolor black -foregroundcolor Green "If you wanted to return spf, mx and dmarc in the same query then simply enter"
write-host -backgroundcolor black -foregroundcolor Green "get-allemail talkingbytes.co.uk"
write-host -backgroundcolor black -foregroundcolor Yellow $hyphens


write-host -backgroundcolor black -foregroundcolor Red "We're always keen to hear suggestions on how we can improve these tools so for now please email suggestions@talkingbytes.co.uk."
write-host -backgroundcolor black -foregroundcolor Red "We hope you enjoy using these tools."
write-host -backgroundcolor yellow -foregroundcolor black $copywrite
}





export-modulemember -function get-spf
export-modulemember -function get-dmarc
export-modulemember -function get-mx
export-modulemember -function get-allemail
export-modulemember -function DNSTools
