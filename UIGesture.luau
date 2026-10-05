--!optimize 2
--!native

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local MathMin = math.min
local MathMax = math.max
local MathAbs = math.abs
local MathClamp = math.clamp
local MathExp = math.exp
local MathRound = math.round
local MathDeg = math.deg
local MathAtan2 = math.atan2
local TableClear = table.clear
local TableInsert = table.insert
local TableClone = table.clone
local OsClock = os.clock
local Vector2New = Vector2.new
local UDim2New = UDim2.new

export type GestureHandle = {
	Disconnect: (self: GestureHandle) -> (),
	SetLocked: (self: GestureHandle, Locked: boolean) -> (),
}

export type SwipeDirection = "Left" | "Right" | "Up" | "Down"

export type SwipeCallback = (direction: SwipeDirection, distance: number) -> ()

export type PanCallback = (Delta: Vector2, Magnitude: number, Dragging: boolean, IsSettle: boolean?) -> ()

export type HoverCallback = (Hovering: boolean) -> ()

export type DragCallback = (Dragging: boolean) -> ()

export type PanConfig = {
	Radius: (number | Vector2 | {number})?,
	ReturnToCenter: boolean?,
	LockAxis: ("X" | "Y")?,
	MoveMain: boolean?,
	Momentum: boolean?,
	Friction: number?,
	PanButton: Enum.UserInputType?,
	Normalization: boolean?,
	ClickToJump: boolean?,
	ReturnSpeed: number?,
	Overscroll: number?,
	Threshold: number?,
	ActivationAxis: ("X" | "Y")?,
	Snap: (number | {number})?,
}

export type PanHandle = {
	Disconnect: (self: PanHandle) -> (),
	SetLocked: (self: PanHandle, Locked: boolean) -> (),
	SetOffset: (self: PanHandle, Offset: Vector2, Animate: boolean?) -> (),
	GetOffset: (self: PanHandle) -> Vector2,
	SetRadius: (self: PanHandle, Radius: (number | Vector2 | {number})?) -> (),
	SetSnap: (self: PanHandle, Snap: (number | {number})?) -> (),
}

export type DragConfig = {
	Bounds: ("Screen" | "None" | GuiObject | Rect)?,
	Margin: number?,
	DragThreshold: number?,
	HoldTime: number?,
}

export type ZoomConfig = {
	ZoomToPointer: boolean?,
	Wheel: boolean?,
	Pinch: boolean?,
}

export type ZoomHandle = {
	Disconnect: (self: ZoomHandle) -> (),
	SetLocked: (self: ZoomHandle, Locked: boolean) -> (),
	ZoomTo: (self: ZoomHandle, Scale: number, Pivot: Vector2?, Duration: number?) -> (),
	ZoomIn: (self: ZoomHandle, Pivot: Vector2?, Duration: number?) -> (),
	ZoomOut: (self: ZoomHandle, Pivot: Vector2?, Duration: number?) -> (),
	Fit: (self: ZoomHandle, Duration: number?) -> (),
	Reset: (self: ZoomHandle, Duration: number?) -> (),
	GetScale: (self: ZoomHandle) -> number,
	GetRange: (self: ZoomHandle) -> (number, number),
	OnScaleChanged: (self: ZoomHandle, Callback: (Scale: number) -> ()) -> { Disconnect: () -> () },
}

export type ResizeEdge = "Right" | "Left" | "Top" | "Bottom" | "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight"

export type ResizeConfig = {
	Edge: ResizeEdge?,
	Bounds: ("Screen" | "None" | GuiObject | Rect)?,
	AspectRatio: (number | boolean)?,
}

export type RotateConfig = {
	MinAngle: number?,
	MaxAngle: number?,
	Step: number?,
}

export type TwoFingerTapCallback = (Position: Vector2) -> ()

export type TwoFingerTapConfig = {
	MaxHoldTime: number?,
	MoveTolerance: number?,
}

export type TwoFingerPanCallback = (Offset: Vector2, Panning: boolean) -> ()

export type TwoFingerPanConfig = {
	MoveMain: boolean?,
}

export type LongPressCallback = (Count: number, Position: Vector2, IsPress: boolean, IsCancel: boolean, IsRelease: boolean) -> ()

export type LongPressConfig = {
	HoldTime: number?,
	MoveTolerance: number?,
	RepeatInterval: number?,
	RepeatTolerance: number?,
	Button: Enum.UserInputType?,
}

export type DoubleTapExpireReason = "Timeout" | "Broken" | "Locked"

export type DoubleTapCallback = (Position: Vector2, IsFirstTap: boolean, IsExpire: boolean, Count: number, Reason: DoubleTapExpireReason?) -> ()

export type DoubleTapConfig = {
	MaxInterval: number?,
	MaxDistance: number?,
	MoveTolerance: number?,
	MaxHoldTime: number?,
	MaxTaps: number?,
	Button: Enum.UserInputType?,
}

export type UIGesture = {
	MakeDraggable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Fn: DragCallback?, Config: DragConfig?) -> GestureHandle,
	MakeResizeable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, MinSize: (Vector2 | () -> Vector2)?, MaxSize: (Vector2 | () -> Vector2)?, Fn: DragCallback?, Config: ResizeConfig?) -> GestureHandle,
	MakeSwipeable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Callback: SwipeCallback?, Threshold: number?, MaxTime: number?, Direction: (SwipeDirection | {SwipeDirection})?) -> GestureHandle,
	MakeRotatable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Fn: DragCallback?, Config: RotateConfig?) -> GestureHandle,
	MakeZoomable: (self: UIGesture, Main: GuiObject, Handle: GuiObject, MinZoom: number?, MaxZoom: number?, ZoomStep: number?, Fn: DragCallback?, Config: ZoomConfig?) -> ZoomHandle,
	MakePannable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Fn: PanCallback?, Config: PanConfig?) -> PanHandle,
	MakeHoverable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Callback: HoverCallback) -> GestureHandle,
	MakeLongPressable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Callback: LongPressCallback, Config: LongPressConfig?) -> GestureHandle,
	MakeDoubleTappable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Callback: DoubleTapCallback, Config: DoubleTapConfig?) -> GestureHandle,
	MakeTwoFingerRotatable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Fn: DragCallback?) -> GestureHandle,
	MakeTwoFingerTappable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Callback: TwoFingerTapCallback, Config: TwoFingerTapConfig?) -> GestureHandle,
	MakeTwoFingerPannable: (self: UIGesture, Main: GuiObject, Handle: GuiObject?, Fn: TwoFingerPanCallback?, Config: TwoFingerPanConfig?) -> GestureHandle,
}

local UIGesture = {} :: UIGesture

local MoveHub = { Listeners = {}, Signal = UserInputService.InputChanged }
local EndHub = { Listeners = {}, Signal = UserInputService.InputEnded }
local FocusHub = { Listeners = {}, Signal = UserInputService.WindowFocusReleased }

local function IsDragMovement(input, ActiveInput)
	if not ActiveInput then
		return false
	end

	if ActiveInput.UserInputType == Enum.UserInputType.Touch then
		return input == ActiveInput
	end

	return input.UserInputType == Enum.UserInputType.MouseMovement
end

local function IsPress(input, Button)
	return input.UserInputState == Enum.UserInputState.Begin
		and (input.UserInputType == (Button or Enum.UserInputType.MouseButton1) or input.UserInputType == Enum.UserInputType.Touch)
