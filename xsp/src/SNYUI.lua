-- 初始化ui变量
local ui = {tmp = {}, ui_table = {}}
local w_, h_ = getScreenSize()

-- 初始化UI界面
-----------------------------------------------------
-- width (number): 整体界面宽度 (默认 0.95 * 屏幕宽度)
-- height (number): 整体界面高度 (默认 0.95 * 屏幕高度)
-- countDown (number): 倒计时 (可选)
-- okName (string): 确定键 (默认“确定”)
-- cancelName (string): 取消键 (默认“退出”)
-- isCancelScroll (boolean): 是否取消滑动(默认不取消)
-- config (string): 界面配置文件名(默认存储文件“config_snyui.dat”)
function ui:new(width, height, countDown, okName, cancelName, isCancelScroll, config)
	self["style"] 	             = "default"
	local orientation = getScreenDirection()
	if orientation ~= 0 then
		w_, h_ = h_, w_
	end
	self["width"] 		     = tonumber(width) or w_ * 0.95
	self["height"] 		     = tonumber(height) or h_ * 0.95
	if countDown then
		self["countdown"]  = countDown
	end
	self["okname"] 	  = okName or "确定"
	self["cancelname"] = cancelName or "退出"
	self["config"]            = config or "config_snyui.dat"
	self["cancelscroll"]   = isCancelScroll or false
	self.views = {}
	local ui_table = self.ui_table
	for k, v in pairs(self) do
		if type(v) ~= "function" and k ~= "tmp" and k ~= "ui_table" then
			ui_table[k] = v
		end
	end
	local o = {};
	setmetatable(o, {__index = self})
	return o
end

-- 返回界面宽
function ui:getWidth()
	return tonumber(self["width"])
end

-- 返回界面高
function ui:getHeight()
	return tonumber(self["height"])
end

-- 新建标签页
-----------------------------------------------------
-- text (string): 标签页文字
function ui:newPage(text)
	local tab = {
		["type"] = "Page",
		["text"]  = text ,
		views = {}
	}
	table.insert(self.views, tab)
	setmetatable(tab, {__index = self})
	return tab
end

-- Box
-----------------------------------------------------
-- id (string): 标识
-- width (number): 盒子宽
-- height (number): 盒子高
-- valign (string): 垂直对齐 (默认 "top")
function ui:newBox(id, width, height, valign)
	local box = {
		["type"] = "LinearLayout",
		["id"] = id,
		["width"] = width,
		["height"] = height,
		["valign"] = valign or "top",
		views = {}
	}
	table.insert(self.views, box)
	setmetatable(box, {__index = self})
	return box
end

-- 标签
-----------------------------------------------------
-- text (string): 标签文字
-- size (number): 标签大小
-- align (string): 标签对齐方向 (默认左对齐)
-- color (string): 字体颜色 (默认 "0,32,96")
-- width (number): 宽度 (可选)
function ui:addLabel(text, size, align, color, width)
	local arr = {
		["type"]    = "Label",
		["text"]    = text,
		["size"]    = tonumber(size) or 30,
		["align"]   = align or "left",
		["color"]   = color or "0,32,96",
		extra = {}
	}
	if width then arr["width"] = tonumber(width) end
	table.insert(self.views,arr)
	setmetatable(arr, {__index = self})
	return arr
end

-- 标签额外属性
-----------------------------------------------------
-- goto (string): 超链接
-- text (string): 需要设置属性的文字
function ui:addLabelExtra(goto, text)
	local arr = {
		["goto"] = goto,
		["text"] = text
	}
	table.insert(self.extra, arr)
end

-- 输入框
-----------------------------------------------------
-- id (string): id标识
-- size (number): 字体大小
-- width (number): 宽度(可选 在box中有效)
-- prompt (string): 提示文本 (这个提示文本好像看不到...)
-- def_value (string): 预输入文本 (可选)
-- kbtype (string):  键盘类型 (两种选择 "ascii""number"，默认不限制输入)
-- align (string): 对齐 (默认 "left", 可能仅在Box中有效)
-- color (string): 字体颜色 (默认 "0,100,0")
function ui:addEdit(id, size, width, prompt, def_value, kbtype, align, color)
	local arr = {
		["type"] = "Edit",
		["id"] = id,
		["prompt"] = prompt or "",
		["text"] = def_value or "" ,
		["size"] = size or 30,
		["align"] = align or "left",
		["color"] = color or "0,100,0",
		["kbtype"]  = kbtype or "ascii"
	}
	if width then arr["width"]	= width end
	self.tmp[id] = id
	table.insert(self.views,arr)
end

-- 空白填充块
-----------------------------------------------------
-- height (number): 指定高度
function ui:addBlank(height)
	self:addLabel("  ", tonumber(height))
end

