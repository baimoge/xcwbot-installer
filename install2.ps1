# 上续install.ps1
# 安装 python 依赖
Write-Output "正在安装依赖，预计需要5~15分钟，请耐心等待..."
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/requirements.txt
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/hoshino/modules/yobot/yobot/src/client/requirements.txt
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/hoshino/modules/eqa/requirements.txt

# 写入 miraiOK 配置文件
if (Test-Path .\mirai\config.txt) {
    Set-Content -Path .\mirai\config.txt -Value "----------`nlogin ${qqid} ${qqpassword}`n"
}
else {
    New-Item -Path .\mirai\config.txt -ItemType File -Value "----------`nlogin ${qqid} ${qqpassword}`n"
}

# 写入 cqmiraihttp 配置文件
if (Test-Path .\mirai\plugins\CQHTTPMirai\setting.yml) {
    Set-Content -Path .\mirai\plugins\CQHTTPMirai\setting.yml -Value @"
"${qqid}":
  ws_reverse:
    - enable: true
      postMessageFormat: string
      reverseHost: 127.0.0.1
      reversePort: ${port}
      reversePath: /ws/
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
}
else {
    New-Item -Path .\mirai\plugins\CQHTTPMirai\setting.yml -ItemType File -Value @"
"${qqid}":
  ws_reverse:
  -  enable: true
     postMessageFormat: string
     reverseHost: 127.0.0.1
     reversePort: ${port}
     reversePath: /ws/
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
}


# 创建文件夹(二度)
New-Item -ItemType Directory -Path .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\yobot_data

# 写入 yobot 配置文件
New-Item -Path .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\yobot_data\yobot_config.json -ItemType File -Value @"
{
    "port": "${port}",
    "super-admin": [
        ${hostqqid}
    ]
}
"@

# 替换 yobot 帮助文件
Copy-Item .\res\help.html .\HoshinoBot\hoshino\modules\yobot\yobot\src\client\public\template

# 写入 hoshino 配置文件
Add-Content .\HoshinoBot\hoshino\config\__bot__.py "`r`nPORT =$port`r`nSUPERUSERS = [$hostqqid]`r`nRES_DIR = r'$PSScriptRoot\res'`r`n"

# 结束流程
write-host "即将启动小仓唯bot，感谢您的使用。如有问题请阅读参考文档或者询问他人..."

# 启动程序
Start-Process -FilePath .\HoshinoBot\start.bat -WorkingDirectory .\HoshinoBot
Start-Process -FilePath .\mirai\miraiOK.exe -WorkingDirectory .\mirai

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