local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local GuiName = "LumberTycoon2"
local player = Players.LocalPlayer

local Config = {
    Background = Color3.fromRGB(12, 12, 14),
    Surface = Color3.fromRGB(22, 22, 25),
    Border = Color3.fromRGB(48, 48, 53),
    Accent = Color3.fromRGB(220, 45, 55),
    Blue = Color3.fromRGB(145, 35, 42),
    Text = Color3.fromRGB(245, 245, 247),
    Muted = Color3.fromRGB(150, 150, 158),
    Red = Color3.fromRGB(255, 65, 75),
    Font = Enum.Font.BuilderSans,
    BoldFont = Enum.Font.BuilderSansExtraBold
}

local function ErrorHandler(err)
    return debug.traceback(tostring(err), 2)
end

pcall(function()
    local existing = CoreGui:FindFirstChild(GuiName)
    if existing then
        existing:Destroy()
    end
end)

pcall(function()
    if _G.LoadedGuiInstance then
        _G.LoadedGuiInstance:Destroy()
    end
end)

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, parent)
end

local function stroke(parent, color, transparency)
    return create("UIStroke", {
        Color = color or Config.Border,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function tween(object, properties, duration)
    local success, result = xpcall(function()
        local animation = TweenService:Create(
            object,
            TweenInfo.new(
                duration or 0.2,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            properties
        )

        animation:Play()
        return animation
    end, ErrorHandler)

    if not success then
        warn("[LumberTycoon2] Tween:", result)
    end

    return success
end

local function createLabel(parent, text, position, size, textSize, color)
    return create("TextLabel", {
        Position = position,
        Size = size,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or Config.Text,
        TextSize = textSize or 12,
        Font = Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function createButton(parent, text, color, position, size)
    local button = create("TextButton", {
        Position = position,
        Size = size,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Config.Text,
        TextSize = 11,
        Font = Config.BoldFont,
        AutoButtonColor = false
    }, parent)

    corner(button, 9)

    button.MouseEnter:Connect(function()
        tween(button, {
            BackgroundColor3 = color:Lerp(
                Color3.new(1, 1, 1),
                0.08
            )
        }, 0.15)
    end)

    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = color
        }, 0.15)
    end)

    return button
end

local ScreenGui = create("ScreenGui", {
    Name = GuiName,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, CoreGui)

_G.LoadedGuiInstance = ScreenGui

local MainFrame = create("Frame", {
    Name = "MainFrame",
    Size = UDim2.fromOffset(320, 360),
    Position = UDim2.new(0, 24, 0.5, -180),
    BackgroundColor3 = Config.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true
}, ScreenGui)

corner(MainFrame, 16)
stroke(MainFrame, Config.Border, 0.1)

local TopBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 66),
    BackgroundColor3 = Config.Surface,
    BorderSizePixel = 0,
    Active = true
}, MainFrame)

corner(TopBar, 16)

create("Frame", {
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundColor3 = Config.Surface,
    BorderSizePixel = 0
}, TopBar)

createLabel(
    TopBar,
    "Lumber Tycoon 2",
    UDim2.fromOffset(16, 5),
    UDim2.new(1, -100, 0, 25),
    16,
    Config.Text
).Font = Config.BoldFont

createLabel(
    TopBar,
    "UTILITY HUB",
    UDim2.fromOffset(17, 29),
    UDim2.new(1, -100, 0, 16),
    10,
    Config.Muted
)

createLabel(
    TopBar,
    "by MaxproGlitcher",
    UDim2.fromOffset(17, 45),
    UDim2.new(1, -100, 0, 14),
    9,
    Config.Accent
)

local ToggleFrameBtn = createButton(
    TopBar,
    "−",
    Config.Background,
    UDim2.new(1, -76, 0, 17),
    UDim2.fromOffset(28, 28)
)

ToggleFrameBtn.TextSize = 20

local CloseButton = createButton(
    TopBar,
    "×",
    Config.Background,
    UDim2.new(1, -42, 0, 17),
    UDim2.fromOffset(28, 28)
)

CloseButton.TextSize = 21

local ContentContainer = create("ScrollingFrame", {
    Name = "ContentContainer",
    Position = UDim2.fromOffset(14, 78),
    Size = UDim2.new(1, -28, 1, -91),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, MainFrame)

create("UIPadding", {
    PaddingBottom = UDim.new(0, 6)
}, ContentContainer)

create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder
}, ContentContainer)

local function createSection(text, order)
    local section = createLabel(
        ContentContainer,
        text,
        UDim2.new(),
        UDim2.new(1, 0, 0, 18),
        10,
        Config.Muted
    )

    section.LayoutOrder = order
    return section
