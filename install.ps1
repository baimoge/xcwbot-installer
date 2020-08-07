﻿$ErrorActionPreference = "Inquire"

$host.ui.RawUI.WindowTitle = "小仓唯bot一键安装脚本"

# 欢迎
Write-Output '欢迎使用小仓唯bot一键安装脚本！小仓唯bot是基于 hoshino 与 yobot 的一个综合性公主连结机器人，功能繁多，操作简单，安装便捷。
安装过程马上开始，全程耗时较长，预计需要30分钟，请耐心等待...'

# 检查运行环境
if ($Host.Version.Major -lt 5) {
    Write-Output 'Powershell 版本过低，请升级之后再试...'
    exit
}
if ((Get-ChildItem -Path Env:OS).Value -ine 'Windows_NT') {
    Write-Output '当前操作系统不支持一键安装...'
    exit
}
if ([Environment]::Is64BitProcess) {
}
else {
    Write-Output '本bot不支持32位系统安装...'
    exit
}

if (Test-Path .\xcwbot) {
    Write-Output '发现重复，是否删除旧文件并重新安装？'
    $reinstall = Read-Host '请输入 y 或 n (y/n)'
    Switch ($reinstall) { 
        Y { Remove-Item .\xcwbot -Recurse -Force } 
        N { exit } 
        Default { exit } 
    } 
}

$loop = $true
while ($loop) {
    $loop = $false
    Write-Output '是否需要安装 Python 3.8?'
    Write-Output 'y：我没有安装，请帮我安装'
    Write-Output 'n：我已经安装，不用了'
    $user_in = Read-Host '请输入 y 或 n (y/n)'
    Switch ($user_in) {
        Y { $install_python = $true }
        N { $install_python = $false }
        Default { $loop = $true }
    }
}

$loop = $true
while ($loop) {
    $loop = $false
    Write-Output '是否需要安装 git?'
    Write-Output 'y：我没有安装，请帮我安装'
    Write-Output 'n：我已经安装，不用了'
    $user_in = Read-Host '请输入 y 或 n (y/n)'
    Switch ($user_in) {
        Y { $install_git = $true }
        N { $install_git = $false }
        Default { $loop = $true }
    }
}

# 用户输入
$qqid = Read-Host '请输入作为机器人的QQ号'
$qqpassword = Read-Host '请输入作为机器人的QQ密码'
$hostqqid = Read-Host '请输入作为主人的QQ号'
$port = Read-Host '请输入要监听的端口号(建议使用8080)'

# 提示
write-Output "您机器人的QQ号为${qqid},密码为${qqpassword},主人QQ号为${hostqqid},端口号为${port}。
下面即将进行依赖安装和配置设置，如确认无误，请按任意键继续。"
[void][System.Console]::ReadKey($true)
write-Output "提示：只要报错之后还能继续执行下去，那就可以暂时忽略，若最后还不能正常运行，再考虑排错，运行bot时同理。
另外，安装python和git时需要管理员权限，若没有自动弹出授权窗口，请看看任务栏。
如您还遇到了其他问题，请查看同目录下的常见问题解答.txt
了解后请按任意键继续。"
[void][System.Console]::ReadKey($true)

# 创建文件夹
New-Item -Path .\xcwbot -ItemType Directory
Set-Location xcwbot
New-Item -ItemType Directory -Path .\mirai\plugins, .\mirai\plugins\CQHTTPMirai, .\HoshinoBot\hoshino\modules\yobot

# 下载帮助
Invoke-WebRequest http://ftp.pcrbotlink.top/QA.txt -OutFile .\常见问题解答.txt