end

local function Setup(Name, Main, Handle)
	Main = Main or Handle
	Handle = Handle or Main
	assert(Main, "Make" .. Name .. ": needs at least one GuiObject")

	Handle.Active = true

	return Main, Handle
end

local function SafeClamp(Value, Min, Max)
	if Min > Max then
		return Min
	end

	return MathClamp(Value, Min, Max)
end

local function Listen(Listeners, Fn)
	Listeners[Fn] = true

	return { Disconnect = function()
		Listeners[Fn] = nil
	end }
end

local function DisconnectAll(Conn)
	for _, Connection in Conn do
		Connection:Disconnect()
	end
end

local function Bind(Self, Conn, Main, Handle)
	local function Destroy()
		Self:Disconnect()
	end

	TableInsert(Conn, Main.Destroying:Connect(Destroy))

	if Handle ~= Main then
		TableInsert(Conn, Handle.Destroying:Connect(Destroy))
	end

	return Self
end

local function GetAncestorScale(Node)
	local Total = 1

	while Node do
		local Found = Node:FindFirstChildOfClass("UIScale")
		if Found then
			Total *= Found.Scale
		end
		Node = Node.Parent
	end

	return Total
end

local function GetScreenBounds()
	local Size = Workspace.CurrentCamera.ViewportSize
	local Inset = GuiService:GetGuiInset()

	return 0, -Inset.Y, Size.X, Size.Y - Inset.Y
end

local Spawn = (function()
	local free, remove, insert, create, running, yield, spawn = {}, table.remove, table.insert, coroutine.create, coroutine.running, coroutine.yield, task.spawn

	local function Worker(fn, ...)
		fn(...)
		insert(free, running())
		return Worker(yield())
	end

	return function(fn, ...)
		spawn(remove(free) or create(Worker), fn, ...)
	end
end)()

local function Dispatch(Listeners, input)
	if next(Listeners) == nil then return end

	for Fn in TableClone(Listeners) do
		if Listeners[Fn] then
			Spawn(Fn, input)
		end
	end
end

local function Attach(Hub, Fn)
	Hub.Listeners[Fn] = true

	if not Hub.Conn then
		Hub.Conn = Hub.Signal:Connect(function(input)
			Dispatch(Hub.Listeners, input)
		end)
	end
end

local function Detach(Hub, Fn)
	Hub.Listeners[Fn] = nil

	if Hub.Conn and next(Hub.Listeners) == nil then
		Hub.Conn:Disconnect()
		Hub.Conn = nil
	end
end

local function AddTouch(Touches, input, OnEnd, OnFocus)
	if input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState ~= Enum.UserInputState.Begin then
		return false
	end

	if not Touches[1] then
		Touches[1] = input
	elseif not Touches[2] then
		Touches[2] = input
	else
		return false
	end

	Attach(EndHub, OnEnd)
	Attach(FocusHub, OnFocus)

	return Touches[1] ~= nil and Touches[2] ~= nil
end

local function RemoveTouch(Touches, input, OnEnd, OnFocus)
	if Touches[1] == input then
		Touches[1] = nil
	elseif Touches[2] == input then
		Touches[2] = nil
	else
		return false
	end

	if not Touches[1] and not Touches[2] then
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
	end

	return true
end