end

local function createCard(name, order, height)
    local card = create("Frame", {
        Name = name,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Config.Surface,
        BorderSizePixel = 0
    }, ContentContainer)

    corner(card, 11)
    stroke(card, Config.Border, 0.3)

    return card
end

createSection("GENERAL", 1)

local AntiAfkEnabled = false

local AntiAfkCard = createCard("AntiAfkContainer", 2, 58)

local IconBackground = create("Frame", {
    Position = UDim2.fromOffset(11, 12),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = Color3.fromRGB(65, 25, 30),
    BorderSizePixel = 0
}, AntiAfkCard)

corner(IconBackground, 10)

local AntiAfkIcon = createLabel(
    IconBackground,
    "◷",
    UDim2.new(),
    UDim2.fromScale(1, 1),
    20,
    Config.Accent
)

AntiAfkIcon.TextXAlignment = Enum.TextXAlignment.Center

createLabel(
    AntiAfkCard,
    "Anti-AFK",
    UDim2.fromOffset(54, 9),
    UDim2.new(1, -110, 0, 20),
    12,
    Config.Text
).Font = Config.BoldFont

createLabel(
    AntiAfkCard,
    "Prevent idle disconnection",
    UDim2.fromOffset(54, 29),
    UDim2.new(1, -110, 0, 17),
    9,
    Config.Muted
)

local ActionButton = create("TextButton", {
    Name = "AntiAfkToggle",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(38, 22),
    BackgroundColor3 = Config.Border,
    Text = "",
    AutoButtonColor = false
}, AntiAfkCard)

corner(ActionButton, 11)

local Indicator = create("Frame", {
    Name = "Indicator",
    Position = UDim2.fromOffset(3, 3),
    Size = UDim2.fromOffset(16, 16),
    BackgroundColor3 = Config.Text,
    BorderSizePixel = 0
}, ActionButton)

corner(Indicator, 8)

local function updateVisuals(state)
    tween(ActionButton, {
        BackgroundColor3 = state and Config.Accent or Config.Border
    })

    tween(Indicator, {
        Position = state
            and UDim2.new(1, -19, 0, 3)
            or UDim2.fromOffset(3, 3)
    })
end

ActionButton.Activated:Connect(function()
    AntiAfkEnabled = not AntiAfkEnabled
    updateVisuals(AntiAfkEnabled)
end)

createSection("ACTIONS", 3)

local SlotCard = createCard("SlotContainer", 4, 54)

createLabel(
    SlotCard,
    "SAVE SLOT",
    UDim2.fromOffset(12, 5),
    UDim2.new(1, -24, 0, 15),
    9,
    Config.Muted
).Font = Config.BoldFont

local SlotTextBox = create("TextBox", {
    Name = "SlotTextBox",
    Position = UDim2.fromOffset(10, 23),
    Size = UDim2.new(1, -20, 0, 24),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Enter a slot number...",
    PlaceholderColor3 = Config.Muted,
    TextColor3 = Config.Text,
    TextSize = 12,
    Font = Config.Font,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left
}, SlotCard)

local function createActionCard(
    name,
    order,
    title,
    description,
    buttonText,
    color
)
    local card = createCard(name, order, 62)

    createLabel(
        card,
        title,
        UDim2.fromOffset(12, 9),
        UDim2.new(1, -115, 0, 19),
        12,
        Config.Text
    ).Font = Config.BoldFont

    createLabel(
        card,
        description,
        UDim2.fromOffset(12, 30),
        UDim2.new(1, -115, 0, 17),
        9,
        Config.Muted
    )

    local button = createButton(
        card,
        buttonText,
        color,
        UDim2.new(1, -98, 0.5, -14),
        UDim2.fromOffset(86, 28)
    )

    return card, button
end

local ActionContainer, DupeActionButton = createActionCard(
    "DupeContainer",
    5,
    "Dupe Axe",
    "Execute slot action",
    "EXECUTE",
    Config.Accent
)

local TpContainer, TpBaseButton = createActionCard(
    "TpContainer",
    6,
    "Teleport to Base",
    "Return to your property",
    "TELEPORT",
    Config.Blue
)

local StatusCard = createCard("StatusCard", 7, 34)

local StatusLabel = createLabel(
    StatusCard,
    "●  SYSTEM READY",
    UDim2.fromOffset(12, 0),
    UDim2.new(1, -24, 1, 0),
    10,
    Config.Accent
)

local isFrameOpen = true

