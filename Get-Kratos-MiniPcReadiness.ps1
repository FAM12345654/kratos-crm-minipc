# Read-only inventory for the Kratos Mini-PC.
# Collects basic host and power information; changes nothing and reads no file contents.
$ErrorActionPreference = "Stop"

try {
    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $kratosPath = "C:\Kratos"
    $kratosExists = Test-Path -LiteralPath $kratosPath
    $topLevelCount = if ($kratosExists) {
        @(Get-ChildItem -LiteralPath $kratosPath -Force -ErrorAction Stop).Count
    } else { 0 }

    $processes = @(Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match '^(node|tunnel-client|tailscale|anydesk|rustdesk|teamviewer)$' } |
        Select-Object -Property ProcessName, Id)

    $services = @(Get-Service -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match 'kratos|tailscale|wireguard|anydesk|rustdesk|teamviewer' } |
        Select-Object -Property Name, Status)

    $activeScheme = (& powercfg /getactivescheme 2>&1 | Out-String).Trim()
    $sleepSettings = @(& powercfg /query SCHEME_CURRENT SUB_SLEEP 2>&1 |
        ForEach-Object { "$_".Trim() } |
        Where-Object { $_ })

    [pscustomobject]@{
        Status = "read_only_inventory"
        Windows = [pscustomobject]@{
            Edition = $os.Caption
            Version = $os.Version
            Build = $os.BuildNumber
            Manufacturer = $computer.Manufacturer
            Model = $computer.Model
        }
        SystemDrive = [pscustomobject]@{
            FreeGiB = [math]::Round($disk.FreeSpace / 1GB, 1)
            SizeGiB = [math]::Round($disk.Size / 1GB, 1)
        }
        KratosFolder = [pscustomobject]@{
            Exists = $kratosExists
            TopLevelItemCount = $topLevelCount
        }
        ActivePowerScheme = $activeScheme
        SleepPowerSettings = $sleepSettings
        RelatedProcesses = $processes
        RelatedServices = $services
    } | ConvertTo-Json -Depth 5
}
catch {
    [pscustomobject]@{
        Status = "inventory_failed"
        ErrorType = $_.Exception.GetType().Name
        Message = "Read-only inventory stopped. No settings were changed."
    } | ConvertTo-Json -Depth 3
    exit 1
}