# 下载安装程序
Write-Output "正在下载安装程序，体积较大，耗时会较长，请耐心等待..."
Invoke-WebRequest "https://alphaone-my.sharepoint.cn/personal/yu_vip_tg/_layouts/15/download.aspx?UniqueId=54f51f3a-6dcc-4132-8121-9ad53aec3243&Translate=false&tempauth=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvYWxwaGFvbmUtbXkuc2hhcmVwb2ludC5jbkAzYjFjODFiMS1kMTU2LTRhZjktYjE2OS1hZTA4MTI4YzAzOTYiLCJpc3MiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAiLCJuYmYiOiIxNTk2ODA5ODU4IiwiZXhwIjoiMTU5NjgxMzQ1OCIsImVuZHBvaW50dXJsIjoiYWlEUjJ0eVRaWDBBSjZvVHdCUFN2aUFySUhGSUlJZTB3aTQxWG95S01rQT0iLCJlbmRwb2ludHVybExlbmd0aCI6IjE0MCIsImlzbG9vcGJhY2siOiJUcnVlIiwiY2lkIjoiWVdJeU0yUXpPR0l0WXpCbFl5MDBNV0k0TFRnNU5XTXRPRGhsTWpKbVkyTTVZakZqIiwidmVyIjoiaGFzaGVkcHJvb2Z0b2tlbiIsInNpdGVpZCI6Ik0ySTRNbU16WkRrdFpXWmlaUzAwWWpnekxUaGxaV1F0Tmprd09HVmxZbVJpTXpsbCIsImFwcF9kaXNwbGF5bmFtZSI6IlBRIHN5bmMiLCJzaWduaW5fc3RhdGUiOiJbXCJrbXNpXCJdIiwiYXBwaWQiOiI0ZDY3MmZhZi00OTU2LTQyNmUtYTMzMy0yNjQwNGVmNTliNGYiLCJ0aWQiOiIzYjFjODFiMS1kMTU2LTRhZjktYjE2OS1hZTA4MTI4YzAzOTYiLCJ1cG4iOiJ5dUB2aXAudGciLCJwdWlkIjoiMTAwMzMyMzBDNTc3QUM5OCIsImNhY2hla2V5IjoiMGguZnxtZW1iZXJzaGlwfDEwMDMzMjMwYzU3N2FjOThAbGl2ZS5jb20iLCJzY3AiOiJhbGxmaWxlcy53cml0ZSIsInR0IjoiMiIsInVzZVBlcnNpc3RlbnRDb29raWUiOm51bGx9.WCtJYnNpRFVKY1V4ejVGTVpSNk9OWkZJYXpYMy9zWnR1bnFleDU5Skg1az0&ApiVersion=2.0" -OutFile one-key-xcw.zip
Expand-Archive one-key-xcw.zip -DestinationPath .\
Invoke-WebRequest http://ftp.pcrbotlink.top/miraiOK_windows_386.exe -OutFile .\mirai\miraiOK.exe

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ($install_python) {
    Write-Output "正在安装 python，请耐心等待..."
    Invoke-WebRequest https://mirrors.huaweicloud.com/python/3.8.5/python-3.8.5-amd64.exe -OutFile .\python-3.8.5.exe
    Start-Process -Wait -FilePath .\python-3.8.5.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0"
    $env:Path += ";C:\Python38\Scripts;C:\Python38"
    Write-Output "python 安装成功"
}
if ($install_git) {
    Write-Output "正在安装 git，请耐心等待..."
    Invoke-WebRequest https://mirrors.huaweicloud.com/git-for-windows/v2.28.0.windows.1/Git-2.28.0-64-bit.exe -OutFile .\git-2.28.0.exe
    Start-Process -Wait -FilePath .\git-2.28.0.exe -ArgumentList "/SILENT /SP-"
    $env:Path += ";C:\Program Files\Git\bin"  # 添加 git 环境变量
    Write-Output "git 安装成功"
}

# 拷贝插件和资源文件
Copy-Item .\插件\*.jar .\mirai\plugins
Copy-Item .\res $PSScriptRoot –recurse -Force
Set-Location .\HoshinoBot\hoshino\modules\yobot

# 从 github 拉取 yobot
git init
git submodule add https://gitee.com/yobot/yobot.git

# 结束当前脚本，开启新脚本
Set-Location ..\..\..\..\
Invoke-WebRequest http://ftp.pcrbotlink.top/install2.ps1 -OutFile .\install2.ps1
powershell -File install2.ps1
exit

#下接install2.ps1