-- 下拉列表
-----------------------------------------------------
-- id (string): 列表id标识
-- size (number): 高度 (默认 30)
-- width (number): 宽度 (可选)
-- def_value (string): 默认选项 ("0" 为第一个选项)
-- ... (string): 多参数 (例："Hello", "Hi", "Hola")
function ui:addComboBox(id, size, width, def_value, ...)
	local tab = {...}
	local arr = {
		["type"] 	= "ComboBox",
		["id"] 		= id,
		["list"] 	    = table.concat(tab,","),
		["select"] 	= def_value or "0",
		["size"]     = size or 30,
	}
	if width then arr["width"]	= tonumber(width) end
	self.tmp[id] = tab
	table.insert(self.views,arr)
end

-- 多选框
-----------------------------------------------------
-- id (string): 列表id标识
-- size (number): 默认大小30
-- width (number): 宽度 (可选)
-- orientation (string): 方向 (默认 横向智能横排)
-- checked (string): 默认已选 (默认选择了第一项)
-- ... (string): 配置项 (例："自动抢红包", "保持前台", "领取奖励")
function ui:addCheckBoxGroup(id, size, width, orientation, checked, ...)
	local tab = {...}
	local arr = {
		["type"] 	       = "CheckBoxGroup",
		["id"] 		       = id,
		["list"] 	           = table.concat(tab, ","),
		["select"] 	       = checked or "0",
		["size"]            = tonumber(size) or 30,
		["orientation"] = orientation or "horizontal"
	}
	if width then arr["width"] = width end
	self.tmp[id] = tab
	table.insert(self.views,arr)
end

-- 单选框
-----------------------------------------------------
-- id (string): 列表id标识
-- size (number): 尺寸 (默认 30)
-- width (number): 宽度 (可选)
-- orientation (string): 方向 (默认垂直)
-- def_value (string): 默认值 ("0")
-- ... (string): 配置项 (例："自动抢红包", "保持前台", "领取奖励")
function ui:addRadioGroup(id, size, width, orientation, def_value, ...)
	local tab = {...}
	local arr = {
		["type"]           = "RadioGroup",
		["id"]               = id,
		["list"]             = table.concat(tab,","),
		["select"]         = def_value or "0",
		["size"]            = size or 30,
		["orientation"] = orientation or "vertical"
	}
	if width then arr["width"] = tonumber(width) end
	self.tmp[id] = tab
	table.insert(self.views, arr)
end

-- 图片
-----------------------------------------------------
-- src (string): 文件路径
-- width (number): 宽度 (宽度设置仅在Box中有效)
function ui:addImage(src, width)
	local arr = {
		["type"]  = "Image",
		["src"]    = src,
	}
	if width then arr["width"] = width end
	table.insert(self.views,arr)
end

-- 网页
-----------------------------------------------------
-- id (string): 标识
-- url (string): 超链接
-- width (string): 宽
-- height (string): 高
function ui:addWebView(id, url, width, height)
	local arr = {
		["type"] = "WebView",
		["id"] = id,
		["url"] = url,
		["width"] = width,
		["height"] = height
	}
	table.insert(self.views, arr)
end

------------------------------------------------------------------------
----------------------------------- 展示UI -------------------------------
------------------------------------------------------------------------

local function split(str)
	local tab = {}
	for n in string.gmatch(str, "(%w+)") do
		table.insert(tab, n)
	end
	return tab
end

local read = function(tmp, retTable)
	local retTable = retTable
	for k,v in pairs(retTable) do 
		local tmp_k = tmp[k]
		if tmp_k.CK then
			local tab = split(v)
			retTable[k] = {}
			for n = 1, # tab do
				local key = tmp_k[tab[n] + 1]
				retTable[k][key] = true
			end
		elseif tmp_k.RC then
			local value = tmp_k[v + 1]
			retTable[k] = value
		end
	end
	return retTable
end

local tableToJson = function(t)
	local function serialize(tbl)
		local tmp = {}
		for k, v in pairs(tbl) do
			local k_type = type(k)
			local v_type = type(v)
			local key 
			if k_type == "string" then
				key = "\"" .. k .. "\":"
			elseif k_type == "number" then
				key = ""
			end
			local value
			if v_type == "table" then
				value = serialize(v)
			elseif v_type == "boolean" then
				value = tostring(v)
			elseif v_type == "string" then
				value = "\"" .. v .. "\""
			 elseif v_type == "number" then
				value = v
			 end
			tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil
		end
		if #tbl == 0 then
			return "{" .. table.concat(tmp, ",") .. "}"
		else
			return "[" .. table.concat(tmp, ",") .. "]"
		end
	end
	return serialize(t)
end 

function ui:show()
	local MyJsonString = tableToJson(self.ui_table)
	local ret,retTable = showUI(MyJsonString)
	for k,v in pairs(self.tmp) do
		if v then
			retTable = read(self.tmp,retTable)
			return ret, retTable
		end
	end
	return ret,retTable
end

return ui