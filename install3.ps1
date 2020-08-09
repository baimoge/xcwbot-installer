# 设置管理员权限运行
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    exit $LASTEXITCODE
}

# 读取重启脚本的绝对路径
$path = Get-Content C:\Users\Public\Documents\scriptpath.txt

# 创建自动重启计划任务
schtasks /create /tn "mirai 自动重启" /ru system /tr $path /sc hourly /mo 2