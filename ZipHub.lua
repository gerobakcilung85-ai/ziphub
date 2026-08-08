--==================================================
-- ZIP HORROR ADMIN SYSTEM
-- CLIENT GUI
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ZipAdminRemote")

--==================================================
-- ADMIN LIST
--==================================================

local ADMINS = {
	[8801724233] = true, -- GANTI DENGAN USER ID ROBLOX-MU
}

if not ADMINS[player.UserId] then
	return
end

--==================================================
-- ROOT GUI
--==================================================

local gui = script.Parent

gui.ResetOnSpawn = false

--==================================================
-- HELPER
--==================================================

local function create(className, properties, parent)

	local object = Instance.new(className)

	for property, value in pairs(properties) do
		object[property] = value
	end

	object.Parent = parent

	return object
end

--==================================================
-- OPEN BUTTON
--==================================================

local openButton = create(
	"TextButton",
	{
		Name = "OpenButton",

		Size = UDim2.fromOffset(60, 60),

		Position =
			UDim2.new(
				0,
				18,
				0.5,
				-30
			),

		BackgroundColor3 =
			Color3.fromRGB(
				12,
				12,
				14
			),

		Text = "ZIP",

		TextColor3 =
			Color3.fromRGB(
				240,
				25,
				35
			),

		TextSize = 18,

		Font = Enum.Font.GothamBlack,

		AutoButtonColor = true,
	},
	gui
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				1,
				0
			),
	},
	openButton
)

create(
	"UIStroke",
	{
		Color =
			Color3.fromRGB(
				150,
				0,
				10
			),

		Thickness = 2,
	},
	openButton
)

--==================================================
-- MAIN WINDOW
--==================================================

local main = create(
	"Frame",
	{
		Name = "Main",

		Size =
			UDim2.fromOffset(
				650,
				430
			),

		Position =
			UDim2.new(
				0.5,
				-325,
				0.5,
				-215
			),

		BackgroundColor3 =
			Color3.fromRGB(
				9,
				9,
				11
			),

		Visible = false,
	},
	gui
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				0,
				12
			),
	},
	main
)

create(
	"UIStroke",
	{
		Color =
			Color3.fromRGB(
				110,
				0,
				10
			),

		Thickness = 2,
	},
	main
)

--==================================================
-- HEADER
--==================================================

local header = create(
	"Frame",
	{
		Size =
			UDim2.new(
				1,
				0,
				0,
				80
			),

		BackgroundColor3 =
			Color3.fromRGB(
				20,
				7,
				10
			),

		BorderSizePixel = 0,
	},
	main
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				0,
				12
			),
	},
	header
)

--==================================================
-- ZIP LOGO
--==================================================

local logo = create(
	"TextLabel",
	{
		Size =
			UDim2.fromOffset(
				180,
				50
			),

		Position =
			UDim2.fromOffset(
				20,
				5
			),

		BackgroundTransparency = 1,

		Text = "ZIP",

		TextColor3 =
			Color3.fromRGB(
				240,
				20,
				30
			),

		TextSize = 40,

		Font = Enum.Font.GothamBlack,

		TextXAlignment =
			Enum.TextXAlignment.Left,
	},
	header
)

--==================================================
-- SUBTITLE
--==================================================

create(
	"TextLabel",
	{
		Size =
			UDim2.fromOffset(
				300,
				25
			),

		Position =
			UDim2.fromOffset(
				22,
				48
			),

		BackgroundTransparency = 1,

		Text = "HORROR ADMIN CONTROL",

		TextColor3 =
			Color3.fromRGB(
				140,
				140,
				145
			),

		TextSize = 11,

		Font = Enum.Font.GothamBold,

		TextXAlignment =
			Enum.TextXAlignment.Left,
	},
	header
)

--==================================================
-- CLOSE
--==================================================

local close = create(
	"TextButton",
	{
		Size =
			UDim2.fromOffset(
				38,
				38
			),

		Position =
			UDim2.new(
				1,
				-52,
				0,
				21
			),

		BackgroundColor3 =
			Color3.fromRGB(
				70,
				10,
				15
			),

		Text = "X",

		TextColor3 =
			Color3.new(
				1,
				1,
				1
			),

		TextSize = 15,

		Font = Enum.Font.GothamBold,
	},
	header
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				0,
				7
			),
	},
	close
)

--==================================================
-- PLAYER TITLE
--==================================================

create(
	"TextLabel",
	{
		Size =
			UDim2.fromOffset(
				250,
				30
			),

		Position =
			UDim2.fromOffset(
				20,
				95
			),

		BackgroundTransparency = 1,

		Text = "PLAYER LIST",

		TextColor3 =
			Color3.fromRGB(
				230,
				230,
				230
			),

		TextSize = 16,

		Font = Enum.Font.GothamBold,

		TextXAlignment =
			Enum.TextXAlignment.Left,
	},
	main
)

--==================================================
-- PLAYER LIST
--==================================================

local playerList = create(
	"ScrollingFrame",
	{
		Name = "PlayerList",

		Size =
			UDim2.fromOffset(
				250,
				285
			),

		Position =
			UDim2.fromOffset(
				20,
				130
			),

		BackgroundColor3 =
			Color3.fromRGB(
				16,
				16,
				19
			),

		BorderSizePixel = 0,

		ScrollBarThickness = 4,

		CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				0
			),
	},
	main
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				0,
				8
			),
	},
	playerList
)

