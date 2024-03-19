# Get variables

#$current_name = $env:COMPUTERNAME
#$change_name = Read-Host -Prompt "The current machine name is $current_name, Would you like to change it?"

$new_machine_name = Read-Host -Prompt "Input the new machine name."

exit

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
echo "Disabling UAC"
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

# Change Power Settings
echo "Adjusting power settings"
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

#Turn Off Windows Firewall
echo "Turning off Windows Firewall"
set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False 

# Enabling RDP
echo "Enabling RDP"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

# Set Time Zone
echo "Setting Time Zone to:" $new_time_zone
Set-TimeZone -Id $new_time_zone

# Rename machine
echo "Renaming machine"
Rename-Computer -NewName $new_machine_name

#Running Software installers
echo "Installing Basic Software"
.\ninite_installer
.\Reader_Install_Setup