function UIGesture:MakeDraggable(Main, Handle, Fn, Config)
	Main, Handle = Setup("Draggable", Main, Handle)

	Config = Config or {}

	local Bounds = Config.Bounds or "Screen"
	local Margin = Config.Margin or 60
	local HoldTime = Config.HoldTime
	local Threshold = Config.DragThreshold or (if HoldTime then 10 else 0)

	local dragging = false
	local Pending = false
	local Activated = false
	local Locked = false
	local PressId = 0
	local ActiveInput, DragInput, DragStart, StartPos, StartAbsPos, LastScale
	local DragScale, BoundMinX, BoundMinY, BoundMaxX, BoundMaxY

	local OnEnd

	local Conn = {}
	local ScaleConn = {}
	local Self = {}

	local function WatchScales()
		DisconnectAll(ScaleConn)
		TableClear(ScaleConn)

		LastScale = GetAncestorScale(Main.Parent)

		local Node = Main.Parent

		while Node do
			local Found = Node:FindFirstChildOfClass("UIScale")
			if Found then
				TableInsert(ScaleConn, Found:GetPropertyChangedSignal("Scale"):Connect(function()
					local NewScale = GetAncestorScale(Main.Parent)

					Main.Position = UDim2New(
						Main.Position.X.Scale,
						Main.Position.X.Offset * LastScale / NewScale,
						Main.Position.Y.Scale,
						Main.Position.Y.Offset * LastScale / NewScale
					)
					LastScale = NewScale
				end))
			end
			Node = Node.Parent
		end
	end

	local function Activate(Position)
		Pending = false
		dragging = true
		Activated = true
		DragStart = Position
		StartPos = Main.Position
		StartAbsPos = Handle.AbsolutePosition
		DragScale = GetAncestorScale(Main.Parent)

		if Bounds ~= "None" then
			local Left, Top, Right, Bottom

			if typeof(Bounds) == "Instance" then
				Left = (Bounds :: GuiObject).AbsolutePosition.X
				Top = (Bounds :: GuiObject).AbsolutePosition.Y
				Right = Left + (Bounds :: GuiObject).AbsoluteSize.X
				Bottom = Top + (Bounds :: GuiObject).AbsoluteSize.Y
			elseif typeof(Bounds) == "Rect" then
				Left = Bounds.Min.X
				Top = Bounds.Min.Y
				Right = Bounds.Max.X
				Bottom = Bounds.Max.Y
			else
				Left, Top, Right, Bottom = GetScreenBounds()
			end

			BoundMinX = Left + MathMin(0, Margin - Handle.AbsoluteSize.X)
			BoundMinY = Top + MathMin(0, Margin - Handle.AbsoluteSize.Y)
			BoundMaxX = MathMax(Right - Margin, Right - Handle.AbsoluteSize.X)
			BoundMaxY = MathMax(Bottom - Margin, Bottom - Handle.AbsoluteSize.Y)
		end

		if Fn then Fn(true) end
	end

	local function OnMove(input)
		if IsDragMovement(input, ActiveInput) then
			DragInput = input
		end

		if input ~= DragInput then return end

		if Pending then
			local Moved = (input.Position - DragStart).Magnitude

			if Moved > 0 and Moved >= Threshold then
				if HoldTime then
					Pending = false
				else
					Activate(input.Position)
				end
			end
			return
		end

		if dragging then
			local delta = input.Position - DragStart
			local desiredAbsX = StartAbsPos.X + delta.X
			local desiredAbsY = StartAbsPos.Y + delta.Y

			local clampedAbsX = desiredAbsX
			local clampedAbsY = desiredAbsY

			if Bounds ~= "None" then
				clampedAbsX = SafeClamp(desiredAbsX, BoundMinX, BoundMaxX)
				clampedAbsY = SafeClamp(desiredAbsY, BoundMinY, BoundMaxY)
			end

			Main.Position = UDim2New(
				StartPos.X.Scale,
				StartPos.X.Offset + (clampedAbsX - StartAbsPos.X) / DragScale,
				StartPos.Y.Scale,
				StartPos.Y.Offset + (clampedAbsY - StartAbsPos.Y) / DragScale
			)
		end
	end

	local function Cancel()
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)
		dragging = false
		Pending = false
		ActiveInput = nil
		DragInput = nil

		if Activated then
			Activated = false
			if Fn then Fn(false) end
		end
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if dragging or Pending or Locked or not IsPress(input) then return end

		ActiveInput = input
		Attach(MoveHub, OnMove)
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Cancel)

		if Threshold == 0 and not HoldTime then
			Activate(input.Position)
			return
		end

		Pending = true
		DragStart = input.Position

		if HoldTime then
			PressId += 1
			local Id = PressId

			task.delay(HoldTime, function()
				if Pending and PressId == Id then
					Activate((DragInput or ActiveInput).Position)
				end
			end)
		end
	end)

	function OnEnd(input)
		if input == ActiveInput then
			Cancel()
		end
	end

	Conn[2] = Main.AncestryChanged:Connect(WatchScales)

	WatchScales()

	function Self:SetLocked(Value)
		Locked = Value

		if Value then
			Cancel()
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		DisconnectAll(ScaleConn)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeResizeable(Main, Handle, MinSize, MaxSize, Fn, Config)
	Main, Handle = Setup("Resizeable", Main, Handle)

	MinSize = MinSize or Vector2New(5, 5)
	MaxSize = MaxSize or Vector2New(math.huge, math.huge)

	Config = Config or {}

	local Edge = Config.Edge or "BottomRight"
	local Bounds = Config.Bounds or "Screen"
	local SignX = if string.find(Edge, "Left") then -1 elseif string.find(Edge, "Right") then 1 else 0
	local SignY = if string.find(Edge, "Top") then -1 elseif string.find(Edge, "Bottom") then 1 else 0
	local AspectRatio = Config.AspectRatio
	local DriveX = SignX ~= 0
	local DriveY = SignY ~= 0

	if AspectRatio then
		SignX = if SignX == 0 then 1 else SignX
		SignY = if SignY == 0 then 1 else SignY
	end

	local resizing = false
	local Locked = false
	local ActiveInput, DragInput, DragStart, StartSize, StartPos, StartAbsSize, StartAbsPos, AncestorScale, SizeScale, Ratio
	local BoundLeft, BoundTop, BoundRight, BoundBottom

	local OnEnd

	local Conn = {}
	local Self = {}

	local function OnMove(input)
		if IsDragMovement(input, ActiveInput) then
			DragInput = input
		end

		if resizing and input == DragInput then
			local delta = input.Position - DragStart
			local Min = if type(MinSize) == "function" then MinSize() else MinSize
			local Max = if type(MaxSize) == "function" then MaxSize() else MaxSize

			local MaxWidth = MathMin(if SignX < 0 then StartAbsPos.X + StartAbsSize.X - BoundLeft else BoundRight - StartAbsPos.X, Max.X)
			local MaxHeight = MathMin(if SignY < 0 then StartAbsPos.Y + StartAbsSize.Y - BoundTop else BoundBottom - StartAbsPos.Y, Max.Y)

			local ClampedAbsWidth, ClampedAbsHeight

			if Ratio then
				local DesiredWidth = StartAbsSize.X + SignX * delta.X
				local HeightAsWidth = (StartAbsSize.Y + SignY * delta.Y) * Ratio
				local Width = if DriveX and DriveY then (if MathAbs(DesiredWidth - StartAbsSize.X) >= MathAbs(HeightAsWidth - StartAbsSize.X) then DesiredWidth else HeightAsWidth) elseif DriveX then DesiredWidth else HeightAsWidth

				ClampedAbsWidth = SafeClamp(Width, MathMax(Min.X, Min.Y * Ratio), MathMin(MaxWidth, MaxHeight * Ratio))
				ClampedAbsHeight = ClampedAbsWidth / Ratio
			else
				ClampedAbsWidth = if SignX == 0 then StartAbsSize.X else SafeClamp(StartAbsSize.X + SignX * delta.X, Min.X, MaxWidth)
				ClampedAbsHeight = if SignY == 0 then StartAbsSize.Y else SafeClamp(StartAbsSize.Y + SignY * delta.Y, Min.Y, MaxHeight)
			end

			local AbsDeltaX = ClampedAbsWidth - StartAbsSize.X
			local AbsDeltaY = ClampedAbsHeight - StartAbsSize.Y

			Main.Size = UDim2New(
				StartSize.X.Scale,
				StartSize.X.Offset + AbsDeltaX / SizeScale,
				StartSize.Y.Scale,
				StartSize.Y.Offset + AbsDeltaY / SizeScale
			)

			local Anchor = Main.AnchorPoint

			Main.Position = UDim2New(
				StartPos.X.Scale,
				StartPos.X.Offset + (Anchor.X + MathMin(SignX, 0)) * AbsDeltaX / AncestorScale,
				StartPos.Y.Scale,
				StartPos.Y.Offset + (Anchor.Y + MathMin(SignY, 0)) * AbsDeltaY / AncestorScale
			)
		end
	end

	local function Cancel()
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)
		ActiveInput = nil
		DragInput = nil

		if resizing then
			resizing = false
			if Fn then Fn(false) end
		end
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if resizing or Locked or not IsPress(input) then return end

		resizing = true
		ActiveInput = input
		Attach(MoveHub, OnMove)
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Cancel)
		DragStart = input.Position
		StartSize = Main.Size
		StartPos = Main.Position
		StartAbsSize = Main.AbsoluteSize
		StartAbsPos = Main.AbsolutePosition

		if Bounds == "None" then
			BoundLeft, BoundTop, BoundRight, BoundBottom = -math.huge, -math.huge, math.huge, math.huge
		elseif typeof(Bounds) == "Instance" then
			BoundLeft = (Bounds :: GuiObject).AbsolutePosition.X
			BoundTop = (Bounds :: GuiObject).AbsolutePosition.Y
			BoundRight = BoundLeft + (Bounds :: GuiObject).AbsoluteSize.X
			BoundBottom = BoundTop + (Bounds :: GuiObject).AbsoluteSize.Y
		elseif typeof(Bounds) == "Rect" then
			BoundLeft = Bounds.Min.X
			BoundTop = Bounds.Min.Y
			BoundRight = Bounds.Max.X
			BoundBottom = Bounds.Max.Y
		else
			BoundLeft, BoundTop, BoundRight, BoundBottom = GetScreenBounds()
		end

		Ratio = if AspectRatio == true then (if StartAbsSize.X > 0 and StartAbsSize.Y > 0 then StartAbsSize.X / StartAbsSize.Y else 1) else AspectRatio

		AncestorScale = GetAncestorScale(Main.Parent)

		local OwnScale = Main:FindFirstChildOfClass("UIScale")
		SizeScale = AncestorScale * (if OwnScale then OwnScale.Scale else 1)

		if Fn then Fn(true) end
	end)

	function OnEnd(input)
		if input == ActiveInput then
			Cancel()
		end
	end

	function Self:SetLocked(Value)
		Locked = Value

		if Value then
			Cancel()
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeSwipeable(Main, Handle, Callback, Threshold, MaxTime, Direction)
	Main, Handle = Setup("Swipeable", Main, Handle)

	Threshold = Threshold or 50
	MaxTime = MaxTime or 0.5

	local swiping = false
	local Locked = false
	local ActiveInput, StartPos, StartTime

	local OnEnd

	local Conn = {}
	local Self = {}

	local function Cancel()
		swiping = false
		ActiveInput = nil
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if swiping or Locked or not IsPress(input) then return end

		swiping = true
		ActiveInput = input
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Cancel)
		StartPos = input.Position
		StartTime = OsClock()
	end)

	function OnEnd(input)
		if input ~= ActiveInput then return end

		Cancel()

		local elapsed = OsClock() - StartTime
		if elapsed <= MaxTime then
			local delta = input.Position - StartPos

			if delta.Magnitude >= Threshold then
				local direction
				if MathAbs(delta.X) > MathAbs(delta.Y) then
					direction = delta.X > 0 and "Right" or "Left"
				else
					direction = delta.Y > 0 and "Down" or "Up"
				end

				local matches = true
				if Direction then
					if type(Direction) == "table" then
						matches = false
						for _, d in Direction do
							if d == direction then
								matches = true
								break
							end
						end
					else
						matches = direction == Direction
					end
				end

				if matches then
					if Callback then Callback(direction, delta.Magnitude) end
				end
			end
		end
	end

	function Self:SetLocked(Value)
		Locked = Value
		Cancel()
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeRotatable(Main, Handle, Fn, Config)
	Main, Handle = Setup("Rotatable", Main, Handle)

	Config = Config or {}

	local MinAngle = Config.MinAngle or -math.huge
	local MaxAngle = Config.MaxAngle or math.huge
	local Step = Config.Step

	local rotating = false
	local Locked = false
	local ActiveInput, DragInput, LastAngle, TotalRotation

	local OnEnd

	local Conn = {}
	local Self = {}

	local function GetAngle(inputPosition)
		local center = Main.AbsolutePosition + Main.AbsoluteSize / 2
		local delta = Vector2New(inputPosition.X, inputPosition.Y) - center
		return MathDeg(MathAtan2(delta.Y, delta.X))
	end

	local function OnMove(input)
		if IsDragMovement(input, ActiveInput) then
			DragInput = input
		end

		if rotating and input == DragInput then
			local CurrentAngle = GetAngle(input.Position)

			TotalRotation = SafeClamp(TotalRotation + (CurrentAngle - LastAngle + 180) % 360 - 180, MinAngle, MaxAngle)
			LastAngle = CurrentAngle

			Main.Rotation = SafeClamp(if Step then MathRound(TotalRotation / Step) * Step else TotalRotation, MinAngle, MaxAngle)
		end
	end

	local function Cancel()
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)
		ActiveInput = nil
		DragInput = nil

		if rotating then
			rotating = false
			if Fn then Fn(false) end
		end
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if rotating or Locked or not IsPress(input) then return end

		rotating = true
		ActiveInput = input
		Attach(MoveHub, OnMove)
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Cancel)
		LastAngle = GetAngle(input.Position)
		TotalRotation = Main.Rotation

		if Fn then Fn(true) end
	end)

	function OnEnd(input)
		if input == ActiveInput then
			Cancel()
		end
	end

	function Self:SetLocked(Value)
		Locked = Value

		if Value then
			Cancel()
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeZoomable(Main, Handle, MinZoom, MaxZoom, ZoomStep, Fn, Config)
	assert(Main, "MakeZoomable: needs a GuiObject to scale")
	assert(Handle, "MakeZoomable: needs a Handle GuiObject")

	Handle.Active = true

	MinZoom = MinZoom or 0.3
	MaxZoom = MaxZoom or 1
	ZoomStep = ZoomStep or 0.1

	Config = Config or {}

	local ZoomToPointer = Config.ZoomToPointer
	local Wheel = if Config.Wheel == nil then true else Config.Wheel
	local Pinch = if Config.Pinch == nil then true else Config.Pinch

	local ContentScale = Main:FindFirstChildOfClass("UIScale")
	if not ContentScale then
		ContentScale = Instance.new("UIScale")
		ContentScale.Parent = Main
	end

	local function GetFitScale()
		local currentScale = ContentScale.Scale
		if currentScale <= 0 then
			currentScale = 1
		end

		local baseContentSize = Main.AbsoluteSize / currentScale
		if baseContentSize.X <= 0 or baseContentSize.Y <= 0 then
			return 1
		end

		return MathMin(
			Handle.AbsoluteSize.X / baseContentSize.X,
			Handle.AbsoluteSize.Y / baseContentSize.Y
		)
	end

	local InitialScale = ContentScale.Scale
	local InitialPosition = Main.Position
	local ZoomConn
	local CachedFit, CachedParentScale, CachedCenter

	local pinching = false
	local Locked = false
	local Touches = {}
	local StartDistance, StartScale, StartAbsSize, StartPos, StartAbsPos, StartMid

	local OnEnd, OnFocus

	local Conn = {}
	local Self = {}

	local function GetMid()
		local Mid = (Touches[1].Position + Touches[2].Position) / 2
		return Vector2New(Mid.X, Mid.Y)
	end

	local function Refresh()
		CachedFit = GetFitScale()
		CachedParentScale = GetAncestorScale(Main.Parent)
		CachedCenter = Handle.AbsolutePosition + Handle.AbsoluteSize / 2
	end

	local function ClampScale(Value)
		return SafeClamp(Value, CachedFit / (if MaxZoom > 0 then MaxZoom else 1), CachedFit / (if MinZoom > 0 then MinZoom else 1))
	end

	local function ApplyZoom(TargetScale, baseScale, baseAbsSize, basePos, baseAbsPos, FromPoint, ToPoint)
		local clampedScale = ClampScale(TargetScale)

		if baseScale <= 0 or baseAbsSize.X <= 0 or baseAbsSize.Y <= 0 then
			ContentScale.Scale = clampedScale
			return
		end

		FromPoint = FromPoint or CachedCenter
		ToPoint = ToPoint or CachedCenter
		local newAbsSize = baseAbsSize * (clampedScale / baseScale)

		local fractionX = (FromPoint.X - baseAbsPos.X) / baseAbsSize.X
		local fractionY = (FromPoint.Y - baseAbsPos.Y) / baseAbsSize.Y

		local desiredAbsX = ToPoint.X - fractionX * newAbsSize.X
		local desiredAbsY = ToPoint.Y - fractionY * newAbsSize.Y

		local anchor = Main.AnchorPoint
		local sizeDelta = newAbsSize - baseAbsSize

		Main.Position = UDim2New(
			basePos.X.Scale,
			basePos.X.Offset + (desiredAbsX - baseAbsPos.X + anchor.X * sizeDelta.X) / CachedParentScale,
			basePos.Y.Scale,
			basePos.Y.Offset + (desiredAbsY - baseAbsPos.Y + anchor.Y * sizeDelta.Y) / CachedParentScale
		)

		ContentScale.Scale = clampedScale
	end

	local function StopZoomAnimation()
		if ZoomConn then
			ZoomConn:Disconnect()
			ZoomConn = nil
		end
	end

	local function RunAnimation(Duration, Step)
		StopZoomAnimation()

		if not Duration or Duration <= 0 then
			Step(1)
			return
		end

		local StartTime = OsClock()

		ZoomConn = RunService.PreRender:Connect(function()
			local Alpha = MathMin((OsClock() - StartTime) / Duration, 1)

			Step(1 - (1 - Alpha) ^ 2)

			if Alpha == 1 then
				StopZoomAnimation()
			end
		end)
	end

	local function ZoomToScale(TargetScale, Pivot, Duration)
		Refresh()

		local BaseScale = ContentScale.Scale
		local BaseAbsSize = Main.AbsoluteSize
		local BasePos = Main.Position
		local BaseAbsPos = Main.AbsolutePosition
		local ClampedTarget = ClampScale(TargetScale)

		RunAnimation(Duration, function(Eased)
			ApplyZoom(BaseScale + (ClampedTarget - BaseScale) * Eased, BaseScale, BaseAbsSize, BasePos, BaseAbsPos, Pivot, Pivot)
		end)
	end

	local function OnMove(input)
		if not pinching or (input ~= Touches[1] and input ~= Touches[2]) then return end

		local currentDistance = (Touches[1].Position - Touches[2].Position).Magnitude
		local factor = currentDistance / MathMax(StartDistance, 1)

		ApplyZoom(StartScale * factor, StartScale, StartAbsSize, StartPos, StartAbsPos, StartMid, StartMid and GetMid())
	end

	local function Cancel()
		if pinching then
			pinching = false
			Detach(MoveHub, OnMove)
			if Fn then Fn(false) end
		end
	end

	if Pinch then
		TableInsert(Conn, Handle.InputBegan:Connect(function(input)
			if Locked or not AddTouch(Touches, input, OnEnd, OnFocus) then return end

			StopZoomAnimation()
			Refresh()

			pinching = true
			Attach(MoveHub, OnMove)
			StartDistance = (Touches[1].Position - Touches[2].Position).Magnitude
			StartScale = ContentScale.Scale
			StartAbsSize = Main.AbsoluteSize
			StartPos = Main.Position
			StartAbsPos = Main.AbsolutePosition
			StartMid = if ZoomToPointer then GetMid() else nil

			if Fn then Fn(true) end
		end))
	end

	function OnEnd(input)
		if not RemoveTouch(Touches, input, OnEnd, OnFocus) or not pinching then return end

		pinching = false
		Detach(MoveHub, OnMove)

		if Fn then Fn(false) end
	end

	if Wheel then
		TableInsert(Conn, Handle.InputChanged:Connect(function(input)
			if Locked or input.UserInputType ~= Enum.UserInputType.MouseWheel then return end

			StopZoomAnimation()
			Refresh()

			local direction = input.Position.Z
			local factor = 1 + (direction * ZoomStep)

			local Pointer = if ZoomToPointer then UserInputService:GetMouseLocation() - GuiService:GetGuiInset() else nil

			ApplyZoom(ContentScale.Scale * factor, ContentScale.Scale, Main.AbsoluteSize, Main.Position, Main.AbsolutePosition, Pointer, Pointer)
		end))
	end

	function OnFocus()
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Cancel()
	end

	function Self:SetLocked(Value)
		Locked = Value
		Cancel()
	end

	local ScaleListeners = {}

	TableInsert(Conn, ContentScale:GetPropertyChangedSignal("Scale"):Connect(function()
		if next(ScaleListeners) then Dispatch(ScaleListeners, Self:GetScale()) end
	end))

	function Self:OnScaleChanged(Callback)
		return Listen(ScaleListeners, Callback)
	end

	function Self:ZoomTo(Zoom, Pivot, Duration)
		ZoomToScale(GetFitScale() / Zoom, Pivot, Duration)
	end

	function Self:ZoomIn(Pivot, Duration)
		ZoomToScale(ContentScale.Scale * (1 + ZoomStep), Pivot, Duration)
	end

	function Self:ZoomOut(Pivot, Duration)
		ZoomToScale(ContentScale.Scale * (1 - ZoomStep), Pivot, Duration)
	end

	function Self:Fit(Duration)
		Refresh()

		local BaseScale = ContentScale.Scale
		local BaseAbsSize = Main.AbsoluteSize
		local BasePos = Main.Position
		local BaseAbsPos = Main.AbsolutePosition
		local FromPoint = BaseAbsPos + BaseAbsSize / 2

		RunAnimation(Duration, function(Eased)
			ApplyZoom(BaseScale + (CachedFit - BaseScale) * Eased, BaseScale, BaseAbsSize, BasePos, BaseAbsPos, FromPoint, FromPoint:Lerp(CachedCenter, Eased))
		end)
	end

	function Self:Reset(Duration)
		local BaseScale = ContentScale.Scale
		local BasePos = Main.Position

		RunAnimation(Duration, function(Eased)
			ContentScale.Scale = BaseScale + (InitialScale - BaseScale) * Eased
			Main.Position = BasePos:Lerp(InitialPosition, Eased)
		end)
	end

	function Self:GetScale()
		return GetFitScale() / ContentScale.Scale
	end

	function Self:GetRange()
		return (if MinZoom > 0 then MinZoom else 1), (if MaxZoom > 0 then MaxZoom else 1)
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		StopZoomAnimation()
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakePannable(Main, Handle, Fn, Config)
	Main, Handle = Setup("Pannable", Main, Handle)

	Config = Config or {}

	local Radius = Config.Radius
	local ReturnToCenter = Config.ReturnToCenter
	local LockAxis = Config.LockAxis
	local Momentum = Config.Momentum
	local Friction = Config.Friction or 4
	local PanButton = Config.PanButton or Enum.UserInputType.MouseButton1
	local MoveMain = if Config.MoveMain == nil then true else Config.MoveMain
	local Normalization = Config.Normalization
	local ClickToJump = Config.ClickToJump or false
	local ReturnSpeed = Config.ReturnSpeed
	local Overscroll = Config.Overscroll
	local ActivationAxis = Config.ActivationAxis
	local Snap = Config.Snap
	local Threshold = Config.Threshold or (if ActivationAxis then 8 else 0)

	assert(not (type(Radius) == "table" and not LockAxis), "MakePannable: Radius table (Min/Max) requires LockAxis to be set")
	assert(not (Snap and not LockAxis), "MakePannable: Snap requires LockAxis to be set")
	assert(Friction > 0, "MakePannable: Friction must be greater than 0")

	local function AssertSnap(Value)
		assert(not Value or (type(Value) == "table" and #Value > 0) or (type(Value) == "number" and Value > 0), "MakePannable: Snap must be a positive number or a non-empty table")
	end

	AssertSnap(Snap)

	local panning = false
	local Pending = false
	local Locked = false
	local Interrupted = false
	local ActiveInput, DragInput, DragStart
	local BasePos = Main.Position
	local CurrentOffset, DragStartOffset = Vector2.zero, Vector2.zero
	local LastOffset, LastSampleTime, Velocity = Vector2.zero, 0, Vector2.zero
	local MomentumConn
	local PanScale

	local OnEnd, Release

	local Conn = {}
	local Self = {}

	local function ApplyPan(offset, Silent)
		if MoveMain then
			Main.Position = UDim2New(
				BasePos.X.Scale,
				BasePos.X.Offset + offset.X,
				BasePos.Y.Scale,
				BasePos.Y.Offset + offset.Y
			)
		end

		if not Silent then
			if Fn then Fn(offset, offset.Magnitude, panning) end
		end
	end

	local function GetScale()
		return GetAncestorScale(if MoveMain then Main.Parent else Main)
	end

	local function ClampOffset(offset)
		if LockAxis == "X" or LockAxis == "Y" then
			local value = if LockAxis == "X" then offset.X else offset.Y
			local handleSize = (if LockAxis == "X" then Handle.AbsoluteSize.X else Handle.AbsoluteSize.Y) / PanScale
			local min, max = -math.huge, math.huge

			if type(Radius) == "table" then
				if Normalization then
					min, max = Radius[1] + handleSize / 2, Radius[2] - handleSize / 2
				else
					min, max = Radius[1], Radius[2]
				end
			elseif Radius then
				if Normalization then
					local effective = MathMax((Radius - handleSize) / 2, 0)
					min, max = -effective, effective
				else
					min, max = -Radius, Radius
				end
			end

			value = SafeClamp(value, min, max)

			return if LockAxis == "X" then Vector2New(value, 0) else Vector2New(0, value)
		end

		if typeof(Radius) == "Vector2" then
			if Normalization then
				local effectiveX = MathMax((Radius.X - Handle.AbsoluteSize.X / PanScale) / 2, 0)
				local effectiveY = MathMax((Radius.Y - Handle.AbsoluteSize.Y / PanScale) / 2, 0)

				return Vector2New(
					MathClamp(offset.X, -effectiveX, effectiveX),
					MathClamp(offset.Y, -effectiveY, effectiveY)
				)
			end

			return Vector2New(
				MathClamp(offset.X, -Radius.X, Radius.X),
				MathClamp(offset.Y, -Radius.Y, Radius.Y)
			)
		end

		if Radius then
			if Normalization then
				local effectiveRadius = MathMax((Radius - Handle.AbsoluteSize.X / PanScale) / 2, 0)
				if offset.Magnitude > effectiveRadius then
					offset = offset.Unit * effectiveRadius
				end
			elseif offset.Magnitude > Radius then
				offset = offset.Unit * Radius
			end
		end

		return offset
	end

	local function StopMomentum()
		if MomentumConn then
			MomentumConn:Disconnect()
			MomentumConn = nil
		end
	end

	local function Glide(Target, Speed, Programmatic)
		StopMomentum()

		if not Speed then
			CurrentOffset = Target
			ApplyPan(Target)

			if Fn then Fn(Target, Target.Magnitude, false, true) end
			return
		end

		local offset = CurrentOffset

		MomentumConn = RunService.PreRender:Connect(function(dt)
			offset = Target + (offset - Target) * MathExp(-Speed * dt)

			local Done = (offset - Target).Magnitude < 0.5
			if Done then
				StopMomentum()
				offset = Target
			end

			CurrentOffset = offset
			ApplyPan(offset)

			if Done and not Programmatic then
				if Fn then Fn(offset, offset.Magnitude, false, true) end
			end
		end)
	end

	local function Settle()
		if ReturnToCenter then
			Glide(Vector2.zero, ReturnSpeed, false)
		else
			if Fn then Fn(CurrentOffset, CurrentOffset.Magnitude, false, true) end
		end
	end

	local function Begin(Position)
		PanScale = GetScale()
		panning = true
		Interrupted = false
		DragStart = Position
		DragStartOffset = CurrentOffset
		LastOffset = CurrentOffset
		LastSampleTime = OsClock()
		Velocity = Vector2.zero

		if Fn then Fn(CurrentOffset, CurrentOffset.Magnitude, true) end

		if ClickToJump then
			local ZeroAbsolutePos = if MoveMain then Main.AbsolutePosition - CurrentOffset * PanScale else Main.AbsolutePosition
			local JumpOffset = ClampOffset((Vector2New(Position.X, Position.Y) - ZeroAbsolutePos) / PanScale)

			DragStartOffset = JumpOffset
			LastOffset = JumpOffset
			CurrentOffset = JumpOffset
			ApplyPan(JumpOffset)
		end
	end

	local function Finish()
		PanScale = GetScale()

		local Bound = ClampOffset(CurrentOffset)

		if Snap then
			local Landing = if LockAxis == "X" then CurrentOffset.X + Velocity.X / Friction else CurrentOffset.Y + Velocity.Y / Friction
			local Target

			if type(Snap) == "table" then
				for _, Point in Snap do
					if not Target or MathAbs(Point - Landing) < MathAbs(Target - Landing) then
						Target = Point
					end
				end
			else
				Target = MathRound(Landing / Snap) * Snap
			end

			Glide(ClampOffset(if LockAxis == "X" then Vector2New(Target, 0) else Vector2New(0, Target)), ReturnSpeed or 12, false)
		elseif Overscroll and Bound ~= CurrentOffset then
			Glide(if ReturnToCenter then Vector2.zero else Bound, ReturnSpeed or 12, false)
		elseif Momentum then
			StopMomentum()

			local velocity = Velocity
			local offset = CurrentOffset

			MomentumConn = RunService.PreRender:Connect(function(dt)
				local Limit = ClampOffset(offset)
				local Excess = offset - Limit

				if Overscroll and Excess.Magnitude > 0 then
					velocity = velocity + (-Excess * 100 - velocity * 20) * dt

					if velocity.Magnitude < 1 and Excess.Magnitude < 0.5 then
						StopMomentum()
						offset = Limit
						CurrentOffset = offset
						ApplyPan(offset)
						Settle()
						return
					end

					offset = offset + velocity * dt
					Limit = ClampOffset(offset)
					Excess = offset - Limit

					if Excess.Magnitude > Overscroll then
						offset = Limit + Excess.Unit * Overscroll
					end
				else
					velocity = velocity * MathExp(-Friction * dt)

					if velocity.Magnitude < 1 then
						StopMomentum()
						Settle()
						return
					end

					offset = if Overscroll then offset + velocity * dt else ClampOffset(offset + velocity * dt)
				end

				CurrentOffset = offset
				ApplyPan(offset)
			end)
		else
			Settle()
		end
	end

	local function Resume()
		if Interrupted then
			Interrupted = false
			Velocity = Vector2.zero
			Finish()
		end
	end

	local function OnMove(input)
		if IsDragMovement(input, ActiveInput) then
			DragInput = input
		end

		if Pending and input == DragInput then
			local Delta = input.Position - DragStart

			if Delta.Magnitude >= Threshold then
				Pending = false

				if ActivationAxis and MathAbs(if ActivationAxis == "X" then Delta.Y else Delta.X) > MathAbs(if ActivationAxis == "X" then Delta.X else Delta.Y) then
					Detach(MoveHub, OnMove)
					Detach(EndHub, OnEnd)
					Detach(FocusHub, Release)
					ActiveInput = nil
					DragInput = nil
					Resume()
				else
					Begin(input.Position)
				end
			end

			return
		end

		if panning and input == DragInput then
			local delta = input.Position - DragStart
			local raw = DragStartOffset + Vector2New(delta.X, delta.Y) / PanScale
			local offset = ClampOffset(raw)

			if Overscroll then
				local Excess = raw - offset
				if Excess.Magnitude > 0 then
					offset = offset + Excess.Unit * (Excess.Magnitude * Overscroll / (Excess.Magnitude + Overscroll))
				end
			end

			local now = OsClock()
			local dt = now - LastSampleTime
			if dt > 0 then
				Velocity = (offset - LastOffset) / dt
			end
			LastOffset = offset
			LastSampleTime = now
			CurrentOffset = offset

			ApplyPan(offset)
		end
	end

	function Release()
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Release)

		if Pending then
			Pending = false

			if not ClickToJump then
				ActiveInput = nil
				DragInput = nil
				Resume()
				return
			end

			Begin(DragStart)
		end

		panning = false
		ActiveInput = nil
		DragInput = nil

		if Fn then Fn(CurrentOffset, CurrentOffset.Magnitude, false) end

		if OsClock() - LastSampleTime > 0.1 then
			Velocity = Vector2.zero
		end

		Finish()
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if Locked or panning or Pending or not IsPress(input, PanButton) then return end

		Interrupted = MomentumConn ~= nil
		StopMomentum()

		ActiveInput = input
		Attach(MoveHub, OnMove)
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Release)
		DragStart = input.Position

		if Threshold == 0 and not ActivationAxis then
			Begin(input.Position)
		else
			Pending = true
		end
	end)

	function OnEnd(input)
		if input == ActiveInput then
			Release()
		end
	end

	Conn[2] = Main:GetPropertyChangedSignal("Position"):Connect(function()
		BasePos = UDim2New(
			Main.Position.X.Scale,
			Main.Position.X.Offset - CurrentOffset.X,
			Main.Position.Y.Scale,
			Main.Position.Y.Offset - CurrentOffset.Y
		)
	end)

	function Self:SetOffset(Offset, Animate)
		PanScale = GetScale()

		local Target = ClampOffset(Offset)

		if Animate then
			Glide(Target, ReturnSpeed or 12, true)
			return
		end

		StopMomentum()
		CurrentOffset = Target
		LastOffset = Target
		Velocity = Vector2.zero

		if panning then
			DragStart = (DragInput or ActiveInput).Position
			DragStartOffset = Target
		end

		ApplyPan(Target, true)
	end

	function Self:GetOffset()
		return CurrentOffset
	end

	function Self:SetSnap(Value)
		assert(not (Value and not LockAxis), "MakePannable: Snap requires LockAxis to be set")
		AssertSnap(Value)

		Snap = Value
	end

	function Self:SetRadius(Value)
		assert(not (type(Value) == "table" and not LockAxis), "MakePannable: Radius table (Min/Max) requires LockAxis to be set")

		Radius = Value
		Self:SetOffset(CurrentOffset)
	end

	function Self:SetLocked(Value)
		Locked = Value

		if not Value then return end

		StopMomentum()
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Release)
		Pending = false
		ActiveInput = nil
		DragInput = nil

		if panning then
			panning = false
			if Fn then Fn(CurrentOffset, CurrentOffset.Magnitude, false) end
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Self:SetLocked(true)
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeHoverable(Main, Handle, Callback)
	Main, Handle = Setup("Hoverable", Main, Handle)
	assert(Callback, "MakeHoverable: needs a Callback")

	local hovering = false
	local Inside = false
	local Locked = false

	local OnFocus

	local Conn = {}
	local Self = {}

	local function Leave()
		if not hovering then return end

		hovering = false
		Callback(false)
	end

	Conn[1] = Handle.MouseEnter:Connect(function()
		Inside = true
		Attach(FocusHub, OnFocus)

		if Locked then return end

		hovering = true
		Callback(true)
	end)

	Conn[2] = Handle.MouseLeave:Connect(function()
		Inside = false
		Leave()
		Detach(FocusHub, OnFocus)
	end)

	function OnFocus()
		Inside = false
		Leave()
		Detach(FocusHub, OnFocus)
	end

	function Self:SetLocked(Value)
		Locked = Value

		if Value then
			Leave()
		elseif Inside and not hovering then
			hovering = true
			Callback(true)
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Leave()
		Detach(FocusHub, OnFocus)
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeLongPressable(Main, Handle, Callback, Config)
	Main, Handle = Setup("LongPressable", Main, Handle)
	assert(Callback, "MakeLongPressable: needs a Callback")

	Config = Config or {}

	local HoldTime = Config.HoldTime or 0.5
	local MoveTolerance = Config.MoveTolerance or 10
	local RepeatInterval = Config.RepeatInterval
	local RepeatTolerance = Config.RepeatTolerance
	local Button = Config.Button

	local pressing = false
	local Locked = false
	local Count = 0
	local PressId = 0
	local ActiveInput, DragInput, StartPos

	local OnEnd, Cancel

	local Conn = {}
	local Self = {}

	local function GetPosition(input)
		return Vector2New(input.Position.X, input.Position.Y)
	end

	local function OnMove(input)
		if IsDragMovement(input, ActiveInput) then
			DragInput = input
		end

		if not pressing or input ~= DragInput then return end

		local Distance = (input.Position - StartPos).Magnitude

		if Count > 0 then
			if RepeatTolerance and Distance > RepeatTolerance then
				pressing = false
			end
		elseif Distance > MoveTolerance then
			pressing = false
			ActiveInput = nil
			DragInput = nil
			Detach(MoveHub, OnMove)
			Detach(EndHub, OnEnd)
			Detach(FocusHub, Cancel)

			Callback(0, GetPosition(input), false, true, false)
		end
	end

	function Cancel()
		if not ActiveInput then return end

		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)

		local Position = GetPosition(DragInput or ActiveInput)
		local Held = Count > 0

		pressing = false
		ActiveInput = nil
		DragInput = nil

		Callback(Count, Position, false, not Held, Held)
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if ActiveInput or Locked or not IsPress(input, Button) then return end

		pressing = true
		Count = 0
		ActiveInput = input
		Attach(MoveHub, OnMove)
		Attach(EndHub, OnEnd)
		Attach(FocusHub, Cancel)
		StartPos = input.Position
		PressId += 1

		local Id = PressId

		Callback(0, GetPosition(input), true, false, false)

		Spawn(function()
			task.wait(HoldTime)

			while pressing and PressId == Id do
				Count += 1

				Callback(Count, GetPosition(DragInput or ActiveInput), false, false, false)

				if not RepeatInterval then
					break
				end

				task.wait(RepeatInterval)
			end
		end)
	end)

	function OnEnd(input)
		if input ~= ActiveInput then return end

		pressing = false
		ActiveInput = nil
		DragInput = nil
		Detach(MoveHub, OnMove)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, Cancel)

		Callback(Count, GetPosition(input), false, false, true)
	end

	function Self:SetLocked(Value)
		Locked = Value

		if Value then
			Cancel()
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Cancel()
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeDoubleTappable(Main, Handle, Callback, Config)
	Main, Handle = Setup("DoubleTappable", Main, Handle)
	assert(Callback, "MakeDoubleTappable: needs a Callback")

	Config = Config or {}

	local MaxInterval = Config.MaxInterval or 0.3
	local MaxHoldTime = Config.MaxHoldTime or MaxInterval
	local MaxDistance = Config.MaxDistance or 40
	local MoveTolerance = Config.MoveTolerance or 10
	local MaxTaps = Config.MaxTaps or 2
	local Button = Config.Button

	local Locked = false
	local Interrupted = false
	local TapCount = 0
	local ActiveInput, StartPos, StartTime, LastTapTime, LastTapPos

	local OnEnd, OnFocus

	local Conn = {}
	local Self = {}

	local function Expire(Reason)
		if not LastTapTime then return end

		local Count = TapCount
		LastTapTime = nil
		TapCount = 0

		Callback(LastTapPos, false, true, Count, Reason)
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if Locked or not IsPress(input, Button) then return end

		if ActiveInput then
			Interrupted = true
			return
		end

		ActiveInput = input
		Attach(EndHub, OnEnd)
		Attach(FocusHub, OnFocus)
		Interrupted = false
		StartPos = input.Position
		StartTime = OsClock()
	end)

	function OnEnd(input)
		if input ~= ActiveInput then return end
		ActiveInput = nil
		Detach(EndHub, OnEnd)

		if Interrupted or OsClock() - StartTime > MaxHoldTime or (input.Position - StartPos).Magnitude > MoveTolerance then
			Expire("Broken")
			return
		end

		local Position = Vector2New(input.Position.X, input.Position.Y)

		if TapCount > 0 and StartTime - LastTapTime <= MaxInterval and (Position - LastTapPos).Magnitude <= MaxDistance then
			TapCount += 1
		else
			Expire("Broken")
			TapCount = 1
		end

		local Count = TapCount

		if Count >= MaxTaps then
			LastTapTime = nil
			TapCount = 0

			Callback(Position, Count == 1, false, Count)
			return
		end

		local TapTime = OsClock()
		LastTapTime = TapTime
		LastTapPos = Position

		Callback(Position, Count == 1, false, Count)

		task.delay(MaxInterval, function()
			if LastTapTime == TapTime and not (ActiveInput and StartTime - TapTime <= MaxInterval) then
				Expire("Timeout")
			end
		end)
	end

	function OnFocus()
		ActiveInput = nil
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Expire("Broken")
	end

	function Self:SetLocked(Value)
		Locked = Value
		ActiveInput = nil
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Expire("Locked")
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		Self:SetLocked(true)
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeTwoFingerRotatable(Main, Handle, Fn)
	Main, Handle = Setup("TwoFingerRotatable", Main, Handle)

	local rotating = false
	local Locked = false
	local Touches = {}
	local LastAngle

	local OnEnd, OnFocus

	local Conn = {}
	local Self = {}

	local function GetAngle()
		local delta = Touches[2].Position - Touches[1].Position
		return MathDeg(MathAtan2(delta.Y, delta.X))
	end

	local function OnMove(input)
		if not rotating or (input ~= Touches[1] and input ~= Touches[2]) then return end

		local Angle = GetAngle()
		Main.Rotation += (Angle - LastAngle + 180) % 360 - 180
		LastAngle = Angle
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if Locked or not AddTouch(Touches, input, OnEnd, OnFocus) then return end

		rotating = true
		Attach(MoveHub, OnMove)
		LastAngle = GetAngle()

		if Fn then Fn(true) end
	end)

	function OnEnd(input)
		if not RemoveTouch(Touches, input, OnEnd, OnFocus) or not rotating then return end

		rotating = false
		Detach(MoveHub, OnMove)

		if Fn then Fn(false) end
	end

	function OnFocus()
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Self:SetLocked(Locked)
	end

	function Self:SetLocked(Value)
		Locked = Value

		if rotating then
			rotating = false
			Detach(MoveHub, OnMove)

			if Fn then Fn(false) end
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Self:SetLocked(true)
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeTwoFingerTappable(Main, Handle, Callback, Config)
	Main, Handle = Setup("TwoFingerTappable", Main, Handle)
	assert(Callback, "MakeTwoFingerTappable: needs a Callback")

	Config = Config or {}

	local MaxHoldTime = Config.MaxHoldTime or 0.3
	local MoveTolerance = Config.MoveTolerance or 10

	local Armed = false
	local Locked = false
	local Touches = {}
	local StartTime, StartPositions

	local OnEnd, OnFocus

	local Conn = {}
	local Self = {}

	local function OnMove(input)
		if not Armed or (input ~= Touches[1] and input ~= Touches[2]) then return end

		for Index = 1, 2 do
			if (Touches[Index].Position - StartPositions[Index]).Magnitude > MoveTolerance then
				Armed = false
			end
		end
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if Locked or not AddTouch(Touches, input, OnEnd, OnFocus) then return end

		Armed = true
		Attach(MoveHub, OnMove)
		StartTime = OsClock()
		StartPositions = { Touches[1].Position, Touches[2].Position }
	end)

	function OnEnd(input)
		if not RemoveTouch(Touches, input, OnEnd, OnFocus) then return end

		Detach(MoveHub, OnMove)

		if not Armed then return end

		Armed = false

		if OsClock() - StartTime <= MaxHoldTime then
			local Mid = (StartPositions[1] + StartPositions[2]) / 2

			Callback(Vector2New(Mid.X, Mid.Y))
		end
	end

	function OnFocus()
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Armed = false
		Detach(MoveHub, OnMove)
	end

	function Self:SetLocked(Value)
		Locked = Value
		Armed = false
		Detach(MoveHub, OnMove)
	end

	function Self:Disconnect()
		Armed = false
		Detach(MoveHub, OnMove)
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		DisconnectAll(Conn)
	end

	return Bind(Self, Conn, Main, Handle)
