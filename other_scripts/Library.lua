--[[
You do not have permission to use this Library in any projects without direct consent from one of the following users:
Someone Insane#9501
sean.#1749

Need an example? See: https://bruh.keshhub.com/Example.lua
--]]

local plrs = game:GetService("Players")
local ws = game:GetService("Workspace")
local ts = game:GetService("TweenService")
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local sg = game:GetService("StarterGui")
local http = game:GetService("HttpService")

if not game:IsLoaded() then
	game.Loaded:wait()
end
local isStudio = run:IsStudio()
if not isStudio then
	BruhHubActive = BruhHubActive;getgenv = getgenv;setclipboard = setclipboard
	if BruhHubActive then return else
		getgenv().BruhHubActive = true
	end
	pcall(game.HttpGet,game,"https://bruh.keshhub.com")
	for i, v in pairs(cg:GetChildren()) do
		if v.Name:match("Bruh ") and v.Name:match(" - ") then
			v:Destroy()
		end
	end
end

local camera = ws:FindFirstChildOfClass("Camera")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local getCustomAsset = getcustomasset or getsynasset

local library = {
	Rainbow = Color3.new(1,0,0),
	rainbowOffset = .005,
	rainbowAnimate = {},
};local animate = library.rainbowAnimate
math.randomseed(os.time())

local function deepCopy(tbl)
    local output = {}
    for i, v in next, tbl do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        output[i] = v
    end
    return output
end
local function tableFind(self,value)
	for i, v in next, self do
		if v == value then
			return i
		end
	end
end

local defaultTheme = {
	homeImageSprite = "hi",
	backgroundColor = Color3.fromRGB(43, 45, 50),
	borderColor = Color3.fromRGB(26, 27, 30),
	componentColor1 = Color3.fromRGB(34, 37, 40),
	componentColor2 = Color3.fromRGB(47, 49, 54),
	interactableOn = Color3.fromRGB(0, 133, 249),
	interactableOff = Color3.fromRGB(255, 65, 65),
}
local subscribed = {
	homeImageSprite = {},
	backgroundColor = {},
	borderColor = {},
	componentColor1 = {},
	componentColor2 = {},
	interactableOn = {},
	interactableOff = {},
}
local theme = setmetatable(deepCopy(defaultTheme),{
	__newindex = function(self,index,value)
		if index == "homeImageSprite" and isfile(value) then
			local image = getCustomAsset(value)
			rawset(self,index,image)
			for i, v in next, subscribed[index] do
				v.Image = image
			end
		else
			rawset(self,index,value)
			for i, v in next, subscribed[index] do
				v.obj[v.property] = value
			end
		end
	end
})

local function create(class,props)
	local obj = Instance.new(class)
	for i, v in pairs(props) do
		if i ~= "Parent" then
			obj[i] = v
		end
		if props.Name ~= "Color" then
			local index = tableFind(defaultTheme,v)
			if index then
				local subscription = subscribed[index]
				subscription[#subscription + 1] = {
					obj = obj,
					property = i,
				}
				obj[i] = theme[index]
			end
		end
	end
	obj.Parent = props.Parent
	return obj
end
local function tween(obj,time,prop,value)
	local tweenInstance = ts:Create(obj,TweenInfo.new(time),{[prop]=value})
	tweenInstance:Play()
	tweenInstance.Completed:wait()
end
local wrap = coroutine.wrap
local shortenKeyName;do
	local translations = setmetatable({
		MouseButton1 = "MB1",MouseButton2 = "MB2",
		Backspace = "BACK",Quote = "'",
		Zero = "0",One = "1",Two = "2",Three = "3",Four = "4",Five = "5",Six = "6",Seven = "7",Eight = "8",Nine = "9",
		Semicolon = ";",Equals = "=",LeftBracket = "[",RightBracket = "]",BackSlash = "\\",Slash = "/",Backquote = "`",
		LeftShift = "LSHFT",RightShift = "RSHFT",LeftAlt = "LALT",RightAlt = "RALT",LeftControl = "LCRTL",RightControl = "RCRTL",
		CapsLock = "CAPS",NumLock = "NUM",ScrollLock = "SCROLL",
		Comma = ","
	},{
		__index = function(self,index)
			return index
		end
	})
	shortenKeyName = function(name)
		return translations[name]:upper()
	end
end

do
	local c = ""
	for i = 48, 57 do c = c .. string.char(i) end
	for i = 65, 90 do c = c .. string.char(i) end
	for i = 97, 122 do c = c .. string.char(i) end
	library.chars = c
end
local function randomString(len,concat)
	local output = " - "
	for i = 1, len do
		i = math.random(library.chars:len())
		output = output .. library.chars:sub(i,i)
	end
	return (concat and concat..output) or output
end
local function roundCorner(obj,scale,offset)
	create("UICorner",{
		Parent = obj,
		CornerRadius = UDim.new(scale or 0,offset or 4),
	})
end

do
	local val = 0
	local pi = math.pi
	local newHSV = Color3.fromHSV
	local acos = math.acos
	local cos = math.cos

	run.Heartbeat:Connect(function()
		local rainbow = newHSV(acos(cos(val*pi))/pi,.65,1)
		library.Rainbow = rainbow
		val = val + library.rainbowOffset

		for i, v in next, animate do
			v.BackgroundColor3 = rainbow
		end
	end)
end