ToggleFrameBtn.Activated:Connect(function()
    isFrameOpen = not isFrameOpen
    ContentContainer.Visible = isFrameOpen

    tween(MainFrame, {
        Size = isFrameOpen
            and UDim2.fromOffset(320, 360)
            or UDim2.fromOffset(320, 66)
    }, 0.22)

    ToggleFrameBtn.Text = isFrameOpen and "−" or "+"
end)

CloseButton.Activated:Connect(function()
    AntiAfkEnabled = false
    ScreenGui:Destroy()
end)

local function showBaseNotLoaded()
    SlotTextBox.Text = ""
    SlotTextBox.PlaceholderText = "Base not loaded"

    task.delay(5, function()
        if SlotTextBox and SlotTextBox.Parent then
            SlotTextBox.PlaceholderText = "Enter a slot number..."
        end
    end)
end

local antiAfkConnection = player.Idled:Connect(function()
    if AntiAfkEnabled then
        local success, err = xpcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end, ErrorHandler)

        if not success then
            warn("[LumberTycoon2] Anti-AFK:", err)
        end
    end
end)

local deb = false
local cooldownDuration = 60

local function executeDupeAction()
    if deb then
        return
    end

    local slotNum = tonumber(SlotTextBox.Text)

    if not slotNum or slotNum < 1 or slotNum % 1 ~= 0 then
        SlotTextBox.Text = ""
        SlotTextBox.PlaceholderText = "Invalid slot number"

        task.delay(3, function()
            if SlotTextBox and SlotTextBox.Parent then
                SlotTextBox.PlaceholderText = "Enter a slot number..."
            end
        end)

        return
    end

    deb = true
    DupeActionButton.Active = false
    StatusLabel.Text = "●  ACTION IN PROGRESS"
    StatusLabel.TextColor3 = Config.Accent

    local success, err = xpcall(function()
        local char = player.Character

        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end

            local root = char:FindFirstChild("HumanoidRootPart")

            if root then
                root.CFrame = CFrame.new(
                    root.Position.X,
                    -350,
                    root.Position.Z
                )
            end
        end

        task.wait(3.5)

        local requests = ReplicatedStorage:FindFirstChild("LoadSaveRequests")
        local requestLoad = requests and requests:FindFirstChild("RequestLoad")

        if not requestLoad then
            error("RequestLoad is unavailable")
        end

        requestLoad:InvokeServer(slotNum)
    end, ErrorHandler)

    if not success then
        warn("[LumberTycoon2] Action:", err)
        StatusLabel.Text = "●  ACTION FAILED"
        StatusLabel.TextColor3 = Config.Red
    end

    for i = cooldownDuration, 0, -1 do
        if not ScreenGui.Parent then
            deb = false
            return
        end

        DupeActionButton.Text = tostring(i) .. "s"
        DupeActionButton.BackgroundColor3 = Config.Border
        task.wait(1)
    end

    DupeActionButton.Text = "EXECUTE"
    DupeActionButton.BackgroundColor3 = Config.Accent
    DupeActionButton.Active = true

    StatusLabel.Text = "●  SYSTEM READY"
    StatusLabel.TextColor3 = Config.Accent

    deb = false
end

local function getPlayerBasePosition()
    local properties = Workspace:FindFirstChild("Properties")

    if properties then
        for _, property in ipairs(properties:GetChildren()) do
            local owner = property:FindFirstChild("Owner")

            if owner and owner.Value == player then
                local origin = property:FindFirstChild("OriginPart")
                    or property:FindFirstChildWhichIsA("BasePart")

                if origin then
                    return origin.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end

    return nil
end

TpBaseButton.Activated:Connect(function()
    local success, err = xpcall(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local baseCFrame = getPlayerBasePosition()

        if not root or not baseCFrame then
            showBaseNotLoaded()
            StatusLabel.Text = "●  BASE NOT FOUND"
            StatusLabel.TextColor3 = Config.Red
            return
        end

        root.CFrame = baseCFrame
        StatusLabel.Text = "●  TELEPORTED TO BASE"
        StatusLabel.TextColor3 = Config.Accent
    end, ErrorHandler)

    if not success then
        warn("[LumberTycoon2] Teleport:", err)
    end
end)

DupeActionButton.Activated:Connect(executeDupeAction)

local dragging = false
local dragInput
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

local dragConnection = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart

        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

ScreenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        AntiAfkEnabled = false
        dragging = false

        pcall(function()
            antiAfkConnection:Disconnect()
            dragConnection:Disconnect()
        end)

        if _G.LoadedGuiInstance == ScreenGui then
            _G.LoadedGuiInstance = nil
        end
    end
end)