end

function UIGesture:MakeTwoFingerPannable(Main, Handle, Fn, Config)
	Main, Handle = Setup("TwoFingerPannable", Main, Handle)

	Config = Config or {}

	local MoveMain = if Config.MoveMain == nil then true else Config.MoveMain

	local Panning = false
	local Locked = false
	local Touches = {}
	local StartMid, StartPos, StartScale, LastOffset

	local OnEnd, OnFocus

	local Conn = {}
	local Self = {}

	local function GetMid()
		local Mid = (Touches[1].Position + Touches[2].Position) / 2
		return Vector2New(Mid.X, Mid.Y)
	end

	local function OnMove(input)
		if not Panning or (input ~= Touches[1] and input ~= Touches[2]) then return end

		LastOffset = GetMid() - StartMid

		if MoveMain then
			Main.Position = UDim2New(
				StartPos.X.Scale,
				StartPos.X.Offset + LastOffset.X / StartScale,
				StartPos.Y.Scale,
				StartPos.Y.Offset + LastOffset.Y / StartScale
			)
		end

		if Fn then Fn(LastOffset, true) end
	end

	Conn[1] = Handle.InputBegan:Connect(function(input)
		if Locked or not AddTouch(Touches, input, OnEnd, OnFocus) then return end

		Panning = true
		Attach(MoveHub, OnMove)
		StartMid = GetMid()
		StartPos = Main.Position
		StartScale = GetAncestorScale(Main.Parent)
		LastOffset = Vector2.zero

		if Fn then Fn(LastOffset, true) end
	end)

	function OnEnd(input)
		if not RemoveTouch(Touches, input, OnEnd, OnFocus) or not Panning then return end

		Panning = false
		Detach(MoveHub, OnMove)

		if Fn then Fn(LastOffset, false) end
	end

	function OnFocus()
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Self:SetLocked(Locked)
	end

	function Self:SetLocked(Value)
		Locked = Value

		if Panning then
			Panning = false
			Detach(MoveHub, OnMove)

			if Fn then Fn(LastOffset, false) end
		end
	end

	function Self:Disconnect()
		DisconnectAll(Conn)
		TableClear(Touches)
		Detach(EndHub, OnEnd)
		Detach(FocusHub, OnFocus)
		Self:SetLocked(true)
	end

	return Bind(Self, Conn, Main, Handle)
end

return UIGesture