local uiTbl = {}
function library.new(name)
	if uiTbl.ui then uiTbl.ui:Destroy() uiTbl.ui = nil end
	
	local functions = {}
	local ui = create("ScreenGui",{
		Name = randomString(16,name),
		Parent = isStudio and plr.PlayerGui or cg,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	});uiTbl.ui = ui
	local main = create("Frame",{
		Name = "MainUI",
		Parent = ui,
		BackgroundColor3 = Color3.fromRGB(43, 45, 50),
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 485, 0, 300),
		Visible = false,
	})
	local top = create("Frame",{
		Name = "TopBorder",
		Parent = main,
		Active = true,
		BackgroundColor3 = Color3.fromRGB(26, 27, 30),
		Size = UDim2.new(1, 0, 0, 25),
		ZIndex = 3,
	})
	local sidebar = create("Frame",{
		Name = "SideBar",
		Parent = main,
		BackgroundColor3 = Color3.fromRGB(26, 27, 30),
		Size = UDim2.new(0.349999994, 0, 1, 0),
		ZIndex = 3,
	})
	local menuHolder = create("ScrollingFrame",{
		Name = "Holder",
		Parent = sidebar,
		Active = true,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 30),
		Size = UDim2.new(1, 0, 1, -30),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 5,
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
	})
	local layout = create("UIListLayout",{
		Parent = menuHolder,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
	})
	local pageHolder = create("Frame",{
		Name = "Pages",
		Parent = main,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 0, 0, 25),
		Size = UDim2.new(1, 0, 1, -25),
	})
	local blur = create("Frame",{
		Name = "Blur",
		Parent = main,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.400,
		Position = UDim2.new(1, 0, 0, 15),
		Size = UDim2.new(1, 0, 1, -15),
		ZIndex = 2,
	})
	local gradient = create("UIGradient",{
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.37, Color3.fromRGB(26, 27, 30)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(26, 27, 30)),
		},
		Parent = blur,
	})
	local misc = create("Frame",{
		Name = "Misc",
		Parent = main,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Size = UDim2.new(1, 0, 0, 25),
		ZIndex = 3,
	})
	local minimize = create("TextButton",{
		Name = "Minimize",
		Parent = misc,
		BackgroundColor3 = Color3.fromRGB(255, 65, 65),
		Position = UDim2.new(1, -20, 0, 5),
		Size = UDim2.new(0, 15, 0, 15),
		AutoButtonColor = false,
		Font = Enum.Font.SourceSans,
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14.000,
	})
	local name = create("TextLabel",{
		Name = "Name",
		Parent = misc,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 30, 0, 1),
		Size = UDim2.new(1, -55, 0, 23),
		Font = Enum.Font.Jura,
		Text = "Bruh Hub",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 24.000,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local menu = create("ImageButton",{
		Name = "Menu",
		Parent = misc,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 5, 0, 2),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://2038908845",
		ImageRectOffset = Vector2.new(15, 15),
		ImageRectSize = Vector2.new(190, 190),
	})
	roundCorner(main)
	roundCorner(top)
	roundCorner(sidebar)
	roundCorner(blur)
	roundCorner(minimize)
	
	local vpSize = camera.ViewportSize/2
	local absPos = main.AbsoluteSize
	main.Position = UDim2.new(0, vpSize.X - (absPos.X/2), 0, vpSize.Y - (absPos.Y/2))

	local menuToggled,menuDebounce = true,false
	local uiMinimized,minimizeDebounce
	local function toggleMenu()
		if menuDebounce or uiMinimized then return end
		menuDebounce = true
		if menuToggled then
			coroutine.wrap(tween)(sidebar,.25,"Position",UDim2.new(-.5, 0, 0, 0))
			coroutine.wrap(tween)(blur,.15,"Size",UDim2.new(1.5, 0, 1, -15))
			tween(blur,.25,"BackgroundTransparency",1)
		else
			coroutine.wrap(tween)(sidebar,.25,"Position",UDim2.new(0, 0, 0, 0))
			coroutine.wrap(tween)(blur,.25,"Size",UDim2.new(1, 0, 1, -15))
			tween(blur,.25,"BackgroundTransparency",.4)
		end
		menuToggled = not menuToggled
		menuDebounce = false
	end
	local function minimizeUI()
		if minimizeDebounce then return end
		minimizeDebounce = true
		if uiMinimized then
			coroutine.wrap(tween)(main,.35,"Size",UDim2.new(0, 485, 0, 300))
			tween(minimize,.35,"BackgroundColor3",Color3.fromRGB(255, 65, 65))
		else
			if menuToggled then toggleMenu() end
			coroutine.wrap(tween)(main,.35,"Size",UDim2.new(0, 485, 0, 25))
			tween(minimize,.35,"BackgroundColor3",Color3.fromRGB(0, 133, 249))
		end
		uiMinimized = not uiMinimized
		minimizeDebounce = false
	end
	menu.MouseButton1Click:Connect(toggleMenu)
	minimize.MouseButton1Click:Connect(minimizeUI)

	local draggingUI,startPos,startInput,sliderActive
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			startPos = main.Position
			startInput = input.Position
			draggingUI = true
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingUI = false
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and draggingUI and not sliderActive then
			local delta = input.Position - startInput
			local screenSize = camera.ViewportSize
			local uiSize = main.Size
			local x = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - uiSize.X.Offset)
			local y = math.clamp(startPos.Y.Offset + delta.Y, -36, screenSize.Y - uiSize.Y.Offset - 36)
			tween(main,.05,"Position",UDim2.new(0, x, 0, y))
		end
	end)

	menuHolder.ChildAdded:Connect(function(obj)
		wait(.1)
		menuHolder.CanvasSize = UDim2.new(0, 0, 0, obj.AbsolutePosition.Y + obj.Size.Y.Offset + menuHolder.CanvasPosition.Y - menuHolder.AbsolutePosition.Y)
	end)

	function functions:Loader(version)
		local loader = {}
		local loaderFrame = create("Frame",{
			Name = "Loader",
			Parent = ui,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(43, 45, 50),
			ClipsDescendants = true,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 23),
			Visible = false,
		})
		local top = create("Frame",{
			Name = "TopBorder",
			Parent = loaderFrame,
			BackgroundColor3 = Color3.fromRGB(26, 27, 30),
			Size = UDim2.new(1, 0, 0, 23),
		})
		local versionTitle = create("TextLabel",{
			Name = "Version",
			Parent = top,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 100, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),
			Font = Enum.Font.Nunito,
			Text = version,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18.000,
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		local name = create("TextLabel",{
			Name = "Name",
			Parent = top,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, -97, 0, 0),
			Size = UDim2.new(1, 0, 0, 23),
			Font = Enum.Font.Jura,
			Text = "Bruh Hub",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 24.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local body = create("TextLabel",{
			Name = "Body",
			Parent = loaderFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 0, 0, 23),
			Size = UDim2.new(1, 0, 0, 40),
			Font = Enum.Font.Gotham,
			Text = "Loading...",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 17.000,
		})
		roundCorner(loaderFrame)
		roundCorner(top)

		function loader:SetText(text)
			body.Text = text
		end
		function loader:Toggle(toggled)
			if toggled then
				loaderFrame.Visible = true
				tween(loaderFrame,.25,"Size",UDim2.new(0, 250, 0, 23))
				tween(loaderFrame,.25,"Size",UDim2.new(0, 250, 0, 65))
				coroutine.wrap(tween)(versionTitle,.25,"Position",UDim2.new(0, 0, 0, 0))
				tween(name,.25,"Position",UDim2.new(0, 3, 0, 0))
			else
				coroutine.wrap(tween)(versionTitle,.25,"Position",UDim2.new(0, 100, 0, 0))
				tween(name,.25,"Position",UDim2.new(0, -97, 0, 0))
				tween(loaderFrame,.25,"Size",UDim2.new(0, 250, 0, 23))
				tween(loaderFrame,.25,"Size",UDim2.new(0, 0, 0, 23))
				loaderFrame.Visible = false
			end
			return true
		end
		return loader
	end
	function functions:PickColor(default,callback)
		local colorPicker = create("Frame",{
			Name = "ColorPicker",
			Parent = ui,
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(26, 27, 30),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 300, 0, 225),
			Visible = true,
		})
		local value = create("ImageLabel",{
			Name = "Value",
			Parent = colorPicker,
			BackgroundColor3 = default,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 10, 0, 11),
			Size = UDim2.new(0, 280, 0, 161),
			Image = "rbxassetid://1720640939",
		})
		local valuePicker = create("ImageLabel",{
			Name = "Picker",
			Parent = value,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 275, 0, -5),
			Size = UDim2.new(0, 10, 0, 10),
			Image = "rbxassetid://3926305904",
			ImageRectOffset = Vector2.new(731, 211),
			ImageRectSize = Vector2.new(22, 22),
		})
		local hue = create("Frame",{
			Name = "Hue",
			Parent = colorPicker,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Position = UDim2.new(0, 10, 0, 180),
			Size = UDim2.new(0, 280, 0, 4),
		})
		local hueGradient = create("UIGradient",{
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
			},
			Parent = hue,
		})
		local huePicker = create("Frame",{
			Name = "Ball",
			Parent = hue,
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = .650,
			Position = UDim2.new(0, -5, .5, 0),
			Size = UDim2.new(0, 10, 0, 10),
		})
		local done = create("TextButton",{
			Name = "Done",
			Parent = colorPicker,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(0, 235, 0, 195),
			Size = UDim2.new(0, 55, 0, 25),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "Done",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
		})
		local rainbow = create("TextButton",{
			Name = "Rainbow",
			Parent = colorPicker,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(0, 155, 0, 195),
			Size = UDim2.new(0, 75, 0, 25),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "Rainbow",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
		})
		local preview = create("Frame",{
			Name = "Preview",
			Parent = colorPicker,
			BackgroundColor3 = default,
			Position = UDim2.new(0, 10, 0, 195),
			Size = UDim2.new(0, 25, 0, 25),
		})
		roundCorner(colorPicker)
		roundCorner(hue,1)
		roundCorner(huePicker,1)
		roundCorner(done)
		roundCorner(rainbow)
		roundCorner(preview)

		local h,s,v = Color3.toHSV(default)
		do
			local sliderSize = hue.Size.X.Offset
			local sliding,startPos,startInput
			hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					startPos = huePicker.Position.X.Offset
					startInput = input.Position

					startPos = startPos + startInput.X - huePicker.AbsolutePosition.X
					sliding = true
					sliderActive = true
					h = startPos/sliderSize

					coroutine.wrap(tween)(huePicker,.1,"Position",UDim2.new(0, math.clamp(startPos - 5, -5, sliderSize), .5, 0))
					coroutine.wrap(tween)(value,.1,"BackgroundColor3",Color3.fromHSV(h,1,1))
					tween(preview,.1,"BackgroundColor3",Color3.fromHSV(h,s,v))
				end
			end)
			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
					sliderActive = false
				end
			end)
			uis.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
					local delta = input.Position - startInput
					local x = math.clamp(startPos + delta.X, 0, sliderSize)
					h = x/sliderSize

					coroutine.wrap(tween)(huePicker,.05,"Position",UDim2.new(0, math.clamp(x - 5, -5, sliderSize), .5, 0))
					coroutine.wrap(tween)(value,.05,"BackgroundColor3",Color3.fromHSV(h,1,1))
					tween(preview,.05,"BackgroundColor3",Color3.fromHSV(h,s,v))
				end
			end)
			huePicker.Position = UDim2.new(0, (h == 1 and 0 or h) * sliderSize - 5, .5, 0)
		end
		do
			local sliderSizeX = value.Size.X.Offset
			local sliderSizeY = value.Size.Y.Offset
			local sliding,startInput,startPosX,startPosY
			value.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					startPosX = valuePicker.Position.X.Offset
					startPosY = valuePicker.Position.Y.Offset
					startInput = input.Position

					startPosX = startPosX + startInput.X - valuePicker.AbsolutePosition.X
					startPosY = startPosY + startInput.Y - valuePicker.AbsolutePosition.Y
					sliding = true
					sliderActive = true

					s = startPosX/sliderSizeX
					v = math.abs(1 - startPosY/sliderSizeY)

					local color = Color3.fromHSV(h,s,v)
					local x = math.clamp(startPosX - 5, -5, sliderSizeX)
					local y = math.clamp(startPosY - 5, -5, sliderSizeY)

					coroutine.wrap(tween)(valuePicker,.1,"Position",UDim2.new(0, x, 0, y))
					tween(preview,.1,"BackgroundColor3",color)
				end
			end)
			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
					sliderActive = false
				end
			end)
			uis.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
					local delta = input.Position - startInput
					local x = math.clamp(startPosX + delta.X, 0, sliderSizeX)
					local y = math.clamp(startPosY + delta.Y, 0, sliderSizeY)

					s = x/sliderSizeX
					v = math.abs(1 - y/sliderSizeY)
					local color = Color3.fromHSV(h,s,v)
					x = math.clamp(x - 5, -5, sliderSizeX)
					y = math.clamp(y - 5, -5, sliderSizeY)

					coroutine.wrap(tween)(valuePicker,.05,"Position",UDim2.new(0, x, 0, y))
					tween(preview,.05,"BackgroundColor3",color)
				end
			end)
			valuePicker.Position = UDim2.new(0, s*sliderSizeX - 5, 0, math.abs(1 - v) * sliderSizeY)
		end

		done.MouseButton1Click:Connect(function()
			wrap(callback)(preview.BackgroundColor3)
			colorPicker:Destroy()
		end)
		rainbow.MouseButton1Click:Connect(function()
			wrap(callback)("Rainbow")
			colorPicker:Destroy()
		end)
	end
	function functions:FileExplorer(path,extension,callback)
        path = path or ""
        extension = extension or ""
        local extensionLength = extension:len()
        
		local fileExplorer = create("Frame",{
			Name = "FileExplorer",
			Parent = ui,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(26, 27, 30),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 450, 0, 225),
			Visible = true,
		})
		local cancel = create("TextButton",{
			Name = "Cancel",
			Parent = fileExplorer,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(1, -60, 1, -30),
			Size = UDim2.new(0, 55, 0, 25),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "Cancel",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
		})
		local done = create("TextButton",{
			Name = "Select",
			Parent = fileExplorer,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(1, -165, 1, -30),
			Size = UDim2.new(0, 100, 0, 25),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "Select File(s)",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
		})
        local refresh = create("TextButton",{
			Name = "Refresh",
			Parent = fileExplorer,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(1, -230, 1, -30),
			Size = UDim2.new(0, 60, 0, 25),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "Refresh",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
		})
		local nameFrame = create("Frame",{
			Name = "NamePrompt",
			Parent = fileExplorer,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(47, 49, 54),
			Position = UDim2.new(0, 5, 1, -30),
			Size = UDim2.new(0, 210, 0, 25),
			Visible = true,
		})
		local namePrompt = create("TextBox",{
			Parent = nameFrame,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),
			Font = Enum.Font.Gotham,
			PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
			PlaceholderText = "File Name",
			Text = "",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 15.000,
			TextXAlignment = Enum.TextXAlignment.Left,
            ClipsDescendants = true,
		})
		local fileFrame = create("Frame",{
			Name = "FileHolder",
			Parent = fileExplorer,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(43, 45, 50),
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			BorderSizePixel = 0,
			Size = UDim2.new(1, -10, 1, -40),
			Position = UDim2.new(0,5,0,5),
			Visible = true,
		})
		local fileHolder = create("ScrollingFrame",{
			Parent = fileFrame,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(43, 45, 50),
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -5, 1, -10),
			Position = UDim2.new(0,5,0,5),
			Visible = true,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 5,
		})
    	local layout = create("UIListLayout",{
    		Parent = fileHolder,
    		SortOrder = Enum.SortOrder.LayoutOrder,
    		Padding = UDim.new(0, 5),
    	})
		local template = create("TextButton",{
			BackgroundColor3 = Color3.fromRGB(255, 65, 65),
			Size = UDim2.new(0, 15, 0, 15),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 14.000,
			Visible = true,
		})
		local fileName = create("TextLabel",{
			Parent = template,
            Name = "FileName",
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Position = UDim2.new(0, 20, 0, 0),
			Size = UDim2.new(0, 425, 1, 0),
			Font = Enum.Font.Gotham,
			Text = "Template",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 15.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
        roundCorner(fileExplorer)
        roundCorner(done)
        roundCorner(cancel)
        roundCorner(refresh)
        roundCorner(nameFrame)
        roundCorner(fileFrame)
        roundCorner(template)

        local absPos = fileExplorer.AbsoluteSize
        fileExplorer.Position = UDim2.new(0, vpSize.X - (absPos.X/2), 0, vpSize.Y - (absPos.Y/2))

        local dragging,startPos,startInput
        fileExplorer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                startPos = fileExplorer.Position
                startInput = input.Position
                dragging = true
            end
        end)
        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        uis.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and not sliderActive then
                local delta = input.Position - startInput
                local screenSize = camera.ViewportSize
                local uiSize = fileExplorer.Size
                local x = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - uiSize.X.Offset)
                local y = math.clamp(startPos.Y.Offset + delta.Y, -36, screenSize.Y - uiSize.Y.Offset - 36)
                tween(fileExplorer,.05,"Position",UDim2.new(0, x, 0, y))
            end
        end)
        
        local selectedFiles = {}
        local files = setmetatable({},{
            __newindex = function(self,index,value)
                if value then
                    local file = template:Clone()
                    file.Name = value.shortened
                    file.FileName.Text = value.shortened
                    local selected,debounce

                    file.MouseButton1Click:Connect(function()
                        if debounce then return end
                        debounce = true
                        
                        if selected then
                            tween(file,.15,"BackgroundColor3",theme.interactableOff)
                            table.remove(selectedFiles,table.find(selectedFiles,value.fileName))
                        else
                            tween(file,.15,"BackgroundColor3",theme.interactableOn)
                            table.insert(selectedFiles,value.fileName)
                        end
                        
                        selected = not selected
                        debounce = false
                    end)

                    file.Parent = fileHolder
                    fileHolder.CanvasSize = UDim2.new(0, 0, 0, (#self + 1) * 20 - 5)
                else
                    fileHolder[index.shortened]:Destroy()
                end
                rawset(self,tableFind(self,index) or index,value)
            end
        })

        local function refreshList()
            for i, v in next, files do
                files[v] = nil
            end
            for i, v in next, listfiles(path) do
                if isfile(v) and (extensionLength == 0 or v:sub(-extensionLength) == extension) then
					local paths = (v:sub(1,v:len() - extensionLength)):split("/")
                    files[#files +1] = {
                        fileName = v,
                        shortened = paths[#paths],
                    }
                end
            end
        end;refreshList()refresh.MouseButton1Click:Connect(refreshList)
        done.MouseButton1Click:Connect(function()
            callback(selectedFiles,path .. namePrompt.Text .. extension)
            fileExplorer:Destroy()
        end)
        cancel.MouseButton1Click:Connect(function()
            callback({})
            fileExplorer:Destroy()
        end)
    end

	local pages = {}
	local selectedPage
	local pageButtons = setmetatable({},{
		__newindex = function(self,index,value)
			value.MouseButton1Click:Connect(function()
				if value ~= selectedPage then
					selectedPage = value
					local page = pages[index]
					for i, v in pairs(self) do
						coroutine.wrap(tween)(v.Parent,.1,"BackgroundTransparency",1)
						coroutine.wrap(tween)(pages[i],.25,"Position",UDim2.new(1, 0, 0, 0))
					end
					page.Position = UDim2.new(-1, 0, 0, 0)
					page.Visible = true
					coroutine.wrap(tween)(page,.25,"Position",UDim2.new(0, 0, 0, 0))
					coroutine.wrap(tween)(value.Parent,.1,"BackgroundTransparency",0)
				end
				toggleMenu()
			end)
			return rawset(self,index,value)
		end
	})

	function functions:AddPage(name,selected)
		local components = {}
		selected = selected or false

		local nameHolder = create("Frame",{
			Name = name,
			Parent = menuHolder,
			BackgroundColor3 = Color3.fromRGB(0, 133, 249),
			BackgroundTransparency = selected and 0 or 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 35),
		})
		local pageButton = create("TextButton",{
			Parent = nameHolder,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local page = create("ScrollingFrame",{
			Name = name,
			Parent = pageHolder,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = selected,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 5,
		})
		local columnOne = create("Frame",{
			Name = "One",
			Parent = page,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, 235, 1, -5),
		})
		local layout = create("UIListLayout",{
			Parent = columnOne,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		})
		local columnTwo = create("Frame",{
			Name = "Two",
			Parent = page,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 250, 0, 5),
			Size = UDim2.new(0, 235, 1, -5),
		})
		local layout = create("UIListLayout",{
			Parent = columnTwo,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		})
		if name == "Home" then
			subscribed.homeImageSprite[1] = create("ImageLabel",{
				Name = "Sprite",
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 0, 1, -230.25),
				Size = UDim2.new(0, 210, 0, 210), --UDim2.new(0, 192, 0, 230.25),
				Image = theme.homeImageSprite,
				ScaleType = Enum.ScaleType.Fit,
			})
		end
		pageButtons[#pageButtons + 1] = pageButton
		pages[#pages + 1] = page
		selectedPage = selected and pageButton or selectedPage
		local column = setmetatable({
			columnOne,
			columnTwo,
			previous = 2,
		},{
			__index = function(self,index)
				if index == "selected" then
					self.previous = self.previous == 1 and 2 or 1
				end
				return self[self.previous]
			end
		})

		local realPageSizes = {
			one = 5,
			two = 5,
			lastOne = nil,
			lastTwo = nil,
		}
		local pageSizes = setmetatable({},{
			__newindex = function(self,index,value)
				realPageSizes[index] = value
				local one = realPageSizes.one
				local two = realPageSizes.two
				local total = one > two and one or two
				page.CanvasSize = UDim2.new(0, 0, 0, total + 5)
			end
		})
		local function childAdded(obj)
			wait(.1)
			local column = obj.Parent.Name:sub(-3):lower()
			if obj:FindFirstChild("Search") then
				obj:GetPropertyChangedSignal("Size"):Connect(function()
					local last = realPageSizes["last"..column]
					pageSizes[column] = last.AbsolutePosition.Y + last.Size.Y.Offset + page.CanvasPosition.Y - page.AbsolutePosition.Y
				end)
			end
			pageSizes[column] = obj.AbsolutePosition.Y + obj.Size.Y.Offset + page.CanvasPosition.Y - page.AbsolutePosition.Y
			realPageSizes["last"..column] = obj
		end
		columnOne.ChildAdded:Connect(childAdded)
		columnTwo.ChildAdded:Connect(childAdded)

		function components:AddLabel(text,showFrame,textSize,labelSize,selectedColumn)
			showFrame = showFrame and 0 or 1
			textSize = textSize or 14
			labelSize = labelSize or 30
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local label = create("TextLabel",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				BackgroundTransparency = showFrame,
				Size = UDim2.new(1, -5, 0, labelSize),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = textSize,
			})
			roundCorner(label)
			return function(text)
				label.Text = tostring(text)
			end
		end
		function components:AddButton(text,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local button = create("TextButton",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 30),
				AutoButtonColor = false,
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			roundCorner(button)
			button.MouseButton1Click:Connect(callback)
		end
		function components:AddToggle(text,default,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local toggle = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 30),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = toggle,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local large = create("TextButton",{
				Name = "Large",
				Parent = toggle,
				BackgroundColor3 = default and Color3.fromRGB(0, 133, 249) or Color3.fromRGB(47, 49, 54),
				Position = UDim2.new(1, -50, 0, 8),
				Size = UDim2.new(0, 45, 0, 16),
				AutoButtonColor = false,
				Font = Enum.Font.SourceSans,
				Text = "",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			local ball = create("Frame",{
				Name = "Ball",
				Parent = large,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = default and UDim2.new(1, -20, 0, -2) or UDim2.new(0, 0, 0, -2),
				Size = UDim2.new(0, 20, 0, 20),
			})
			roundCorner(toggle)
			roundCorner(large,1)
			roundCorner(ball,1)

			local toggled,debounce = default,false
			large.MouseButton1Click:Connect(function()
				if debounce then return end
				debounce = true
				if toggled then
					coroutine.wrap(tween)(large,.1,"BackgroundColor3",theme.componentColor2)
					tween(ball,.1,"Position",UDim2.new(0, 0, 0, -2))
				else
					coroutine.wrap(tween)(large,.1,"BackgroundColor3",theme.interactableOn)
					tween(ball,.1,"Position",UDim2.new(1, -20, 0, -2))
				end
				toggled = not toggled
				wrap(callback)(toggled)
				debounce = false
			end)
		end
		function components:AddSlider(text,default,min,max,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local realMax = max - min
			local slider = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 45),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = slider,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 0, 30),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local box = create("TextBox",{
				Parent = slider,
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Position = UDim2.new(1, -75, 0, 5),
				Size = UDim2.new(0, 70, 0, 20),
				Font = Enum.Font.Nunito,
				PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
				PlaceholderText = max,
				Text = default,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 15.000,
			})
			local negative = create("Frame",{
				Name = "Negative",
				Parent = slider,
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Position = UDim2.new(0, 7, 0, 33),
				Size = UDim2.new(0, 215, 0, 5),
			});local sliderSize = negative.Size.X.Offset
			local filler = create("Frame",{
				Name = "Filler",
				Parent = negative,
				BackgroundColor3 = Color3.fromRGB(0, 133, 249),
				Size = UDim2.new(0, default/realMax * sliderSize - min/realMax * sliderSize, 1, 0),
			})
			local ball = create("Frame",{
				Name = "Ball",
				Parent = negative,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.new(0, default/realMax * sliderSize - min/realMax * sliderSize - 5, 0.5, 0),
				Size = UDim2.new(0, 10, 0, 10),
			})
			local value = create("IntValue",{
				Parent = ball,
				Value = default,
			})
			roundCorner(slider)
			roundCorner(box)
			roundCorner(negative,1)
			roundCorner(filler,1)
			roundCorner(ball,1)

			local sliding,startPos,startInput
			negative.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					startPos = ball.Position.X.Offset
					startInput = input.Position

					startPos = startPos + startInput.X - ball.AbsolutePosition.X
					sliding = true
					sliderActive = true

					coroutine.wrap(tween)(ball,.1,"Position",UDim2.new(0, math.clamp(startPos - 5, -5, sliderSize), .5, 0))
					coroutine.wrap(tween)(filler,.1,"Size",UDim2.new(0, startPos, 1, 0))
					tween(value,.1,"Value",startPos/sliderSize * realMax + min)
				end
			end)
			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
					sliderActive = false
				end
			end)
			uis.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
					local delta = input.Position - startInput
					local x = math.clamp(startPos + delta.X, 0, sliderSize)

					coroutine.wrap(tween)(ball,.05,"Position",UDim2.new(0, math.clamp(x - 5, -5, sliderSize), .5, 0))
					coroutine.wrap(tween)(filler,.05,"Size",UDim2.new(0, x, 1, 0))
					tween(value,.05,"Value",x/sliderSize * realMax + min)
				end
			end)
			box.FocusLost:Connect(function()
				local input = tonumber(box.Text)
				if input then
					input = math.ceil(math.clamp(input,min,max))
					box.Text = input
					local x = input/realMax * sliderSize - min/realMax * sliderSize

					coroutine.wrap(tween)(ball,.1,"Position",UDim2.new(0, math.clamp(x - 5, -5, sliderSize), .5, 0))
					coroutine.wrap(tween)(filler,.1,"Size",UDim2.new(0, x, 1, 0))
					tween(value,.1,"Value",input)
				else
					box.Text = value.Value
				end
			end)
			value.Changed:Connect(function(num)
				box.Text = num
				callback(num)
			end)
		end
		function components:AddKeybind(text,default,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local keybind = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 30),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = keybind,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local box = create("TextButton",{
				Parent = keybind,
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Position = UDim2.new(1, -75, 0, 5),
				Size = UDim2.new(0, 70, 0, 20),
				AutoButtonColor = false,
				Font = Enum.Font.SourceSans,
				Text = default.shortened,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			roundCorner(keybind)
			roundCorner(box)

			local pickingKey,pressedKey
			box.MouseButton1Click:Connect(function()
				if pickingKey then return end
				pickingKey = true
				box.Text = "..."
			end)
			uis.InputBegan:Connect(function(input)
				if pickingKey and not pressedKey then
					pressedKey = false

					local keyCode
					if input.UserInputType.Name == "Keyboard" then
						keyCode = input.KeyCode
					else
						keyCode = input.UserInputType
					end
					local keyName = keyCode.Name
					local shortenedKeyName = shortenKeyName(keyName)

					box.Text = shortenedKeyName
					default.keyName = keyName
					default.shortened = shortenedKeyName
					default.key = keyCode
					wrap(callback)(default)

					wait(1)
					pressedKey = false
					pickingKey = false
				end
			end)
		end
		function components:AddColor(text,default,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local colorPicker = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 30),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = colorPicker,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local colorButton = create("TextButton",{
				Name = "Color",
				Parent = colorPicker,
				BackgroundColor3 = type(default) ~= "string" and default or library.Rainbow,
				Position = UDim2.new(1, -25, 0, 6),
				Size = UDim2.new(0, 20, 0, 20),
				AutoButtonColor = false,
				Font = Enum.Font.SourceSans,
				Text = "",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			roundCorner(colorPicker)
			roundCorner(colorButton)

			if type(default) == "string" then
				animate[#animate + 1] = colorButton
			end
			local picking = false
			colorButton.MouseButton1Click:Connect(function()
				if picking then return end
				picking = true

				functions:PickColor(colorButton.BackgroundColor3,function(color)
					local index = tableFind(animate,colorButton)
					if color == "Rainbow" then
						if not index then
							table.insert(animate,colorButton)
							animate[#animate + 1] = colorButton
						end
					else
						if index then
							table.remove(animate,index)
						end
						colorButton.BackgroundColor3 = color
					end
					wrap(callback)(color)
					picking = false
				end)
			end)
		end
		function components:AddDropdown(text,default,multiple,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local dropdown = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				ClipsDescendants = true,
				Size = UDim2.new(1, -5, 0, 30),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = dropdown,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 0, 30),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local toggle = create("TextButton",{
				Name = "Toggle",
				Parent = dropdown,
				BackgroundColor3 = Color3.fromRGB(0, 133, 249),
				Position = UDim2.new(1, -24, 0, 5),
				Size = UDim2.new(0, 20, 0, 20),
				AutoButtonColor = false,
				Text = ""
			})
			local holder = create("ScrollingFrame",{
				Name = "Holder",
				Parent = dropdown,
				Active = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 30),
				Size = UDim2.new(1, 0, 1, -25),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 5,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			})
			local layout = create("UIListLayout",{
				Parent = holder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			})
			local template1 = create("TextButton",{
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Size = UDim2.new(1, -10, 0, 25),
				AutoButtonColor = false,
				Font = Enum.Font.Gotham,
				Text = "Option",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			local template2 = create("Frame",{
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(1, -10, 0, 25),
			})
			local title = create("TextLabel",{
				Name = "Title",
				Parent = template2,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 1, 0),
				Font = Enum.Font.Gotham,
				Text = "Option",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local large = create("TextButton",{
				Name = "Large",
				Parent = template2,
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Position = UDim2.new(1, -48, 0, 5),
				Size = UDim2.new(0, 45, 0, 16),
				AutoButtonColor = false,
				Font = Enum.Font.SourceSans,
				Text = "",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
			})
			local ball = create("Frame",{
				Name = "Ball",
				Parent = large,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.new(0, 0, 0, -2),
				Size = UDim2.new(0, 20, 0, 20),
			})
			local searchBar = create("Frame",{
				Name = "SearchBar",
				Parent = dropdown,
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.new(1, -29, 0, 5),
				Size = UDim2.new(0, 0, 0, 20),
			})
			local searchBox = create("TextBox",{
				Name = "SearchBox",
				Parent = searchBar,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -5, 1, 0),
				Font = Enum.Font.Gotham,
				PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
				PlaceholderText = "Search...",
				Text = "",
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 15.000,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local searchIcon = create("ImageButton",{
				Name = "Search",
				Parent = dropdown,
				BackgroundTransparency = 1.000,
				Position = UDim2.new(1, -47, 0, 7),
				Size = UDim2.new(0, 15, 0, 15),
				AutoButtonColor = false,
				Image = "rbxassetid://3926305904",
				ImageColor3 = Color3.fromRGB(150, 150, 150),
				ImageRectOffset = Vector2.new(968, 328),
				ImageRectSize = Vector2.new(27, 27),
			})
			roundCorner(dropdown)
			roundCorner(toggle)
			roundCorner(template1)
			roundCorner(large,1)
			roundCorner(ball,1)
			roundCorner(searchBar)
			local searching,searchDebounce
			local minimized,debounce = true,false
			
			local function search()
				local text = searchBox.Text:lower()
				local tooShort = text:len() == 0
				for i, v in pairs(holder:GetChildren()) do
					if not v:IsA("UIListLayout") then
						v.Visible = tooShort or v.Name:lower():match(text)
					end
				end
			end
			local function toggleSearch()
				if minimized or searchDebounce then return end
				searchDebounce = true

				if searching then
					searchBox.Text = ""
					search()
					tween(searchBar,.15,"Size",UDim2.new(0, 0, 0, 20))
				else
					tween(searchBar,.15,"Size",UDim2.new(1, -34, 0, 20))
				end
				
				searching = not searching
				searchDebounce = false
			end
			local function minimizeDropdown()
				if debounce then return end
				debounce = true
				
				if searching then
					toggleSearch()
					search()
				end
				if minimized then
					coroutine.wrap(tween)(dropdown,.35,"Size",UDim2.new(1, -5, 0, 180))
					tween(toggle,.35,"BackgroundColor3",theme.interactableOff)
				else
					if menuToggled then toggleMenu() end
					coroutine.wrap(tween)(dropdown,.35,"Size",UDim2.new(1, -5, 0, 30))
					tween(toggle,.35,"BackgroundColor3",theme.interactableOn)
				end
				
				minimized = not minimized
				debounce = false
			end
			searchBox:GetPropertyChangedSignal("Text"):Connect(search)
			searchIcon.MouseButton1Click:Connect(toggleSearch)
			toggle.MouseButton1Click:Connect(minimizeDropdown)
			
			local count = 0
			local dropdownFunctions = {}
			local realOptions = {}
			local options = setmetatable({},{
				__newindex = function(self,index,value)
					realOptions[(type(index) == "number" or multiple) and index or tableFind(realOptions,index)] = value
					count = count + (value ~= nil and 1 or -1)
					holder.CanvasSize = UDim2.new(0, 0, 0, count * 30)

					if value == nil then
						return holder:FindFirstChild(index):Destroy()
					end
					if not multiple then
						local option = template1:Clone()
						option.Name = value
						option.Text = value
						option.Parent = holder

						while not option.TextFits do
							option.TextSize = option.TextSize - 1
							option.TextWrapped = true
						end
						option.MouseButton1Click:Connect(function()
							wrap(callback)(value)
							minimizeDropdown()
						end)
					else
						local toggled,debounce = value,false
						local option = template2:Clone()
						local title = option.Title
						local large = option.Large
						local ball = large.Ball
						title.Text = index
						large.BackgroundColor3 = toggled and theme.interactableOn or theme.componentColor2
						ball.Position = toggled and UDim2.new(1, -20, 0, -2) or UDim2.new(0, 0, 0, -2)
						option.Name = index
						option.Parent = holder

						if (title.TextBounds.X + 12) >= (option.AbsoluteSize-large.AbsoluteSize).X then
						    while (title.TextBounds.X + 12) >= (option.AbsoluteSize-large.AbsoluteSize).X do
						        title.TextSize = title.TextSize - 1
						    end
						end
						large.MouseButton1Click:Connect(function()
							if debounce then return end
							debounce = true
							if toggled then
								coroutine.wrap(tween)(large,.1,"BackgroundColor3",theme.componentColor2)
								tween(ball,.1,"Position",UDim2.new(0, 0, 0, -2))
							else
								coroutine.wrap(tween)(large,.1,"BackgroundColor3",theme.interactableOn)
								tween(ball,.1,"Position",UDim2.new(1, -20, 0, -2))
							end
							toggled = not toggled
							wrap(callback)(index,toggled)
							debounce = false
						end)
					end
					search()
				end
			})

			function dropdownFunctions:Add(option,selected)
				selected = not multiple and option or selected
				options[multiple and option or #realOptions + 1] = selected
			end
			function dropdownFunctions:Remove(option)
				assert(self:Has(option),"invalid argument #1 to 'Remove' (string expected)")
				options[option] = nil
			end
			function dropdownFunctions:Has(option)
				return (tableFind(realOptions,option) or realOptions[option] ~= nil) and true or false
			end
			function dropdownFunctions:Clear(option)
				for i, v in next, realOptions do
					options[type(v) ~= "bool" and v or i] = nil
				end
			end
			return dropdownFunctions
		end
		function components:AddBox(text,default,placeholder,clearOnFocus,callback,selectedColumn)
			selectedColumn = selectedColumn and column[selectedColumn] or column.selected
			local box = create("Frame",{
				Parent = selectedColumn,
				BackgroundColor3 = Color3.fromRGB(34, 37, 40),
				Size = UDim2.new(1, -5, 0, 30),
			})
			if text ~= nil then
				local title = create("TextLabel",{
					Name = "Title",
					Parent = box,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 5, 0, 0),
					Size = UDim2.new(1, -5, 1, 0),
					Font = Enum.Font.Gotham,
					Text = text,
					TextColor3 = Color3.fromRGB(225, 225, 225),
					TextSize = 14.000,
					TextXAlignment = Enum.TextXAlignment.Left,
				})
			end
			local textBox = create("TextBox",{
				Parent = box,
				BackgroundColor3 = Color3.fromRGB(47, 49, 54),
				Position = text and UDim2.new(1, -75, 0, 5) or UDim2.new(0, 5, 0, 5),
				Size = text and UDim2.new(0, 70, 0, 20) or UDim2.new(1, -10, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = default,
				TextColor3 = Color3.fromRGB(225, 225, 225),
				TextSize = 14.000,
				PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
				PlaceholderText = placeholder,
				ClearTextOnFocus = clearOnFocus,
			})
			roundCorner(box)
			roundCorner(textBox)

			textBox.FocusLost:Connect(function()
				callback(textBox.Text)
			end)
		end
		return components
	end
	
	function functions:Toggle(toggled)
		main.Visible = toggled == nil and not main.Visible or toggled
	end

	do
		local mb1,mb2 = Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton2
		local keyboardEnum = Enum.UserInputType.Keyboard
		local endState = Enum.UserInputState.End
		local home = functions:AddPage("Home",true);library.home = home

		function library.isKeyDown(keyData)
			local key = keyData.key
			local isMB = key == mb1 or key == mb2
			return isMB and uis:IsMouseButtonPressed(key) or not isMB and uis:IsKeyDown(key)
		end
		local function areKeysSame(keyData,input)
			local key = keyData.key
			local isMB = key == mb1 or key == mb2
			local isInputMB = not (input.UserInputType == keyboardEnum)
			if isMB ~= isInputMB then return false end
			return isMB and uis:IsMouseButtonPressed(key) or not isMB and key == input.KeyCode
		end
		function library:bind(keyData,callback,callOnRelease)
			uis.InputBegan:Connect(function(input,typing)
				if library.running() and not typing and areKeysSame(keyData,input) then
					callback()
				end
			end)
			if callOnRelease then
				uis.InputEnded:Connect(function(input,typing)
					if library.running() and not typing and areKeysSame(keyData,input) then
						callback(true)
					end
				end)
			end
		end

		home:AddLabel("Discord server: (URL)",false,20,20,1)
		home:AddButton("bruh.keshsenpai.com/invite",function()
			setclipboard("https://discord.gg/wZe74ZK")
			library:CreateNotification("Success!","Successfully copied URL to clipboard")
		end,1)
		home:AddLabel("Credits:",false,20,20,2)
		home:AddLabel("Someone Insane#9501",true,16,25,2)
		home:AddLabel("kesh#1749",true,16,25,2)
		home:AddLabel("Acknowledgments:",false,20,20,2)
		home:AddLabel("BruhRain#0420",true,16,25,2)
		home:AddLabel("ceg#0550",true,16,25,2)
		home:AddLabel("miau#0004",true,16,25,2)
		home:AddLabel("Ice Bear#1060",true,16,25,2)
		home:AddLabel("integer#1993",true,16,25,2)

		function library:addSettings()
			local settings = functions:AddPage("Settings");library.settings = settings
			library.Keybind = {
				shortened = "RSHFT",
				keyName = "RightShift",
				key = Enum.KeyCode.RightShift,
			}
			settings:AddKeybind("Toggle UI",library.Keybind,function(keyData)
				library.Keybind = keyData
			end)
			library:bind(library.Keybind,function()
				functions:Toggle()
			end)

			if isfile("BruhHubTheme.json") then
				settings:AddButton("Update Theme",library.updateTheme)
			end

			return settings
		end
	end

	return functions
end
function library:CreateNotification(title,body,duration)
	sg:SetCore("SendNotification",{
		Title = title,
		Text = body,
		Duration = duration,
	})
end
function library.running()
	return uiTbl.ui and uiTbl.ui:IsDescendantOf(isStudio and plr.PlayerGui or cg)
end
function library.updateTheme()
	if isfile("BruhHubTheme.json")then
		local newTheme = http:JSONDecode(readfile("BruhHubTheme.json"))
		for i, v in next, defaultTheme do
			if newTheme[i] == nil then
				newTheme[i] = v
			end
		end
		for i, v in next, newTheme do
			if theme[i] then
				theme[i] = nil
			end
			if type(v) == "table" then
				v = Color3.fromRGB(unpack(v))
			end
			theme[i] = v
		end
	else
		for i, v in next, defaultTheme do
			theme[i] = v
		end
	end
end;library.updateTheme()
function library.hook(func,hook,mode)
	if mode == "mt" then
		local wrapper = function(...)
			return shared[getinfo(1).func](...)
		end
		shared[wrapper] = hook
		return hookfunc(func,wrapper)
	else
		shared[func] = hook
		return hookfunc(func,function(...)
			return shared[getinfo(1).func](...)
		end)
	end
end

return library