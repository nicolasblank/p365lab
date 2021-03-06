#exchange-2019-smtp-relay-connector.ps1
#https://github.com/nicolasblank/p365lab/blob/main/Articles/exchange-2019-smtp-relay-connector.ps1
#Build the Practical 365 lab for "How to Configure Exchange Server 2016 for SMTP Anonymous Relay"

#This file uses the AutomateLab 2019 Exchange demo as a template
# https://github.com/AutomatedLab/AutomatedLab/blob/develop/Help/Wiki/SampleScripts/Introduction/en-us/07.3%20Exchange%202019%20Server%20and%20client%2C%20domain%20joined.md
#The file is customised to reflect the needs of the P365 article
#Customisations include:
#   Static IP addresses for all machines
#   Installation of MS Edge browser
#   Removal of Internet Explorer
#   Installation of Telnet


# IMPORTANT NOTE: You must have Exchange 2019 ISO or CU already available. Microsoft has limited Exchange 2019 access to VL & MSDN
# so it is not publicly available for download. Also note Exchange 2019 will only run on Windows 2019 Core or Desktop but not Nano
#
#Default Administrator password is Somepass1
#
New-LabDefinition -Name LabEx2019 -DefaultVirtualizationEngine HyperV -VmPath 'E:\AutomatedLab-VMs'

#defining default parameter values, as these ones are the same for all the machines
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:DomainName' = 'practical365lab.com'
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2019 Datacenter (Desktop Experience)'
}

Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.12.0/24

Add-LabMachineDefinition -Name Lab2019DC1 -Roles RootDC -Memory 1GB -IpAddress 192.168.12.3

#remove the ISOpath reference below since that breaks the lab
$role = Get-LabPostInstallationActivity -CustomRole Exchange2019 -Properties @{ OrganizationName = 'Practical365'} # ; IsoPath = "$labSources\ISOs\ExchangeServer2019-x64-CU9.iso" }

Add-LabMachineDefinition -Name Lab2019Ex1 -Memory 6GB -PostInstallationActivity $role IpAddress 192.168.12.4

Add-LabMachineDefinition -Name Lab2019Client -Memory 2GB -OperatingSystem 'Windows 10 Pro' -IpAddress 192.168.12.5

Install-Lab -NetworkSwitches -BaseImages -VMs -Domains -StartRemainingMachines 

#increase MaxEnvelopeSizeKb to 10240
Write-ScreenInfo -Message "Extending MaxEnvelopeSizeKb -Value 10240" 
Invoke-LabCommand -ScriptBlock {Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 10240 } -ComputerName (Get-LabVM) -PassThru -ActivityName 'Increase MaxEnvelopeSizeKb'

#install Microsoft Edge on all machines
Write-ScreenInfo -Message "Installing Microsoft Edge"
Install-LabSoftwarePackage -ComputerName (Get-LabVM) -Path $labSources\SoftwarePackages\MicrosoftEdgeEnterpriseX64.msi -CommandLine /q 

#Removing Internet Explorer from all machines
Invoke-LabCommand -ScriptBlock { dism  /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /norestart /quiet } -ComputerName  (Get-LabVM) -PassThru -ActivityName 'Remove Internet Explorer'

#Since We're testing email and all machines are Server 2019 or Windows 10, install Telnet on all machines
Install-LabWindowsFeature -FeatureName Telnet-Client -ComputerName (Get-LabVM)

Write-ScreenInfo -Message "Rebooting all VMs following browser changeover"
Restart-LabVM -ComputerName  (Get-LabVM) -Wait


Write-ScreenInfo -Message "Installing Exchange 2019"

Install-Lab -PostInstallations

Checkpoint-LabVM -All -SnapshotName 'Clean Install'

Show-LabDeploymentSummary -Detailed