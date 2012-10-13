@echo off
if %1==makeprj goto :makeprj
if %1==xnuke goto :xnuke
echo Unknown command
goto :exit

:makeprj
Set PrjFile=%~2
Set Language=%~3
if EXIST %PrjFile% del %PrjFile%
:addfile
if "%~4"=="" goto :exit
if %Language%==na (
echo work %~4 >> %PrjFile%
) else (
echo %Language% work %~4 >> %PrjFile%
)
shift
goto :addfile

:xnuke
del *.cmd_log 2>NULL
del *.vhi 2>NULL
del *.mif 2>NULL
del *.lso 2>NULL
del *.prj 2>NULL
del *.stx 2>NULL
del *.bit 2>NULL
del *.bld 2>NULL
del *.drc 2>NULL
del *.ncd 2>NULL
del *.gise 2>NULL
del *.ngc 2>NULL
del *.ngd 2>NULL
del *.ngr 2>NULL
del *.pad 2>NULL
del *.par 2>NULL
del *.pcf 2>NULL
del *.ptwx 2>NULL
del *.bgn 2>NULL
del *.syr 2>NULL
del *.twr 2>NULL
del *.twx 2>NULL
del *.unroutes 2>NULL
del *.ut 2>NULL
del *.xpi 2>NULL
del *.xst 2>NULL
del *.xwbt 2>NULL
del *_envsettings.html 2>NULL
del *_map.map 2>NULL
del *.mrp 2>NULL
del *.ngm 2>NULL
del *.xrpt 2>NULL
del *_pad.csv 2>NULL
del *_summary.html 2>NULL
del *_summary.xml 2>NULL
del *_usage.xml 2>NULL
del *_pad.txt 2>NULL
del fuse.log 2>NULL
del *.xmsgs 2>NULL
del fuseRelaunch.cmd 2>NULL
del isim.cmd 2>NULL
del isim.log 2>NULL
del par_usage_stat* 2>NULL
del usage_statistics_webtalk.html 2>NULL
del webtalk*.* 2>NULL
del xilinxsim.ini 2>NULL
del *.wdb 2>NULL
rd /s /q _ngo 2>NULL
rd /s /q _xmsgs 2>NULL
rd /s /q iseconfig 2>NULL
rd /s /q isim 2>NULL
rd /s /q xlnx_auto_0_xdb 2>NULL
rd /s /q xst 2>NULL
@echo XNuke Complete



:exit