# Requires admin privileges if UAC (User Account Control) is enabled
# Code can be pasted directly into a Admin elavated terminal (Hit enter once and the script will run)
# Made by pando#0001
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Start-Process PowerShell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ErrorActionPreference = 'SilentlyContinue'

[int] $global:column = 0
[int] $maxColumn = 1
[int] $separate = 30
[int] $global:lastPos = 50
[bool]$global:install = $false

function generate_checkbox {
    param(
        [string]$checkboxText,
        [string]$package,
        [bool]$enabled = $true
    )
    $checkbox = new-object System.Windows.Forms.checkbox
    if ($global:column -ge $maxColumn) {
        $checkbox.Location = new-object System.Drawing.Size(($global:column * 300), $global:lastPos)
        $global:column = 0
        $global:lastPos += $separate
    }
    else {
        $checkbox.Location = new-object System.Drawing.Size(30, $global:lastPos)
        $global:column = $column + 1
    }
    $checkbox.Size = new-object System.Drawing.Size(250, 18)
    $checkbox.Text = $checkboxText
    $checkbox.Name = $package
    $checkbox.Enabled = $enabled
    
    $checkbox
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Set the size of form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Install Software | pando#0001" # Titlebar
$Form.ShowIcon = $false
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.Size = New-Object System.Drawing.Size(600, 210)
$Form.AutoSizeMode = 0
$Form.KeyPreview = $True
$Form.SizeGripStyle = 2

# Label
$Label = New-Object System.Windows.Forms.label
$Label.Location = New-Object System.Drawing.Size(11, 15)
$Label.Size = New-Object System.Drawing.Size(255, 15)
$Label.Text = "Download and install software using winget:"
$Form.Controls.Add($Label)

# Mozilla Firefox
$Form.Controls.Add((generate_checkbox "Mozilla Firefox" "Mozilla.Firefox"))

# Brave Browser
$Form.Controls.Add((generate_checkbox "Brave Browser" "BraveSoftware.BraveBrowser"))

# Google Chrome
$Form.Controls.Add((generate_checkbox "Google Chrome" "Microsoft.MicrosoftEdge"))

# TorProject.TorBrowser
$Form.Controls.Add((generate_checkbox "TorBrowser" "TorProject.TorBrowser"))

# VeraCrypt
$Form.Controls.Add((generate_checkbox "VeraCrypt" "IDRIX.VeraCrypt"))

# Discord
$Form.Controls.Add((generate_checkbox "Discord" "Discord.Discord"))

# Telegram.TelegramDesktop
$Form.Controls.Add((generate_checkbox "Telegram" "Telegram.TelegramDesktop"))

# Steam
$Form.Controls.Add((generate_checkbox "Steam" "Valve.Steam"))

# VS Code
$Form.Controls.Add((generate_checkbox "Visual Studio Code" "Microsoft.VisualStudioCode"))

# Python 3.11
$Form.Controls.Add((generate_checkbox "Python 3.11" "Python.Python.3.11"))

# NVCleanstall
$Form.Controls.Add((generate_checkbox "NVCleanstall" "TechPowerUp.NVCleanstall"))

# DirectX web installer
$Form.Controls.Add((generate_checkbox "DirectX web installer" "Microsoft.DirectX"))

# 7-Zip
$Form.Controls.Add((generate_checkbox "7-Zip" "IgorPavlov.7zip"))

# Everything
$Form.Controls.Add((generate_checkbox "Everything" "voidtools.Everything"))

# Flow-Launcher
$Form.Controls.Add((generate_checkbox "Flow-Launcher" "Flow-Launcher.Flow-Launcher"))

# Notepad++
$Form.Controls.Add((generate_checkbox "Notepad++" "NotepadPlusPlus.NotepadPlusPlus"))

# GPU-Z
$Form.Controls.Add((generate_checkbox "GPU-Z" "TechPowerUp.GPU-Z"))

# OBS
$Form.Controls.Add((generate_checkbox "OBS" "OBSProject.OBSStudio"))

# Powertoys
$Form.Controls.Add((generate_checkbox "PowerToys" "Microsoft.PowerToys"))

# Ditto
$Form.Controls.Add((generate_checkbox "Ditto" "Ditto.Ditto"))

# qBittorrent
$Form.Controls.Add((generate_checkbox "qBittorrent" "qBittorrent.qBittorrent"))

# MullvadVPN
$Form.Controls.Add((generate_checkbox "MullvadVPN, Best privacy wise ~,~" "MullvadVPN.MullvadVPN"))

# ExpressVPN
$Form.Controls.Add((generate_checkbox "ExpressVPN" "ExpressVPN.ExpressVPN"))

# IVPN
$Form.Controls.Add((generate_checkbox "IVPN" "IVPN.IVPN"))

# GIMP
$Form.Controls.Add((generate_checkbox "GIMP" "GIMP.GIMP"))

# PrivateInternetAccess
$Form.Controls.Add((generate_checkbox "PrivateInternetAccess" "PrivateInternetAccess.PrivateInternetAccess"))

# VPNetwork.TorGuard
$Form.Controls.Add((generate_checkbox "TorGuard" "VPNetwork.TorGuard"))

if ($global:column -ne 0) {
    $global:lastPos += $separate
}

$Form.height = $global:lastPos + 80

# Dark Mode (default)
$Form.BackColor = [System.Drawing.Color]::FromArgb(64, 64, 64)
$Form.ForeColor = [System.Drawing.Color]::White
foreach ($control in $Form.Controls) {
    if ($control.GetType().Name -eq "Checkbox") {
        $control.BackColor = [System.Drawing.Color]::FromArgb(64, 64, 64)
        $control.ForeColor = [System.Drawing.Color]::White
    }
}

# Install Button
$lastPosWidth = $form.Width - 80 - 31
$InstallButton = new-object System.Windows.Forms.Button
$InstallButton.Location = new-object System.Drawing.Size($lastPosWidth, $global:lastPos)
$InstallButton.Size = new-object System.Drawing.Size(80, 23)
$InstallButton.Text = "Install"
$InstallButton.Add_Click({
    $checkedPackages = $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] -and $_.Checked } | Select-Object -ExpandProperty Name
    if ($checkedPackages.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one software package to install.", "No package selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    else {
        $packagesToInstall = $checkedPackages -join ','
        Write-Host "winget install --id $packagesToInstall"
        Start-Process -FilePath "winget" -ArgumentList "install --id $packagesToInstall" -Wait
    }
})
$Form.Controls.Add($InstallButton)

# Activate the form
$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()
