<#
  .SYNOPSIS
  Outputs the status of Windows Defender RealTimeProtectionEnabled in Wavefront format for telegraf consumption.

  .DESCRIPTION
  The defender_rtp.ps1 script will run (Get-MpComputerStatus).RealTimeProtectionEnabled
  and parse the results to a code. 1 for $true, 0 for $false and -1 for else (failure).

  .INPUTS
  None.

  .OUTPUTS
  The defender_rtp.ps1 script writes output containing the metric name, metric value and the source.

  .EXAMPLE
  PS> .\defender_rtp.ps1
    win.defender.RealTimeProtectionEnabled 1 source=US00SMGTA

  .NOTES
  Github: @git-cgallagher

  Example usage in telegraf.conf:
    [[inputs.exec]]
    commands = ['powershell.exe -file "C:\path\to\your\scripts\defender_rtp.ps1"']
    timeout = "15s"
    data_format = "wavefront"
    interval="5m"
#>

$ComputerName = $env:COMPUTERNAME

$RtpStatus = (Get-MpComputerStatus).RealTimeProtectionEnabled

if ($RtpStatus -eq $true) {
  $RtpValue = 1
}
elseif ($RtpStatus -eq $false) {
  $RtpValue = 0
}
else {
  $RtpValue = -1  # Error
}

$WavefrontOutput = "win.defender.RealTimeProtectionEnabled " + $RtpValue + " source=" + $ComputerName
Write-Output $WavefrontOutput
