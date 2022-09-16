#noenv
#singleInstance force
#persistent
程序路径:=substr(A_ScriptFullPath,1,-4) . ".exe"
图标路径:=substr(A_ScriptFullPath,1,-4) . ".exe"
程序名称:=substr(A_ScriptName,1,-4) . ".exe"

;不能忍,自己做个编辑菜单
Menu,tray, NoStandard
Menu,tray,Add,(&H)休眠
Menu,tray,Add,(&D)软件说明
Menu,tray,Add,(&N)隐藏图标
Menu,tray,Add,(&S)开机启动
Menu,tray,Add,(&X)退出程序
开机启动路径 =%A_Startup%\%程序名称%.lnk

IfExist, %开机启动路径%
	Menu,tray,Check,(&S)开机启动
else
	Menu,tray,UnCheck,(&S)开机启动

goto,开始运行
(&H)休眠:
gosub,启动休眠
return

(&N)隐藏图标:
Menu, Tray, NoIcon 
return

(&D)软件说明:
MsgBox,%软件说明%
Return

(&S)开机启动:
IfExist, %开机启动路径%
{
	FileDelete,%开机启动路径%
	Menu,tray,UnCheck,(&S)开机启动
}Else{
	IfNotExist, %图标路径%
		图标路径:=""
	FileCreateShortcut,%程序路径%,%开机启动路径%,%A_ScriptDir%\,,没有说明哈哈,%图标路径%
	Menu,tray,Check,(&S)开机启动
}
Return

(&X)退出程序:
ExitApp

开始运行:

;程序真正开始的位置
;-------------------------------------------------------------------------------------------------------------------------------

软件说明:="软件说明:`n`n按printScreen键进入增强型休眠`n`n如果机子被意外唤醒，在没有确认的情况下`n`n30秒后会再次进入休眠状态，如是循环"
printscreen::
启动休眠:
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
setTimer,休眠检查,100
return

休眠检查:
msgbox,,取消休眠,请按确定键解除休眠,30
IfMsgBox,OK
{
	setTimer,休眠检查,off
	tooltip,休眠解除
	sleep,2000
	tooltip
}	
ifMsgBox,timeOut
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return
