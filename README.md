# SNYUI

![Build Status](https://travis-ci.org/hrscy/TodayNews.svg?branch=master)

> ✨初学Lua总结编写的UI库, 符合JSON编写界面风格

### 适用平台

* 适用于 叉叉助手 以及其他使用JSON作为界面显示的脚本平台(结构不同则请修改)

### 实现原理

* 通过table序列化生成JSON调用系统函数实现界面展示

### 使用说明

需引用 “SUNYUI” 文件
```lua
local sgui = require "SNYUI"
```

初始化界面
```lua
ui = sgui:new(600, 800)
```

图片上的单页代码展示
```lua
local page1 = ui:newPage("通用设置")
page1:addLabel("功能选项：")
page1:addComboBox("taskComboBox", 30, nil, "2", "Hello", "Hi", "Hola")
page1:addCheckBoxGroup("page1CB", 30, nil, nil, "0@2", "自动抢红包", "保持前台", "领取奖励", "自动喊话", "无限跳跃")
page1:addBlank(10)
page1:addLabel("抢红包设置")
page1:addRadioGroup("redWarsSetting", nil, nil, "vertical", "1", "省电模式", "一般模式", "极速模式")
```

其他控件使用方式请参考Demo，SNYUI文件中用注释对函数做了详细说明。
