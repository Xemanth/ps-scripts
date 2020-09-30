#https://poshcode.gitbooks.io/powershell-practice-and-style/content/Style-Guide/Documentation-and-Comments.html

<#
    .SYNOPSIS
        Clears Teams cache for all users in local computer
    .DESCRIPTION
        Needed when user data for example name is changed in O365.
        Windows Desktop Teams client doesn't update old user name in chat logs to match new name, so this handy script cleans the cache and when user opens Teams next time local logs are refreshed.
#>

function Clear-TeamsCache {
    Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Teams\*" -directory -ErrorAction SilentlyContinue | Where-Object Name -in ('Cache','databases','blob_storage','IndexedDB')|ForEach-Object{Remove-Item $_.FullName -Recurse -Force}
}

$teamsstatus = get-process -Name Teams -ErrorAction SilentlyContinue #Store Teams status
if ($teamsstatus) # If running, stop Teams and clear
{
    Stop-Process -Name Teams;
    Start-Sleep 2
    Clear-TeamsCache
    Start-Sleep 2
}
else # If not running, clear without closing
{
    Clear-TeamsCache
}