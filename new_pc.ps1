#Get current PC name
$current_name = $env:COMPUTERNAME

#Ask if user would like to change PC name
$change_name = Read-Host -Prompt "The current machine name is $current_name, Would you like to change it? (y or n)"

if ($change_name -eq "y"){
    #Get new machine name
    $new_machine_name = Read-Host -Prompt "Input the new machine name."
    # Rename machine
    Write-Output "Renaming machine"
    Rename-Computer -NewName $new_machine_name
}

Function Get-NewTimeZone {
    $zone=Read-Host "
    1 - Eastern
    2 - Central
    3 - Mountain
    4 - Pacific
    Please Choose"
    Switch ($zone){
        1 {$choice="Eastern Standard Time"}
        2 {$choice="Central Standard Time"}
        3 {$choice="Mountain Standard Time"}
        4 {$choice="Pacific Standard Time"}
    }
    return $choice
}

$new_time_zone=Get-NewTimeZone

#disable UAC
Write-Output "Disabling UAC"
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

# Change Power Settings
Write-Output "Adjusting power settings"
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

#Turn Off Windows Firewall
Write-Output "Turning off Windows Firewall"
set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False 

# Enabling RDP
Write-Output "Enabling RDP"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

# Set Time Zone
Write-Output "Setting Time Zone to:" $new_time_zone
Set-TimeZone -Id $new_time_zone

#Enable System Restore
Write-Output "Ensuring System Restore is Enabled"
Checkpoint-Computer -Description "Origin"

#Running Software installers
Write-Output "Installing Basic Software"
.\ninite
.\adobe

<<<<<<< HEAD
Write-Output "Please Allow Ninite and Adobe Installs to complete before continuing

pause

#Create Origin Restore Point
Checkpoint-Computer -Description "Origin"
=======
#Setting execution policy back to restricted
Write-Output "Setting Execution Policy to Restricted"
set-executionpolicy restricted
>>>>>>> refs/remotes/origin/main

pause
