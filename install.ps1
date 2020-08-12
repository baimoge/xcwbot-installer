$ErrorActionPreference = "SilentlyContinue"

$host.ui.RawUI.WindowTitle = "小仓唯bot一键安装脚本"

# 欢迎
Write-Output '欢迎使用小仓唯bot一键安装脚本！小仓唯bot是基于 hoshino 与 yobot 的一个综合性公主连结机器人，功能繁多，操作简单，安装便捷。
具体功能表可查看：https://xcw.pcrbotlink.top/help.html
如安装遇到问题请请查看同目录下的常见问题解答.txt！！！
在开始之前，建议学一下英语和中文，再学一下搜索引擎的使用方法。
请牢记：重启可以解决50%的问题，重装可以解决90%的问题，遇事不决请先重启。
另外，强烈建议在服务器上部署，如在本地部署出现问题概不负责！！！
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
        N { Write-Output "请选择y删除文件后继续"
            exit } 
        Default { Write-Output "请选择y删除文件后继续"
            exit } 
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
如您还遇到了其他问题，请查看同目录下的常见问题解答.txt！
请牢记：重启可以解决50%的问题，重装可以解决90%的问题，遇事不决请先重启。
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
if (Test-Path one-key-xcw.zip) {
    write-Output "检测到安装程序已经存在，跳过下载..."
}
else {
    write-Output "正在从第1个源下载..."
    Invoke-WebRequest https://boost.pcrbotlink.top/one-key-xcw.zip -OutFile one-key-xcw.zip
    If (!$?) {
        write-Output "下载失败，正在从第2个源下载..."
        Remove-Item one-key-xcw.zip -Force
        Invoke-WebRequest https://boost3.pcrbotlink.top/one-key-xcw.zip -OutFile one-key-xcw.zip
        if (!$?) {
            write-Output "下载失败，正在从第3个源下载..."
            Remove-Item one-key-xcw.zip -Force
            Invoke-WebRequest https://oscarlongsslz.yobot.win/one-key-xcw.zip -OutFile one-key-xcw.zip
            if (!$?) {
                write-Output "下载失败，正在从第4个源下载..." 
                Remove-Item one-key-xcw.zip -Force
                Invoke-WebRequest https://boost2.pcrbotlink.top/one-key-xcw.zip -OutFile one-key-xcw.zip
                if (!$?) {
                    write-Output "下载失败，正在从第5个源下载..." 
                    Remove-Item one-key-xcw.zip -Force
                    Invoke-WebRequest https://download.pcrbotlink.top/one-key-xcw.zip -OutFile one-key-xcw.zip
                    if (!$?) {
                        write-Output "下载失败，正在从第6个源下载..." 
                        Remove-Item one-key-xcw.zip -Force
                        Invoke-WebRequest http://ftp.pcrbotlink.top/one-key-xcw.zip -OutFile one-key-xcw.zip
                        if(!$?){
                            write-Output "从所有源下载均失败，请手动从帮助文件中的地址下载安装程序并放置在xcwbot文件夹下，请注意不要解压。"
                            Remove-Item one-key-xcw.zip -Force
                            break
                        }
                    }
                }
            }
        }
    }
    write-Output "下载成功！" 
}

# SHA256校验
$OriginFileHash = "A24B55EEBA089A0F179DBA3BE91AA96A55D361EE131B92DE25EC597C452F5AF2"
$DownloadFileHash = (Get-FileHash .\one-key-xcw.zip -Algorithm SHA256).Hash
if ($OriginFileHash -ceq $DownloadFileHash){
}
else {
    write-Output "压缩文件损坏，请重启脚本重新下载。若反复出现，请手动从帮助文件中的地址下载安装程序并放置在xcwbot文件夹下，请注意不要解压。"
    break
}

write-Output "正在解压安装程序..."
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
if(!$?){
    write-Output "调用git失败，请检查git是否完整安装，建议卸载之后重启脚本再试。"
    break
}
git submodule add https://gitee.com/yobot/yobot.git

# 生成随机 access_token
$token = -join ((65..90) + (97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ })


# 写入 miraiOK 配置文件
Set-Location ..\..\..\..\
New-Item -Path .\mirai\config.txt -ItemType File -Value "----------`nlogin ${qqid} ${qqpassword}`n"

# 写入 cqmiraihttp 配置文件
New-Item -Path .\mirai\plugins\CQHTTPMirai\setting.yml -ItemType File -Value @"
"${qqid}":
  ws_reverse:
  -  enable: true
     postMessageFormat: string
     reverseHost: 127.0.0.1
     reversePort: ${port}
     reversePath: /ws/
     accessToken: ${token}
     reconnectInterval: 3000
  http:
    enable: false   
    host: 0.0.0.0   
    port: 5700   
    accessToken: ""   
    postUrl: ""
    postMessageFormat: string
    secret: ""
  ws:
    enable: false
    postMessageFormat: string
    accessToken: ""
    wsHost: "0.0.0.0"
    wsPort: 6700
"@

# 创建文件夹(二度)
New-Item -ItemType Directory -Path .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\yobot_data

# 写入 yobot 配置文件
New-Item -Path .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\yobot_data\yobot_config.json -ItemType File -Value @"
{
    "port": "${port}",
    "access_token": "${token}",
    "super-admin": [
        ${hostqqid}
    ]
}
"@

# 替换 yobot 帮助文件
Copy-Item .\res\help.html .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\public\template

# 写入 hoshino 配置文件
Add-Content .\HoshinoBot\hoshino\config\__bot__.py "`r`nACCESS_TOKEN='${token}'`r`nPORT =$port`r`nSUPERUSERS = [$hostqqid]`r`nRES_DIR = r'$PSScriptRoot\res'`r`n"

# 创建快捷方式
$desktop = [Environment]::GetFolderPath("Desktop")

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("${desktop}\mirai-请先打开这个.lnk")
$Shortcut.TargetPath = "${pwd}\mirai\miraiOK.exe"
$Shortcut.WorkingDirectory = "${pwd}\mirai\"
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("${desktop}\启动小仓唯.lnk")
$Shortcut.TargetPath = "${pwd}\HoshinoBot\start.bat"
$Shortcut.WorkingDirectory = "${pwd}\HoshinoBot\"
$Shortcut.Save()

# 创建自动重启脚本
New-Item -Path .\restart.ps1 -ItemType File -Value "taskkill /im miraiOK.exe /f
taskkill /im java.exe /f
Start-Process -FilePath $PSScriptRoot\xcwbot\mirai\miraiOK.exe -WorkingDirectory $PSScriptRoot\xcwbot\mirai"

# 记录自动重启脚本的绝对路径
New-Item -Path C:\Users\Public\Documents\scriptpath.txt -ItemType File -Value "$PSScriptRoot\xcwbot\restart.ps1"

# 重新启动一个进程以刷新git和python安装状态
Write-Output "正在安装依赖，预计需要5~15分钟，请耐心等待..."
Invoke-WebRequest http://ftp.pcrbotlink.top/install2.ps1 -OutFile .\install2.ps1
powershell -File install2.ps1
exit