local layout = create(
	"UIListLayout",
	{
		Padding =
			UDim.new(
				0,
				5
			),

		SortOrder =
			Enum.SortOrder.Name,
	},
	playerList
)

--==================================================
-- ACTION PANEL
--==================================================

local actionPanel = create(
	"Frame",
	{
		Size =
			UDim2.fromOffset(
				350,
				285
			),

		Position =
			UDim2.fromOffset(
				285,
				130
			),

		BackgroundColor3 =
			Color3.fromRGB(
				16,
				16,
				19
			),

		BorderSizePixel = 0,
	},
	main
)

create(
	"UICorner",
	{
		CornerRadius =
			UDim.new(
				0,
				8
			),
	},
	actionPanel
)

--==================================================
-- SELECTED TARGET
--==================================================

local selectedPlayer = nil

local targetLabel = create(
	"TextLabel",
	{
		Size =
			UDim2.new(
				1,
				-20,
				0,
				40
			),

		Position =
			UDim2.fromOffset(
				10,
				10
			),

		BackgroundTransparency = 1,

		Text = "TARGET: NONE",

		TextColor3 =
			Color3.fromRGB(
				235,
				30,
				40
			),

		TextSize = 15,

		Font = Enum.Font.GothamBold,

		TextXAlignment =
			Enum.TextXAlignment.Left,
	},
	actionPanel
)

--==================================================
-- BUTTON CREATOR
--==================================================

local function createActionButton(
	text,
	x,
	y,
	action
)

	local button = create(
		"TextButton",
		{
			Size =
				UDim2.fromOffset(
					150,
					45
				),

			Position =
				UDim2.fromOffset(
					x,
					y
				),

			BackgroundColor3 =
				Color3.fromRGB(
					35,
					18,
					21
				),

			Text = text,

			TextColor3 =
				Color3.fromRGB(
					235,
					235,
					235
				),

			TextSize = 12,

			Font = Enum.Font.GothamBold,
		},
		actionPanel
	)

	create(
		"UICorner",
		{
			CornerRadius =
				UDim.new(
					0,
					7
				),
		},
		button
	)

	create(
		"UIStroke",
		{
			Color =
				Color3.fromRGB(
					70,
					25,
					30
				),

			Thickness = 1,
		},
		button
	)

	button.MouseButton1Click:Connect(function()

		if action == "KillAll" then

			remote:FireServer(
				"KillAll"
			)

			return
		end

		if not selectedPlayer then
			return
		end

		remote:FireServer(
			action,
			selectedPlayer.Name
		)

	end)

	return button
end

--==================================================
-- ACTION BUTTONS
--==================================================

createActionButton(
	"HEAL",
	15,
	60,
	"Heal"
)

createActionButton(
	"KILL",
	180,
	60,
	"Kill"
)

createActionButton(
	"BRING",
	15,
	115,
	"Bring"
)

createActionButton(
	"TELEPORT",
	180,
	115,
	"Teleport"
)

createActionButton(
	"FREEZE",
	15,
	170,
	"Freeze"
)

createActionButton(
	"UNFREEZE",
	180,
	170,
	"Unfreeze"
)

createActionButton(
	"RESPAWN",
	15,
	225,
	"Respawn"
)

createActionButton(
	"KILL ALL",
	180,
	225,
	"KillAll"
)

--==================================================
-- REFRESH PLAYER LIST
--==================================================

local function refreshPlayers()

	for _, child in ipairs(
		playerList:GetChildren()
	) do

		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, target in ipairs(
		Players:GetPlayers()
	) do

		local button = create(
			"TextButton",
			{
				Size =
					UDim2.new(
						1,
						-10,
						0,
						38
					),

				BackgroundColor3 =
					Color3.fromRGB(
						27,
						27,
						30
					),

				Text =
					target.DisplayName,

				TextColor3 =
					Color3.fromRGB(
						220,
						220,
						220
					),

				TextSize = 12,

				Font =
					Enum.Font.GothamMedium,
			},
			playerList
		)

		create(
			"UICorner",
			{
				CornerRadius =
					UDim.new(
						0,
						6
					),
			},
			button
		)

		button.MouseButton1Click:Connect(
			function()

				selectedPlayer = target

				targetLabel.Text =
					"TARGET: "
					.. target.DisplayName

			end
		)
	end

	task.wait()

	playerList.CanvasSize =
		UDim2.fromOffset(
			0,
			layout.AbsoluteContentSize.Y + 10
		)
end

--==================================================
-- PLAYER EVENTS
--==================================================

refreshPlayers()

Players.PlayerAdded:Connect(
	refreshPlayers
)

Players.PlayerRemoving:Connect(
	refreshPlayers
)

--==================================================
-- WINDOW CONTROLS
--==================================================

openButton.MouseButton1Click:Connect(
	function()

		main.Visible =
			not main.Visible

	end
)

close.MouseButton1Click:Connect(
	function()

		main.Visible = false

	end
)

print(
	"ZIP HORROR ADMIN GUI LOADED"
)
