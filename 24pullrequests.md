24Remember, contributions to this repository should follow our GitHub Community Guidelines.
 ProTip! Add comments to specific lines under Files changed.https://github.com/mmu094/.mmu094/pull/13#issue-2012915650 more computers to set up.
Windows (Cmd)
"%PROGRAMFILES(X86)%\Google\Chrome Remote Desktop\CurrentVersion\remoting_start_host.exe" --code="4/0AfJohXlbJ7KRAu1jeXzBN8mjJ-3bsAELMnzWEUNTknjj5m3H_nwBbpqjKyL_lBDvttcKtg" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=%COMPUTERNAME%
Windows (PowerShell)
& "${Env:PROGRAMFILES(X86)}\Google\Chrome Remote Desktop\CurrentVersion\remoting_start_host.exe" --code="4/0AfJohXlbJ7KRAu1jeXzBN8mjJ-3bsAELMnzWEUNTknjj5m3H_nwBbpqjKyL_lBDvttcKtg" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$Env:COMPUTERNAME
Debian Linux
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AfJohXlbJ7KRAu1jeXzB
