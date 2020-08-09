# 上续install.ps1

# 安装 python 依赖
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/requirements.txt
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/hoshino/modules/yobot/yobot/src/client/requirements.txt
py -3.8 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r HoshinoBot/hoshino/modules/eqa/requirements.txt

# 并行执行install3.ps1
Invoke-WebRequest http://ftp.pcrbotlink.top/install3.ps1 -OutFile .\install3.ps1
powershell -File install3.ps1

# 结束流程
write-host "即将启动小仓唯bot，感谢您的使用。如有问题请阅读参考文档或者询问他人..."

# 启动程序
Start-Process -FilePath .\HoshinoBot\start.bat -WorkingDirectory .\HoshinoBot
Start-Process -FilePath .\mirai\miraiOK.exe -WorkingDirectory .\mirai