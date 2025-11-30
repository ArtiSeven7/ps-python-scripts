Write-Host "WorkingSet (RAM):`n"
Get-Process |
    Sort-Object -Property WorkingSet -Descending |
    Select-Object -First 10 -Property Id, ProcessName,
        @{Name="RAM_MB"; Expression = { [math]::Round($_.WorkingSet / 1MB, 1) }} |
    Format-Table -AutoSize

Write-Host "`n CPU (total time):`n"
Get-Process |
    Sort-Object -Property CPU -Descending |
    Select-Object -First 10 -Property Id, ProcessName,
        @{Name="CPU_s"; Expression = { [math]::Round($_.CPU, 1) }} |
    Format-Table -AutoSize
