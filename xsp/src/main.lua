local sgui = require "SNYUI"

init(0, 1)

ui = sgui:new(600, 800)
--print("UI 宽：" .. ui:getWidth() .. " 高：" .. ui:getHeight())

local page1 = ui:newPage("通用设置")
page1:addLabel("功能选项：")
page1:addComboBox("taskComboBox", 30, nil, "2", "Hello", "Hi", "Hola")
page1:addCheckBoxGroup("page1CB", 30, nil, nil, "0@2", "自动抢红包", "保持前台", "领取奖励", "自动喊话", "无限跳跃")
page1:addBlank(10)
page1:addLabel("抢红包设置")
page1:addRadioGroup("redWarsSetting", nil, nil, "vertical", "1", "省电模式", "一般模式", "极速模式")

local page2 = sgui:newPage("水平展示")
page2Box = page2:newBox("page2Box", "500", "150")
page2Box:addLabel("右边是图片哦~", nil, nil, nil, 180)
page2Box:addImage("b.jpg", 300)
page2:addEdit("page3Edit", nil, 300, "组队还是怎么说", "这里是预输入文本", nil, "number")

local page3 = sgui:newPage("关于")
contactLabel = page3:addLabel("我是Sunny，联系我QQ: 1900200075")
contactLabel:addLabelExtra("https://zesicus.xyz", "Sunny")
contactLabel:addLabelExtra("qq", "QQ: 1900200075")
page3:addWebView("aboutWebView", "https://cn.bing.com", 550, 530)

local ret,result = sgui:show()

if ret == 0 then lua_exit() end
--print(result)