-- Tutorial One (is now a spare)
local tutorial = {}

local iconfmt = "//ICON/80/80/500/350"
local textfmt = "//TEXTBLOCK/28/430/604/64/font_system/center/vcenter"
local morefmt = "//TEXTBLOCK/28/500/604/64/font_system/center/vcenter"
local btmfmt =  "//ICON/0/568/20/20"



	



tutorial[1] = {}
tutorial[1].format =	"//TITLE/28/font_system_blue" ..	
						iconfmt..textfmt..morefmt..btmfmt..
						"//BACKGROUND/img_tip_border" ..
						"//BORDER/200/200/255/0" ..
						"//"

tutorial[1].data =		"//[TUT_HEAD_1]" ..
						"//img_tip_25"..
						"//[TUT_INFO_1]"..
						"//[TUT_MORE_1]"..
						"//img_blank"..
						"//"

tutorial[1].x =			512
tutorial[1].y =			384
tutorial[1].facing =	-1
tutorial[1].minWidth =	640

return tutorial