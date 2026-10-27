local OpInfoMap = {
    [0] = {Name = "NOP", Aux = false},
    [227] = {Name = "BREAK", Aux = false},
    [198] = {Name = "LOADNIL", Aux = false},
    [169] = {Name = "LOADB", Aux = false},
    [140] = {Name = "LOADN", Aux = false},
    [111] = {Name = "LOADK", Aux = false},
    [82] = {Name = "MOVE", Aux = false},
    [53] = {Name = "GETGLOBAL", Aux = true},
    [24] = {Name = "SETGLOBAL", Aux = true},
    [251] = {Name = "GETUPVAL", Aux = false},
    [222] = {Name = "SETUPVAL", Aux = false},
    [193] = {Name = "CLOSEUPVALS", Aux = false},
    [164] = {Name = "GETIMPORT", Aux = true},
    [135] = {Name = "GETTABLE", Aux = false},
    [106] = {Name = "SETTABLE", Aux = false},
    [77] = {Name = "GETTABLEKS", Aux = true},
    [48] = {Name = "SETTABLEKS", Aux = true},
    [19] = {Name = "GETTABLEN", Aux = false},
    [246] = {Name = "SETTABLEN", Aux = false},
    [217] = {Name = "NEWCLOSURE", Aux = false},
    [188] = {Name = "NAMECALL", Aux = true},
    [159] = {Name = "CALL", Aux = false},
    [37] = {Name = "CALL", Aux = true},
    [130] = {Name = "RETURN", Aux = false},
    [101] = {Name = "JUMP", Aux = false},
    [72] = {Name = "JUMPBACK", Aux = false},
    [43] = {Name = "JUMPIF", Aux = false},
    [14] = {Name = "JUMPIFNOT", Aux = false},
    [241] = {Name = "JUMPIFEQ", Aux = true},
    [212] = {Name = "JUMPIFLE", Aux = true},
    [183] = {Name = "JUMPIFLT", Aux = true},
    [154] = {Name = "JUMPIFNOTEQ", Aux = true},
    [125] = {Name = "JUMPIFNOTLE", Aux = true},
    [96] = {Name = "JUMPIFNOTLT", Aux = true},
    [67] = {Name = "ADD", Aux = false},
    [38] = {Name = "SUB", Aux = false},
    [9] = {Name = "MUL", Aux = false},
    [236] = {Name = "DIV", Aux = false},
    [207] = {Name = "MOD", Aux = false},
    [178] = {Name = "POW", Aux = false},
    [149] = {Name = "ADDK", Aux = false},
    [120] = {Name = "SUBK", Aux = false},
    [91] = {Name = "MULK", Aux = false},
    [62] = {Name = "DIVK", Aux = false},
    [33] = {Name = "MODK", Aux = false},
    [4] = {Name = "POWK", Aux = false},
    [231] = {Name = "AND", Aux = false},
    [202] = {Name = "OR", Aux = false},
    [173] = {Name = "ANDK", Aux = false},
    [144] = {Name = "ORK", Aux = false},
    [115] = {Name = "CONCAT", Aux = false},
    [86] = {Name = "NOT", Aux = false},
    [57] = {Name = "MINUS", Aux = false},
    [28] = {Name = "LENGTH", Aux = false},
    [255] = {Name = "NEWTABLE", Aux = true},
    [226] = {Name = "DUPTABLE", Aux = false},
    [197] = {Name = "SETLIST", Aux = true},
    [168] = {Name = "FORNPREP", Aux = false},
    [139] = {Name = "FORNLOOP", Aux = false},
    [110] = {Name = "FORGLOOP", Aux = true},
    [81] = {Name = "FORGPREP_INEXT", Aux = false},
    [23] = {Name = "FORGPREP_NEXT", Aux = false},
    [250] = {Name = "NATIVECALL", Aux = false},
    [221] = {Name = "GETVARARGS", Aux = false},
    [192] = {Name = "DUPCLOSURE", Aux = false},
    [163] = {Name = "PREPVARARGS", Aux = false},
    [134] = {Name = "LOADKX", Aux = false},
    [105] = {Name = "JUMPX", Aux = false},
    [76] = {Name = "FASTCALL", Aux = false},
    [47] = {Name = "COVERAGE", Aux = false},
    [18] = {Name = "CAPTURE", Aux = false},
    [245] = {Name = "SUBRK", Aux = false},
    [216] = {Name = "DIVRK", Aux = false},
    [187] = {Name = "FASTCALL1", Aux = false},
    [158] = {Name = "FASTCALL2", Aux = true},
    [129] = {Name = "FASTCALL2K", Aux = true},
    [52] = {Name = "FASTCALL3", Aux = true},
    [100] = {Name = "FORGPREP", Aux = false},
    [71] = {Name = "JUMPXEQKNIL", Aux = true},
    [42] = {Name = "JUMPXEQKB", Aux = true},
    [13] = {Name = "JUMPXEQKN", Aux = true},
    [240] = {Name = "JUMPXEQKS", Aux = true},
    [211] = {Name = "IDIV", Aux = false},
    [182] = {Name = "IDIVK", Aux = false},
    [235] = {Name = "HINT", Aux = false},
    [153] = {Name = "COUNT", Aux = false},
}

local function Update(Target, Fields)
    for Key, Value in pairs(Fields) do
        Target[Key] = Value
    end
end

local EmptyList = table.freeze({})

local function CharAt(Text, Index)
    return string.sub(Text, Index + 1, Index + 1)
end

local function Slice(Text, From, To)
    return string.sub(Text, From + 1, To)
end

local function FindFrom(Text, Needle, From)
    local Position = string.find(Text, Needle, From + 1, true)

    if Position then
        return Position - 1
    end

    return -1
end

local function StartsWith(Text, Prefix)
    return string.sub(Text, 1, #Prefix) == Prefix
end

local function EndsWith(Text, Suffix)
    return Suffix == "" or string.sub(Text, -#Suffix) == Suffix
end

local function Strip(Text)
    local First = string.find(Text, "%S")

    if not First then
        return ""
    end

    local Last = #Text

    while string.find(string.sub(Text, Last, Last), "%s") do
        Last -= 1
    end

    return string.sub(Text, First, Last)
end

local function LStrip(Text)
    local First = string.find(Text, "%S")

    if not First then
        return ""
    end

    return string.sub(Text, First)
end

local function RStrip(Text)
    local Last = #Text

    while Last > 0 and string.find(string.sub(Text, Last, Last), "%s") do
        Last -= 1
    end

    return string.sub(Text, 1, Last)
end

local function IsWordAt(Text, Index)
    local Byte = string.byte(Text, Index)

    return Byte ~= nil and (Byte >= 97 and Byte <= 122 or Byte >= 65 and Byte <= 90 or Byte >= 48 and Byte <= 57 or Byte == 95 or Byte >= 128)
end

local function IsAlphaChar(Char)
    return Char ~= "" and string.find(Char, "^[A-Za-z\128-\255]") ~= nil
end

local function IsAlnumChar(Char)
    return Char ~= "" and string.find(Char, "^[A-Za-z0-9\128-\255]") ~= nil
end

local function IsDigitChar(Char)
    return Char ~= "" and Char >= "0" and Char <= "9"
end

local function FindWord(Text, Word, Init)
    local Position = Init or 1

    while true do
        local Start = string.find(Text, Word, Position, true)

        if not Start then
            return nil
        end

        if not IsWordAt(Text, Start - 1) and not IsWordAt(Text, Start + #Word) then
            return Start
        end

        Position = Start + 1
    end
end

local function CountWord(Text, Word)
    local Count = 0
    local Position = 1

    while true do
        local Start = FindWord(Text, Word, Position)

        if not Start then
            return Count
        end

        Count += 1
        Position = Start + 1
    end
end

local function Split(Text, Separator)
    local Parts = {}
    local Position = 1

    while true do
        local Start, Stop = string.find(Text, Separator, Position, true)

        if not Start then
            Parts[#Parts + 1] = string.sub(Text, Position)
            return Parts
        end

        Parts[#Parts + 1] = string.sub(Text, Position, Start - 1)
        Position = Stop + 1
    end
end

local function SortedIds(Map)
    local Ids = {}

    for Id in pairs(Map) do
        Ids[#Ids + 1] = Id
    end

    table.sort(Ids)

    return Ids
end

local function ListHas(List, Value)
    for Index = 1, #List do
        if List[Index] == Value then
            return true
        end
    end

    return false
end

local function ListCount(List, Value)
    local Count = 0

    for Index = 1, #List do
        if List[Index] == Value then
            Count += 1
        end
    end

    return Count
end

local function ListEqual(Left, Right)
    if #Left ~= #Right then
        return false
    end

    for Index = 1, #Left do
        if Left[Index] ~= Right[Index] then
            return false
        end
    end

    return true
end

local function ListCopy(List)
    local Copy = {}

    for Index = 1, #List do
        Copy[Index] = List[Index]
    end

    return Copy
end

local function ListExtend(List, Other)
    for Index = 1, #Other do
        List[#List + 1] = Other[Index]
    end
end

local function SetFrom(List)
    local Set = {}

    for Index = 1, #List do
        Set[List[Index]] = true
    end

    return Set
end

local function SetCopy(Set)
    local Copy = {}

    for Key in pairs(Set) do
        Copy[Key] = true
    end

    return Copy
end

local function SetEqual(Left, Right)
    for Key in pairs(Left) do
        if not Right[Key] then
            return false
        end
    end

    for Key in pairs(Right) do
        if not Left[Key] then
            return false
        end
    end

    return true
end

local function SetCount(Set)
    local Count = 0

    for _ in pairs(Set) do
        Count += 1
    end

    return Count
end

local function Lookup(Map, Key)
    local Value = Map[Key]

    if Value == nil then
        error("KeyError: " .. tostring(Key), 0)
    end

    return Value
end

local function DecodeUtf8(Bytes)
    if not string.find(Bytes, "[\128-\255]") then
        return Bytes
    end

    local Out = {}
    local Index = 1
    local Length = #Bytes

    while Index <= Length do
        local Lead = string.byte(Bytes, Index)

        if Lead < 128 then
            local High = string.find(Bytes, "[\128-\255]", Index) or Length + 1
            Out[#Out + 1] = string.sub(Bytes, Index, High - 1)
            Index = High
        else
            local Need = nil
            local Low = 0x80
            local Top = 0xBF

            if Lead >= 0xC2 and Lead <= 0xDF then
                Need = 1
            elseif Lead == 0xE0 then
                Need = 2
                Low = 0xA0
            elseif Lead == 0xED then
                Need = 2
                Top = 0x9F
            elseif Lead >= 0xE1 and Lead <= 0xEF then
                Need = 2
            elseif Lead == 0xF0 then
                Need = 3
                Low = 0x90
            elseif Lead >= 0xF1 and Lead <= 0xF3 then
                Need = 3
            elseif Lead == 0xF4 then
                Need = 3
                Top = 0x8F
            end

            if not Need then
                Out[#Out + 1] = "\239\191\189"
                Index += 1
            else
                local Used = 1
                local Valid = true

                for Step = 1, Need do
                    local Byte = string.byte(Bytes, Index + Step)
                    local Min = 0x80
                    local Max = 0xBF

                    if Step == 1 then
                        Min = Low
                        Max = Top
                    end

                    if Byte == nil or Byte < Min or Byte > Max then
                        Valid = false
                        break
                    end

                    Used += 1
                end

                if Valid then
                    Out[#Out + 1] = string.sub(Bytes, Index, Index + Used - 1)
                else
                    Out[#Out + 1] = "\239\191\189"
                end

                Index += Used
            end
        end
    end

    return table.concat(Out)
end

local function PyLen(Text)
    return utf8.len(Text) or #Text
end

local function FloatRepr(Value)
    local Text = nil

    for Precision = 0, 16 do
        Text = string.format("%." .. Precision .. "e", Value)

        if tonumber(Text) == Value then
            break
        end
    end

    local Sign, Lead, Rest, Exponent = string.match(Text, "^(-?)(%d)%.?(%d*)e([+-]%d+)$")
    local Digits = Lead .. Rest
    local Exp = tonumber(Exponent)

    if Exp < -4 or Exp >= 16 then
        local Mantissa = Lead

        if Rest ~= "" then
            Mantissa = Lead .. "." .. Rest
        end

        local ExpSign = Exp < 0 and "-" or "+"
        local ExpDigits = tostring(math.abs(Exp))

        if #ExpDigits < 2 then
            ExpDigits = "0" .. ExpDigits
        end

        return Sign .. Mantissa .. "e" .. ExpSign .. ExpDigits
    end

    if Exp >= 0 then
        local IntPart = string.sub(Digits, 1, Exp + 1)
        local FracPart = string.sub(Digits, Exp + 2)

        if #IntPart < Exp + 1 then
            IntPart = IntPart .. string.rep("0", Exp + 1 - #IntPart)
        end

        if FracPart == "" then
            FracPart = "0"
        end

        return Sign .. IntPart .. "." .. FracPart
    end

    return Sign .. "0." .. string.rep("0", -Exp - 1) .. Digits
end

local Buf = nil
local Offset = 0
local CurrentBufferLen = 0

local function CheckRead(N, ErrorMsg)
    if Offset + N > CurrentBufferLen then
        error(string.format("%s at position %d, but buffer length is %d", ErrorMsg, Offset, CurrentBufferLen), 0)
    end
end

local function NextByte()
    CheckRead(1, "Attempted to read 1 byte")
    local Value = string.byte(Buf, Offset + 1)
    Offset += 1

    return Value
end

local function NextUint32()
    CheckRead(4, "Attempted to read 4 bytes for Uint32")
    local Value = string.unpack("<I4", Buf, Offset + 1)
    Offset += 4

    return Value
end

local function NextInt()
    CheckRead(4, "Attempted to read 4 bytes for Int32")
    local Value = string.unpack("<i4", Buf, Offset + 1)
    Offset += 4

    return Value
end

local function NextVarInt()
    local Result = 0
    local Multiplier = 1

    while true do
        local B = NextByte()
        Result = Result + bit32.band(B, 0x7F) * Multiplier

        if bit32.band(B, 0x80) == 0 then
            break
        end

        Multiplier = Multiplier * 128
    end

    return Result
end

local OpcodeIsPlain = false

local function OpcodeKey(Word)
    local Byte = bit32.band(Word, 0xFF)

    if OpcodeIsPlain then
        return (Byte * 227) % 256
    end

    return (Byte * 203 * 227) % 256
end

local function NextVarIntDecimal()
    local Groups = {}

    while true do
        local B = NextByte()
        table.insert(Groups, 1, bit32.band(B, 0x7F))

        if bit32.band(B, 0x80) == 0 then
            break
        end
    end

    local Limbs = {0}

    for _, Group in ipairs(Groups) do
        local Carry = Group

        for Index = 1, #Limbs do
            local Value = Limbs[Index] * 128 + Carry
            Limbs[Index] = Value % 10000000
            Carry = Value // 10000000
        end

        while Carry > 0 do
            Limbs[#Limbs + 1] = Carry % 10000000
            Carry = Carry // 10000000
        end
    end

    local Text = tostring(Limbs[#Limbs])

    for Index = #Limbs - 1, 1, -1 do
        Text = Text .. string.format("%07d", Limbs[Index])
    end

    return Text
end

local function ReadProto(Proto)
    local CodeTable = Proto.CodeTable
    local Instructions = {}
    local CurrentPc = 1

    while CurrentPc <= #CodeTable do
        local InstructionInt = CodeTable[CurrentPc]
        local OpcodeNum = OpcodeKey(InstructionInt)
        local OpInfo = OpInfoMap[OpcodeNum]
        local Bx = bit32.rshift(InstructionInt, 16)

        local InstructionData = {
            Name = OpInfo and OpInfo.Name or "UNKNOWN",
            A = bit32.band(bit32.rshift(InstructionInt, 8), 0xFF),
            B = bit32.band(bit32.rshift(InstructionInt, 16), 0xFF),
            C = bit32.band(bit32.rshift(InstructionInt, 24), 0xFF),
            Bx = Bx,
            SBx = Bx >= 0x8000 and Bx - 0x10000 or Bx,
            Pc = CurrentPc,
        }

        if OpInfo ~= nil and OpInfo.Aux then
            CurrentPc += 1

            if CurrentPc <= #CodeTable then
                InstructionData.Aux = CodeTable[CurrentPc]
            else
                InstructionData.Aux = "Missing AUX value"
            end
        end

        Instructions[#Instructions + 1] = InstructionData
        CurrentPc += 1
    end

    return {
        ProtoIndex = Proto.ProtoIndex,
        LineDefined = Proto.LineDefined,
        Source = Proto.Source,
        NumParams = Proto.NumParams,
        IsVarArg = Proto.IsVarArg,
        MaxStackSize = Proto.MaxStackSize,
        Instructions = Instructions,
        RawProto = Proto,
    }
end

local RecKeywords = {
    ["and"] = true, ["break"] = true, ["continue"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true, ["end"] = true,
    ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true, ["nil"] = true,
    ["not"] = true, ["or"] = true, ["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
    ["while"] = true,
}

local function RecIdent(Text)
    return string.find(Text, "^[A-Za-z_][A-Za-z0-9_]*$") ~= nil and not RecKeywords[Text]
end

local function RecConst(K)
    if K == nil or K.Type == 0 then
        return "nil"
    end

    if K.Type == 1 then
        return K.Value and "true" or "false"
    end

    if K.Type == 2 then
        local Value = K.Value

        if Value ~= Value then
            return "(0/0)"
        end

        if Value == math.huge or Value == -math.huge then
            return Value > 0 and "math.huge" or "(-math.huge)"
        end

        if Value == math.floor(Value) and math.abs(Value) < 1e15 then
            if Value == 0 and 1 / Value < 0 then
                return "-0"
            end

            return string.format("%d", Value)
        end

        return FloatRepr(Value)
    end

    if K.Type == 3 then
        local Out = {}

        for Index = 1, #K.Value do
            local Ch = string.sub(K.Value, Index, Index)
            local Byte = string.byte(Ch)

            if Ch == "\\" then
                Out[Index] = "\\\\"
            elseif Ch == '"' then
                Out[Index] = '\\"'
            elseif Ch == "\n" then
                Out[Index] = "\\n"
            elseif Ch == "\r" then
                Out[Index] = "\\r"
            elseif Ch == "\t" then
                Out[Index] = "\\t"
            elseif Byte < 32 or Byte == 127 then
                Out[Index] = string.format("\\%03d", Byte)
            else
                Out[Index] = Ch
            end
        end

        return '"' .. table.concat(Out) .. '"'
    end

    if K.Type == 9 then
        return (K.Negative and K.Value ~= "0" and "-" or "") .. K.Value
    end

    if K.Type == 7 then
        local Texts = {}

        for Index = 1, 3 do
            local X = K.Value[Index]
            local Number = X

            if X == X and X ~= math.huge and X ~= -math.huge then
                local Text = nil

                for Digits = 1, 9 do
                    Text = string.format("%." .. Digits .. "g", X)

                    if string.unpack("<f", string.pack("<f", tonumber(Text))) == X then
                        break
                    end
                end

                Number = tonumber(Text)
            end

            Texts[Index] = RecConst({Type = 2, Value = Number})
        end

        return "Vector3.new(" .. table.concat(Texts, ", ") .. ")"
    end

    return "nil"
end

local function RecField(Name)
    if RecIdent(Name) then
        return "." .. Name
    end

    return "[" .. RecConst({Type = 3, Value = Name}) .. "]"
end

local function RecStrip(Text)
    if not StartsWith(Text, "(") or not EndsWith(Text, ")") then
        return Text
    end

    local Depth = 0
    local Quote = false
    local Index = 0

    while Index < #Text do
        local Ch = CharAt(Text, Index)

        if Quote then
            if Ch == "\\" then
                Index += 1
            elseif Ch == '"' then
                Quote = false
            end
        elseif Ch == '"' then
            Quote = true
        elseif Ch == "(" then
            Depth += 1
        elseif Ch == ")" then
            Depth -= 1

            if Depth == 0 then
                if Index == #Text - 1 then
                    return string.sub(Text, 2, -2)
                end

                return Text
            end
        end

        Index += 1
    end

    return Text
end

local function RecFormat(Parts, Texts)
    local Out = {}

    for Index = 1, #Parts do
        local Part = Parts[Index]

        if type(Part) == "string" then
            Out[#Out + 1] = Part
        elseif type(Part) == "table" then
            local Text = Texts[Part[2]]
            local First = string.sub(Text, 1, 1)

            if First == '"' or First == "-" or First == "{" or IsDigitChar(First) or Text == "nil" or Text == "true" or Text == "false" or StartsWith(Text, "function") or StartsWith(Text, "...") then
                Out[#Out + 1] = "(" .. Text .. ")"
            else
                Out[#Out + 1] = Text
            end
        else
            local Text = Texts[Part]

            if string.sub(Text, 1, 1) == "-" and #Parts > 1 then
                Out[#Out + 1] = "(" .. Text .. ")"
            else
                Out[#Out + 1] = Text
            end
        end
    end

    return table.concat(Out)
end

local function RecAtomic(Text)
    if string.find(Text, "\n", 1, true) or StartsWith(Text, "function") then
        return false
    end

    local Depth = 0
    local Quote = false
    local Index = 0

    while Index < #Text do
        local Ch = CharAt(Text, Index)

        if Quote then
            if Ch == "\\" then
                Index += 1
            elseif Ch == '"' then
                Quote = false
            end
        elseif Ch == '"' then
            Quote = true
        elseif Ch == "(" or Ch == "[" or Ch == "{" then
            Depth += 1
        elseif Ch == ")" or Ch == "]" or Ch == "}" then
            Depth -= 1
        elseif Ch == " " and Depth == 0 then
            return false
        end

        Index += 1
    end

    return true
end

local function RecWrap(Text)
    if RecAtomic(Text) then
        return Text
    end

    return "(" .. Text .. ")"
end

local function RecIndent(Text, Level)
    local Lines = Split(Text, "\n")
    local Pad = string.rep("    ", Level)

    for Index = 1, #Lines do
        if Lines[Index] ~= "" then
            Lines[Index] = Pad .. Lines[Index]
        end
    end

    return table.concat(Lines, "\n")
end

local function RecNegate(Cond)
    return {P = Cond.N, N = Cond.P}
end

local function MatchAssignLine(Line)
    local Indent, Rest = string.match(Line, "^( *)(.*)$")

    if StartsWith(Rest, "local ") then
        local Var, Left = string.match(string.sub(Rest, 7), "^([%w_\128-\255]+) = (.+)$")

        if Var then
            return Indent, "local ", Var, Left
        end
    end

    local Var, Left = string.match(Rest, "^([%w_\128-\255]+) = (.+)$")

    if Var then
        return Indent, nil, Var, Left
    end

    return nil
end

local function MatchAssignList(Text, Var)
    local Start = string.find(Text, "[^ ]") or #Text + 1

    for Attempt = 1, 2 do
        local Position = Start

        if Attempt == 1 then
            if string.sub(Text, Position, Position + 5) ~= "local " then
                continue
            end

            Position += 6
        end

        if string.sub(Text, Position, Position + #Var - 1) == Var then
            local Next = Position + #Var

            while string.sub(Text, Next, Next + 1) == ", " do
                local Stop = Next + 2

                if not IsWordAt(Text, Stop) then
                    break
                end

                while IsWordAt(Text, Stop) do
                    Stop += 1
                end

                Next = Stop
            end

            if string.sub(Text, Next, Next + 2) == " = " then
                return true
            end
        end
    end

    return false
end

local function FindInCall(Text, Var)
    local Needle = "in " .. Var .. "("
    local Position = 1

    while true do
        local Start = string.find(Text, Needle, Position, true)

        if not Start then
            return nil
        end

        if not IsWordAt(Text, Start - 1) then
            return Start
        end

        Position = Start + 1
    end
end

local function RecFold(Source)
    local Body = ListCopy(Source)
    local Chains = {}
    local Changed = true

    while Changed do
        Changed = false
        local Row = #Body - 3

        while Row >= 1 do
            local Ind, Local, Var, Left = MatchAssignLine(Body[Row])

            if Var and Left ~= "function" and not EndsWith(Left, "{") and not EndsWith(Left, "(") and not EndsWith(Left, ",") then
                if Body[Row + 1] == nil or Body[Row + 2] == nil then
                    error("list index out of range", 0)
                end

                local Op = nil

                if Body[Row + 1] == Ind .. "if not " .. Var .. " then" then
                    Op = "or"
                elseif Body[Row + 1] == Ind .. "if " .. Var .. " then" then
                    Op = "and"
                end

                local Prefix = Ind .. "    " .. Var .. " = "
                local Right = nil

                if StartsWith(Body[Row + 2], Prefix) and #Body[Row + 2] > #Prefix then
                    Right = string.sub(Body[Row + 2], #Prefix + 1)
                end

                if Op and Right and Body[Row + 3] == nil then
                    error("list index out of range", 0)
                end

                if Op and Right and Body[Row + 3] == Ind .. "end" and not FindWord(Right, Var) and not EndsWith(Right, "{") and not EndsWith(Right, "(") and not EndsWith(Right, ",") and Right ~= "function" and not StartsWith(Right, "function") then
                    local Joined = nil

                    if Chains[Op .. "\0" .. Right] then
                        Joined = RecWrap(Left) .. " " .. Op .. " " .. Right
                    else
                        Joined = RecWrap(Left) .. " " .. Op .. " " .. RecWrap(Right)
                    end

                    Chains[Op .. "\0" .. Joined] = true
                    Body[Row] = Ind .. (Local or "") .. Var .. " = " .. Joined
                    table.remove(Body, Row + 1)
                    table.remove(Body, Row + 1)
                    table.remove(Body, Row + 1)
                    Changed = true
                end
            end

            Row -= 1
        end
    end

    local Row = 1

    while Row <= #Body do
        local Alias = nil
        local AliasVar = nil
        local AliasTarget = nil
        local Spaces, AfterSpaces = string.match(Body[Row], "^( *)(.*)$")

        for Attempt = 1, 2 do
            local Rest = AfterSpaces

            if Attempt == 1 then
                if not StartsWith(Rest, "local ") then
                    continue
                end

                Rest = string.sub(Rest, 7)
            end

            local Name, Target = string.match(Rest, "^([%w_\128-\255]+) = (%a+)$")

            if Name and (Target == "ipairs" or Target == "pairs" or Target == "next") then
                Alias = true
                AliasVar = Name
                AliasTarget = Target
                break
            end
        end

        if Alias and AliasVar ~= AliasTarget then
            local Var = AliasVar
            local Hits = {}

            for Index = Row + 1, #Body do
                if FindWord(Body[Index], Var) then
                    Hits[#Hits + 1] = Index
                end
            end

            if #Hits > 0 and FindInCall(Body[Hits[1]], Var) and CountWord(Body[Hits[1]], Var) == 1 and (#Hits == 1 or MatchAssignList(Body[Hits[2]], Var)) then
                local Start = FindInCall(Body[Hits[1]], Var)
                Body[Hits[1]] = string.sub(Body[Hits[1]], 1, Start - 1) .. "in " .. AliasTarget .. "(" .. string.sub(Body[Hits[1]], Start + 4 + #Var)
                table.remove(Body, Row)
                continue
            end
        end

        Row += 1
    end

    return Body
end

local function RecTerminal(Nodes)
    if #Nodes == 0 then
        return false
    end

    local Last = Nodes[#Nodes]

    if Last.K == "ret" or Last.K == "break" or Last.K == "continue" or Last.K == "goto" then
        return true
    end

    if Last.K == "if" then
        return RecTerminal(Last.Then) and RecTerminal(Last.Else)
    end

    return false
end

local function RecBreaks(Nodes)
    for _, Node in ipairs(Nodes) do
        if Node.K == "break" then
            return true
        end

        if Node.K == "if" and (RecBreaks(Node.Then) or RecBreaks(Node.Else)) then
            return true
        end
    end

    return false
end

local function RecContinues(Nodes)
    for _, Node in ipairs(Nodes) do
        if Node.K == "continue" then
            return true
        end

        if Node.K == "if" and (RecContinues(Node.Then) or RecContinues(Node.Else)) then
            return true
        end
    end

    return false
end

local function RecCleanup(Nodes, InLoopTail)
    local Out = {}

    for Index = 1, #Nodes do
        local Node = Nodes[Index]
        local DeadAfter = Node.K == "if" and RecTerminal(Node.Then) and RecTerminal(Node.Else)
        local Last = Index == #Nodes or DeadAfter

        if Node.K == "if" then
            Node.Then = RecCleanup(Node.Then, InLoopTail and Last)
            Node.Else = RecCleanup(Node.Else, InLoopTail and Last)

            if InLoopTail and Last and #Node.Else >= 2 and Node.Else[1].K == "if" and #Node.Else[1].Else == 0 and #Node.Else[1].Then == 1 and Node.Else[1].Then[1].K == "continue" then
                local Rest = {}

                for Offset2 = 2, #Node.Else do
                    Rest[#Rest + 1] = Node.Else[Offset2]
                end

                Node.Else = {{K = "if", Cond = RecNegate(Node.Else[1].Cond), Then = Rest, Else = {}}}
            end

            if #Node.Then == 0 and #Node.Else > 0 then
                Node.Cond, Node.Then, Node.Else = RecNegate(Node.Cond), Node.Else, {}
            end
        elseif Node.K == "loop" then
            Node.Body = RecCleanup(Node.Body, true)
        elseif Node.K == "continue" and Last and InLoopTail then
            Node = nil
        end

        if Node ~= nil then
            Out[#Out + 1] = Node
        end

        if DeadAfter then
            break
        end
    end

    return Out
end

local function RecPreds(Blocks)
    for _, Id in ipairs(SortedIds(Blocks)) do
        Blocks[Id].Preds = {}
    end

    for _, Id in ipairs(SortedIds(Blocks)) do
        local B = Blocks[Id]

        for _, S in ipairs(B.Succ) do
            if Blocks[S] then
                table.insert(Blocks[S].Preds, B.Id)
            end
        end
    end
end

local function RecDominators(Entry, Succ, Preds)
    local Order = {}
    local Seen = {[Entry] = true}
    local Stack = {{Entry, Succ(Entry), 0}}

    while #Stack > 0 do
        local Frame = Stack[#Stack]
        local Pushed = false

        while Frame[3] < #Frame[2] do
            Frame[3] += 1
            local S = Frame[2][Frame[3]]

            if not Seen[S] then
                Seen[S] = true
                Stack[#Stack + 1] = {S, Succ(S), 0}
                Pushed = true
                break
            end
        end

        if not Pushed then
            table.remove(Stack)
            Order[#Order + 1] = Frame[1]
        end
    end

    local Count = #Order
    local Reversed = {}

    for Index = 1, Count do
        Reversed[Index] = Order[Count - Index + 1]
    end

    local Index = {}

    for Position = 1, Count do
        Index[Reversed[Position]] = Position - 1
    end

    local Idom = {[Entry] = Entry}
    local Changed = true

    while Changed do
        Changed = false

        for Position = 2, Count do
            local N = Reversed[Position]
            local Ps = {}

            for _, P in ipairs(Preds(N)) do
                if Idom[P] ~= nil and Index[P] ~= nil then
                    Ps[#Ps + 1] = P
                end
            end

            if #Ps > 0 then
                local New = Ps[1]

                for PIndex = 2, #Ps do
                    local A = Ps[PIndex]
                    local B = New

                    while A ~= B do
                        while Index[A] > Index[B] do
                            A = Idom[A]
                        end

                        while Index[B] > Index[A] do
                            B = Idom[B]
                        end
                    end

                    New = A
                end

                if Idom[N] ~= New then
                    Idom[N] = New
                    Changed = true
                end
            end
        end
    end

    return Idom, Index
end

local RecStructurer = {}
RecStructurer.__index = RecStructurer

function RecStructurer.New(Entry, Blocks)
    local Self = setmetatable({}, RecStructurer)
    Self.Entry = Entry
    Self.Blocks = Blocks
    Self.Idom, Self.RpoIndex = RecDominators(Entry, function(N)
        return Blocks[N].Succ
    end, function(N)
        return Blocks[N].Preds
    end)

    Self.Loops = {}

    local Ids = SortedIds(Blocks)

    for _, Id in ipairs(Ids) do
        local B = Blocks[Id]

        for _, S in ipairs(B.Succ) do
            if Self.Idom[S] ~= nil and Self.Idom[B.Id] ~= nil then
                local Walk = B.Id

                while true do
                    if Walk == S then
                        if not Self.Loops[S] then
                            Self.Loops[S] = {}
                        end

                        Self.Loops[S][B.Id] = true
                        break
                    end

                    local Next = Self.Idom[Walk]

                    if Next == nil or Next == Walk then
                        break
                    end

                    Walk = Next
                end
            end
        end
    end

    Self.LoopBody = {}

    for H, Latches in pairs(Self.Loops) do
        local Body = {[H] = true}
        local Stack = {}

        for Latch in pairs(Latches) do
            Stack[#Stack + 1] = Latch
        end

        while #Stack > 0 do
            local X = table.remove(Stack)

            if not Body[X] then
                Body[X] = true

                for _, P in ipairs(Blocks[X].Preds) do
                    if Self.Idom[P] ~= nil then
                        Stack[#Stack + 1] = P
                    end
                end
            end
        end

        Self.LoopBody[H] = Body
    end

    local Exits = {}
    local RSucc = {}
    local RPred = {}

    for _, Id in ipairs(Ids) do
        if #Blocks[Id].Succ == 0 then
            Exits[#Exits + 1] = Id
        end

        RSucc[Id] = ListCopy(Blocks[Id].Preds)
        RPred[Id] = ListCopy(Blocks[Id].Succ)
    end

    RSucc[0] = Exits
    RPred[0] = {}

    for _, E in ipairs(Exits) do
        local Copy = ListCopy(RPred[E])
        Copy[#Copy + 1] = 0
        RPred[E] = Copy
    end

    local Can = {}
    local Stack = {0}

    while #Stack > 0 do
        local X = table.remove(Stack)

        if not Can[X] then
            Can[X] = true

            if RSucc[X] then
                ListExtend(Stack, RSucc[X])
            end
        end
    end

    for _, Id in ipairs(Ids) do
        if not Can[Id] then
            RSucc[0][#RSucc[0] + 1] = Id
            local Copy = ListCopy(RPred[Id])
            Copy[#Copy + 1] = 0
            RPred[Id] = Copy
        end
    end

    Self.Ipdom = RecDominators(0, function(N)
        return RSucc[N] or {}
    end, function(N)
        return RPred[N] or {}
    end)

    Self.Emitted = {}
    Self.Gotos = {}
    Self.LoopExit = {}
    Self.StubFollows = {}
    Self.ForBreak = {}
    Self.Redirect = {}
    Self.Relaxed = false
    Self.FlagTargets = {}

    return Self
end

function RecStructurer.IpdomOf(Self, N)
    local P = Self.Ipdom[N]

    if P == nil or P == 0 then
        return nil
    end

    return P
end

function RecStructurer.ReachFrom(Self, Start, Loop)
    local Seen = {}
    local Stack = {Start}

    while #Stack > 0 do
        local X = table.remove(Stack)

        if not Seen[X] then
            if not (Loop ~= nil and (X == Loop[1] or X == Loop[3] or not Loop[2][X])) then
                Seen[X] = true
                ListExtend(Stack, Self.Blocks[X].Succ)
            end
        end
    end

    return Seen
end

function RecStructurer.CommonJoin(Self, T, E, Loop)
    local A = Self:ReachFrom(T, Loop)

    if next(A) == nil then
        return nil
    end

    local Both = {}

    for X in pairs(Self:ReachFrom(E, Loop)) do
        if A[X] and not Self.Emitted[X] then
            Both[#Both + 1] = X
        end
    end

    if #Both == 0 then
        return nil
    end

    table.sort(Both, function(Left, Right)
        local L = Self.RpoIndex[Left] or 1073741824
        local R = Self.RpoIndex[Right] or 1073741824

        if L ~= R then
            return L < R
        end

        return Left < Right
    end)

    local M = Both[1]

    for _, X in ipairs(Both) do
        local Seen = {}
        local Stack = {T, E}
        local Covered = true

        while #Stack > 0 and Covered do
            local Y = table.remove(Stack)

            if not (Y == X or Seen[Y]) then
                Seen[Y] = true

                if Loop ~= nil and (Y == Loop[1] or Y == Loop[3] or (not Loop[2][Y] and #Self.Blocks[Y].Succ > 0)) then
                    Covered = false
                else
                    ListExtend(Stack, Self.Blocks[Y].Succ)
                end
            end
        end

        if Covered then
            M = X
            break
        end
    end

    for H, Body in pairs(Self.LoopBody) do
        if Body[M] and H ~= M and (Loop == nil or H ~= Loop[1]) and (not Body[T] or not Body[E]) then
            return nil
        end
    end

    return M
end

function RecStructurer.BreakingRegion(Self, Cur, H, Body, Ex, Limit)
    Limit = Limit or 40

    if Ex == nil or Self.Blocks[Ex] == nil then
        return false
    end

    local Seen = {}
    local SeenCount = 0
    local Stack = {Cur}

    while #Stack > 0 do
        local X = table.remove(Stack)

        if X ~= Ex and not Seen[X] then
            Seen[X] = true
            SeenCount += 1
            local B = Self.Blocks[X]
            local KindOk = nil

            if Self.Relaxed then
                KindOk = B.Kind == "goto" or B.Kind == "cond" or B.Kind == "ret" or B.Kind == "end"
            else
                KindOk = B.Kind == "goto" or B.Kind == "cond"
            end

            if SeenCount > Limit or Self.Emitted[X] or Body[X] or not KindOk then
                return false
            end

            for _, Lb in pairs(Self.LoopBody) do
                if Lb[X] and not Lb[H] then
                    return false
                end
            end

            ListExtend(Stack, B.Succ)
        end
    end

    for X in pairs(Seen) do
        for _, P in ipairs(Self.Blocks[X].Preds) do
            if not Seen[P] and not Body[P] then
                return false
            end
        end
    end

    return true
end

function RecStructurer.TerminalTail(Self, Cur, Loop, Limit, Stop)
    Limit = Limit or 40
    local Out = {}
    local Seen = {}
    local SeenCount = 0

    while true do
        if Loop ~= nil and Cur == Loop[1] and SeenCount > 0 then
            Out[#Out + 1] = {K = "continue"}
            return Out
        end

        if Loop ~= nil and Cur == Loop[3] and SeenCount > 0 then
            Out[#Out + 1] = {K = "break"}
            return Out
        end

        if Stop ~= nil and Cur == Stop and SeenCount > 0 then
            return Out
        end

        if Seen[Cur] or Self.Loops[Cur] then
            return nil
        end

        Seen[Cur] = true
        SeenCount += 1
        local B = Self.Blocks[Cur]

        for _, T in ipairs(B.Stmts) do
            Out[#Out + 1] = {K = "text", Text = T}
        end

        if #Out > Limit then
            return nil
        end

        if B.Kind == "ret" then
            Out[#Out + 1] = {K = "ret", Text = B.Values}
            return Out
        end

        if B.Kind ~= "goto" then
            return nil
        end

        Cur = B.Succ[1]
    end
end

function RecStructurer.IsExitStub(Self, X, Body, Limit)
    Limit = Limit or 12
    local B = Self.Blocks[X]

    if B == nil or B.Kind ~= "goto" or Self.Loops[X] or #B.Stmts > Limit then
        return false
    end

    for _, P in ipairs(B.Preds) do
        if not Body[P] then
            return false
        end
    end

    return true
end

function RecStructurer.Region(Self, Cur, Stop, Loop)
    local Out = {}
    local Guard = 0

    while Cur ~= nil and Cur ~= Stop do
        Guard += 1

        if Guard > 100000 then
            Self.Gotos[#Self.Gotos + 1] = {"guard", Cur}
            Out[#Out + 1] = {K = "goto", Target = Cur}
            break
        end

        if Self.Redirect[Cur] then
            ListExtend(Out, Self.Redirect[Cur])
            return Out
        end

        if Loop ~= nil then
            local H = Loop[1]
            local Body = Loop[2]
            local Ex = Loop[3]

            if Cur == H then
                Out[#Out + 1] = {K = "continue"}
                return Out
            end

            if Cur == Ex then
                Out[#Out + 1] = {K = "break"}
                return Out
            end

            if not Body[Cur] then
                local Tail = Self:TerminalTail(Cur, Loop)

                if Tail ~= nil then
                    ListExtend(Out, Tail)
                    return Out
                end

                if Ex ~= nil and Cur ~= Ex and Self.Blocks[Cur] ~= nil and Self.Blocks[Ex] ~= nil and Self.Blocks[Cur].Kind == "goto" and Self.Blocks[Ex].Kind == "goto" and ListEqual(Self.Blocks[Cur].Succ, Self.Blocks[Ex].Succ) and ListEqual(Self.Blocks[Cur].Stmts, Self.Blocks[Ex].Stmts) then
                    Out[#Out + 1] = {K = "break"}
                    return Out
                end

                if Self:BreakingRegion(Cur, H, Body, Ex) then
                    ListExtend(Out, Self:Region(Cur, Ex, nil))
                    Out[#Out + 1] = {K = "break"}
                    return Out
                end

                local Seen = {}
                local SeenCount = 0
                local Stack = {Cur}
                local Broke = false

                while #Stack > 0 do
                    local X = table.remove(Stack)

                    if not Seen[X] then
                        Seen[X] = true
                        SeenCount += 1

                        if SeenCount > 400 or Self.Emitted[X] then
                            Broke = true
                            break
                        end

                        ListExtend(Stack, Self.Blocks[X].Succ)
                    end
                end

                if not Broke then
                    local External = false

                    for X in pairs(Seen) do
                        for _, P in ipairs(Self.Blocks[X].Preds) do
                            if not Seen[P] and not Body[P] then
                                External = true
                            end
                        end
                    end

                    if not External then
                        local Bad = false

                        for Hd, Lb in pairs(Self.LoopBody) do
                            local Inter = false
                            local Subset = true

                            for K in pairs(Lb) do
                                if Seen[K] then
                                    Inter = true
                                else
                                    Subset = false
                                end
                            end

                            if (Seen[Hd] ~= nil) ~= Inter or (Seen[Hd] ~= nil and not Subset) then
                                Bad = true
                                break
                            end
                        end

                        if not Bad then
                            ListExtend(Out, Self:Region(Cur, nil, nil))
                            return Out
                        end
                    end
                end

                if Self.ForBreak[H] ~= nil and Self:BreakingRegion(Cur, H, Body, Self.ForBreak[H][1]) then
                    Out[#Out + 1] = {K = "text", Text = Self.ForBreak[H][2] .. " = true"}
                    ListExtend(Out, Self:Region(Cur, Self.ForBreak[H][1], nil))
                    Out[#Out + 1] = {K = "break"}
                    return Out
                end

                Out[#Out + 1] = {K = "goto", Target = Cur}
                Self.Gotos[#Self.Gotos + 1] = {"exit", H, Cur}
                return Out
            end
        end

        if Self.Emitted[Cur] and not Self.Loops[Cur] then
            local Tail = Self:TerminalTail(Cur, Loop, 40, Stop)

            if Tail ~= nil then
                ListExtend(Out, Tail)
                return Out
            end

            local Seen = {}
            local Stack = {Cur}
            local Weight = 0
            local Dupable = true

            while #Stack > 0 and Dupable do
                local X = table.remove(Stack)

                if not (X == Stop or Seen[X] or (Loop ~= nil and (X == Loop[1] or X == Loop[3]))) then
                    Seen[X] = true
                    local Dup = Self.Blocks[X]
                    Weight += 1 + #Dup.Stmts

                    if Weight > 40 or Self.Loops[X] or Dup.Kind == "for" or Dup.Kind == "forin" or (Loop ~= nil and not Loop[2][X] and Dup.Kind ~= "ret") then
                        Dupable = false
                    end

                    ListExtend(Stack, Dup.Succ)
                end
            end

            if not Dupable then
                Out[#Out + 1] = {K = "goto", Target = Cur}
                Self.Gotos[#Self.Gotos + 1] = {"shared", Cur}
                return Out
            end
        end

        if Self.Loops[Cur] and (Loop == nil or Loop[1] ~= Cur) then
            local Header = Cur
            local LoopBlocks = Self.LoopBody[Header]
            local LoopExits = {}
            local LoopExitSet = {}

            for _, N in ipairs(SortedIds(LoopBlocks)) do
                for _, S in ipairs(Self.Blocks[N].Succ) do
                    if not LoopBlocks[S] and not LoopExitSet[S] then
                        LoopExitSet[S] = true
                        LoopExits[#LoopExits + 1] = S
                    end
                end
            end

            local LoopEx = nil

            if #LoopExits == 1 then
                LoopEx = LoopExits[1]
            elseif #LoopExits > 0 then
                local P = Self:IpdomOf(Header)

                while P ~= nil and LoopBlocks[P] do
                    P = Self:IpdomOf(P)
                end

                if P ~= nil and LoopExitSet[P] then
                    LoopEx = P
                elseif not Self.Relaxed then
                    LoopEx = LoopExits[1]

                    for _, X in ipairs(LoopExits) do
                        if (Self.RpoIndex[X] or 1073741824) < (Self.RpoIndex[LoopEx] or 1073741824) then
                            LoopEx = X
                        end
                    end
                else
                    local Pool = {}
                    local PoolSet = {}
                    local Starts = {Header}

                    for _, Latch in ipairs(SortedIds(Self.Loops[Header])) do
                        Starts[#Starts + 1] = Latch
                    end

                    for _, N in ipairs(Starts) do
                        for _, S in ipairs(Self.Blocks[N].Succ) do
                            if LoopExitSet[S] and not PoolSet[S] then
                                PoolSet[S] = true
                                Pool[#Pool + 1] = S
                            end
                        end
                    end

                    if #Pool == 0 then
                        Pool = LoopExits
                    end

                    LoopEx = Pool[1]

                    for _, X in ipairs(Pool) do
                        if (Self.RpoIndex[X] or 1073741824) < (Self.RpoIndex[LoopEx] or 1073741824) then
                            LoopEx = X
                        end
                    end

                    local Reach = {}

                    for _, X in ipairs(Pool) do
                        local Seen = {}
                        local Stack = {X}

                        while #Stack > 0 do
                            local Y = table.remove(Stack)

                            if not (Seen[Y] or LoopBlocks[Y]) then
                                Seen[Y] = true
                                ListExtend(Stack, Self.Blocks[Y].Succ)
                            end
                        end

                        Reach[X] = Seen
                    end

                    for _, X in ipairs(Pool) do
                        local Covers = true

                        for _, Y in ipairs(Pool) do
                            if Y ~= X and not Reach[Y][X] then
                                Covers = false
                                break
                            end
                        end

                        if Covers then
                            LoopEx = X
                            break
                        end
                    end
                end

                if Self:IsExitStub(LoopEx, LoopBlocks) then
                    local F = Self.Blocks[LoopEx].Succ[1]

                    if not LoopBlocks[F] and not Self.Loops[F] then
                        local Count = 0

                        for _, X in ipairs(LoopExits) do
                            if X == F then
                                Count += 1
                            elseif X ~= LoopEx and Self:IsExitStub(X, LoopBlocks) and Self.Blocks[X].Succ[1] == F then
                                Count += 1
                            end
                        end

                        if Count > 0 then
                            Self.StubFollows[F] = true
                            LoopEx = F
                        end
                    end
                end
            end

            Self.Emitted[Header] = true
            local HeaderBlock = Self.Blocks[Header]

            if HeaderBlock.Kind == "for" or HeaderBlock.Kind == "forin" then
                LoopEx = HeaderBlock.Succ[2]
            end

            Self.LoopExit[Header] = LoopEx

            if HeaderBlock.Kind == "for" or HeaderBlock.Kind == "forin" then
                for _, T in ipairs(HeaderBlock.Stmts) do
                    Out[#Out + 1] = {K = "text", Text = T}
                end

                local Others = {}

                for _, X in ipairs(LoopExits) do
                    if X ~= LoopEx then
                        Others[#Others + 1] = X
                    end
                end

                if #Others > 0 and Self:IsExitStub(LoopEx, LoopBlocks) then
                    local Follow = Self.Blocks[LoopEx].Succ[1]

                    if not LoopBlocks[Follow] and not Self.Loops[Follow] then
                        local AllBreak = true

                        for _, X in ipairs(Others) do
                            if not Self:BreakingRegion(X, Header, LoopBlocks, Follow) then
                                AllBreak = false
                                break
                            end
                        end

                        if AllBreak then
                            Self.ForBreak[Header] = {Follow, "brk" .. tostring(Header)}
                            Out[#Out + 1] = {K = "text", Text = "local brk" .. tostring(Header) .. " = false"}
                        end
                    end
                end

                local LoopNodes = Self:Region(HeaderBlock.Succ[1], nil, {Header, LoopBlocks, LoopEx})
                Out[#Out + 1] = {K = "loop", Body = LoopNodes, Kind = HeaderBlock.Kind, Header = HeaderBlock.Info}
            else
                local Inner = {}

                for _, T in ipairs(HeaderBlock.Stmts) do
                    Inner[#Inner + 1] = {K = "text", Text = T}
                end

                local InnerLoop = {Header, LoopBlocks, LoopEx}

                if HeaderBlock.Kind == "goto" then
                    ListExtend(Inner, Self:Region(HeaderBlock.Succ[1], nil, InnerLoop))
                elseif HeaderBlock.Kind == "cond" then
                    local T = HeaderBlock.Succ[1]
                    local E = HeaderBlock.Succ[2]
                    local M = Self:IpdomOf(Header)

                    if M ~= nil and not LoopBlocks[M] then
                        M = nil
                    end

                    if M == nil then
                        M = Self:CommonJoin(T, E, InnerLoop)
                    end

                    local Then = Self:Region(T, M, InnerLoop)
                    local Els = Self:Region(E, M, InnerLoop)
                    Inner[#Inner + 1] = {K = "if", Cond = HeaderBlock.Cond, Then = Then, Else = Els}

                    if M ~= nil then
                        ListExtend(Inner, Self:Region(M, nil, InnerLoop))
                    end
                elseif HeaderBlock.Kind == "ret" then
                    Inner[#Inner + 1] = {K = "ret", Text = HeaderBlock.Values}
                end

                Out[#Out + 1] = {K = "loop", Body = Inner, Kind = "while", Header = nil}
            end

            Cur = LoopEx
            local Lp = Out[#Out]

            if Self.ForBreak[Header] ~= nil then
                local BreakName = Self.ForBreak[Header][2]
                local After = Self:Region(Cur, Self.ForBreak[Header][1], Loop)
                Out[#Out + 1] = {K = "if", Cond = {P = "(not " .. BreakName .. ")", N = BreakName}, Then = After, Else = {}}
                Cur = Self.ForBreak[Header][1]
                continue
            end

            if Lp.Kind == "while" and not RecBreaks(Lp.Body) then
                return Out
            end

            continue
        end

        local B = Self.Blocks[Cur]

        if B.Kind == "for" or B.Kind == "forin" then
            Out[#Out + 1] = {K = "goto", Target = Cur}
            Self.Gotos[#Self.Gotos + 1] = {"for", Cur}
            return Out
        end

        Self.Emitted[Cur] = true

        for _, T in ipairs(B.Stmts) do
            Out[#Out + 1] = {K = "text", Text = T}
        end

        if B.Kind == "ret" then
            Out[#Out + 1] = {K = "ret", Text = B.Values}
            return Out
        end

        if B.Kind == "end" then
            return Out
        end

        if B.Kind == "goto" then
            Cur = B.Succ[1]
            continue
        end

        local T = B.Succ[1]
        local E = B.Succ[2]
        local M = Self:IpdomOf(Cur)

        if Loop ~= nil and M ~= nil and not Loop[2][M] and (M ~= Loop[3] or Self.StubFollows[M]) then
            M = nil
        end

        if Loop ~= nil and M == Loop[1] then
            if (T == Loop[1] or E == Loop[1]) and Stop ~= nil and Stop ~= Loop[1] and Loop[2][Stop] then
                local ContCond = B.Cond

                if T ~= Loop[1] then
                    ContCond = RecNegate(B.Cond)
                end

                Out[#Out + 1] = {K = "if", Cond = ContCond, Then = {{K = "continue"}}, Else = {}}

                if T == Loop[1] then
                    Cur = E
                else
                    Cur = T
                end

                continue
            end

            local Joined = Self:CommonJoin(T, E, Loop)

            if Self.Relaxed and Joined == nil and Stop ~= nil and Stop ~= Loop[1] and Loop[2][Stop] and (Self:ReachFrom(T, Loop)[Stop] or Self:ReachFrom(E, Loop)[Stop]) then
                M = Stop
            else
                M = Joined or M
            end
        end

        if M == nil then
            M = Self:CommonJoin(T, E, Loop)
        end

        local Shared = nil

        for _, X in ipairs(B.Succ) do
            if not (not Self.FlagTargets[X] or X == M or Self.Redirect[X] or Self.Emitted[X] or Self.Loops[X] or (Loop ~= nil and (X == Loop[1] or X == Loop[3]))) then
                local TreeSet = {[Cur] = true}
                local TreeCount = 1
                local Stack = {Cur}

                while #Stack > 0 and TreeSet ~= nil and TreeCount <= 30 do
                    local N = table.remove(Stack)

                    for _, S in ipairs(Self.Blocks[N].Succ) do
                        if not (S == X or S == M or TreeSet[S] or (Loop ~= nil and (S == Loop[1] or S == Loop[3]))) then
                            if Self.Emitted[S] or Self.Loops[S] or Self.Redirect[S] or not (Self.Blocks[S].Kind == "goto" or Self.Blocks[S].Kind == "cond" or Self.Blocks[S].Kind == "ret") then
                                TreeSet = nil
                                break
                            end

                            TreeSet[S] = true
                            TreeCount += 1
                            Stack[#Stack + 1] = S
                        end
                    end
                end

                if TreeSet ~= nil and TreeCount <= 30 and #Self.Blocks[X].Preds >= 2 then
                    local Closed = true

                    for S in pairs(TreeSet) do
                        if S ~= Cur then
                            for _, P in ipairs(Self.Blocks[S].Preds) do
                                if not TreeSet[P] then
                                    Closed = false
                                end
                            end
                        end
                    end

                    for _, P in ipairs(Self.Blocks[X].Preds) do
                        if not TreeSet[P] then
                            Closed = false
                        end
                    end

                    if Closed then
                        Shared = X
                        break
                    end
                end
            end
        end

        if Shared ~= nil then
            local Flag = "sh" .. tostring(Shared)
            local SubStop = Stop

            if M ~= nil then
                SubStop = M
            end

            Self.Redirect[Shared] = {{K = "text", Text = Flag .. " = true"}}
            Out[#Out + 1] = {K = "text", Text = "local " .. Flag .. " = false"}
            local Then = Self:Region(T, SubStop, Loop)
            local Els = Self:Region(E, SubStop, Loop)
            Out[#Out + 1] = {K = "if", Cond = B.Cond, Then = Then, Else = Els}
            Self.Redirect[Shared] = nil
            local SharedNodes = Self:Region(Shared, SubStop, Loop)
            Out[#Out + 1] = {K = "if", Cond = {P = Flag, N = "(not " .. Flag .. ")"}, Then = SharedNodes, Else = {}}

            if M == nil then
                return Out
            end

            Cur = M
            continue
        end

        if M == nil then
            local Then = Self:Region(T, Stop, Loop)

            if RecTerminal(Then) then
                Out[#Out + 1] = {K = "if", Cond = B.Cond, Then = Then, Else = {}}
                Cur = E
                continue
            end

            local Els = Self:Region(E, Stop, Loop)

            if RecTerminal(Els) then
                Out[#Out + 1] = {K = "if", Cond = RecNegate(B.Cond), Then = Els, Else = {}}
                ListExtend(Out, Then)
                return Out
            end

            Out[#Out + 1] = {K = "if", Cond = B.Cond, Then = Then, Else = Els}
            return Out
        end

        local Then = Self:Region(T, M, Loop)
        local Els = Self:Region(E, M, Loop)
        Out[#Out + 1] = {K = "if", Cond = B.Cond, Then = Then, Else = Els}
        Cur = M
    end

    return Out
end

local function RecLines(Nodes, Level)
    local Out = {}

    for Index, Node in ipairs(Nodes) do
        local Last = Index == #Nodes

        if Node.K == "text" then
            Out[#Out + 1] = RecIndent((StartsWith(Node.Text, "(") and ";" or "") .. Node.Text, Level)
        elseif Node.K == "ret" or Node.K == "break" or Node.K == "continue" then
            local Text = Node.K

            if Node.K == "ret" then
                Text = Node.Text
            end

            if Last then
                Out[#Out + 1] = RecIndent(Text, Level)
            else
                Out[#Out + 1] = RecIndent("do " .. Text .. " end", Level)
            end
        elseif Node.K == "if" then
            Out[#Out + 1] = RecIndent("if " .. RecStrip(Node.Cond.P) .. " then", Level)
            ListExtend(Out, RecLines(Node.Then, Level + 1))
            local Els = Node.Else

            while #Els == 1 and Els[1].K == "if" do
                Out[#Out + 1] = RecIndent("elseif " .. RecStrip(Els[1].Cond.P) .. " then", Level)
                ListExtend(Out, RecLines(Els[1].Then, Level + 1))
                Els = Els[1].Else
            end

            if #Els > 0 then
                Out[#Out + 1] = RecIndent("else", Level)
                ListExtend(Out, RecLines(Els, Level + 1))
            end

            Out[#Out + 1] = RecIndent("end", Level)
        elseif Node.K == "loop" then
            local Body = Node.Body

            if Node.Kind ~= "while" then
                Out[#Out + 1] = RecIndent(Node.Header, Level)
                ListExtend(Out, RecLines(Body, Level + 1))
                Out[#Out + 1] = RecIndent("end", Level)
            elseif #Body > 0 and Body[1].K == "if" and #Body[1].Else == 1 and Body[1].Else[1].K == "break" then
                Out[#Out + 1] = RecIndent("while " .. RecStrip(Body[1].Cond.P) .. " do", Level)
                local Merged = ListCopy(Body[1].Then)

                for Offset2 = 2, #Body do
                    Merged[#Merged + 1] = Body[Offset2]
                end

                ListExtend(Out, RecLines(Merged, Level + 1))
                Out[#Out + 1] = RecIndent("end", Level)
            elseif #Body > 0 and Body[1].K == "if" and #Body[1].Then == 1 and Body[1].Then[1].K == "break" then
                Out[#Out + 1] = RecIndent("while " .. RecStrip(Body[1].Cond.N) .. " do", Level)
                local Merged = ListCopy(Body[1].Else)

                for Offset2 = 2, #Body do
                    Merged[#Merged + 1] = Body[Offset2]
                end

                ListExtend(Out, RecLines(Merged, Level + 1))
                Out[#Out + 1] = RecIndent("end", Level)
            elseif #Body > 1 and Body[#Body].K == "if" and #Body[#Body].Else == 0 and #Body[#Body].Then == 1 and Body[#Body].Then[1].K == "break" and not RecContinues({table.unpack(Body, 1, #Body - 1)}) then
                Out[#Out + 1] = RecIndent("repeat", Level)
                ListExtend(Out, RecLines({table.unpack(Body, 1, #Body - 1)}, Level + 1))
                Out[#Out + 1] = RecIndent("until " .. RecStrip(Body[#Body].Cond.P), Level)
            else
                Out[#Out + 1] = RecIndent("while true do", Level)
                ListExtend(Out, RecLines(Body, Level + 1))
                Out[#Out + 1] = RecIndent("end", Level)
            end
        elseif Node.K == "goto" then
            error("unstructured jump", 0)
        end
    end

    return Out
end

local BinSymbols = {ADD = "+", SUB = "-", MUL = "*", DIV = "/", IDIV = "//", MOD = "%", POW = "^", AND = "and", OR = "or"}
local KSymbols = {ADDK = "+", SUBK = "-", MULK = "*", DIVK = "/", IDIVK = "//", MODK = "%", POWK = "^", ANDK = "and", ORK = "or"}
local IgnoredOps = {
    NOP = true, BREAK = true, HINT = true, COVERAGE = true, PREPVARARGS = true, CLOSEUPVALS = true, CAPTURE = true, NATIVECALL = true,
    FASTCALL = true, FASTCALL1 = true, FASTCALL2 = true, FASTCALL2K = true, FASTCALL3 = true,
}

local PureCalls = {type = true, typeof = true, tostring = true, tonumber = true, select = true, rawget = true, rawequal = true, rawlen = true, ipairs = true, pairs = true, next = true, tick = true, time = true}
local PureLibs = {math = true, string = true, bit32 = true, utf8 = true, os = true, Vector3 = true, Vector2 = true, CFrame = true, UDim = true, UDim2 = true, Color3 = true, Rect = true, Ray = true, TweenInfo = true, NumberRange = true, ColorSequence = true, NumberSequence = true}

local function HasRiskyCall(Text, Completed)
    if string.find(Text, "[%)%]]%(") then
        return true
    end

    for Callee in string.gmatch(Text, Completed and "([%w_][%w_%.:]*)%b()" or "([%w_][%w_%.:]*)%(") do
        local Root = string.match(Callee, "^([%w_]+)%.[%w_]+$")

        if not (PureCalls[Callee] or (Root and PureLibs[Root])) then
            return true
        end
    end

    return false
end

local function LineWrites(Text, Name)
    local Lhs = string.match(Text, "^ *local +([^=(){}\"']-) *=[^=]") or string.match(Text, "^ *([^=(){}\"']-) *=[^=]") or string.match(Text, "^ *for +(.-) +in ") or string.match(Text, "^ *for +([%w_]+) *=")

    if Lhs then
        for Target in string.gmatch(Lhs, "[^,]+") do
            if string.gsub(string.match(Target, "^%s*(.-)%s*$"), "[%s%+%-%*/%%%^%.]+$", "") == Name then
                return true
            end
        end
    end

    return string.find(Text, "%f[%w_\128-\255]" .. Name .. "%s*[%+%-%*/%.]*=[^=]") ~= nil
end

local function BuildWordRows(Body)
    local WordRows = {}
    local RowWords = {}

    for Row = 1, #Body do
        local Words = {}

        if string.find(Body[Row], "[vV]%d") then
            for Word in string.gmatch(Body[Row], "%f[%w_\128-\255][vV]%d[%w_\128-\255]*") do
                if not WordRows[Word] then
                    WordRows[Word] = {}
                end

                if not WordRows[Word][Row] then
                    WordRows[Word][Row] = true
                    Words[#Words + 1] = Word
                end
            end
        end

        RowWords[Row] = Words
    end

    return WordRows, RowWords
end

local function ReindexRow(WordRows, RowWords, Body, Row)
    for _, Word in ipairs(RowWords[Row]) do
        WordRows[Word][Row] = nil
    end

    local Words = {}

    for Word in string.gmatch(Body[Row], "%f[%w_\128-\255][vV]%d[%w_\128-\255]*") do
        if not WordRows[Word] then
            WordRows[Word] = {}
        end

        if not WordRows[Word][Row] then
            WordRows[Word][Row] = true
            Words[#Words + 1] = Word
        end
    end

    RowWords[Row] = Words
end

local function RowsOf(Set)
    local Rows = {}

    if Set then
        for Row in pairs(Set) do
            Rows[#Rows + 1] = Row
        end

        table.sort(Rows)
    end

    return Rows
end

local function RecFunctionText(Module, Data, UpNames, Depth)
    local Error = nil
    local Result = nil

    for _, Lowered in ipairs({false, true}) do
        local Ok, Value = pcall(function()
            local Proto = Data.RawProto
            local Ins = Data.Instructions
            local Suffix = Depth == 0 and "" or "_" .. tostring(Depth)
            local Used = {}
            local PosOf = {}

            for Index = 1, #Ins do
                PosOf[Ins[Index].Pc - 1] = Index - 1
            end

            local Code = {}
            local Pend = nil
            local MethodAt = {}
            local PinRanges = {}
            local Closes = {}
            local RefCaps = {}
            local LoopMoves = {}

            local function Name(Reg)
                Used[Reg] = true

                return "v" .. tostring(Reg) .. Suffix
            end

            local function UpName(Index)
                return UpNames[Index + 1] or "up" .. tostring(Index)
            end

            for Pos = 0, #Ins - 1 do
                local I = Ins[Pos + 1]
                local Op = I.Name
                local A = I.A
                local B = I.B
                local C = I.C
                local D = I.SBx
                local Aux = I.Aux or 0
                local Idx = I.Pc - 1
                local S = {Pos = Pos, Kind = "Nop", Dst = EmptyList, Ops = EmptyList, Parts = EmptyList, Eff = 0}
                Code[Pos + 1] = S

                if Op == "CLOSEUPVALS" then
                    Closes[#Closes + 1] = {Pos, A}
                end

                local Symbol = BinSymbols[Op]
                local KSymbol = KSymbols[Op]

                if Op == "LOADNIL" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {"nil"}
                elseif Op == "LOADB" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {B ~= 0 and "true" or "false"}

                    if C ~= 0 then
                        S.Jump = Lookup(PosOf, Idx + 1 + C)
                    end
                elseif Op == "LOADN" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {RecConst({Type = 2, Value = D})}
                elseif Op == "LOADK" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {RecConst(Proto.KTable[I.Bx + 1])}
                elseif Op == "LOADKX" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {RecConst(Proto.KTable[Aux + 1])}
                elseif Op == "MOVE" then
                    if not LoopMoves[Pos] then
                        S.Kind = "Def"
                        S.Dst = {A}
                        S.Ops = {B}
                        S.Parts = {1}
                    end
                elseif Op == "GETGLOBAL" then
                    local Key = Proto.KTable[Aux + 1].Value
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {RecIdent(Key) and Key or "_G" .. RecField(Key)}
                    S.Eff = 1
                elseif Op == "SETGLOBAL" then
                    local Key = Proto.KTable[Aux + 1].Value
                    S.Kind = "Store"
                    S.Ops = {A}
                    S.Parts = {RecIdent(Key) and Key or "_G" .. RecField(Key), " = ", 1}
                    S.Eff = 2
                    S.Full = true
                elseif Op == "GETUPVAL" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {UpName(B)}
                    S.Eff = 1
                elseif Op == "SETUPVAL" then
                    S.Kind = "Store"
                    S.Ops = {A}
                    S.Parts = {UpName(B), " = ", 1}
                    S.Eff = 2
                    S.Full = true
                elseif Op == "GETIMPORT" then
                    local Id = Proto.KTable[I.Bx + 1].Value
                    local Keys = {}
                    local Shifts = {20, 10, 0}

                    for Index = 1, bit32.rshift(Id, 30) do
                        Keys[Index] = Proto.KTable[bit32.band(bit32.rshift(Id, Shifts[Index]), 1023) + 1].Value
                    end

                    local Text = RecIdent(Keys[1]) and Keys[1] or "_G" .. RecField(Keys[1])

                    for Index = 2, #Keys do
                        Text = Text .. RecField(Keys[Index])
                    end

                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {Text}
                elseif Op == "GETTABLE" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B, C}
                    S.Parts = {{"b", 1}, "[", 2, "]"}
                    S.Eff = 1
                elseif Op == "SETTABLE" then
                    S.Kind = "Store"
                    S.Ops = {B, C, A}
                    S.Parts = {{"b", 1}, "[", 2, "] = ", 3}
                    S.Eff = 2
                    S.Full = true
                    S.Elem = {{"d", 2, 3}}
                elseif Op == "GETTABLEKS" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {{"b", 1}, RecField(Proto.KTable[Aux + 1].Value)}
                    S.Eff = 1
                elseif Op == "SETTABLEKS" then
                    S.Kind = "Store"
                    S.Ops = {B, A}
                    S.Parts = {{"b", 1}, RecField(Proto.KTable[Aux + 1].Value), " = ", 2}
                    S.Eff = 2
                    S.Full = true
                    S.Elem = {{"s", Proto.KTable[Aux + 1].Value, 2}}
                elseif Op == "GETTABLEN" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {{"b", 1}, string.format("[%d]", C + 1)}
                    S.Eff = 1
                elseif Op == "SETTABLEN" then
                    S.Kind = "Store"
                    S.Ops = {B, A}
                    S.Parts = {{"b", 1}, string.format("[%d] = ", C + 1), 2}
                    S.Eff = 2
                    S.Full = true
                    S.Elem = {{"i", C + 1, 2}}
                elseif Op == "NEWCLOSURE" or Op == "DUPCLOSURE" then
                    local Child = nil

                    if Op == "NEWCLOSURE" then
                        Child = Module.Protos[Proto.PTable[I.Bx + 1].ProtoIndex + 1]
                    else
                        Child = Module.Protos[Proto.KTable[I.Bx + 1].Value + 1]
                    end

                    local Caps = {}

                    for X = 0, Child.RawProto.NumUpvalues - 1 do
                        Caps[X + 1] = {Ins[Pos + 2 + X].A, Ins[Pos + 2 + X].B}
                    end

                    S.Kind = "Closure"
                    S.Dst = {A}
                    S.Child = Child
                    S.Caps = Caps
                    S.Copies = {}
                    S.ChildUp = {Ref = {}}
                    S.Ops = {}
                elseif Op == "NAMECALL" then
                    MethodAt[A] = Proto.KTable[Aux + 1].Value
                    S.Kind = "Def"
                    S.Dst = {A + 1}
                    S.Ops = {B}
                    S.Parts = {1}
                elseif Op == "CALL" then
                    local Args = {}

                    if B == 0 then
                        for Reg = A + 1, Pend[2] - 1 do
                            Args[#Args + 1] = Reg
                        end

                        Args[#Args + 1] = Pend[1]
                    else
                        for Reg = A + 1, A + B - 1 do
                            Args[#Args + 1] = Reg
                        end
                    end

                    Pend = nil
                    local Method = MethodAt[A]
                    MethodAt[A] = nil
                    local Ops = nil
                    local Parts = nil
                    local First = 2

                    if Method == nil then
                        Ops = {A}
                        ListExtend(Ops, Args)
                        Parts = {{"b", 1}, "("}
                    elseif RecIdent(Method) then
                        Ops = Args
                        Parts = {{"b", 1}, ":" .. Method .. "("}
                    else
                        Ops = Args
                        Parts = {{"b", 1}, "[" .. RecConst({Type = 3, Value = Method}) .. "](", 1, ", "}
                    end

                    for Index = First, #Ops do
                        if Index > First then
                            Parts[#Parts + 1] = ", "
                        end

                        Parts[#Parts + 1] = Index
                    end

                    Parts[#Parts + 1] = ")"
                    S.Kind = "Call"
                    S.Ops = Ops
                    S.Parts = Parts
                    S.Eff = 2
                    S.Last = #Ops >= First and #Ops or nil

                    if C == 0 then
                        S.Dst = {1000 + Pos}
                        Pend = {1000 + Pos, A}
                    elseif C >= 2 then
                        S.Dst = {}

                        for Reg = A, A + C - 2 do
                            S.Dst[#S.Dst + 1] = Reg
                        end

                        S.CallLike = C == 2
                    end
                elseif Op == "RETURN" then
                    local Ops = {}

                    if B == 0 then
                        for Reg = A, Pend[2] - 1 do
                            Ops[#Ops + 1] = Reg
                        end

                        Ops[#Ops + 1] = Pend[1]
                    elseif B ~= 1 then
                        for Reg = A, A + B - 2 do
                            Ops[#Ops + 1] = Reg
                        end
                    end

                    Pend = nil
                    local Parts = {#Ops > 0 and "return " or "return"}

                    for Index = 1, #Ops do
                        if Index == 1 then
                            Parts[#Parts + 1] = 1
                        else
                            Parts[#Parts + 1] = ", "
                            Parts[#Parts + 1] = Index
                        end
                    end

                    S.Kind = "Ret"
                    S.Ops = Ops
                    S.Parts = Parts
                    S.Full = true
                    S.Last = #Ops > 0 and #Ops or nil
                elseif Op == "JUMP" or Op == "JUMPBACK" then
                    S.Kind = "Jump"
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)
                elseif Op == "JUMPX" then
                    local Offset3 = bit32.rshift(Proto.CodeTable[I.Pc], 8)

                    if Offset3 >= 0x800000 then
                        Offset3 = Offset3 - 0x1000000
                    end

                    S.Kind = "Jump"
                    S.Tgt = Lookup(PosOf, Idx + 1 + Offset3)
                elseif Op == "JUMPIF" or Op == "JUMPIFNOT" then
                    S.Kind = "CJump"
                    S.Ops = {A}
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)
                    S.PParts = Op == "JUMPIF" and {1} or {"(not ", 1, ")"}
                    S.NParts = Op == "JUMPIF" and {"(not ", 1, ")"} or {1}
                elseif Op == "JUMPIFEQ" or Op == "JUMPIFNOTEQ" or Op == "JUMPIFLE" or Op == "JUMPIFLT" or Op == "JUMPIFNOTLE" or Op == "JUMPIFNOTLT" then
                    local HasEq = string.find(Op, "EQ", 1, true) ~= nil
                    local HasNot = string.find(Op, "NOT", 1, true) ~= nil
                    local Sym = HasEq and "==" or string.find(Op, "LE", 1, true) and "<=" or "<"
                    local PosParts = {"(", 1, " " .. Sym .. " ", 2, ")"}
                    local NegParts = nil

                    if HasEq then
                        NegParts = {"(", 1, " ~= ", 2, ")"}
                    else
                        NegParts = {"(not (", 1, " " .. Sym .. " ", 2, "))"}
                    end

                    if HasEq and HasNot then
                        PosParts = {"(", 1, " ~= ", 2, ")"}
                        NegParts = {"(", 1, " == ", 2, ")"}
                    end

                    local Swap = HasNot and not HasEq

                    S.Kind = "CJump"
                    S.Ops = {A, Aux}
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)
                    S.PParts = Swap and NegParts or PosParts
                    S.NParts = Swap and PosParts or NegParts
                elseif Op == "JUMPXEQKNIL" or Op == "JUMPXEQKB" or Op == "JUMPXEQKN" or Op == "JUMPXEQKS" then
                    local Const = nil

                    if Op == "JUMPXEQKNIL" then
                        Const = "nil"
                    elseif Op == "JUMPXEQKB" then
                        Const = bit32.band(Aux, 1) ~= 0 and "true" or "false"
                    else
                        Const = RecConst(Proto.KTable[bit32.band(Aux, 0xFFFFFF) + 1])
                    end

                    local Eq = {"(", 1, " == " .. Const .. ")"}
                    local Ne = {"(", 1, " ~= " .. Const .. ")"}
                    local Inverted = bit32.band(bit32.rshift(Aux, 31), 1) ~= 0

                    S.Kind = "CJump"
                    S.Ops = {A}
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)
                    S.PParts = Inverted and Ne or Eq
                    S.NParts = Inverted and Eq or Ne
                elseif Symbol then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B, C}
                    S.Parts = {"(", 1, " " .. Symbol .. " ", 2, ")"}
                elseif KSymbol then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {"(", 1, " " .. KSymbol .. " " .. RecConst(Proto.KTable[C + 1]) .. ")"}
                elseif Op == "SUBRK" or Op == "DIVRK" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {C}
                    S.Parts = {"(" .. RecConst(Proto.KTable[B + 1]) .. (Op == "SUBRK" and " - " or " / "), 1, ")"}
                elseif Op == "CONCAT" then
                    local Parts = {"("}
                    local Ops = {}

                    for Index = 1, C - B + 1 do
                        if Index > 1 then
                            Parts[#Parts + 1] = " .. "
                        end

                        Parts[#Parts + 1] = Index
                    end

                    for Reg = B, C do
                        Ops[#Ops + 1] = Reg
                    end

                    Parts[#Parts + 1] = ")"
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = Ops
                    S.Parts = Parts
                elseif Op == "NOT" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {"(not ", 1, ")"}
                elseif Op == "MINUS" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {"(-", 1, ")"}
                elseif Op == "LENGTH" then
                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Ops = {B}
                    S.Parts = {"(#", 1, ")"}
                elseif Op == "NEWTABLE" or Op == "DUPTABLE" then
                    local Shape = nil
                    local Tpl = nil

                    if Op == "NEWTABLE" then
                        Shape = {B ~= 0 and 2 ^ (B - 1) or 0, Aux}
                    else
                        local Template = Proto.KTable[I.Bx + 1].Value
                        Shape = {Template.Size, 0}

                        if Template.Values ~= nil then
                            local AnyConst = false

                            for _, V in ipairs(Template.Values) do
                                if V >= 0 then
                                    AnyConst = true
                                    break
                                end
                            end

                            if AnyConst then
                                Tpl = {}

                                for Index = 1, math.min(#Template.Ids, #Template.Values) do
                                    local ValueId = Template.Values[Index]
                                    local KeyText = Lookup(Proto.KTable, Template.Ids[Index]).Value
                                    local ValText = nil

                                    if ValueId >= 0 then
                                        ValText = RecConst(Lookup(Proto.KTable, ValueId + 1))
                                    end

                                    Tpl[Index] = {Key = KeyText, Val = ValText}
                                end
                            end
                        end
                    end

                    S.Kind = "Def"
                    S.Dst = {A}
                    S.Parts = {"{}"}
                    S.NoFold = true
                    S.Tab = Shape
                    S.Tpl = Tpl
                elseif Op == "SETLIST" then
                    local Fixed = {}
                    local Ops = {A}

                    if C == 0 then
                        for Reg = B, Pend[2] - 1 do
                            Fixed[#Fixed + 1] = Reg
                        end

                        ListExtend(Ops, Fixed)
                        Ops[#Ops + 1] = Pend[1]
                    else
                        for Reg = B, B + C - 2 do
                            Fixed[#Fixed + 1] = Reg
                        end

                        ListExtend(Ops, Fixed)
                    end

                    Pend = nil
                    local Parts = {}

                    for Index = 0, #Fixed - 1 do
                        ListExtend(Parts, {{"b", 1}, string.format("[%d] = ", Aux + Index), Index + 2, "\n"})
                    end

                    if C == 0 then
                        ListExtend(Parts, {"do local p = table.pack(", #Ops, string.format(") table.move(p, 1, p.n, %d, ", Aux + #Fixed), {"b", 1}, ") end"})
                    elseif #Parts > 0 then
                        table.remove(Parts)
                    end

                    local Elem = {}

                    for Index = 0, #Fixed - 1 do
                        Elem[#Elem + 1] = {"l", Aux + Index, Index + 2}
                    end

                    if C == 0 then
                        Elem[#Elem + 1] = {"m", Aux + #Fixed, #Ops}
                    end

                    S.Kind = "Store"
                    S.Ops = Ops
                    S.Parts = Parts
                    S.Eff = 2
                    S.Full = true
                    S.NoFold = true
                    S.Elem = Elem
                elseif Op == "GETVARARGS" then
                    if B == 0 then
                        S.Kind = "Def"
                        S.Dst = {1000 + Pos}
                        S.Parts = {"..."}
                        Pend = {1000 + Pos, A}
                    elseif B == 2 then
                        S.Kind = "Def"
                        S.Dst = {A}
                        S.Parts = {"..."}
                        S.CallLike = true
                    elseif B > 2 then
                        local Dst = {}

                        for Reg = A, A + B - 2 do
                            Dst[#Dst + 1] = Reg
                        end

                        S.Kind = "Call"
                        S.Dst = Dst
                        S.Parts = {"..."}
                    end
                elseif Op == "FORNPREP" then
                    local Exit = Lookup(PosOf, Idx + 1 + D)

                    if Lowered then
                        local Enter = string.format("((%s > 0 and %s <= %s) or (not (%s > 0) and %s <= %s))", Name(A + 1), Name(A + 2), Name(A), Name(A + 1), Name(A), Name(A + 2))
                        S.Kind = "CJump"
                        S.Tgt = Exit
                        S.PParts = {"(not " .. Enter .. ")"}
                        S.NParts = {Enter}
                        S.Pre = {Name(A + 3) .. " = " .. Name(A + 2)}
                        S.Dst = {A + 3}
                        S.Pin = {A, A + 1, A + 2}
                    else
                        local Moved = Ins[Pos + 2].Name == "MOVE" and Ins[Pos + 2].A == A + 3 and Ins[Pos + 2].B == A + 2
                        local Var = Moved and A + 3 or A + 2

                        if Moved then
                            LoopMoves[Pos + 1] = true
                        end

                        S.Kind = "ForN"
                        S.Ops = {A + 2, A, A + 1}
                        S.Dst = {Var}
                        S.Parts = {"for " .. Name(Var) .. " = ", 1, ", ", 2, ", ", 3, " do"}
                        S.Full = true
                        S.Exit = Exit
                        S.End = Exit - 1
                    end
                elseif Op == "FORNLOOP" then
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)

                    if Lowered then
                        local Enter = string.format("((%s > 0 and %s <= %s) or (not (%s > 0) and %s <= %s))", Name(A + 1), Name(A + 2), Name(A), Name(A + 1), Name(A), Name(A + 2))
                        S.Kind = "CJump"
                        S.PParts = {Enter}
                        S.NParts = {"(not " .. Enter .. ")"}
                        S.Pre = {Name(A + 2) .. " = " .. Name(A + 2) .. " + " .. Name(A + 1), Name(A + 3) .. " = " .. Name(A + 2)}
                        S.Dst = {A + 2, A + 3}
                        S.Pin = {A, A + 1, A + 2}
                    else
                        S.Kind = "ForNLoop"
                    end
                elseif Op == "FORGPREP" or Op == "FORGPREP_INEXT" or Op == "FORGPREP_NEXT" then
                    local Q = Lookup(PosOf, Idx + 1 + D)
                    local Count = bit32.band(Ins[Q + 1].Aux, 0xFF)
                    local Vars = {}

                    for Reg = A + 3, A + 2 + Count do
                        Vars[#Vars + 1] = Reg
                    end

                    if Lowered then
                        local Pre = string.format("if type(%s) ~= \"function\" then\n    local m = getmetatable(%s)\n    if type(m) == \"table\" and m.__iter then\n        %s, %s, %s = m.__iter(%s)\n    else\n        %s, %s, %s = next, %s, nil\n    end\nend", Name(A), Name(A), Name(A), Name(A + 1), Name(A + 2), Name(A), Name(A), Name(A + 1), Name(A + 2), Name(A))
                        S.Kind = "Jump"
                        S.Tgt = Q
                        S.Pre = {Pre}
                        S.Pin = {A, A + 1, A + 2}
                    else
                        local VarNames = {}

                        for _, R in ipairs(Vars) do
                            VarNames[#VarNames + 1] = Name(R)
                        end

                        S.Kind = "ForG"
                        S.Ops = {A, A + 1, A + 2}
                        S.Dst = Vars
                        S.Parts = {"for " .. table.concat(VarNames, ", ") .. " in ", 1, ", ", 2, ", ", 3, " do"}
                        S.Full = true
                        S.Exit = Q + 1
                        S.End = Q
                    end
                elseif Op == "FORGLOOP" then
                    S.Tgt = Lookup(PosOf, Idx + 1 + D)
                    local Count = bit32.band(Aux, 0xFF)
                    local Vars = {}

                    for Reg = A + 3, A + 2 + Count do
                        Vars[#Vars + 1] = Reg
                    end

                    if Lowered then
                        local VarNames = {}

                        for _, R in ipairs(Vars) do
                            VarNames[#VarNames + 1] = Name(R)
                        end

                        local Dst = ListCopy(Vars)
                        Dst[#Dst + 1] = A + 2
                        S.Kind = "CJump"
                        S.PParts = {"(" .. Name(A + 3) .. " ~= nil)"}
                        S.NParts = {"(" .. Name(A + 3) .. " == nil)"}
                        S.Pre = {table.concat(VarNames, ", ") .. " = " .. Name(A) .. "(" .. Name(A + 1) .. ", " .. Name(A + 2) .. ")", "if " .. Name(A + 3) .. " ~= nil then " .. Name(A + 2) .. " = " .. Name(A + 3) .. " end"}
                        S.Dst = Dst
                        S.Pin = {A, A + 1, A + 2}
                    else
                        S.Kind = "ForGLoop"
                    end
                elseif not IgnoredOps[Op] then
                    return "unsupported opcode " .. Op .. " (" .. tostring(OpcodeKey(Proto.CodeTable[I.Pc])) .. ")"
                end
            end

            local MoveList = {}

            for MovePos in pairs(LoopMoves) do
                MoveList[#MoveList + 1] = MovePos
            end

            table.sort(MoveList)

            for _, MovePos in ipairs(MoveList) do
                local Loop = Code[MovePos]
                local Var = Loop.Dst[1]
                local Found = false

                for Position = MovePos + 2, Loop.End do
                    if ListHas(Code[Position].Ops, Var - 1) then
                        Found = true
                        break
                    end
                end

                if Found then
                    LoopMoves[MovePos] = nil
                    Update(Loop, {Dst = {Var - 1}, Parts = {"for " .. Name(Var - 1) .. " = ", 1, ", ", 2, ", ", 3, " do"}})
                    Update(Code[MovePos + 1], {Kind = "Def", Dst = {Var}, Ops = {Var - 1}, Parts = {1}})
                end
            end

            local Writes = {}

            for _, S in ipairs(Code) do
                for _, R in ipairs(S.Dst) do
                    if not Writes[R] then
                        Writes[R] = {}
                    end

                    table.insert(Writes[R], S.Pos)
                end

                for _, R in ipairs(S.Pin or {}) do
                    if not PinRanges[R] then
                        PinRanges[R] = {}
                    end

                    table.insert(PinRanges[R], {0, #Code})
                end
            end

            local Loops = {}
            local ForVars = {}

            for _, S in ipairs(Code) do
                if (S.Kind == "Jump" or S.Kind == "CJump" or S.Kind == "ForNLoop" or S.Kind == "ForGLoop") and S.Tgt ~= nil and S.Tgt <= S.Pos then
                    Loops[#Loops + 1] = {S.Tgt, S.Pos}
                end

                if S.Kind == "ForN" or S.Kind == "ForG" then
                    ForVars[#ForVars + 1] = {SetFrom(S.Dst), S.Pos + 1, S.End}
                end
            end

            for _, S in ipairs(Code) do
                if S.Kind == "Closure" then
                    for K, Cap in ipairs(S.Caps) do
                        local Type = Cap[1]
                        local Index = Cap[2]

                        if Type == 2 then
                            S.ChildUp[#S.ChildUp + 1] = UpName(Index)

                            if UpNames.Ref and UpNames.Ref[UpName(Index)] then
                                S.ChildUp.Ref[UpName(Index)] = true
                            end
                        elseif Type == 1 then
                            RefCaps[#RefCaps + 1] = {S, Index, true}
                            S.ChildUp[#S.ChildUp + 1] = Name(Index)
                            S.ChildUp.Ref[Name(Index)] = true
                        else
                            local Ws = Writes[Index] or {}
                            local Stable = false

                            for _, FV in ipairs(ForVars) do
                                if FV[1][Index] and FV[2] <= S.Pos and S.Pos <= FV[3] then
                                    local Later = false

                                    for _, W in ipairs(Ws) do
                                        if S.Pos < W and W <= FV[3] then
                                            Later = true
                                            break
                                        end
                                    end

                                    if not Later then
                                        Stable = true
                                        break
                                    end
                                end
                            end

                            if not Stable then
                                Stable = true

                                for _, W in ipairs(Ws) do
                                    local InLoop = false

                                    for _, L in ipairs(Loops) do
                                        if L[1] <= W and W <= L[2] then
                                            InLoop = true
                                            break
                                        end
                                    end

                                    if not (W <= S.Pos and not InLoop) then
                                        Stable = false
                                        break
                                    end
                                end
                            end

                            if Stable then
                                RefCaps[#RefCaps + 1] = {S, Index, false}
                                S.ChildUp[#S.ChildUp + 1] = Name(Index)
                            else
                                local Alias = string.format("c%d_%d_%d", Depth, S.Pos, K - 1)
                                S.Copies[#S.Copies + 1] = {Alias, #S.Ops + 1}
                                S.Ops[#S.Ops + 1] = Index
                                S.ChildUp[#S.ChildUp + 1] = Alias
                            end
                        end
                    end

                    if #S.Copies > 0 then
                        S.NoFold = true
                        S.Full = true
                    end
                end
            end

            local Leaders = {[0] = true}

            for _, S in ipairs(Code) do
                if S.Kind == "Jump" or S.Kind == "CJump" then
                    Leaders[S.Tgt] = true
                    Leaders[S.Pos + 1] = true
                elseif S.Kind == "Def" and S.Jump ~= nil then
                    Leaders[S.Jump] = true
                    Leaders[S.Pos + 1] = true
                elseif S.Kind == "Ret" or S.Kind == "ForNLoop" or S.Kind == "ForGLoop" then
                    Leaders[S.Pos + 1] = true
                elseif S.Kind == "ForN" then
                    Leaders[S.Pos + 1] = true
                    Leaders[S.Exit] = true
                elseif S.Kind == "ForG" then
                    Leaders[S.Pos + 1] = true
                    Leaders[S.Exit] = true
                    Leaders[S.End] = true
                end
            end

            local Starts = {}

            for X in pairs(Leaders) do
                if X < #Code then
                    Starts[#Starts + 1] = X
                end
            end

            table.sort(Starts)

            local Blocks = {}
            local Seqs = {}

            for BI = 1, #Starts do
                local Start = Starts[BI]
                local End = Starts[BI + 1] or #Code
                local B = {Id = Start + 1, Stmts = {}, Kind = "goto", Succ = {}, Cond = nil, Values = nil, Preds = {}, Info = nil}
                Blocks[B.Id] = B
                local Last = Code[End]
                local Seq = {}

                for Position = Start + 1, End do
                    local S = Code[Position]

                    if S.Kind ~= "Nop" and S.Kind ~= "ForNLoop" and S.Kind ~= "ForGLoop" then
                        Seq[#Seq + 1] = S
                    end
                end

                Seqs[B.Id] = Seq

                if Last.Kind == "Jump" then
                    B.Succ = {Last.Tgt + 1}
                elseif Last.Kind == "CJump" then
                    B.Kind = "cond"
                    B.Succ = {Last.Tgt + 1, Last.Pos + 2}
                elseif Last.Kind == "Def" and Last.Jump ~= nil then
                    B.Succ = {Last.Jump + 1}
                elseif Last.Kind == "Ret" then
                    B.Kind = "ret"
                elseif Last.Kind == "ForN" then
                    B.Kind = "for"
                    B.Succ = {Last.Pos + 2, Last.Exit + 1}
                elseif Last.Kind == "ForG" then
                    B.Kind = "forin"
                    B.Succ = {Last.Pos + 2, Last.Exit + 1}
                elseif Last.Kind == "ForNLoop" or Last.Kind == "ForGLoop" then
                    local Best = nil

                    for _, X in ipairs(Starts) do
                        if X < Last.Tgt and (Best == nil or X > Best) then
                            Best = X
                        end
                    end

                    B.Succ = {Best + 1}
                elseif End < #Code then
                    B.Succ = {End + 1}
                else
                    B.Kind = "end"
                end
            end

            local BlockOf = {}
            local BlockPreds = {}

            for Bid, Seq in pairs(Seqs) do
                BlockPreds[Bid] = {}

                for _, S in ipairs(Seq) do
                    BlockOf[S.Pos] = Bid
                end
            end

            for _, Bid in ipairs(SortedIds(Blocks)) do
                for _, X in ipairs(Blocks[Bid].Succ) do
                    if BlockPreds[X] then
                        table.insert(BlockPreds[X], Bid)
                    end
                end
            end

            for _, Ref in ipairs(RefCaps) do
                local S = Ref[1]
                local Index = Ref[2]
                local ByRef = Ref[3]
                local Home = BlockOf[S.Pos]
                local HomeSeq = Seqs[Home]
                local Where = 0

                for Position = 1, #HomeSeq do
                    if HomeSeq[Position] == S then
                        Where = Position
                        break
                    end
                end

                local Found = {}

                for Position = Where - 1, 1, -1 do
                    if ListHas(HomeSeq[Position].Dst, Index) then
                        Found[1] = HomeSeq[Position].Pos
                        break
                    end
                end

                local Stack = {}

                if #Found == 0 then
                    Stack = ListCopy(BlockPreds[Home])
                end

                local Seen = {}
                local SeenAny = false
                local FromEntry = false

                while #Stack > 0 do
                    local X = table.remove(Stack)

                    if not Seen[X] then
                        Seen[X] = true
                        SeenAny = true
                        local Hit = nil

                        for Position = #Seqs[X], 1, -1 do
                            if ListHas(Seqs[X][Position].Dst, Index) then
                                Hit = Seqs[X][Position].Pos
                                break
                            end
                        end

                        if Hit ~= nil then
                            Found[#Found + 1] = Hit
                        else
                            ListExtend(Stack, BlockPreds[X])
                            FromEntry = FromEntry or X == 1
                        end
                    end
                end

                if #Found == 0 and not SeenAny then
                    FromEntry = true
                end

                local NextClose = nil

                if ByRef then
                    NextClose = #Code

                    for _, Close in ipairs(Closes) do
                        if Close[1] > S.Pos and Close[2] <= Index and Close[1] < NextClose then
                            NextClose = Close[1]
                        end
                    end
                else
                    NextClose = S.Pos
                end

                local MinFound = nil
                local MaxFound = NextClose

                for _, F in ipairs(Found) do
                    if MinFound == nil or F < MinFound then
                        MinFound = F
                    end

                    if F > MaxFound then
                        MaxFound = F
                    end
                end

                if not PinRanges[Index] then
                    PinRanges[Index] = {}
                end

                table.insert(PinRanges[Index], {(FromEntry or #Found == 0) and 0 or MinFound, MaxFound})
            end

            local LiveIn = {}

            for Bid in pairs(Blocks) do
                LiveIn[Bid] = {}
            end

            local Changed = true
            local LiveIds = SortedIds(Blocks)

            while Changed do
                Changed = false

                for Position = #LiveIds, 1, -1 do
                    local Bid = LiveIds[Position]
                    local Live = {}

                    for _, X in ipairs(Blocks[Bid].Succ) do
                        if LiveIn[X] then
                            for R in pairs(LiveIn[X]) do
                                Live[R] = true
                            end
                        end
                    end

                    local Seq = Seqs[Bid]

                    for SIndex = #Seq, 1, -1 do
                        local S = Seq[SIndex]

                        for _, R in ipairs(S.Dst) do
                            Live[R] = nil
                        end

                        for _, R in ipairs(S.Ops) do
                            Live[R] = true
                        end
                    end

                    if not SetEqual(Live, LiveIn[Bid]) then
                        LiveIn[Bid] = Live
                        Changed = true
                    end
                end
            end

            local LiveAfter = {}

            for _, Bid in ipairs(SortedIds(Blocks)) do
                local Live = {}

                for _, X in ipairs(Blocks[Bid].Succ) do
                    if LiveIn[X] then
                        for R in pairs(LiveIn[X]) do
                            Live[R] = true
                        end
                    end
                end

                local Seq = Seqs[Bid]

                for SIndex = #Seq, 1, -1 do
                    local S = Seq[SIndex]
                    LiveAfter[S.Pos] = Live
                    local NewLive = {}

                    for R in pairs(Live) do
                        NewLive[R] = true
                    end

                    for _, R in ipairs(S.Dst) do
                        NewLive[R] = nil
                    end

                    for _, R in ipairs(S.Ops) do
                        NewLive[R] = true
                    end

                    Live = NewLive
                end
            end

            local SelfVal = {}

            local function FlatCount(Seq, Slots, Index, Reg, Lead)
                local Count = 0
                local First = 0

                for OpIndex, Op in ipairs(Seq[Index].Ops) do
                    local Inner = Slots[Index * 1024 + OpIndex]
                    local Here = OpIndex == 1 and (Lead or Seq[Index].Kind == "Call")

                    if Inner == nil then
                        if Op == Reg then
                            Count += 1

                            if Here then
                                First += 1
                            end
                        end
                    else
                        local InnerCount, InnerFirst = FlatCount(Seq, Slots, Inner, Reg, Here)
                        Count += InnerCount
                        First += InnerFirst
                    end
                end

                return Count, First
            end

            local function Flat(Seq, Slots, Index)
                local Out = {}

                for OpIndex, Reg in ipairs(Seq[Index].Ops) do
                    local Inner = Slots[Index * 1024 + OpIndex]

                    if Inner == nil then
                        Out[#Out + 1] = Reg
                    else
                        ListExtend(Out, Flat(Seq, Slots, Inner))
                    end
                end

                return Out
            end

            local function EffOf(Seq, Slots, Index)
                local Level = Seq[Index].Eff

                for OpIndex, Reg in ipairs(Seq[Index].Ops) do
                    local Inner = Slots[Index * 1024 + OpIndex]

                    if Inner == nil then
                        local Pinned = 0

                        for _, Range in ipairs(PinRanges[Reg] or {}) do
                            if Range[1] <= Seq[Index].Pos and Seq[Index].Pos <= Range[2] then
                                Pinned = 1
                                break
                            end
                        end

                        Level = math.max(Level, Pinned)
                    else
                        Level = math.max(Level, EffOf(Seq, Slots, Inner))
                    end
                end

                return Level
            end

            local function Order(Seq, Slots, Index)
                local Out = {}

                for OpIndex = 1, #Seq[Index].Ops do
                    local Inner = Slots[Index * 1024 + OpIndex]

                    if Inner ~= nil then
                        ListExtend(Out, Order(Seq, Slots, Inner))
                    end
                end

                Out[#Out + 1] = Index

                return Out
            end

            local function FindSlot(Seq, Slots, Index, Reg)
                for OpIndex, Op in ipairs(Seq[Index].Ops) do
                    local Inner = Slots[Index * 1024 + OpIndex]

                    if Inner == nil then
                        if Op == Reg then
                            return Index * 1024 + OpIndex
                        end
                    else
                        local Found = FindSlot(Seq, Slots, Inner, Reg)

                        if Found then
                            return Found
                        end
                    end
                end

                return nil
            end

            local Render = nil

            local function OpTexts(Seq, Slots, Index)
                local S = Seq[Index]
                local Texts = {}

                for OpIndex, Reg in ipairs(S.Ops) do
                    local Inner = Slots[Index * 1024 + OpIndex]

                    if Inner == nil then
                        Texts[OpIndex] = Name(Reg)
                    else
                        local Text = Render(Seq, Slots, Inner)

                        if Seq[Inner].CallLike and S.Last == OpIndex then
                            Text = "(" .. Text .. ")"
                        end

                        Texts[OpIndex] = Text
                    end
                end

                return Texts
            end

            Render = function(Seq, Slots, Index)
                local S = Seq[Index]
                local Texts = OpTexts(Seq, Slots, Index)

                if S.Kind == "CJump" then
                    S.NText = RecFormat(S.NParts, Texts)

                    return RecFormat(S.PParts, Texts)
                end

                if S.Kind == "Closure" then
                    if #S.Copies == 0 then
                        return RecFunctionText(Module, S.Child, S.ChildUp, Depth + 1)
                    end

                    local Up = {Ref = S.ChildUp.Ref}
                    local Lines = {}

                    for K, Alias in ipairs(S.ChildUp) do
                        Up[K] = Alias
                    end

                    for _, Copy in ipairs(S.Copies) do
                        if S.Ops[Copy[2]] == S.Dst[1] then
                            SelfVal[Name(S.Dst[1])] = true

                            for K, Alias in ipairs(Up) do
                                if Alias == Copy[1] then
                                    Up[K] = Name(S.Dst[1])
                                end
                            end
                        else
                            Lines[#Lines + 1] = "local " .. Copy[1] .. " = " .. Texts[Copy[2]] .. "\n"
                        end
                    end

                    return table.concat(Lines) .. Name(S.Dst[1]) .. " = " .. RecFunctionText(Module, S.Child, Up, Depth + 1)
                end

                return RecFormat(S.Parts, Texts)
            end

            local ReadRegs = {}

            for _, T in ipairs(Code) do
                for _, R in ipairs(T.Ops) do
                    ReadRegs[R] = true
                end
            end

            for _, Bid in ipairs(SortedIds(Blocks)) do
                local B = Blocks[Bid]
                local Seq = Seqs[Bid]
                local Slots = {}
                local Metas = {}
                local Gone = {}
                local HasTerm = #Seq > 0 and (Seq[#Seq].Kind == "CJump" or Seq[#Seq].Kind == "Ret" or Seq[#Seq].Kind == "ForN" or Seq[#Seq].Kind == "ForG" or Seq[#Seq].Kind == "Jump")

                for X = #Seq, 1, -1 do
                    local Def = Seq[X]
                    local Skip = #Def.Dst ~= 1 or Def.NoFold or Def.Full

                    if not Skip then
                        for _, Range in ipairs(PinRanges[Def.Dst[1]] or {}) do
                            if Range[1] <= Def.Pos and Def.Pos <= Range[2] then
                                Skip = true
                                break
                            end
                        end
                    end

                    if Skip or not (Def.Kind == "Def" or Def.Kind == "Call" or Def.Kind == "Closure") or (HasTerm and X == #Seq) then
                        continue
                    end

                    local Reg = Def.Dst[1]
                    local Reader = nil

                    for T = X + 1, #Seq do
                        if Gone[T] then
                            continue
                        end

                        if FlatCount(Seq, Slots, T, Reg) > 0 then
                            Reader = T
                            break
                        end

                        if ListHas(Seq[T].Dst, Reg) then
                            break
                        end
                    end

                    if Reader == nil or FlatCount(Seq, Slots, Reader, Reg) ~= 1 then
                        continue
                    end

                    local Host = Seq[Reader]

                    if not ListHas(Host.Dst, Reg) and LiveAfter[Host.Pos][Reg] then
                        continue
                    end

                    local DefReads = Flat(Seq, Slots, X)
                    local EffD = EffOf(Seq, Slots, X)
                    local _, FirstCount = FlatCount(Seq, Slots, Reader, Reg)
                    local Callee = EffD == 1 and FirstCount == 1
                    local Blocked = false

                    for Y = X + 1, Reader - 1 do
                        if Gone[Y] then
                            continue
                        end

                        local EffY = EffOf(Seq, Slots, Y)
                        local Writes2 = false

                        for _, W in ipairs(Seq[Y].Dst) do
                            if ListHas(DefReads, W) then
                                Writes2 = true
                                break
                            end
                        end

                        if Writes2 or (EffD == 2 and EffY >= 1) or (EffD >= 1 and EffY == 2 and not Callee) then
                            Blocked = true
                            break
                        end
                    end

                    if Blocked then
                        continue
                    end

                    local Where = FindSlot(Seq, Slots, Reader, Reg)
                    Slots[Where] = X
                    local Sub = {}
                    local Ordered = Order(Seq, Slots, Reader)

                    for K = 1, #Ordered - 1 do
                        if Seq[Ordered[K]].Eff >= 1 then
                            Sub[#Sub + 1] = Ordered[K]
                        end
                    end

                    local Sorted = true

                    for K = 2, #Sub do
                        if Sub[K - 1] > Sub[K] then
                            Sorted = false
                            break
                        end
                    end

                    if not Sorted then
                        Slots[Where] = nil
                        continue
                    end

                    Gone[X] = true
                end

                local Term = HasTerm and Seq[#Seq] or nil

                for X = 1, #Seq - (HasTerm and 1 or 0) do
                    if Gone[X] then
                        continue
                    end

                    local S = Seq[X]

                    if S.Kind == "Def" and #S.Dst > 0 and S.Dst[1] >= 1000 then
                        if not ReadRegs[S.Dst[1]] then
                            continue
                        end
                    end

                    local Text = Render(Seq, Slots, X)
                    local Before = #B.Stmts

                    if S.Full then
                        B.Stmts[#B.Stmts + 1] = Text
                    elseif S.Kind == "Call" then
                        local Prefix = ""

                        if #S.Dst > 0 then
                            local ReadLater = S.Dst[1] < 1000

                            if not ReadLater then
                                ReadLater = ReadRegs[S.Dst[1]] == true
                            end

                            if ReadLater then
                                local DstNames = {}

                                for _, R in ipairs(S.Dst) do
                                    DstNames[#DstNames + 1] = Name(R)
                                end

                                Prefix = table.concat(DstNames, ", ") .. " = "
                            end
                        end

                        B.Stmts[#B.Stmts + 1] = Prefix .. Text
                    elseif Text ~= Name(S.Dst[1]) then
                        B.Stmts[#B.Stmts + 1] = Name(S.Dst[1]) .. " = " .. Text
                    end

                    if #B.Stmts > Before then
                        Metas[#Metas + 1] = {X, S}
                    end
                end

                if #Metas == #B.Stmts then
                    local Stmts = B.Stmts
                    local Drop = {}

                    for I = #Metas, 1, -1 do
                        local S = Metas[I][2]

                        if Drop[I] or S.Tab == nil or S.Kind ~= "Def" or #S.Dst ~= 1 or Stmts[I] ~= Name(S.Dst[1]) .. " = {}" then
                            continue
                        end

                        local Base = S.Dst[1]
                        local BName = Name(Base)
                        local Hash = S.Tab[1]
                        local Arr = S.Tab[2]
                        local Items = {}
                        local ItemKeys = {}
                        local Positional = 0
                        local HashCount = 0
                        local ArrCount = 0
                        local Pending = {}
                        local SafeCount = 0
                        local SafeEnd = I
                        local J = I + 1

                        while J <= #Metas do
                            if Drop[J] then
                                J += 1
                                continue
                            end

                            local TX = Metas[J][1]
                            local TS = Metas[J][2]

                            if TS.Elem ~= nil and #TS.Elem > 0 and TS.Ops[1] == Base then
                                local Texts = OpTexts(Seq, Slots, TX)
                                local Taken = {}
                                local Good = true
                                local Pieces = {}
                                local PieceKeys = {}
                                local NewPositional = Positional
                                local NewHash = HashCount
                                local NewArr = ArrCount
                                local Slack = 0

                                for _, Element in ipairs(TS.Elem) do
                                    local Kind = Element[1]
                                    local Key = Element[2]
                                    local ValOp = Element[3]
                                    local Val = Texts[ValOp]
                                    local Reg = TS.Ops[ValOp]

                                    if Slots[TX * 1024 + ValOp] == nil and Val == Name(Reg) then
                                        local Def = nil

                                        for _, P in ipairs(Pending) do
                                            if Metas[P][2].Dst[1] == Reg then
                                                Def = P
                                                break
                                            end
                                        end

                                        if Def ~= nil then
                                            local Prefix = Name(Reg) .. " = "
                                            local Elsewhere = false

                                            for M = Def + 1, J - 1 do
                                                if not Drop[M] and FlatCount(Seq, Slots, Metas[M][1], Reg) > 0 then
                                                    Elsewhere = true
                                                    break
                                                end
                                            end

                                            if ListHas(Taken, Def) or FlatCount(Seq, Slots, TX, Reg) ~= 1 or LiveAfter[TS.Pos][Reg] or Elsewhere or not StartsWith(Stmts[Def], Prefix) then
                                                Good = false
                                                break
                                            end

                                            Val = string.sub(Stmts[Def], #Prefix + 1)
                                            Taken[#Taken + 1] = Def
                                        end
                                    end

                                    if FindWord(Val, BName) then
                                        Good = false
                                        break
                                    end

                                    if Kind == "m" and (Slots[TX * 1024 + ValOp] == nil or Key ~= NewPositional + 1) then
                                        Good = false
                                        break
                                    end

                                    if Kind == "l" or Kind == "m" then
                                        NewArr += 1

                                        if Kind == "m" then
                                            Slack = 1
                                        end

                                        PieceKeys[#PieceKeys + 1] = false

                                        if Key == NewPositional + 1 then
                                            NewPositional += 1
                                            Pieces[#Pieces + 1] = Val
                                        else
                                            Pieces[#Pieces + 1] = string.format("[%d] = %s", Key, Val)
                                        end
                                    else
                                        NewHash += 1
                                        PieceKeys[#PieceKeys + 1] = Kind == "s" and Key or false

                                        if Kind == "s" then
                                            Pieces[#Pieces + 1] = (RecIdent(Key) and Key or "[" .. RecConst({Type = 3, Value = Key}) .. "]") .. " = " .. Val
                                        elseif Kind == "i" then
                                            Pieces[#Pieces + 1] = string.format("[%d] = %s", Key, Val)
                                        else
                                            Pieces[#Pieces + 1] = "[" .. Texts[Key] .. "] = " .. Val
                                        end
                                    end
                                end

                                local Prefixed = #Pending >= #Taken

                                for K = 1, #Taken do
                                    if Taken[K] ~= Pending[K] then
                                        Prefixed = false
                                    end
                                end

                                if not Good or not Prefixed or NewHash > Hash or NewArr > Arr + Slack then
                                    break
                                end

                                local Remaining = {}

                                for K = #Taken + 1, #Pending do
                                    Remaining[#Remaining + 1] = Pending[K]
                                end

                                Pending = Remaining
                                ListExtend(Items, Pieces)
                                ListExtend(ItemKeys, PieceKeys)
                                Positional = NewPositional
                                HashCount = NewHash
                                ArrCount = NewArr

                                if #Pending == 0 then
                                    SafeCount = #Items
                                    SafeEnd = J
                                end
                            elseif (TS.Kind == "Def" or TS.Kind == "Call" or TS.Kind == "Closure") and not TS.Full and #TS.Dst == 1 and TS.Dst[1] >= 0 and TS.Dst[1] < 1000 and TS.Dst[1] ~= Base and not FindWord(Stmts[J], BName) and StartsWith(Stmts[J], Name(TS.Dst[1]) .. " = ") then
                                Pending[#Pending + 1] = J
                            else
                                break
                            end

                            J += 1
                        end

                        if SafeCount == 0 and S.Tpl == nil then
                            continue
                        end

                        local Elems = {}

                        for K = 1, SafeCount do
                            Elems[K] = Items[K]
                        end

                        if S.Tpl ~= nil then
                            local Left = {}

                            for K = 1, SafeCount do
                                Left[K] = {Key = ItemKeys[K], Text = Items[K]}
                            end

                            Elems = {}

                            for _, TplEntry in ipairs(S.Tpl) do
                                if TplEntry.Val ~= nil then
                                    Elems[#Elems + 1] = (RecIdent(TplEntry.Key) and TplEntry.Key or "[" .. RecConst({Type = 3, Value = TplEntry.Key}) .. "]") .. " = " .. TplEntry.Val
                                else
                                    local Hit = nil

                                    for K = 1, #Left do
                                        if Left[K].Key == TplEntry.Key then
                                            Hit = K
                                            break
                                        end
                                    end

                                    if Hit ~= nil then
                                        Elems[#Elems + 1] = table.remove(Left, Hit).Text
                                    end
                                end
                            end

                            for K = 1, #Left do
                                Elems[#Elems + 1] = Left[K].Text
                            end
                        end

                        local Multi = false

                        for K = 1, #Elems do
                            if string.find(Elems[K], "\n", 1, true) then
                                Multi = true
                            end
                        end

                        if not Multi and PyLen(table.concat(Elems, ", ")) > 100 then
                            Multi = true
                        end

                        if Multi then
                            local Indented = {}

                            for K = 1, #Elems do
                                Indented[K] = RecIndent(Elems[K], 1) .. ","
                            end

                            Stmts[I] = BName .. " = {\n" .. table.concat(Indented, "\n") .. "\n}"
                        else
                            Stmts[I] = BName .. " = {" .. table.concat(Elems, ", ") .. "}"
                        end

                        for K = I + 1, SafeEnd do
                            Drop[K] = true
                        end
                    end

                    local Kept = {}

                    for K = 1, #Stmts do
                        if not Drop[K] then
                            Kept[#Kept + 1] = Stmts[K]
                        end
                    end

                    B.Stmts = Kept
                end

                if Term ~= nil then
                    local Text = Render(Seq, Slots, #Seq)
                    ListExtend(B.Stmts, Term.Pre or {})

                    if Term.Kind == "CJump" then
                        B.Cond = {P = Text, N = Term.NText}
                    elseif Term.Kind == "Ret" then
                        B.Values = Text
                    elseif Term.Kind == "ForN" or Term.Kind == "ForG" then
                        local Body = nil

                        if EndsWith(Text, " do") then
                            Body = string.sub(Text, 1, -4)
                        end

                        local Stripped = nil

                        if Body ~= nil then
                            local Trimmed = Body
                            local Count = 0

                            while EndsWith(Trimmed, ", nil") do
                                Trimmed = string.sub(Trimmed, 1, -6)
                                Count += 1
                            end

                            if Count > 0 then
                                Stripped = Trimmed
                            end
                        end

                        if Stripped ~= nil and not EndsWith(Stripped, ")") then
                            B.Info = Stripped .. " do"
                        else
                            B.Info = Text
                        end

                        if Term.Kind == "ForG" and #Seq >= 2 and Seq[#Seq - 1].Kind == "Call" and ListEqual(Seq[#Seq - 1].Dst, Term.Ops) and not Gone[#Seq - 1] and #B.Stmts > 0 then
                            local DstNames = {}

                            for _, R in ipairs(Term.Ops) do
                                DstNames[#DstNames + 1] = Name(R)
                            end

                            local Prefix = table.concat(DstNames, ", ") .. " = "

                            if StartsWith(B.Stmts[#B.Stmts], Prefix) then
                                local Popped = table.remove(B.Stmts)
                                B.Info = Term.Parts[1] .. string.sub(Popped, #Prefix + 1) .. " do"
                            end
                        end
                    end
                end
            end

            local function Target(Bid)
                local Seen = {}
                local B = Blocks[Bid]

                while B.Kind == "goto" and #B.Stmts == 0 and not Seen[B.Succ[1]] and B.Id ~= B.Succ[1] do
                    Seen[B.Id] = true
                    B = Blocks[B.Succ[1]]
                end

                return B.Id
            end

            local Entry = Target(1)

            for _, Bid in ipairs(SortedIds(Blocks)) do
                local B = Blocks[Bid]
                local NewSucc = {}

                for K, S in ipairs(B.Succ) do
                    NewSucc[K] = Target(S)
                end

                B.Succ = NewSucc
            end

            for _, Bid in ipairs(SortedIds(Blocks)) do
                local B = Blocks[Bid]

                if B.Kind == "cond" and B.Succ[1] == B.Succ[2] then
                    B.Kind = "goto"
                    B.Succ = {B.Succ[1]}
                    B.Cond = nil
                end
            end

            local Reach = {}
            local Stack = {Entry}

            while #Stack > 0 do
                local X = table.remove(Stack)

                if not (Reach[X] or Blocks[X] == nil) then
                    Reach[X] = true
                    ListExtend(Stack, Blocks[X].Succ)
                end
            end

            for _, Bid in ipairs(SortedIds(Blocks)) do
                if not Reach[Bid] then
                    Blocks[Bid] = nil
                end
            end

            RecPreds(Blocks)
            Changed = true

            while Changed do
                Changed = false

                for _, Bid in ipairs(SortedIds(Blocks)) do
                    local B = Blocks[Bid]

                    if B ~= nil and B.Kind == "goto" then
                        local S = Blocks[B.Succ[1]]

                        if not (S.Id == B.Id or #S.Preds ~= 1 or S.Id == Entry) then
                            B.Stmts = ListCopy(B.Stmts)
                            ListExtend(B.Stmts, S.Stmts)
                            B.Kind, B.Cond, B.Succ, B.Values, B.Info = S.Kind, S.Cond, S.Succ, S.Values, S.Info
                            Blocks[S.Id] = nil

                            for _, X in ipairs(B.Succ) do
                                if Blocks[X] then
                                    local Ps = Blocks[X].Preds

                                    for Pi, P in ipairs(Ps) do
                                        if P == S.Id then
                                            Ps[Pi] = B.Id
                                        end
                                    end
                                end
                            end

                            Changed = true
                        end
                    end
                end
            end

            RecPreds(Blocks)
            Changed = true

            while Changed do
                Changed = false

                for _, Aid in ipairs(SortedIds(Blocks)) do
                    local A = Blocks[Aid]

                    if A ~= nil and A.Kind == "cond" then
                        for Side = 0, 1 do
                            local B = Blocks[A.Succ[Side + 1]]
                            local Other = A.Succ[2 - Side]

                            if not (B == nil or B.Id == A.Id or B.Id == Entry or B.Kind ~= "cond" or #B.Stmts > 0 or not (#B.Preds == 1 and B.Preds[1] == A.Id) or Other == B.Id or not (B.Succ[1] == Other or B.Succ[2] == Other) or B.Succ[1] == B.Succ[2]) then
                                local Cb = nil

                                if (B.Succ[2] == Other) == (Side == 0) then
                                    Cb = B.Cond
                                else
                                    Cb = RecNegate(B.Cond)
                                end

                                local X = nil

                                if B.Succ[2] == Other then
                                    X = B.Succ[1]
                                else
                                    X = B.Succ[2]
                                end

                                if Side == 0 then
                                    A.Cond = {P = "(" .. A.Cond.P .. " and " .. Cb.P .. ")", N = "(" .. A.Cond.N .. " or " .. Cb.N .. ")"}
                                    A.Succ = {X, Other}
                                else
                                    A.Cond = {P = "(" .. A.Cond.P .. " or " .. Cb.P .. ")", N = "(" .. A.Cond.N .. " and " .. Cb.N .. ")"}
                                    A.Succ = {Other, X}
                                end

                                Blocks[B.Id] = nil
                                RecPreds(Blocks)
                                Changed = true
                                break
                            end
                        end
                    end
                end
            end

            RecPreds(Blocks)
            local Sr = RecStructurer.New(Entry, Blocks)
            local Nodes = Sr:Region(Sr.Entry, nil, nil)
            local TargetSet = {}

            for _ = 1, 4 do
                if #Sr.Gotos == 0 then
                    break
                end

                local Grew = false

                for _, G in ipairs(Sr.Gotos) do
                    if G[1] == "shared" then
                        if not TargetSet[G[2]] then
                            Grew = true
                        end

                        TargetSet[G[2]] = true
                    end
                end

                if Sr.Relaxed and not Grew then
                    break
                end

                local Prev = Sr
                Sr = setmetatable({}, RecStructurer)
                Sr.Entry = Entry
                Sr.Blocks = Blocks
                Sr.Idom = Prev.Idom
                Sr.RpoIndex = Prev.RpoIndex
                Sr.Loops = Prev.Loops
                Sr.LoopBody = Prev.LoopBody
                Sr.Ipdom = Prev.Ipdom
                Sr.Emitted = {}
                Sr.Gotos = {}
                Sr.LoopExit = {}
                Sr.StubFollows = {}
                Sr.ForBreak = {}
                Sr.Redirect = {}
                Sr.Relaxed = true
                Sr.FlagTargets = TargetSet
                Nodes = Sr:Region(Sr.Entry, nil, nil)
            end

            local Lines = {}

            if #Sr.Gotos == 0 then
                Nodes = RecCleanup(Nodes)

                if #Nodes > 0 and Nodes[#Nodes].K == "ret" and Nodes[#Nodes].Text == "return" then
                    table.remove(Nodes)
                end

                Lines = RecLines(Nodes, 0)
            elseif not Lowered then
                return nil
            else
                local Ids = SortedIds(Blocks)
                local Pc = "pc" .. Suffix
                local Cases = {}

                for _, Bid in ipairs(Ids) do
                    local B = Blocks[Bid]
                    local Case = {}

                    for _, T in ipairs(B.Stmts) do
                        Case[#Case + 1] = RecIndent((StartsWith(T, "(") and ";" or "") .. T, 0)
                    end

                    if B.Kind == "goto" then
                        Case[#Case + 1] = string.format("%s = %d", Pc, B.Succ[1])
                    elseif B.Kind == "cond" then
                        Case[#Case + 1] = string.format("if %s then %s = %d else %s = %d end", RecStrip(B.Cond.P), Pc, B.Succ[1], Pc, B.Succ[2])
                    elseif B.Kind == "ret" then
                        Case[#Case + 1] = B.Values
                    else
                        Case[#Case + 1] = "return"
                    end

                    Cases[Bid] = table.concat(Case, "\n")
                end

                local function Tree(Part, Level)
                    if #Part == 1 then
                        return RecIndent(Cases[Part[1]], Level)
                    end

                    local Mid = #Part // 2
                    local Left = {}
                    local Right = {}

                    for K = 1, #Part do
                        if K <= Mid then
                            Left[#Left + 1] = Part[K]
                        else
                            Right[#Right + 1] = Part[K]
                        end
                    end

                    return RecIndent(string.format("if %s < %d then", Pc, Part[Mid + 1]), Level) .. "\n" .. Tree(Left, Level + 1) .. "\n" .. RecIndent("else", Level) .. "\n" .. Tree(Right, Level + 1) .. "\n" .. RecIndent("end", Level)
                end

                Lines = {string.format("local %s = %d", Pc, Entry), "while true do", Tree(Ids, 1), "end"}
            end

            local Params = {}

            for R = 0, Proto.NumParams - 1 do
                Params[#Params + 1] = Name(R)
            end

            local Body = RecFold(Split(table.concat(Lines, "\n"), "\n"))
            local Row = 1

            while Row <= #Body do
                local Pad, Reg, Value = string.match(Body[Row], "^( *)([vV]%d[%w_]*) = ([%a_][%w_]*)$")
                local Inner = Pad and Pad .. "    "
                local Rhs = Pad and string.match(Body[Row + 2] or "", "^" .. Inner .. Reg .. " = (.*)$")
                local EndRow = nil

                if Rhs and Value ~= "nil" and Value ~= "true" and Value ~= "false" and Body[Row + 1] == Pad .. "if " .. Reg .. " then" and not FindWord(Rhs, Reg) then
                    for X = Row + 2, #Body do
                        if Body[X] == Pad .. "end" then
                            EndRow = X
                            break
                        elseif Body[X] ~= "" and string.sub(Body[X], 1, #Inner) ~= Inner then
                            break
                        end
                    end
                end

                if EndRow then
                    table.insert(Body, EndRow, Inner .. Reg .. " = " .. Value)
                    table.insert(Body, EndRow, Pad .. "else")
                    Body[Row + 1] = Pad .. "if " .. Value .. " then"
                    table.remove(Body, Row)

                    local ElseRow = EndRow - 1
                    local Folding = true

                    while Folding do
                        Folding = false
                        local First = string.match(Body[Row + 1], "^" .. Inner .. Reg .. " = ([%a_][%w_%.]*)$")

                        if First then
                            local Root = string.match(First, "^[%a_][%w_]*")

                            for X = Row + 2, ElseRow - 1 do
                                local Text = Body[X]

                                if FindWord(Text, Reg) then
                                    local Tail = string.match(Text, "^" .. Inner .. Reg .. " = " .. Reg .. "([%(%.:].*)$")

                                    if Tail and not FindWord(Tail, Reg) then
                                        Body[X] = Inner .. Reg .. " = " .. First .. Tail
                                        table.remove(Body, Row + 1)
                                        ElseRow -= 1
                                        Folding = true
                                    end

                                    break
                                elseif FindWord(Text, "break") or FindWord(Text, "continue") or FindWord(Text, "goto") or string.match(Text, "^ *" .. Root .. " = ") then
                                    break
                                end
                            end
                        end
                    end
                end

                Row += 1
            end

            local Ind = {}
            local FnStart = {}
            local IsLoop = {}
            local ClosureBody = {}

            for Row = 1, #Body do
                local Text = Body[Row]
                local Lead = #Text - #LStrip(Text)

                if Strip(Text) ~= "" then
                    Ind[Row] = Lead
                end

                local Head = string.sub(Text, Lead + 1)
                FnStart[Row] = string.find(Text, "function(", 1, true)
                IsLoop[Row] = StartsWith(Head, "for ") or StartsWith(Head, "while ") or StartsWith(Head, "repeat")
            end

            for Row = 1, #Body do
                if FnStart[Row] and Ind[Row] then
                    local Next = Row + 1

                    while Next <= #Body and (Ind[Next] == nil or Ind[Next] > Ind[Row]) do
                        ClosureBody[Next] = true
                        Next += 1
                    end

                    if Next <= #Body and Ind[Next] == Ind[Row] and StartsWith(string.sub(Body[Next], Ind[Next] + 1), "end") then
                        ClosureBody[Next] = true
                    end
                end
            end

            local NextLess = {}
            local PrevLess = {}
            local LessStack = {}

            for Row = 1, #Body do
                if Ind[Row] then
                    while #LessStack > 0 and Ind[LessStack[#LessStack]] > Ind[Row] do
                        NextLess[LessStack[#LessStack]] = Row
                        LessStack[#LessStack] = nil
                    end

                    LessStack[#LessStack + 1] = Row
                end
            end

            LessStack = {}

            for Row = 1, #Body do
                if Ind[Row] then
                    while #LessStack > 0 and Ind[LessStack[#LessStack]] >= Ind[Row] do
                        LessStack[#LessStack] = nil
                    end

                    PrevLess[Row] = LessStack[#LessStack]
                    LessStack[#LessStack + 1] = Row
                end
            end

            local Roots = {}
            local Derived = {}
            local Counts = {}
            local Work = {}
            local WordRows, RowWords = BuildWordRows(Body)

            local function LoopKills(Var, Loop, NeedInside)
                local Lead = Ind[Loop]
                local Rows = RowsOf(WordRows[Var])

                if not Lead or #Rows == 0 then
                    return false
                end

                local End = #Body + 1

                for X = Loop + 1, #Body do
                    if Ind[X] and Ind[X] <= Lead then
                        End = X
                        break
                    end
                end

                local BodyLead = nil

                for X = Loop + 1, End - 1 do
                    if Ind[X] then
                        BodyLead = Ind[X]
                        break
                    end
                end

                if not BodyLead then
                    return false
                end

                if NeedInside and (Rows[1] < Loop or Rows[#Rows] >= End) then
                    return false
                end

                local First = nil

                for _, X in ipairs(Rows) do
                    if X >= Loop then
                        First = X
                        break
                    end
                end

                if First == nil or First >= End then
                    return false
                end

                if First == Loop then
                    local Head = string.match(Body[Loop], "^ *for (.-) in ") or string.match(Body[Loop], "^ *for ([%w_]+) =")

                    return Head ~= nil and FindWord(Head, Var) ~= nil
                end

                if Ind[First] ~= BodyLead or ClosureBody[First] then
                    return false
                end

                local Rest = string.match(Body[First], "^ *local +" .. Var .. " = (.*)$") or string.match(Body[First], "^ *" .. Var .. " = (.*)$")

                if Rest == nil then
                    return false
                end

                local Parts = {Rest}

                for X = First + 1, #Body do
                    local XLead = Ind[X]

                    if XLead == nil or XLead > BodyLead then
                        Parts[#Parts + 1] = Body[X]
                    else
                        local Head = string.sub(Body[X], XLead + 1)

                        if XLead == BodyLead and #Parts > 1 and (StartsWith(Head, "}") or StartsWith(Head, ")") or StartsWith(Head, "end") and not IsWordAt(Head, 4)) then
                            Parts[#Parts + 1] = Body[X]
                        end

                        break
                    end
                end

                return FindWord(table.concat(Parts, "\n"), Var) == nil
            end

            for _, R in ipairs(SortedIds(Used)) do
                if Proto.NumParams <= R and R < 1000 then
                    local Var = "v" .. tostring(R) .. Suffix
                    Roots[Var] = R
                    Work[#Work + 1] = Var
                end
            end

            local WorkIndex = 1
            local Chain = {}
            local Finals = {}

            while WorkIndex <= #Work do
                local Var = Work[WorkIndex]
                WorkIndex += 1
                local State = Chain[Var]
                Chain[Var] = nil
                local PhysVar = State and State.Phys or Var
                local Mentions = State and State.Rows or RowsOf(WordRows[Var])
                local FirstMention = State and State.First or 1

                if #Mentions - FirstMention < 1 then
                    continue
                end

                local Explicit = false

                if not Derived[Var] then
                    for _, Row in ipairs(Mentions) do
                        local DeclHead = string.match(Strip(Body[Row]), "^local ([^=]*)")

                        if DeclHead and FindWord(DeclHead, Var) then
                            Explicit = true
                            break
                        end
                    end
                end

                if Explicit then
                    continue
                end

                local SelfBody = {}

                if SelfVal[Var] then
                    for _, Fn in ipairs(Mentions) do
                        if Ind[Fn] and FnStart[Fn] and string.sub(Body[Fn], Ind[Fn] + 1, Ind[Fn] + #Var + 12) == Var .. " = function(" then
                            local Next = Fn + 1

                            while Next <= #Body and (Ind[Next] == nil or Ind[Next] > Ind[Fn]) do
                                SelfBody[Next] = true
                                Next += 1
                            end
                        end
                    end
                end

                local FirstBad = nil
                local BadScan = FirstMention

                for MentionIndex = FirstMention + 1, #Mentions do
                    local Row = Mentions[MentionIndex]
                    local Lead = Ind[Row]
                    local Text = Body[Row]

                    if not Lead or ClosureBody[Row] or string.sub(Text, Lead + 1, Lead + #PhysVar + 3) ~= PhysVar .. " = " then
                        continue
                    end

                    local End = Row
                    local Next = Row + 1

                    while Next <= #Body do
                        local NextLead = Ind[Next]

                        if NextLead == nil or NextLead > Lead then
                            End = Next
                        else
                            local NextHead = string.sub(Body[Next], NextLead + 1)

                            if End > Row and NextLead == Lead and (StartsWith(NextHead, "}") or StartsWith(NextHead, ")") or StartsWith(NextHead, "end") and not IsWordAt(NextHead, 4)) then
                                End = Next
                            end

                            break
                        end

                        Next += 1
                    end

                    local Rhs = string.sub(Text, Lead + #PhysVar + 4)
                    local RhsRows = {Rhs}

                    for X = Row + 1, End do
                        RhsRows[#RhsRows + 1] = Body[X]
                    end

                    local Eligible = not FindWord(table.concat(RhsRows, "\n"), PhysVar)
                    local Close = #Body + 1

                    if Eligible then
                        Close = NextLess[Row] or Close

                        if Mentions[#Mentions] >= Close then
                            Eligible = false
                        else
                            while FirstBad == nil and Mentions[BadScan] ~= nil and Mentions[BadScan] < Row do
                                local M = Mentions[BadScan]

                                if not SelfBody[M] and (ClosureBody[M] or FnStart[M] and FindWord(string.sub(Body[M], FnStart[M]), PhysVar)) then
                                    FirstBad = M
                                end

                                BadScan += 1
                            end

                            if FirstBad ~= nil then
                                Eligible = false
                            end
                        end
                    end

                    local Cur = Row
                    local CurLead = Lead

                    while Eligible and CurLead > 0 do
                        local Parent = PrevLess[Cur]

                        if Parent == nil then
                            break
                        end

                        if IsLoop[Parent] and not LoopKills(PhysVar, Parent, false) then
                            for MentionPos = FirstMention, #Mentions do
                                local M = Mentions[MentionPos]

                                if M >= Parent and M < Row then
                                    Eligible = false
                                    break
                                end
                            end
                        end

                        Cur = Parent
                        CurLead = Ind[Parent]
                    end

                    if not Eligible then
                        continue
                    end

                    local Root = Roots[Var]
                    Counts[Root] = (Counts[Root] or 0) + 1
                    local NewName = "V" .. tostring(Root) .. "_" .. tostring(Counts[Root]) .. Suffix
                    local TailName = "V" .. tostring(Root) .. "_Z" .. Suffix
                    Roots[NewName] = Root
                    Derived[NewName] = true
                    Work[#Work + 1] = NewName
                    Body[Row] = string.rep(" ", Lead) .. "local " .. TailName .. " = " .. Rhs
                    ReindexRow(WordRows, RowWords, Body, Row)
                    local NewRows = {Row}
                    local NewFirst = 1

                    if State then
                        for MentionPos = FirstMention, MentionIndex - 1 do
                            local X = Mentions[MentionPos]
                            Body[X] = (string.gsub(Body[X], "%f[%w_\128-\255]" .. TailName .. "%f[^%w_\128-\255]", Var))
                            ReindexRow(WordRows, RowWords, Body, X)
                        end

                        NewRows = Mentions
                        NewFirst = MentionIndex
                    else
                        for _, X in ipairs(Mentions) do
                            if X <= End or X >= Close then
                                continue
                            end

                            local Line = Body[X]
                            local Pieces = {}
                            local Start = 1
                            local Cursor = 1
                            local Quoted = false

                            while Cursor <= #Line do
                                local Byte = string.byte(Line, Cursor)

                                if Quoted then
                                    if Byte == 92 then
                                        Cursor += 2
                                    else
                                        if Byte == 34 then
                                            Quoted = false
                                        end

                                        Cursor += 1
                                    end
                                elseif Byte == 34 then
                                    Quoted = true
                                    Cursor += 1
                                elseif string.sub(Line, Cursor, Cursor + #Var - 1) == Var and not IsWordAt(Line, Cursor - 1) and not IsWordAt(Line, Cursor + #Var) and not (string.byte(Line, Cursor - 1) == 46 and string.byte(Line, Cursor - 2) ~= 46) and string.byte(Line, Cursor - 1) ~= 58 then
                                    Pieces[#Pieces + 1] = string.sub(Line, Start, Cursor - 1) .. TailName
                                    Cursor += #Var
                                    Start = Cursor
                                else
                                    Cursor += 1
                                end
                            end

                            Pieces[#Pieces + 1] = string.sub(Line, Start)
                            Body[X] = table.concat(Pieces)

                            if Body[X] ~= Line then
                                NewRows[#NewRows + 1] = X
                            end

                            ReindexRow(WordRows, RowWords, Body, X)
                        end

                        local Fresh = {}

                        for Key in pairs(WordRows[Var]) do
                            Fresh[Key] = true
                        end

                        WordRows[Var] = Fresh
                    end

                    local Entry = {Rows = NewRows, First = NewFirst, Phys = TailName, Name = NewName}
                    Chain[NewName] = Entry
                    Finals[TailName] = Entry

                    break
                end
            end

            for TailName, Final in pairs(Finals) do
                for MentionPos = Final.First, #Final.Rows do
                    local X = Final.Rows[MentionPos]
                    Body[X] = (string.gsub(Body[X], "%f[%w_\128-\255]" .. TailName .. "%f[^%w_\128-\255]", Final.Name))
                    ReindexRow(WordRows, RowWords, Body, X)
                end
            end

            local Dead = {}

            for Row = 1, #Body do
                local Alias, Orig = string.match(Body[Row], "^ *local (c%d+_%d+_%d+) = ([vV]%d[%w_]*)$")

                if Alias and WordRows[Orig] then
                    local InLoop = false
                    local Level = Ind[Row] or 0

                    for Up = Row - 1, 1, -1 do
                        if Ind[Up] and Ind[Up] < Level then
                            Level = Ind[Up]

                            if string.find(Body[Up], "^ *for ") or string.find(Body[Up], "^ *while ") or string.find(Body[Up], "^ *repeat") then
                                InLoop = not LoopKills(Orig, Up, true)
                                break
                            end
                        end
                    end

                    local Written = InLoop

                    for _, M in ipairs(RowsOf(WordRows[Orig])) do
                        if Written then
                            break
                        end

                        if M > Row then
                            local Text = Body[M]
                            local Lhs = string.match(Text, "^ *local +([^=(){}\"']-) *=[^=]") or string.match(Text, "^ *([^=(){}\"']-) *=[^=]") or string.match(Text, "^ *for +(.-) +in ") or string.match(Text, "^ *for +([%w_]+) *=")

                            if Lhs then
                                for Target in string.gmatch(Lhs, "[^,]+") do
                                    if string.gsub(string.match(Target, "^%s*(.-)%s*$"), "[%s%+%-%*/%%%^%.]+$", "") == Orig then
                                        Written = true
                                    end
                                end
                            end
                        end
                    end

                    if not Written then
                        for X = Row + 1, #Body do
                            if string.find(Body[X], Alias, 1, true) then
                                Body[X] = string.gsub(Body[X], "%f[%w_\128-\255]" .. Alias .. "%f[^%w_\128-\255]", Orig)
                                ReindexRow(WordRows, RowWords, Body, X)
                            end
                        end

                        Dead[Row] = true
                    end
                end
            end

            local RefRegs = {}
            local IsUp = {}

            for _, Ref in ipairs(RefCaps) do
                RefRegs[Ref[2]] = true
            end

            for _, Up in ipairs(UpNames) do
                IsUp[Up] = true
            end

            for Row = 1, #Body do
                local Text = (string.gsub(Body[Row], "^( *)local ", "%1"))
                local Copy, Orig = string.match(Text, "^ *([vV]%d[%w_]*) = ([vV]%d[%w_]*)$")
                local Frozen = false

                if not Copy then
                    Copy, Orig = string.match(Text, "^ *([vV]%d[%w_]*) = (c%d+_%d+_%d+)$")
                    Frozen = Copy ~= nil
                end

                if Copy and Copy ~= Orig and not IsUp[Copy] and not Dead[Row] and WordRows[Copy] and (Frozen or WordRows[Orig]) then
                    local Uses = RowsOf(WordRows[Copy])
                    local Safe = Uses[1] == Row and #Uses > 1

                    for X = Row + 1, #Body do
                        if Ind[X] and Ind[X] < (Ind[Row] or 0) and Uses[#Uses] >= X then
                            Safe = false
                            break
                        end
                    end

                    for K = 2, #Uses do
                        if not Safe then
                            break
                        end

                        if ClosureBody[Uses[K]] or Dead[Uses[K]] or LineWrites(Body[Uses[K]], Copy) then
                            Safe = false
                        end
                    end

                    if Safe and not Frozen then
                        local OrigRows = RowsOf(WordRows[Orig])
                        local LastUse = Uses[#Uses]

                        for _, M in ipairs(OrigRows) do
                            if M > Row and LineWrites(Body[M], Orig) then
                                local Rewritten = M > LastUse and not string.find(Body[M], "^ *local ")

                                if Rewritten then
                                    for X = Row + 1, M do
                                        if string.find(Body[X], "^ *for ") or string.find(Body[X], "^ *while ") or string.find(Body[X], "^ *repeat") then
                                            Rewritten = false
                                            break
                                        end
                                    end
                                end

                                if not Rewritten then
                                    Safe = false
                                    break
                                end
                            end
                        end
                    end

                    if Safe and not Frozen and ((UpNames.Ref and UpNames.Ref[Orig]) or RefRegs[tonumber(string.match(Orig, "^[vV](%d+)"))]) then
                        for X = Row + 1, Uses[#Uses] - 1 do
                            if HasRiskyCall(Body[X]) or string.find(Body[X], "^ *for ") or string.find(Body[X], "^ *while ") or string.find(Body[X], "^ *repeat") then
                                Safe = false
                                break
                            end
                        end

                        local LastText = Body[Uses[#Uses]]
                        local LastPos = 0

                        for Pos in string.gmatch(LastText, "()%f[%w_\128-\255]" .. Copy .. "%f[^%w_\128-\255]") do
                            LastPos = Pos
                        end

                        if HasRiskyCall(string.sub(LastText, 1, LastPos), true) then
                            Safe = false
                        end
                    end

                    if Safe then
                        for K = 2, #Uses do
                            Body[Uses[K]] = string.gsub(Body[Uses[K]], "%f[%w_\128-\255]" .. Copy .. "%f[^%w_\128-\255]", Orig)
                            ReindexRow(WordRows, RowWords, Body, Uses[K])
                        end

                        Dead[Row] = true
                    end
                end
            end

            local function EnclosingLoops(Row)
                local Loops = {}
                local Level = Ind[Row] or 0

                for Up = Row - 1, 1, -1 do
                    if Ind[Up] and Ind[Up] < Level then
                        Level = Ind[Up]

                        if IsLoop[Up] then
                            Loops[#Loops + 1] = Up
                        end
                    end
                end

                return Loops
            end

            local function BlockEnd(Row)
                for X = Row + 1, #Body do
                    if Ind[X] and Ind[X] < (Ind[Row] or 0) then
                        return X - 1
                    end
                end

                return #Body
            end

            local function LiveRows(Name)
                local Rows = {}

                for _, M in ipairs(RowsOf(WordRows[Name])) do
                    if not Dead[M] then
                        Rows[#Rows + 1] = M
                    end
                end

                return Rows
            end

            local function DeclaredInside(Name, Rows, Loop)
                local First = Rows[1]

                if First == Loop then
                    return true
                end

                return First > Loop and LineWrites(Body[First], Name) and (string.find(Body[First], "^ *local ") ~= nil or IsLoop[First])
            end

            local function Substitute(Copy, Orig, Row, Uses)
                for K = 1, #Uses do
                    if Uses[K] ~= Row then
                        Body[Uses[K]] = string.gsub(Body[Uses[K]], "%f[%w_\128-\255]" .. Copy .. "%f[^%w_\128-\255]", Orig)
                        ReindexRow(WordRows, RowWords, Body, Uses[K])
                    end
                end

                Dead[Row] = true
            end

            for Row = 1, #Body do
                local Text = (string.gsub(Body[Row], "^( *)local ", "%1"))
                local Copy, Orig = string.match(Text, "^ *([vV]%d[%w_]*) = ([vV]%d[%w_]*)$")

                if Copy and Copy ~= Orig and not Dead[Row] and not ClosureBody[Row] and not IsUp[Copy] and not IsUp[Orig] and WordRows[Copy] and WordRows[Orig] then
                    local Uses = LiveRows(Copy)
                    local OrigRows = LiveRows(Orig)
                    local OrigReg = tonumber(string.match(Orig, "^[vV](%d+)"))
                    local Loops = EnclosingLoops(Row)

                    if Uses[1] == Row and Uses[#Uses] <= BlockEnd(Row) and not RefRegs[OrigReg] then
                        local Merge = true

                        for _, M in ipairs(OrigRows) do
                            if M > Row or ClosureBody[M] then
                                Merge = false
                                break
                            end
                        end

                        if Merge then
                            for _, Loop in ipairs(Loops) do
                                if not DeclaredInside(Orig, OrigRows, Loop) then
                                    Merge = false
                                    break
                                end
                            end
                        end

                        if Merge then
                            Substitute(Copy, Orig, Row, Uses)
                        else
                            local Immutable = true
                            local Writers = {}

                            for _, M in ipairs(OrigRows) do
                                if LineWrites(Body[M], Orig) then
                                    Writers[#Writers + 1] = M
                                end
                            end

                            for K = 2, #Uses do
                                if LineWrites(Body[Uses[K]], Copy) then
                                    Immutable = false
                                    break
                                end
                            end

                            if #Writers > 1 or (Writers[1] and Writers[1] >= Row) then
                                Immutable = false
                            end

                            if Immutable and Writers[1] then
                                for _, Loop in ipairs(Loops) do
                                    if Writers[1] > Loop and not (Writers[1] == Loop or string.find(Body[Writers[1]], "^ *local ")) then
                                        Immutable = false
                                        break
                                    end
                                end
                            end

                            if Immutable then
                                Substitute(Copy, Orig, Row, Uses)
                            end
                        end
                    end
                end
            end

            local SplitNames = {}

            local function ScanRows(Name)
                local Rows = {}

                for X = 1, #Body do
                    if not Dead[X] and FindWord(Body[X], Name) then
                        Rows[#Rows + 1] = X
                    end
                end

                return Rows
            end

            local function StatementRows(Row)
                local Lead = Ind[Row]
                local End = Row
                local Next = Row + 1

                while Next <= #Body do
                    local NextLead = Ind[Next]

                    if NextLead == nil or NextLead > Lead then
                        End = Next
                    else
                        local NextHead = string.sub(Body[Next], NextLead + 1)

                        if End > Row and NextLead == Lead and (StartsWith(NextHead, "}") or StartsWith(NextHead, ")") or StartsWith(NextHead, "end") and not IsWordAt(NextHead, 4)) then
                            End = Next
                        end

                        break
                    end

                    Next += 1
                end

                return End
            end

            local function IsFreshWrite(Row, Name)
                local Lead = Ind[Row]

                if not Lead or ClosureBody[Row] or Dead[Row] then
                    return false
                end

                local Head = string.gsub(string.sub(Body[Row], Lead + 1), "^local ", "")

                if string.sub(Head, 1, #Name + 3) ~= Name .. " = " then
                    return false
                end

                local Parts = {string.sub(Head, #Name + 4)}

                for X = Row + 1, StatementRows(Row) do
                    Parts[#Parts + 1] = Body[X]
                end

                return not FindWord(table.concat(Parts, "\n"), Name)
            end

            local function IsBranchHead(Text)
                return (StartsWith(Text, "if ") or StartsWith(Text, "elseif ")) and EndsWith(Text, " then") or Text == "else"
            end

            local function IsCloserText(Text)
                if StartsWith(Text, "}") or StartsWith(Text, ")") then
                    return true
                end

                for _, Word in ipairs({"end", "else", "elseif", "until"}) do
                    if StartsWith(Text, Word) and not IsWordAt(Text, #Word + 1) then
                        return true
                    end
                end

                return false
            end

            local function ParentRow(Row)
                for Probe = Row - 1, 1, -1 do
                    if Ind[Probe] and Ind[Probe] < Ind[Row] then
                        return Probe
                    end
                end

                return nil
            end

            local function ChainHead(Row)
                local Lead = Ind[Row]
                local Head = Row

                while true do
                    local Text = string.sub(Body[Head], Lead + 1)

                    if not IsBranchHead(Text) then
                        return nil
                    end

                    if StartsWith(Text, "if ") then
                        return Head
                    end

                    local Found = nil

                    for Probe = Head - 1, 1, -1 do
                        if Ind[Probe] and Ind[Probe] < Lead then
                            return nil
                        end

                        if Ind[Probe] == Lead then
                            Found = Probe
                            break
                        end
                    end

                    if not Found then
                        return nil
                    end

                    Head = Found
                end
            end

            local function ChainFrom(Head)
                local Lead = Ind[Head]
                local Branches = {Head}

                for X = Head + 1, #Body do
                    if Ind[X] == Lead then
                        local Text = string.sub(Body[X], Lead + 1)

                        if (StartsWith(Text, "elseif ") and EndsWith(Text, " then")) or Text == "else" then
                            Branches[#Branches + 1] = X
                        else
                            if string.sub(Body[Branches[#Branches]], Lead + 1) ~= "else" then
                                return nil
                            end

                            return Branches, X
                        end
                    elseif Ind[X] and Ind[X] < Lead then
                        return nil
                    end
                end

                return nil
            end

            local BodyDefines = nil

            local function ChainDefines(Head, Name)
                local Branches, Close = ChainFrom(Head)

                if not Branches then
                    return false
                end

                for K, Branch in ipairs(Branches) do
                    if FindWord(Body[Branch], Name) then
                        return false
                    end

                    if not BodyDefines(Branch + 1, (Branches[K + 1] or Close) - 1, Name) then
                        return false
                    end
                end

                return true
            end

            BodyDefines = function(Start, Stop, Name)
                local BodyLead = nil

                for X = Start, Stop do
                    if Ind[X] then
                        BodyLead = Ind[X]
                        break
                    end
                end

                if not BodyLead then
                    return false
                end

                local X = Start

                while X <= Stop do
                    if Ind[X] == BodyLead and not IsCloserText(string.sub(Body[X], BodyLead + 1)) then
                        if IsFreshWrite(X, Name) then
                            return true
                        end

                        local Text = string.sub(Body[X], BodyLead + 1)
                        local Last = X

                        if StartsWith(Text, "if ") and IsBranchHead(Text) then
                            local Branches, Close = ChainFrom(X)

                            if Branches and ChainDefines(X, Name) then
                                return true
                            end

                            Last = Close or Stop
                        else
                            local Next = X + 1

                            while Next <= Stop and not (Ind[Next] == BodyLead and not IsCloserText(string.sub(Body[Next], BodyLead + 1))) do
                                Next += 1
                            end

                            Last = Next - 1
                        end

                        for Y = X, math.min(Last, Stop) do
                            if not Dead[Y] and FindWord(Body[Y], Name) then
                                return false
                            end
                        end

                        X = Last + 1
                    else
                        X += 1
                    end
                end

                return false
            end

            local function SegmentEnd(First, Orig)
                local Best = nil

                if IsFreshWrite(First, Orig) then
                    Best = BlockEnd(First)
                end

                local Parent = ParentRow(First)

                while Parent and IsBranchHead(string.sub(Body[Parent], Ind[Parent] + 1)) do
                    local Head = ChainHead(Parent)

                    if not Head then
                        break
                    end

                    if ChainDefines(Head, Orig) then
                        Best = BlockEnd(Head)
                    end

                    Parent = ParentRow(Head)
                end

                return Best
            end

            local function TrySplit(Row, Copy, Orig)
                local CopyRows = ScanRows(Copy)

                if CopyRows[1] ~= Row or CopyRows[#CopyRows] > BlockEnd(Row) then
                    return
                end

                for K = 2, #CopyRows do
                    if LineWrites(Body[CopyRows[K]], Copy) then
                        return
                    end
                end

                local OrigRows = LiveRows(Orig)
                local Post = {}

                for _, M in ipairs(OrigRows) do
                    if ClosureBody[M] and M < Row then
                        return
                    end

                    if M > Row then
                        Post[#Post + 1] = M
                    end
                end

                if #Post == 0 then
                    return
                end

                for _, Loop in ipairs(EnclosingLoops(Row)) do
                    local Decl = OrigRows[1]

                    if not (Decl > Loop and Decl < Row and LineWrites(Body[Decl], Orig) and BlockEnd(Decl) >= Row and Ind[Decl] <= Ind[Row]) then
                        return
                    end
                end

                local Segments = {}
                local Cursor = 1

                while Cursor <= #Post do
                    local ScopeEnd = SegmentEnd(Post[Cursor], Orig)

                    if not ScopeEnd then
                        return
                    end

                    local Segment = {}

                    while Cursor <= #Post and Post[Cursor] <= ScopeEnd do
                        Segment[#Segment + 1] = Post[Cursor]
                        Cursor += 1
                    end

                    Segments[#Segments + 1] = Segment
                end

                local OrigReg = tonumber(string.match(Orig, "^[vV](%d+)"))
                local Root = Roots[Orig] or OrigReg

                for _, Segment in ipairs(Segments) do
                    Counts[Root] = (Counts[Root] or 0) + 1
                    local NewName = "V" .. tostring(Root) .. "_" .. tostring(Counts[Root]) .. Suffix
                    SplitNames[#SplitNames + 1] = NewName

                    for _, M in ipairs(Segment) do
                        Body[M] = string.gsub(Body[M], "%f[%w_\128-\255]" .. Orig .. "%f[^%w_\128-\255]", NewName)
                        ReindexRow(WordRows, RowWords, Body, M)
                    end
                end

                for K = 2, #CopyRows do
                    Body[CopyRows[K]] = string.gsub(Body[CopyRows[K]], "%f[%w_\128-\255]" .. Copy .. "%f[^%w_\128-\255]", Orig)
                    ReindexRow(WordRows, RowWords, Body, CopyRows[K])
                end

                Dead[Row] = true
            end

            for Row = 1, #Body do
                if not Dead[Row] and not ClosureBody[Row] then
                    local Text = (string.gsub(Body[Row], "^( *)local ", "%1"))
                    local Copy, Orig = string.match(Text, "^ *([vV]%d[%w_]*) = ([vV]%d[%w_]*)$")

                    if not Copy then
                        Copy, Orig = string.match(Text, "^ *(c%d+_%d+_%d+) = ([vV]%d[%w_]*)$")
                    end

                    if Copy and Copy ~= Orig and not IsUp[Copy] and not IsUp[Orig] and WordRows[Orig] then
                        TrySplit(Row, Copy, Orig)
                    end
                end
            end

            for Row = 1, #Body - 1 do
                local Pad, Temp, Value = string.match(Body[Row], "^( *)([vV]%d[%w_]*) = (.+)$")

                if Temp and not IsUp[Temp] and not Dead[Row] and WordRows[Temp] and not FindWord(Value, Temp) then
                    local Target = string.match(Body[Row + 1], "^" .. Pad .. "([%a_][%w_%.]*) = " .. Temp .. "$")
                    if Target and WordRows[Temp][Row] and WordRows[Temp][Row + 1] then
                        local Count = 0

                        for _ in pairs(WordRows[Temp]) do
                            Count += 1

                            if Count > 2 then
                                break
                            end
                        end

                        if Count == 2 then
                            Body[Row + 1] = Pad .. Target .. " = " .. Value
                            ReindexRow(WordRows, RowWords, Body, Row + 1)
                            Dead[Row] = true
                        end
                    end
                end
            end

            for _, Var in ipairs(Work) do
                local Set = WordRows[Var]
                local Hit = Set and next(Set)

                if Hit and next(Set, Hit) == nil then
                    local Value = string.match(Body[Hit], "^ *local " .. Var .. " = (.+)$") or string.match(Body[Hit], "^ *" .. Var .. " = (.+)$")

                    if Value == "nil" or Value == "true" or Value == "false" or Value ~= nil and string.find(Value, "^%-?%d+%.?%d*$") then
                        Dead[Hit] = true
                    end
                end
            end

            if next(Dead) then
                local Kept = {}

                for Row = 1, #Body do
                    if not Dead[Row] then
                        Kept[#Kept + 1] = Body[Row]
                    end
                end

                Body = Kept
                WordRows, RowWords = BuildWordRows(Body)
            end

            local Spans = {}

            for Row = 1, #Body do
                local Text = Body[Row]
                local Indent, After = string.match(Text, "^( *)for (.+)$")

                if Indent then
                    local Sep = nil
                    local SepLen = 0

                    for P = 2, #After do
                        if string.sub(After, P, P + 2) == " = " then
                            Sep = P
                            SepLen = 3
                            break
                        elseif string.sub(After, P, P + 3) == " in " then
                            Sep = P
                            SepLen = 4
                            break
                        end
                    end

                    if Sep ~= nil then
                        local VarsText = string.sub(After, 1, Sep - 1)
                        local RestText = string.sub(After, Sep + SepLen)
                        local End = nil

                        for X = Row + 1, #Body do
                            if Strip(Body[X]) ~= "" and #Body[X] - #LStrip(Body[X]) <= #Indent then
                                End = X
                                break
                            end
                        end

                        if End ~= nil and Strip(Body[End]) == "end" then
                            for _, Var in ipairs(Split(VarsText, ", ")) do
                                if not FindWord(RestText, Var) then
                                    if not Spans[Var] then
                                        Spans[Var] = {}
                                    end

                                    table.insert(Spans[Var], {Row, End})
                                end
                            end
                        end
                    end
                end
            end

            local RowLead = {}
            local ParentOf = {}
            local IsCloserRow = {}
            local IsBlockRow = {}
            local LoopRow = {}
            local Stack = {}

            for Row = 1, #Body do
                local Text = Body[Row]

                if Strip(Text) ~= "" then
                    local Indent = #Text - #LStrip(Text)
                    local Content = string.sub(Text, Indent + 1)
                    local Head = string.sub(Content, 1, 1)
                    RowLead[Row] = Indent

                    while #Stack > 0 and RowLead[Stack[#Stack]] >= Indent do
                        table.remove(Stack)
                    end

                    ParentOf[Row] = Stack[#Stack] or 0
                    Stack[#Stack + 1] = Row
                    IsCloserRow[Row] = Head == "}" or Head == ")"

                    for _, Word in ipairs({"end", "else", "elseif", "until"}) do
                        if StartsWith(Content, Word) and not IsWordAt(Content, #Word + 1) then
                            IsCloserRow[Row] = true
                        end
                    end

                    IsBlockRow[Row] = Content == "else" or Content == "do" or Content == "repeat" or EndsWith(Content, " then") or EndsWith(Content, " do")
                    LoopRow[Row] = StartsWith(Content, "for ") or StartsWith(Content, "while ") or Content == "repeat"
                end
            end

            local function StmtEnd(Row)
                local Next = Row + 1

                while Next <= #Body and (RowLead[Next] == nil or RowLead[Next] > RowLead[Row] or RowLead[Next] == RowLead[Row] and IsCloserRow[Next]) do
                    Next += 1
                end

                return Next
            end

            local function ReadNames(Row)
                local Text = Body[Row]
                local Position = RowLead[Row] + 1
                local Names = {}
                local Stop = Position

                while true do
                    local WordEnd = Position

                    while IsWordAt(Text, WordEnd) do
                        WordEnd += 1
                    end

                    if WordEnd == Position then
                        break
                    end

                    Names[#Names + 1] = string.sub(Text, Position, WordEnd - 1)
                    Stop = WordEnd

                    if string.sub(Text, WordEnd, WordEnd + 1) == ", " and IsWordAt(Text, WordEnd + 2) then
                        Position = WordEnd + 2
                    else
                        break
                    end
                end

                if #Names > 0 and string.sub(Text, Stop, Stop + 2) == " = " and string.sub(Text, Stop + 3, Stop + 3) ~= "=" then
                    return Names, Stop + 3
                end

                return {}, 0
            end

            local function RestText(Row, From)
                local Parts = {string.sub(Body[Row], From)}

                for X = Row + 1, StmtEnd(Row) - 1 do
                    Parts[#Parts + 1] = Body[X]
                end

                return table.concat(Parts, "\n")
            end

            local function IsPureWrite(Var, Row)
                local Names, From = ReadNames(Row)

                return ListHas(Names, Var) and not FindWord(RestText(Row, From), Var)
            end

            local DefAssigned

            DefAssigned = function(Var, Block)
                for Row = Block + 1, #Body do
                    if RowLead[Row] == nil then
                        continue
                    end

                    if RowLead[Row] <= RowLead[Block] then
                        break
                    end

                    if ParentOf[Row] ~= Block or IsCloserRow[Row] then
                        continue
                    end

                    local Last = StmtEnd(Row) - 1
                    local Mentioned = false

                    for X = Row, Last do
                        if FindWord(Body[X], Var) then
                            Mentioned = true
                            break
                        end
                    end

                    if not Mentioned then
                        continue
                    end

                    if IsPureWrite(Var, Row) then
                        return true
                    end

                    local Content = string.sub(Body[Row], RowLead[Row] + 1)

                    if Content == "do" then
                        return DefAssigned(Var, Row)
                    end

                    if not StartsWith(Content, "if ") then
                        return false
                    end

                    local Branches = {}
                    local HasElse = false

                    for X = Row, Last do
                        if ParentOf[X] == Block then
                            local Line = string.sub(Body[X], RowLead[X] + 1)

                            if Line == "else" then
                                HasElse = true
                                Branches[#Branches + 1] = X
                            elseif (StartsWith(Line, "if ") or StartsWith(Line, "elseif ")) and IsBlockRow[X] then
                                if FindWord(Line, Var) then
                                    return false
                                end

                                Branches[#Branches + 1] = X
                            elseif Line ~= "end" then
                                return false
                            end
                        end
                    end

                    if not HasElse then
                        return false
                    end

                    for _, Branch in ipairs(Branches) do
                        if not DefAssigned(Var, Branch) then
                            return false
                        end
                    end

                    return true
                end

                return false
            end

            local function IsAncestor(Ancestor, Row)
                while Row > Ancestor do
                    Row = ParentOf[Row]
                end

                return Row == Ancestor
            end

            local function ScopeOf(Var, Rows)
                local Scope = ParentOf[Rows[1]]

                for K = 2, #Rows do
                    local Parent = ParentOf[Rows[K]]

                    while not IsAncestor(Scope, Parent) do
                        Scope = ParentOf[Scope]
                    end
                end

                local Bad = nil
                local Cur = Scope

                while Cur ~= 0 do
                    if not IsBlockRow[Cur] then
                        Bad = Cur
                    end

                    Cur = ParentOf[Cur]
                end

                if Bad then
                    Scope = ParentOf[Bad]
                end

                local Loop = nil
                Cur = Scope

                while Cur ~= 0 do
                    if LoopRow[Cur] then
                        Loop = Cur
                    end

                    Cur = ParentOf[Cur]
                end

                if Loop and not DefAssigned(Var, Scope) then
                    Scope = ParentOf[Loop]
                end

                return Scope
            end

            local Groups = {}

            local DeclVars = {}

            for _, R in ipairs(SortedIds(Used)) do
                if Proto.NumParams <= R and R < 1000 then
                    DeclVars[#DeclVars + 1] = "v" .. tostring(R) .. Suffix
                end
            end

            for _, Extra in ipairs(SplitNames) do
                DeclVars[#DeclVars + 1] = Extra
            end

            for _, Var in ipairs(DeclVars) do
                local Rows = {}

                for _, Row in ipairs(RowsOf(WordRows[Var])) do
                    local Inside = false

                    for _, Span in ipairs(Spans[Var] or {}) do
                        if Span[1] <= Row and Row <= Span[2] then
                            Inside = true
                            break
                        end
                    end

                    if not Inside then
                        Rows[#Rows + 1] = Row
                    end
                end

                if #Rows > 0 then
                    local Scope = ScopeOf(Var, Rows)
                    local Stmt = Rows[1]

                    while ParentOf[Stmt] ~= Scope do
                        Stmt = ParentOf[Stmt]
                    end

                    while IsCloserRow[Stmt] do
                        repeat
                            Stmt -= 1
                        until ParentOf[Stmt] == Scope
                    end

                    if not Groups[Stmt] then
                        Groups[Stmt] = {}
                    end

                    table.insert(Groups[Stmt], Var)
                end
            end

            local function AliasRisk(Var, Row, Rest)
                local Rhs = Strip(Rest)

                if not string.match(Rhs, "^[%a_][%w_]*$") or string.match(Rhs, "^[vVcC]%d+[%w_]*$") or Rhs == "nil" or Rhs == "true" or Rhs == "false" then
                    return false
                end

                for X = Row + 1, #Body do
                    if RowLead[X] ~= nil and ListHas(ReadNames(X), Var) then
                        return true
                    end
                end

                return false
            end

            local Out = {}

            for Row = 1, #Body do
                local Text = Body[Row]
                local Vars = Groups[Row]

                if not Vars then
                    Out[#Out + 1] = Text
                else
                    local Pad = string.rep(" ", RowLead[Row])
                    local Names, From = ReadNames(Row)
                    local Targets = {}

                    if #Names > 0 then
                        local Rest = RestText(Row, From)
                        local VarSet = SetFrom(Vars)
                        local Ok2 = SetCount(SetFrom(Names)) == #Names

                        for _, T in ipairs(Names) do
                            if not VarSet[T] or FindWord(Rest, T) or AliasRisk(T, Row, Rest) then
                                Ok2 = false
                                break
                            end
                        end

                        if Ok2 then
                            Targets = Names
                        end
                    end

                    local TargetSet2 = SetFrom(Targets)
                    local Pending = {}

                    for _, V in ipairs(Vars) do
                        if not TargetSet2[V] then
                            Pending[#Pending + 1] = V
                        end
                    end

                    for K = 1, #Pending, 20 do
                        Out[#Out + 1] = Pad .. "local " .. table.concat(Pending, ", ", K, math.min(K + 19, #Pending))
                    end

                    if #Targets > 0 then
                        Out[#Out + 1] = Pad .. "local " .. string.sub(Text, RowLead[Row] + 1)
                    else
                        Out[#Out + 1] = Text
                    end
                end
            end

            local ParamList = ListCopy(Params)

            if Proto.IsVarArg then
                ParamList[#ParamList + 1] = "..."
            end

            return {ParamList, table.concat(Out, "\n")}
        end)

        if type(Value) == "table" then
            Result = Value
        else
            Error = Value
            Result = nil
        end

        if Result ~= nil then
            break
        end
    end

    if Result == nil then
        local Message = tostring(Error)

        if string.find(Message, "stack overflow", 1, true) then
            Message = "maximum recursion depth exceeded"
        end

        Message = string.gsub(Message, '"', "'")

        if Depth == 0 then
            return "decompile failed: " .. Message, false
        end

        Result = {{}, "-- decompile failed: " .. Message}
    end

    if Depth == 0 then
        return Result[2]
    end

    local BodyText = " "

    if Result[2] ~= "" then
        BodyText = "\n" .. RecIndent(Result[2], 1) .. "\n"
    end

    local DebugName = string.match(Data.Source, "^[%a_][%w_]*$")

    return "function(" .. table.concat(Result[1], ", ") .. ")" .. (DebugName and "--[[dn:" .. DebugName .. "]]" or "") .. BodyText .. "end"
end

local function Decompile(Bytecode)
    local Ok, Value, Succeeded = pcall(function()
        if #Bytecode == 0 then
            return "Reconstruct failed: index out of range", false
        end

        if string.byte(Bytecode, 1) == 0 then
            return DecodeUtf8(string.sub(Bytecode, 2))
        end

        local LuauVersion = nil
        local TypesVersion = nil
        local ProtoTable = {}
        local MainProto = nil
        local StringTable = {}

        local DeserOk, DeserError = pcall(function()
            Buf = Bytecode
            Offset = 0
            CurrentBufferLen = #Buf
            LuauVersion = NextByte()

            if LuauVersion < 1 or LuauVersion > 14 or LuauVersion == 10 then
                return "Unsupported bytecode version: " .. tostring(LuauVersion)
            end

            TypesVersion = 0

            if LuauVersion >= 4 then
                TypesVersion = NextByte()

                if TypesVersion ~= 1 and TypesVersion ~= 2 and TypesVersion ~= 3 then
                    return "Invalid types version (types version: " .. tostring(TypesVersion) .. ")"
                end
            end

            local SizeStrings = NextVarInt()

            for I = 1, SizeStrings do
                local Length = NextVarInt()
                CheckRead(Length, string.format("Attempted to read string of length %d", Length))
                StringTable[I] = DecodeUtf8(string.sub(Buf, Offset + 1, Offset + Length))
                Offset += Length
            end

            if TypesVersion >= 3 then
                while NextByte() ~= 0 do
                end
            end

            local SizeProtos = NextVarInt()

            for I = 0, SizeProtos - 1 do
                ProtoTable[I + 1] = {
                    CodeTable = {},
                    KTable = {},
                    PTable = {},
                    LineInfoCompKey = 0,
                    Locals = {},
                    UpvalNames = {},
                    ProtoIndex = I,
                }
            end

            for _, Proto in ipairs(ProtoTable) do
                local ProtoEnd = nil

                if LuauVersion >= 12 then
                    ProtoEnd = NextVarInt()
                    ProtoEnd = Offset + ProtoEnd
                end

                Proto.MaxStackSize = NextByte()
                Proto.NumParams = NextByte()
                Proto.NumUpvalues = NextByte()
                Proto.IsVarArg = NextByte() ~= 0
                Proto.Flags = 0
                Proto.TypeInfo = {}

                if LuauVersion >= 4 then
                    Proto.Flags = NextByte()
                    local TypeSize = NextVarInt()

                    for _ = 1, TypeSize do
                        Proto.TypeInfo[#Proto.TypeInfo + 1] = NextByte()
                    end
                end

                Proto.SizeCode = NextVarInt()
                Proto.CodeTable = {}

                for _ = 1, Proto.SizeCode do
                    Proto.CodeTable[#Proto.CodeTable + 1] = NextUint32()
                end

                Proto.SizeConsts = NextVarInt()
                Proto.KTable = {}

                for I = 1, Proto.SizeConsts do
                    local K = {Type = NextByte()}

                    if K.Type == 1 then
                        K.Value = NextByte() == 1
                    elseif K.Type == 2 then
                        CheckRead(8, "Attempted to read 8 bytes for Float64")
                        K.Value = string.unpack("<d", Buf, Offset + 1)
                        Offset += 8
                    elseif K.Type == 3 then
                        local Index = NextVarInt()
                        K.Value = StringTable[Index] or "Invalid string index"
                    elseif K.Type == 4 then
                        K.Value = NextUint32()
                    elseif K.Type == 5 then
                        local SizeKey = NextVarInt()
                        local Keys = {}

                        for _ = 1, SizeKey do
                            Keys[#Keys + 1] = NextVarInt() + 1
                        end

                        K.Value = {Size = SizeKey, Ids = Keys}
                    elseif K.Type == 6 then
                        K.Value = NextVarInt()
                    elseif K.Type == 8 then
                        local SizeKey = NextVarInt()
                        local Keys = {}
                        local Values = {}

                        for _ = 1, SizeKey do
                            Keys[#Keys + 1] = NextVarInt() + 1
                            Values[#Values + 1] = NextInt()
                        end

                        K.Value = {Size = SizeKey, Ids = Keys, Values = Values}
                    elseif K.Type == 9 then
                        K.Negative = NextByte() ~= 0
                        K.Value = NextVarIntDecimal()
                    elseif K.Type == 7 then
                        local Vec = {}

                        for _ = 1, 4 do
                            CheckRead(4, "Attempted to read 4 bytes for Float32")
                            Vec[#Vec + 1] = string.unpack("<f", Buf, Offset + 1)
                            Offset += 4
                        end

                        K.Value = Vec
                    elseif K.Type ~= 0 then
                        return "Unrecognized constant type: " .. tostring(K.Type)
                    end

                    Proto.KTable[I] = K
                end

                Proto.SizeProtos = NextVarInt()
                Proto.PTable = {}

                for _ = 1, Proto.SizeProtos do
                    local Child = ProtoTable[NextVarInt() + 1]

                    if Child == nil then
                        return "list index out of range"
                    end

                    Proto.PTable[#Proto.PTable + 1] = Child
                end

                Proto.LineDefined = 0

                if LuauVersion >= 2 then
                    Proto.LineDefined = NextVarInt()
                end

                Proto.Source = StringTable[NextVarInt()] or "Invalid source index"

                if NextByte() == 1 then
                    Proto.LineInfoCompKey = NextByte()
                    local LineInterval = 2 ^ Proto.LineInfoCompKey
                    local SmallLineInfo = {}
                    local LastOffset = 0

                    for _ = 1, Proto.SizeCode do
                        LastOffset = (LastOffset + NextByte()) % 256
                        SmallLineInfo[#SmallLineInfo + 1] = LastOffset
                    end

                    local Intervals = (Proto.SizeCode - 1) // LineInterval + 1
                    local LargeLineInfo = {}
                    local LastLine = 0

                    for _ = 1, Intervals do
                        LastLine = LastLine + NextInt()
                        LargeLineInfo[#LargeLineInfo + 1] = LastLine
                    end

                    Proto.InstructionLines = {}

                    for Pc = 0, Proto.SizeCode - 1 do
                        Proto.InstructionLines[#Proto.InstructionLines + 1] = LargeLineInfo[Pc // LineInterval + 1] + SmallLineInfo[Pc + 1]
                    end
                else
                    Proto.InstructionLines = nil
                end

                if NextByte() == 1 then
                    local SizeLocals = NextVarInt()
                    Proto.Locals = {}

                    for _ = 1, SizeLocals do
                        local LocalName = StringTable[NextVarInt()] or "invalid_local_name"
                        local StartPC = NextVarInt()
                        local EndPC = NextVarInt()
                        local Register = NextByte()
                        Proto.Locals[#Proto.Locals + 1] = {Name = LocalName, StartPC = StartPC, EndPC = EndPC, Register = Register}
                    end

                    local SizeUpvals = NextVarInt()
                    Proto.UpvalNames = {}

                    for _ = 1, SizeUpvals do
                        Proto.UpvalNames[#Proto.UpvalNames + 1] = StringTable[NextVarInt()] or "invalid_upval_name"
                    end
                end

                if LuauVersion == 11 then
                    for _ = 1, NextVarInt() do
                        NextVarInt()
                        NextVarInt()
                    end
                end

                if ProtoEnd ~= nil then
                    Offset = ProtoEnd
                end
            end

            local MainProtoId = NextVarInt() + 1

            if MainProtoId > #ProtoTable then
                return "Index " .. tostring(MainProtoId) .. " out of range for ProtoTable with length " .. tostring(#ProtoTable)
            end

            MainProto = ProtoTable[MainProtoId]
        end)

        if not DeserOk or DeserError ~= nil then
            return "Reconstruct failed: Failed to deserialize bytecode: " .. tostring(DeserError), false
        end

        local PlainVotes = 0
        local EncodedVotes = 0

        for _, Proto in ipairs(ProtoTable) do
            if Proto.SizeCode > 0 then
                local LastByte = bit32.band(Proto.CodeTable[Proto.SizeCode], 0xFF)

                if LastByte == 22 then
                    PlainVotes += 1
                elseif LastByte == 130 then
                    EncodedVotes += 1
                end
            end
        end

        OpcodeIsPlain = PlainVotes > EncodedVotes

        local DisassembledProtos = {}
        local MainProtoData = nil

        for _, Proto in ipairs(ProtoTable) do
            local ProcessedProto = ReadProto(Proto)
            DisassembledProtos[#DisassembledProtos + 1] = ProcessedProto

            if Proto == MainProto then
                MainProtoData = ProcessedProto
            end
        end

        local Module = {
            MainProto = MainProtoData,
            Protos = DisassembledProtos,
            ProtoCount = #ProtoTable,
            LuauVersion = LuauVersion,
            TypesVersion = TypesVersion,
            StringTable = StringTable,
        }

        return RecFunctionText(Module, Module.MainProto, {}, 0)
    end)

    if not Ok then
        return "Reconstruct failed: " .. tostring(Value), false
    end

    return Value, Succeeded ~= false
end

local Keywords = {
    ["and"] = true,
    ["break"] = true,
    ["continue"] = true,
    ["do"] = true,
    ["else"] = true,
    ["elseif"] = true,
    ["end"] = true,
    ["false"] = true,
    ["for"] = true,
    ["function"] = true,
    ["if"] = true,
    ["in"] = true,
    ["local"] = true,
    ["nil"] = true,
    ["not"] = true,
    ["or"] = true,
    ["repeat"] = true,
    ["return"] = true,
    ["self"] = true,
    ["then"] = true,
    ["true"] = true,
    ["until"] = true,
    ["while"] = true,
}

local LibMethods = {
    ["math.random"] = "MathRandom",
    ["math.randomseed"] = "MathRandomSeed",
    ["math.floor"] = "MathFloor",
    ["math.ceil"] = "MathCeil",
    ["math.abs"] = "MathAbs",
    ["math.clamp"] = "MathClamp",
    ["math.min"] = "MathMin",
    ["math.max"] = "MathMax",
    ["math.rad"] = "MathRad",
    ["math.deg"] = "MathDeg",
    ["math.sqrt"] = "MathSqrt",
    ["math.sin"] = "MathSin",
    ["math.cos"] = "MathCos",
    ["math.tan"] = "MathTan",
    ["math.asin"] = "MathAsin",
    ["math.acos"] = "MathAcos",
    ["math.atan"] = "MathAtan",
    ["math.atan2"] = "MathAtan2",
    ["math.sinh"] = "MathSinh",
    ["math.cosh"] = "MathCosh",
    ["math.tanh"] = "MathTanh",
    ["math.log"] = "MathLog",
    ["math.log10"] = "MathLog10",
    ["math.exp"] = "MathExp",
    ["math.pow"] = "MathPow",
    ["math.frexp"] = "MathFrexp",
    ["math.ldexp"] = "MathLdexp",
    ["math.modf"] = "MathModf",
    ["math.fmod"] = "MathFmod",
    ["math.noise"] = "MathNoise",
    ["math.round"] = "MathRound",
    ["math.sign"] = "MathSign",
    ["math.lerp"] = "MathLerp",
    ["math.map"] = "MathMap",
    ["math.huge"] = "MathHuge",
    ["math.pi"] = "MathPi",
    ["math.nan"] = "MathNaN",
    ["table.insert"] = "TableInsert",
    ["table.remove"] = "TableRemove",
    ["table.concat"] = "TableConcat",
    ["table.find"] = "TableFind",
    ["table.sort"] = "TableSort",
    ["table.unpack"] = "TableUnpack",
    ["table.pack"] = "TablePack",
    ["table.create"] = "TableCreate",
    ["table.clear"] = "TableClear",
    ["table.clone"] = "TableClone",
    ["table.freeze"] = "TableFreeze",
    ["table.isfrozen"] = "TableIsFrozen",
    ["table.maxn"] = "TableMaxN",
    ["table.move"] = "TableMove",
    ["table.foreach"] = "TableForeach",
    ["table.foreachi"] = "TableForeachi",
    ["table.getn"] = "TableGetN",
    ["string.format"] = "StringFormat",
    ["string.sub"] = "StringSub",
    ["string.upper"] = "StringUpper",
    ["string.lower"] = "StringLower",
    ["string.rep"] = "StringRep",
    ["string.split"] = "StringSplit",
    ["string.gsub"] = "StringGsub",
    ["string.match"] = "StringMatch",
    ["string.find"] = "StringFind",
    ["string.gmatch"] = "StringGmatch",
    ["string.len"] = "StringLen",
    ["string.byte"] = "StringByte",
    ["string.char"] = "StringChar",
    ["string.reverse"] = "StringReverse",
    ["string.pack"] = "StringPack",
    ["string.unpack"] = "StringUnpack",
    ["string.packsize"] = "StringPackSize",
    ["string.dump"] = "StringDump",
    ["task.wait"] = "TaskWait",
    ["task.spawn"] = "TaskSpawn",
    ["task.delay"] = "TaskDelay",
    ["task.defer"] = "TaskDefer",
    ["task.cancel"] = "TaskCancel",
    ["task.synchronize"] = "TaskSync",
    ["task.desynchronize"] = "TaskDesync",
    ["coroutine.create"] = "CoroutineCreate",
    ["coroutine.resume"] = "CoroutineResume",
    ["coroutine.yield"] = "CoroutineYield",
    ["coroutine.status"] = "CoroutineStatus",
    ["coroutine.wrap"] = "CoroutineWrap",
    ["coroutine.running"] = "CoroutineRunning",
    ["coroutine.isyieldable"] = "CoroutineIsYieldable",
    ["coroutine.close"] = "CoroutineClose",
    ["os.time"] = "OsTime",
    ["os.date"] = "OsDate",
    ["os.clock"] = "OsClock",
    ["os.difftime"] = "OsDiffTime",
    ["os.getenv"] = "OsGetEnv",
    ["utf8.char"] = "Utf8Char",
    ["utf8.codepoint"] = "Utf8CodePoint",
    ["utf8.len"] = "Utf8Len",
    ["utf8.offset"] = "Utf8Offset",
    ["utf8.codes"] = "Utf8Codes",
    ["utf8.graphemes"] = "Utf8Graphemes",
    ["bit32.band"] = "Bit32Band",
    ["bit32.bor"] = "Bit32Bor",
    ["bit32.bxor"] = "Bit32Bxor",
    ["bit32.bnot"] = "Bit32Bnot",
    ["bit32.lshift"] = "Bit32LShift",
    ["bit32.rshift"] = "Bit32RShift",
    ["bit32.arshift"] = "Bit32ArShift",
    ["bit32.lrotate"] = "Bit32LRotate",
    ["bit32.rrotate"] = "Bit32RRotate",
    ["bit32.btest"] = "Bit32BTest",
    ["bit32.extract"] = "Bit32Extract",
    ["bit32.replace"] = "Bit32Replace",
    ["bit32.countlz"] = "Bit32CountLZ",
    ["bit32.countrz"] = "Bit32CountRZ",
    ["debug.traceback"] = "DebugTraceback",
    ["debug.info"] = "DebugInfo",
    ["debug.getinfo"] = "DebugGetInfo",
    ["debug.profilebegin"] = "DebugProfileBegin",
    ["debug.profileend"] = "DebugProfileEnd",
    ["debug.getmemorycategory"] = "DebugGetMemoryCategory",
    ["debug.setmemorycategory"] = "DebugSetMemoryCategory",
    ["debug.resetmemorycategory"] = "DebugResetMemoryCategory",
    ["debug.upvalues"] = "DebugUpvalues",
    ["debug.getupvalue"] = "DebugGetUpvalue",
    ["debug.setupvalue"] = "DebugSetUpvalue",
    ["debug.getlocal"] = "DebugGetLocal",
    ["debug.setlocal"] = "DebugSetLocal",
    ["debug.getregistry"] = "DebugGetRegistry",
    ["debug.getmetatable"] = "DebugGetMetatable",
    ["debug.setmetatable"] = "DebugSetMetatable",
    ["debug.getfenv"] = "DebugGetFenv",
    ["debug.setfenv"] = "DebugSetFenv",
    ["debug.sethook"] = "DebugSetHook",
    ["debug.gethook"] = "DebugGetHook",
    ["debug.debug"] = "DebugDebug",
    ["debug.getuservalue"] = "DebugGetUserValue",
    ["debug.setuservalue"] = "DebugSetUserValue",
    ["buffer.create"] = "BufferCreate",
    ["buffer.fromstring"] = "BufferFromString",
    ["buffer.tostring"] = "BufferToString",
    ["buffer.len"] = "BufferLen",
    ["buffer.copy"] = "BufferCopy",
    ["buffer.fill"] = "BufferFill",
    ["buffer.readi8"] = "BufferReadI8",
    ["buffer.readu8"] = "BufferReadU8",
    ["buffer.readi16"] = "BufferReadI16",
    ["buffer.readu16"] = "BufferReadU16",
    ["buffer.readi32"] = "BufferReadI32",
    ["buffer.readu32"] = "BufferReadU32",
    ["buffer.readf32"] = "BufferReadF32",
    ["buffer.readf64"] = "BufferReadF64",
    ["buffer.writei8"] = "BufferWriteI8",
    ["buffer.writeu8"] = "BufferWriteU8",
    ["buffer.writei16"] = "BufferWriteI16",
    ["buffer.writeu16"] = "BufferWriteU16",
    ["buffer.writei32"] = "BufferWriteI32",
    ["buffer.writeu32"] = "BufferWriteU32",
    ["buffer.writef32"] = "BufferWriteF32",
    ["buffer.writef64"] = "BufferWriteF64",
    ["vector.create"] = "VectorCreate",
    ["vector.magnitude"] = "VectorMagnitude",
    ["vector.normalize"] = "VectorNormalize",
    ["vector.cross"] = "VectorCross",
    ["vector.dot"] = "VectorDot",
    ["vector.angle"] = "VectorAngle",
    ["vector.floor"] = "VectorFloor",
    ["vector.ceil"] = "VectorCeil",
    ["vector.abs"] = "VectorAbs",
    ["vector.sign"] = "VectorSign",
    ["vector.clamp"] = "VectorClamp",
    ["vector.min"] = "VectorMin",
    ["vector.max"] = "VectorMax",
    ["vector.zero"] = "VectorZero",
    ["vector.one"] = "VectorOne",
    ["vector.xAxis"] = "VectorXAxis",
    ["vector.yAxis"] = "VectorYAxis",
    ["vector.zAxis"] = "VectorZAxis",
    ["json.encode"] = "JsonEncode",
    ["json.decode"] = "JsonDecode",
    ["bit.band"] = "BitBand",
    ["bit.bor"] = "BitBor",
    ["bit.bxor"] = "BitBxor",
    ["bit.bnot"] = "BitBnot",
    ["bit.lshift"] = "BitLShift",
    ["bit.rshift"] = "BitRShift",
    ["bit.arshift"] = "BitArShift",
    ["bit.rol"] = "BitRol",
    ["bit.ror"] = "BitRor",
    ["bit.bswap"] = "BitBswap",
    ["bit.tohex"] = "BitToHex",
    ["WebSocket.connect"] = "Socket",
    ["base64.decode"] = "Decoded",
    ["base64.encode"] = "Encoded",
    ["bit.bdiv"] = "BitBdiv",
    ["bit.bmul"] = "BitBmul",
    ["bit.bsub"] = "BitBsub",
    ["bit.byteswap"] = "BitByteSwap",
    ["bit.countlz"] = "BitCountLz",
    ["bit.countrz"] = "BitCountRz",
    ["bit.extract"] = "BitExtract",
    ["bit.lrotate"] = "BitLRotate",
    ["bit.nadd"] = "BitNadd",
    ["bit.replace"] = "BitReplace",
    ["bit.rrotate"] = "BitRRotate",
    ["bit.tobit"] = "BitToBit",
    ["crypt.base64_decode"] = "Decoded",
    ["crypt.base64_encode"] = "Encoded",
    ["crypt.base64decode"] = "Decoded",
    ["crypt.base64encode"] = "Encoded",
    ["crypt.decrypt"] = "Decrypted",
    ["crypt.encrypt"] = "Encrypted",
    ["crypt.generatebytes"] = "Bytes",
    ["crypt.generatekey"] = "Key",
    ["crypt.hash"] = "Hash",
    ["crypt.hmac"] = "Hmac",
    ["crypt.lz4compress"] = "Compressed",
    ["crypt.lz4decompress"] = "Decompressed",
    ["crypt.random"] = "Random",
    ["debug.getcallstack"] = "CallStack",
    ["debug.getconstant"] = "Constant",
    ["debug.getconstants"] = "Constants",
    ["debug.getproto"] = "Proto",
    ["debug.getprotos"] = "Protos",
    ["debug.getstack"] = "Stack",
    ["debug.getupvalues"] = "Upvalues",
    ["debug.loadmodule"] = "Module",
    ["fluxus.request"] = "Request",
    ["http.request"] = "Request",
    ["oth.get_original_thread"] = "OriginalThread",
    ["oth.get_root_callback"] = "RootCallback",
    ["oth.hook"] = "Original",
    ["syn.request"] = "Request",
}

local GlobalFunctions = {
    ["pcall"] = "PcallOk",
    ["xpcall"] = "XpcallOk",
    ["assert"] = "Asserted",
    ["type"] = "TypeName",
    ["typeof"] = "TypeName",
    ["tostring"] = "ToString",
    ["tonumber"] = "ToNumber",
    ["ipairs"] = "IPairsIterator",
    ["pairs"] = "PairsIterator",
    ["next"] = "NextItem",
    ["select"] = "Selected",
    ["unpack"] = "Unpacked",
    ["rawget"] = "RawValue",
    ["rawset"] = "RawTable",
    ["rawequal"] = "RawEqual",
    ["rawlen"] = "RawLength",
    ["getmetatable"] = "Metatable",
    ["setmetatable"] = "WithMetatable",
    ["newproxy"] = "NewProxy",
    ["require"] = "Module",
    ["collectgarbage"] = "Collected",
    ["loadstring"] = "LoadedFunction",
    ["load"] = "LoadedFunction",
    ["getfenv"] = "Fenv",
    ["setfenv"] = "SetFenv",
    ["getgenv"] = "Genv",
    ["getsenv"] = "ScriptEnv",
    ["getrenv"] = "RobloxEnv",
    ["getreg"] = "Registry",
    ["getmenv"] = "ModuleEnv",
    ["error"] = "ErrorMessage",
    ["tick"] = "Now",
    ["time"] = "GameTime",
    ["elapsedTime"] = "Elapsed",
    ["wait"] = "Elapsed",
    ["spawn"] = "Thread",
    ["delay"] = "Thread",
    ["settings"] = "GlobalSettings",
    ["stats"] = "StatsService",
    ["print"] = "Printed",
    ["warn"] = "Warned",
    ["IsA"] = "IsType",
    ["writefile"] = "WriteFile",
    ["readfile"] = "ReadFile",
    ["appendfile"] = "AppendFile",
    ["makefolder"] = "MakeFolder",
    ["delfile"] = "DeleteFile",
    ["delfolder"] = "DeleteFolder",
    ["listfiles"] = "ListFiles",
    ["isfile"] = "IsFile",
    ["isfolder"] = "IsFolder",
    ["loadfile"] = "LoadFile",
    ["dofile"] = "DoFile",
    ["getupvalue"] = "Upvalue",
    ["getupvalues"] = "Upvalues",
    ["setupvalue"] = "SetUpvalue",
    ["upvalues"] = "UpvalueList",
    ["getrawmetatable"] = "RawMetatable",
    ["setrawmetatable"] = "SetRawMetatable",
    ["hookfunction"] = "HookFunction",
    ["hookmetamethod"] = "HookMetamethod",
    ["getnamecallmethod"] = "NamecallMethod",
    ["setnamecallmethod"] = "SetNamecallMethod",
    ["checkcaller"] = "CheckCaller",
    ["islclosure"] = "IsLClosure",
    ["iscclosure"] = "IsCClosure",
    ["newcclosure"] = "NewCClosure",
    ["clonefunction"] = "CloneFunction",
    ["restorefunction"] = "RestoreFunction",
    ["getfunctionhash"] = "FunctionHash",
    ["getconstant"] = "Constant",
    ["getconstants"] = "Constants",
    ["getgc"] = "GC",
    ["getinstances"] = "Instances",
    ["getnilinstances"] = "NilInstances",
    ["getscripts"] = "Scripts",
    ["getloadedmodules"] = "LoadedModules",
    ["getrunningscripts"] = "RunningScripts",
    ["fireclickdetector"] = "FireClickDetector",
    ["firetouchinterest"] = "FireTouchInterest",
    ["fireproximityprompt"] = "FireProximityPrompt",
    ["firesignal"] = "FireSignal",
    ["getconnections"] = "Connections",
    ["getcustomasset"] = "CustomAsset",
    ["getcallbackvalue"] = "CallbackValue",
    ["getrenderstepped"] = "RenderStepped",
    ["getheartbeat"] = "Heartbeat",
    ["getstepped"] = "Stepped",
    ["identifyexecutor"] = "IdentifyExecutor",
    ["getexecutorname"] = "ExecutorName",
    ["getscriptbytecode"] = "ScriptBytecode",
    ["getscripthash"] = "ScriptHash",
    ["getscriptclosure"] = "ScriptClosure",
    ["getscriptfromthread"] = "ScriptFromThread",
    ["request"] = "Response",
    ["httprequest"] = "HttpRequest",
    ["synrequest"] = "SynRequest",
    ["setclipboard"] = "SetClipboard",
    ["toclipboard"] = "ToClipboard",
    ["mouse1click"] = "Mouse1Click",
    ["mouse1press"] = "Mouse1Press",
    ["mouse1release"] = "Mouse1Release",
    ["mouse2click"] = "Mouse2Click",
    ["mouse2press"] = "Mouse2Press",
    ["mouse2release"] = "Mouse2Release",
    ["mousemoveabs"] = "MouseMoveAbs",
    ["mousemoverel"] = "MouseMoveRel",
    ["mousescroll"] = "MouseScroll",
    ["keypress"] = "KeyPress",
    ["keyrelease"] = "KeyRelease",
    ["keytap"] = "KeyTap",
    ["iskeydown"] = "IsKeyDown",
    ["iskeypressed"] = "IsKeyPressed",
    ["getmouseposition"] = "MousePosition",
    ["getmousestate"] = "MouseState",
    ["setfflag"] = "SetFFlag",
    ["getfflag"] = "FFlag",
    ["getthreadidentity"] = "ThreadIdentity",
    ["setthreadidentity"] = "SetThreadIdentity",
    ["getidentity"] = "Identity",
    ["setidentity"] = "SetIdentity",
    ["getcallingscript"] = "CallingScript",
    ["decompile"] = "Source",
    ["setreadonly"] = "SetReadOnly",
    ["isreadonly"] = "IsReadOnly",
    ["isexecutorclosure"] = "IsExecutorClosure",
    ["isexecutor"] = "IsExecutor",
    ["getactors"] = "Actors",
    ["gethui"] = "Hui",
    ["getimmersivemode"] = "ImmersiveMode",
    ["setimmersivemode"] = "SetImmersiveMode",
    ["isrenderobj"] = "IsRenderObj",
    ["getrenderproperty"] = "RenderProperty",
    ["setrenderproperty"] = "SetRenderProperty",
    ["cleardrawcache"] = "ClearDrawCache",
    ["drawingnew"] = "DrawingNew",
    ["getscriptsource"] = "ScriptSource",
    ["getmenv2"] = "ModuleEnv2",
    ["getscriptthread"] = "ScriptThread",
    ["getthreads"] = "Threads",
    ["getproperties"] = "Properties",
    ["getattributes"] = "Attributes",
    ["getsignals"] = "Signals",
    ["getprotos"] = "Protos",
    ["getupvals"] = "Upvalues",
    ["getrawproperty"] = "RawProperty",
    ["setrawproperty"] = "SetRawProperty",
    ["gethiddenproperty"] = "HiddenProperty",
    ["sethiddenproperty"] = "SetHiddenProperty",
    ["setcallbackvalue"] = "SetCallbackValue",
    ["writecustomasset"] = "WriteCustomAsset",
    ["base64_decode"] = "Decoded",
    ["base64_encode"] = "Encoded",
    ["base64decode"] = "Decoded",
    ["base64encode"] = "Encoded",
    ["checkclosure"] = "IsExecutorClosure",
    ["clonefunc"] = "CloneFunction",
    ["cloneref"] = "Clone",
    ["clonereference"] = "Clone",
    ["consoleinput"] = "Input",
    ["copyfunction"] = "CloneFunction",
    ["create_comm_channel"] = "CommChannel",
    ["deletefile"] = "DeleteFile",
    ["deletefolder"] = "DeleteFolder",
    ["detour_function"] = "HookFunction",
    ["detourfunction"] = "HookFunction",
    ["dumpbytecode"] = "GetScriptBytecode",
    ["dumpstring"] = "GetScriptBytecode",
    ["filter_gc"] = "Filtered",
    ["filtergc"] = "Filtered",
    ["get_actors"] = "Actors",
    ["get_callback_value"] = "CallbackValue",
    ["get_calling_script"] = "CallingScript",
    ["get_clipboard"] = "Clipboard",
    ["get_comm_channel"] = "CommChannel",
    ["get_current_actor"] = "CurrentActor",
    ["get_deleted_actors"] = "DeletedActors",
    ["get_destroyed_actors"] = "DestroyedActors",
    ["get_fps_cap"] = "FpsCap",
    ["get_gc_objects"] = "GC",
    ["get_hidden_gui"] = "Hui",
    ["get_hidden_prop"] = "HiddenProperty",
    ["get_hidden_properties"] = "HiddenProperty",
    ["get_hidden_property"] = "HiddenProperty",
    ["get_instances"] = "Instances",
    ["get_loaded_modules"] = "LoadedModules",
    ["get_nil_instances"] = "NilInstances",
    ["get_original_thread"] = "OriginalThread",
    ["get_process_identifier"] = "ProcessIdentifier",
    ["get_properties"] = "Properties",
    ["get_render_property"] = "RenderProperty",
    ["get_renderstepped_list"] = "RenderSteppedCallbacks",
    ["get_script_function"] = "ScriptClosure",
    ["get_scripts"] = "Scripts",
    ["get_signal_cons"] = "SignalArguments",
    ["get_thread_context"] = "ThreadIdentity",
    ["get_thread_identity"] = "ThreadIdentity",
    ["getactorstates"] = "ActorStates",
    ["getactorthreads"] = "ActorThreads",
    ["getallactors"] = "Actors",
    ["getallthreads"] = "AllThreads",
    ["getbspval"] = "BspValue",
    ["getcallbackmember"] = "CallbackValue",
    ["getcaller"] = "CallingScript",
    ["getcallstack"] = "CallStack",
    ["getcbvalue"] = "CallbackValue",
    ["getclipboard"] = "Clipboard",
    ["getconnection"] = "Connections",
    ["getconnectionfunction"] = "ConnectionFunction",
    ["getconnectionthread"] = "ConnectionThread",
    ["getcontext"] = "ThreadIdentity",
    ["getcurrentactor"] = "CurrentActor",
    ["getdeletedactors"] = "DeletedActors",
    ["getdestroyedactors"] = "DestroyedActors",
    ["geteventmember"] = "EventMember",
    ["getexecutorversion"] = "IdentifyExecutor",
    ["getfastflag"] = "FFlag",
    ["getfastflagtype"] = "FFlagType",
    ["getfflagtype"] = "FFlagType",
    ["getfilter"] = "Filter",
    ["getfpscap"] = "FpsCap",
    ["getfunctionbytecode"] = "ScriptBytecode",
    ["getgamestate"] = "GameState",
    ["gethiddenproperties"] = "HiddenProperty",
    ["gethiddenprops"] = "HiddenProperty",
    ["gethost_ip"] = "HostIp",
    ["gethostip"] = "HostIp",
    ["gethwid"] = "Hwid",
    ["getinfo"] = "DebugGetInfo",
    ["getinstancecache"] = "InstanceCache",
    ["getinternalparent"] = "InternalParent",
    ["getluastate"] = "LuaState",
    ["getmousepos"] = "MousePos",
    ["getobjects"] = "Objects",
    ["getpcd"] = "Pcd",
    ["getpcdprop"] = "Pcd",
    ["getprops"] = "Properties",
    ["getproto"] = "Proto",
    ["getproximitypromptduration"] = "ProximityPromptDuration",
    ["getregistry"] = "Registry",
    ["getrenderobj"] = "RenderProperty",
    ["getrenderstepcallbacks"] = "RenderSteppedCallbacks",
    ["getrendersteppedlist"] = "RenderSteppedCallbacks",
    ["getscriptcaller"] = "CallingScript",
    ["getscriptfunction"] = "ScriptClosure",
    ["getscriptname"] = "ScriptName",
    ["getscriptsthatrun"] = "Scripts",
    ["getsignalarguments"] = "SignalArguments",
    ["getsignalargumentsinfo"] = "SignalArguments",
    ["getsignalwhitelist"] = "SignalWhitelist",
    ["getsimulationradius"] = "SimulationRadius",
    ["getstack"] = "Stack",
    ["gettenv"] = "ThreadEnv",
    ["getthreadcontext"] = "ThreadIdentity",
    ["hook_func"] = "HookFunction",
    ["hook_function"] = "HookFunction",
    ["hook_metamethod"] = "HookMetamethod",
    ["hookclosure"] = "HookFunction",
    ["hookfunc"] = "HookFunction",
    ["http_post"] = "Response",
    ["http_request"] = "Request",
    ["httpget"] = "Response",
    ["httppost"] = "Response",
    ["is_c_closure"] = "IsCClosure",
    ["is_executor_closure"] = "IsExecutorClosure",
    ["is_l_closure"] = "IsLClosure",
    ["is_our_closure"] = "IsExecutorClosure",
    ["is_protosmasher_caller"] = "CheckCaller",
    ["is_render_property"] = "IsRenderObj",
    ["is_sirhurt_closure"] = "IsExecutorClosure",
    ["iscustomcclosure"] = "IsExecutorClosure",
    ["isnewcclosure"] = "IsExecutorClosure",
    ["isourclosure"] = "IsExecutorClosure",
    ["isrenderproperty"] = "IsRenderObj",
    ["keyclick"] = "KeyTap",
    ["keydown"] = "KeyPress",
    ["lz4_compress"] = "Compressed",
    ["lz4_decompress"] = "Decompressed",
    ["lz4compress"] = "Compressed",
    ["lz4decompress"] = "Decompressed",
    ["messagebox"] = "Button",
    ["messageboxasync"] = "Button",
    ["newlclosure"] = "NewLClosure",
    ["randomstring"] = "RandomString",
    ["rconsoleinput"] = "Input",
    ["readbinarystring"] = "BinaryString",
    ["readbinarystringpropertyvalue"] = "BinaryString",
    ["readbspval"] = "Pcd",
    ["readclipboard"] = "Clipboard",
    ["replaceclosure"] = "HookFunction",
    ["replacefunc"] = "HookFunction",
    ["replacefunction"] = "HookFunction",
    ["restoreclosure"] = "RestoreFunction",
    ["restorefunc"] = "RestoreFunction",
    ["secure_call"] = "Result",
    ["securecall"] = "Result",
    ["set_clipboard"] = "SetClipboard",
    ["set_hidden_prop"] = "SetHiddenProperty",
    ["set_hidden_property"] = "SetHiddenProperty",
    ["set_raw_metatable"] = "SetRawMetatable",
    ["set_render_property"] = "SetRenderProperty",
    ["set_thread_context"] = "SetThreadIdentity",
    ["set_thread_identity"] = "SetThreadIdentity",
    ["setcontext"] = "SetThreadIdentity",
    ["setfastflag"] = "SetFFlag",
    ["sethiddenprop"] = "SetHiddenProperty",
    ["setrenderobj"] = "SetRenderProperty",
    ["setthreadcontext"] = "SetThreadIdentity",
    ["trampoline_call"] = "Result",
    ["trampolinecall"] = "Result",
    ["unhook_function"] = "RestoreFunction",
    ["unhookfunction"] = "RestoreFunction",
    ["zstd_compress"] = "Compressed",
    ["zstd_decompress"] = "Decompressed",
    ["zstdcompress"] = "Compressed",
    ["zstddecompress"] = "Decompressed",
}

local MethodNames = {
    ["Wait"] = "Elapsed",
    ["Connect"] = "Connection",
    ["Once"] = "Connection",
    ["Clone"] = "Clone",
    ["Destroy"] = "Destroyed",
    ["ClearAllChildren"] = "Cleared",
    ["GetChildren"] = "Children",
    ["GetDescendants"] = "Descendants",
    ["GetPlayers"] = "PlayerList",
    ["GetTagged"] = "Tagged",
    ["GetInstanceAddedSignal"] = "Signal",
    ["GetInstanceRemovedSignal"] = "Signal",
    ["GetDataStore"] = "DataStore",
    ["GetOrderedDataStore"] = "OrderedDataStore",
    ["GetGlobalDataStore"] = "GlobalDataStore",
    ["GetCollisionGroupId"] = "GroupId",
    ["GetCollisionGroupName"] = "GroupName",
    ["CreatePath"] = "Path",
    ["Create"] = "Created",
    ["JSONEncode"] = "Json",
    ["JSONDecode"] = "Decoded",
    ["HttpGetAsync"] = "Response",
    ["HttpPostAsync"] = "Response",
    ["GetAsync"] = "Value",
    ["SetAsync"] = "Value",
    ["UpdateAsync"] = "Value",
    ["IncrementAsync"] = "Value",
    ["Kick"] = "Kicked",
    ["GetMouse"] = "Mouse",
    ["GetPropertyChangedSignal"] = "Signal",
    ["GetAttributeChangedSignal"] = "Signal",
    ["GetAttribute"] = "Value",
    ["SetAttribute"] = "Attribute",
    ["GetPivot"] = "Pivot",
    ["PivotTo"] = "Pivot",
    ["GetFullName"] = "FullName",
    ["GetDebugId"] = "DebugId",
    ["FindFirstAncestor"] = "Ancestor",
    ["FindFirstAncestorOfClass"] = "Ancestor",
    ["FindFirstAncestorWhichIsA"] = "Ancestor",
    ["IsA"] = "IsType",
    ["AddTag"] = "Tag",
    ["RemoveTag"] = "Tag",
    ["HasTag"] = "HasTag",
    ["GetTags"] = "Tags",
    ["WaitForChild"] = "Child",
    ["FindFirstChild"] = "Child",
    ["FindFirstChildOfClass"] = "Child",
    ["FindFirstChildWhichIsA"] = "Child",
    ["SetPrimaryPartCFrame"] = "Pivot",
    ["GetPrimaryPartCFrame"] = "Pivot",
    ["MoveTo"] = "Pivot",
    ["LoadCharacter"] = "Character",
    ["LoadCharacterWithHumanoidDescription"] = "Character",
    ["GetRankInGroup"] = "Rank",
    ["GetRoleInGroup"] = "Role",
    ["IsInGroup"] = "IsInGroup",
    ["IsFriendsWith"] = "IsFriend",
    ["GetFriendsAsync"] = "Friends",
    ["GetUserIdFromNameAsync"] = "UserId",
    ["GetNameFromUserIdAsync"] = "UserName",
    ["GetUserThumbnailAsync"] = "Thumbnail",
    ["GetProductInfo"] = "ProductInfo",
    ["UserOwnsGamePassAsync"] = "OwnsGamePass",
    ["PromptGamePassPurchase"] = "Prompt",
    ["PromptProductPurchase"] = "Prompt",
    ["PromptPurchase"] = "Prompt",
    ["GetDeveloperProductsAsync"] = "Products",
    ["GetStorePages"] = "Pages",
    ["GetService"] = "Service",
    ["GetPlayerFromCharacter"] = "Player",
    ["GetPlayerByUserId"] = "Player",
    ["GetNetworkPing"] = "Ping",
    ["DistanceFromCharacter"] = "Distance",
    ["HasAppearanceLoaded"] = "AppearanceLoaded",
    ["GetJoinData"] = "JoinData",
    ["GetFriendsOnline"] = "Friends",
    ["GetGroupsAsync"] = "Groups",
    ["GetGroupInfoAsync"] = "GroupInfo",
    ["GetBadgeInfoAsync"] = "BadgeInfo",
    ["UserHasBadgeAsync"] = "HasBadge",
    ["AwardBadge"] = "Awarded",
    ["GetCharacterAppearanceAsync"] = "Appearance",
    ["GetCharacterAppearanceInfoAsync"] = "AppearanceInfo",
    ["GetHumanoidDescriptionFromUserId"] = "Description",
    ["GetHumanoidDescriptionFromOutfitId"] = "Description",
    ["GetUserInfosByUserIdsAsync"] = "UserInfos",
    ["IsDescendantOf"] = "IsDescendant",
    ["IsAncestorOf"] = "IsAncestor",
    ["GetAttributes"] = "Attributes",
    ["FindFirstDescendant"] = "Descendant",
    ["GetActor"] = "Actor",
    ["GetBoundingBox"] = "BoundingBox",
    ["GetExtentsSize"] = "Size",
    ["GetScale"] = "Scale",
    ["GetModelCFrame"] = "ModelCFrame",
    ["GetMass"] = "Mass",
    ["GetVelocityAtPosition"] = "Velocity",
    ["GetConnectedParts"] = "ConnectedParts",
    ["GetTouchingParts"] = "TouchingParts",
    ["GetJoints"] = "Joints",
    ["GetRootPart"] = "RootPart",
    ["GetNetworkOwner"] = "NetworkOwner",
    ["CanCollideWith"] = "CanCollide",
    ["GetClosestPointOnSurface"] = "ClosestPoint",
    ["Raycast"] = "RaycastResult",
    ["Spherecast"] = "RaycastResult",
    ["Blockcast"] = "RaycastResult",
    ["FindPartOnRay"] = "Part",
    ["FindPartOnRayWithIgnoreList"] = "Part",
    ["FindPartOnRayWithWhitelist"] = "Part",
    ["FindPartsInRegion3"] = "Parts",
    ["FindPartsInRegion3WithIgnoreList"] = "Parts",
    ["FindPartsInRegion3WithWhiteList"] = "Parts",
    ["GetPartBoundsInBox"] = "Parts",
    ["GetPartBoundsInRadius"] = "Parts",
    ["GetPartsInPart"] = "Parts",
    ["GetPartsObscuringTarget"] = "Parts",
    ["GetServerTimeNow"] = "ServerTime",
    ["GetRealPhysicsFPS"] = "Fps",
    ["GetNumAwakeParts"] = "AwakeParts",
    ["GetRenderCFrame"] = "RenderCFrame",
    ["ScreenPointToRay"] = "Ray",
    ["ViewportPointToRay"] = "Ray",
    ["WorldToScreenPoint"] = "ScreenPoint",
    ["WorldToViewportPoint"] = "ViewportPoint",
    ["GetMouseLocation"] = "MouseLocation",
    ["GetMouseDelta"] = "MouseDelta",
    ["GetKeysPressed"] = "KeysPressed",
    ["GetMouseButtonsPressed"] = "MouseButtons",
    ["GetGamepadState"] = "GamepadState",
    ["GetConnectedGamepads"] = "Gamepads",
    ["GetNavigationGamepads"] = "Gamepads",
    ["IsMouseButtonPressed"] = "IsPressed",
    ["GetFocusedTextBox"] = "TextBox",
    ["GetStringForKeyCode"] = "KeyName",
    ["GetLastInputType"] = "InputType",
    ["GetGuiInset"] = "Inset",
    ["GetBoundActionInfo"] = "ActionInfo",
    ["GetAllBoundActionInfo"] = "ActionInfo",
    ["GetState"] = "State",
    ["GetAccessories"] = "Accessories",
    ["GetAppliedDescription"] = "Description",
    ["GetPlayingAnimationTracks"] = "Tracks",
    ["LoadAnimation"] = "Track",
    ["GetMarkerReachedSignal"] = "Signal",
    ["GetTimeOfKeyframe"] = "Time",
    ["GetValue"] = "Alpha",
    ["Lerp"] = "Lerped",
    ["ToObjectSpace"] = "ObjectSpace",
    ["ToWorldSpace"] = "WorldSpace",
    ["PointToObjectSpace"] = "ObjectPoint",
    ["PointToWorldSpace"] = "WorldPoint",
    ["VectorToObjectSpace"] = "ObjectVector",
    ["VectorToWorldSpace"] = "WorldVector",
    ["ToOrientation"] = "Orientation",
    ["GetComponents"] = "Components",
    ["FuzzyEq"] = "IsEqual",
    ["ToHSV"] = "Hsv",
    ["ToHex"] = "Hex",
    ["NextInteger"] = "RandomInteger",
    ["NextNumber"] = "RandomNumber",
    ["NextUnitVector"] = "UnitVector",
    ["GenerateGUID"] = "Guid",
    ["RequestAsync"] = "Response",
    ["PostAsync"] = "Response",
    ["UrlEncode"] = "EncodedUrl",
    ["InvokeServer"] = "Result",
    ["InvokeClient"] = "Result",
    ["GetSunDirection"] = "SunDirection",
    ["GetMoonDirection"] = "MoonDirection",
    ["GetMinutesAfterMidnight"] = "Minutes",
    ["GetWaypoints"] = "Waypoints",
    ["GetAllTags"] = "Tags",
    ["CollisionGroupsAreCollidable"] = "Collidable",
    ["GetRegisteredCollisionGroups"] = "Groups",
    ["RemoveAsync"] = "Value",
    ["GetVersionAsync"] = "Version",
    ["ListKeysAsync"] = "Pages",
    ["ListDataStoresAsync"] = "Pages",
    ["GetSortedAsync"] = "Pages",
    ["GetCurrentPage"] = "Page",
    ["GetRequestBudgetForRequestType"] = "Budget",
    ["PlayerOwnsAsset"] = "OwnsAsset",
    ["PlayerOwnsBundle"] = "OwnsBundle",
    ["GetUserSubscriptionStatusAsync"] = "SubscriptionStatus",
    ["GetSubscriptionProductInfoAsync"] = "ProductInfo",
    ["GetBundleDetailsAsync"] = "BundleDetails",
    ["GetLocalPlayerTeleportData"] = "TeleportData",
    ["GetArrivingTeleportGui"] = "TeleportGui",
    ["TeleportAsync"] = "TeleportResult",
    ["ReserveServer"] = "AccessCode",
    ["LoadAsset"] = "Model",
    ["LoadAssetVersion"] = "Model",
    ["GetFreeModels"] = "FreeModels",
    ["CreateMeshPartAsync"] = "MeshPart",
    ["CreateEditableMesh"] = "EditableMesh",
    ["CreateEditableImage"] = "EditableImage",
    ["FilterStringAsync"] = "FilterResult",
    ["GetChatForUserAsync"] = "FilteredText",
    ["GetNonChatStringForBroadcastAsync"] = "FilteredText",
    ["GetNonChatStringForUserAsync"] = "FilteredText",
    ["GetTranslatorForPlayer"] = "Translator",
    ["GetTranslatorForPlayerAsync"] = "Translator",
    ["GetTranslatorForLocaleAsync"] = "Translator",
    ["GetCountryRegionForPlayerAsync"] = "Region",
    ["CanSendGameInviteAsync"] = "CanInvite",
}

local RobloxMethods = {
    ["AcquireWakeLock"] = "DisplayWakeLock",
    ["AddNewAction"] = "PluginAction",
    ["ApplyToDataModel"] = "TextureGenerationPartGroup",
    ["ApplyTransformSubregion"] = "TerrainRegion",
    ["Bind"] = "MemStorageConnection",
    ["BindAndFire"] = "MemStorageConnection",
    ["CalculateAverageEditableCageMeshDistance"] = "AverageEditableCageMeshDistance",
    ["CalculateConstraintsToPreserve"] = "ConstraintsToPreserve",
    ["CalculateEditableMeshInsideMeshPercentage"] = "EditableMeshInsideMeshPercentage",
    ["CalculateEditableMeshTotalSurfaceArea"] = "EditableMeshTotalSurfaceArea",
    ["CalculateEditableMeshUniqueUVCount"] = "EditableMeshUniqueUVCount",
    ["CalculateJumpDistance"] = "JumpDistance",
    ["CalculateJumpHeight"] = "JumpHeight",
    ["CalculateJumpPower"] = "JumpPower",
    ["CapturePluginGui"] = "StudioScreenshotCapture",
    ["CheckApplyDefaultClothing"] = "HumanoidDescription",
    ["CheckApplyDefaultClothingAsync"] = "HumanoidDescription",
    ["ComputeBufferHash"] = "BufferHash",
    ["ComputeOriginalSizeForPart"] = "OriginalSizeForPart",
    ["ComputeRawPathAsync"] = "Path",
    ["ComputeSmoothPathAsync"] = "Path",
    ["ComputeStringHash"] = "StringHash",
    ["ConformToAvatarRules"] = "HumanoidDescription",
    ["ConformToAvatarRulesAsync"] = "HumanoidDescription",
    ["CopyRegion"] = "TerrainRegion",
    ["CreateBasicMeshPart"] = "MeshPart",
    ["CreateButton"] = "PluginToolbarButton",
    ["CreateCageMeshPartsWithScaleForExportAsync"] = "Folder",
    ["CreateClient"] = "WebSocketClient",
    ["CreateDecalAsync"] = "Decal",
    ["CreateDockWidgetPluginGui"] = "DockWidgetPluginGui",
    ["CreateDockWidgetPluginGuiAsync"] = "DockWidgetPluginGui",
    ["CreateEditableImageAsync"] = "EditableImage",
    ["CreateEditableImageFromBinaryStringRobloxOnly"] = "EditableImage",
    ["CreateEditableImageFromDownloadAsync"] = "EditableImage",
    ["CreateEditableImageOriginalSizeAsync"] = "EditableImage",
    ["CreateEditableMeshAsync"] = "EditableMesh",
    ["CreateEditableMeshFromBinaryStringRobloxOnly"] = "EditableMesh",
    ["CreateHumanoidModelFromDescription"] = "Model",
    ["CreateHumanoidModelFromDescriptionAsync"] = "Model",
    ["CreateHumanoidModelFromUserId"] = "Model",
    ["CreateHumanoidModelFromUserIdAsync"] = "Model",
    ["CreateLocalPlayer"] = "Player",
    ["CreatePartGroup"] = "TextureGenerationPartGroup",
    ["CreatePluginAction"] = "PluginAction",
    ["CreatePluginMenu"] = "PluginMenu",
    ["CreatePopupButton"] = "PluginToolbarButton",
    ["CreateQWidgetPluginGui"] = "QWidgetPluginGui",
    ["CreateSessionAsync"] = "MLSession",
    ["CreateSurfaceAppearanceAsync"] = "SurfaceAppearance",
    ["CreateTextureAsync"] = "Texture",
    ["CreateTextureInCageSpaceAsync"] = "EditableImage",
    ["CreateTextureInTargetSpaceAsync"] = "EditableImage",
    ["CreateThumbnailPlayer"] = "Player",
    ["CreateToolbar"] = "PluginToolbar",
    ["CreateVideoSamplerAsync"] = "VideoSampler",
    ["CreateVoxelBuffer_beta"] = "VoxelBuffer",
    ["CreateWebStreamClient"] = "WebStreamClient",
    ["CreateWebStreamClientInternal"] = "WebStreamClient",
    ["DeriveNewMessageProperties"] = "ChatWindowMessageProperties",
    ["DisplaySystemMessage"] = "TextChatMessage",
    ["ExecuteCommand"] = "ExecutedRemoteCommand",
    ["FetchAssetQualitySummaryFromGltfAsync"] = "AssetQualitySummaryFromGltf",
    ["FetchAssetQualitySummaryFromJobIdAsync"] = "AssetQualitySummaryFromJobId",
    ["FetchAssetWithFormat"] = "AssetWithFormat",
    ["FetchExtraAssets"] = "ExtraAssets",
    ["FilterAndTranslateStringAsync"] = "TextFilterTranslatedResult",
    ["FindBinding"] = "Binding",
    ["FindBindings"] = "Bindings",
    ["FindClosestVertex"] = "ClosestVertex",
    ["FindPathAsync"] = "Path",
    ["FindScriptDocument"] = "ScriptDocument",
    ["FindService"] = "Service",
    ["FindVerticesWithinSphere"] = "VerticesWithinSphere",
    ["GenerateItemListAsync"] = "RecommendationPages",
    ["GetAbsolutePosition"] = "AbsolutePosition",
    ["GetAccessoryHandleScale"] = "AccessoryHandleScale",
    ["GetAccessoryType"] = "AccessoryType",
    ["GetAdAvailabilityNowAsync"] = "AdAvailabilityNow",
    ["GetAdAvailabilityNowForUniverseAsync"] = "AdAvailabilityNowForUniverse",
    ["GetAdjacentFaces"] = "AdjacentFaces",
    ["GetAdjacentVertices"] = "AdjacentVertices",
    ["GetAllBoundCoreActionInfo"] = "AllBoundCoreActionInfo",
    ["GetAllCollections"] = "AllCollections",
    ["GetAllInstances"] = "AllInstances",
    ["GetAllPresets"] = "AllPresets",
    ["GetAlliesAsync"] = "StandardPages",
    ["GetAndClearCallFailureMessage"] = "AndClearCallFailureMessage",
    ["GetAndClearLastPendingUrl"] = "AndClearLastPendingUrl",
    ["GetAngleAttenuation"] = "AngleAttenuation",
    ["GetAnglesAtTime"] = "AnglesAtTime",
    ["GetAnimationClip"] = "AnimationClip",
    ["GetAnimationClipAsync"] = "AnimationClip",
    ["GetAnimationClipById"] = "AnimationClip",
    ["GetAnimationMemoryAsync"] = "AnimationMemory",
    ["GetAnimationNodeDefinition"] = "AnimationNodeDefinitionList",
    ["GetAnimationNodeTypes"] = "AnimationNodeTypes",
    ["GetAnimations"] = "Animations",
    ["GetAnimationsAsync"] = "Animations",
    ["GetAnnotationThreads"] = "AnnotationThreads",
    ["GetApiV1"] = "OpenCloudApiV1",
    ["GetAppAgeSignalsAsync"] = "AppAgeSignals",
    ["GetAppliedInstance"] = "AppliedInstance",
    ["GetAppliedStyles"] = "AppliedStyles",
    ["GetArg"] = "Arg",
    ["GetAssetFetchStatus"] = "AssetFetchStatus",
    ["GetAssetIdsForPackage"] = "AssetIdsForPackage",
    ["GetAssetIdsForPackageAsync"] = "AssetIdsForPackage",
    ["GetAssetInfoAsync"] = "AssetInfo",
    ["GetAsyncFullUrl"] = "AsyncFullUrl",
    ["GetAttachedReceivers"] = "AttachedReceivers",
    ["GetAudibilityFor"] = "AudibilityFor",
    ["GetAudioInstances"] = "AudioInstances",
    ["GetAudioMemoryAsync"] = "AudioMemory",
    ["GetAudioMetadataAsync"] = "AudioMetadata",
    ["GetAutoUIScaleHundredths"] = "AutoUIScaleHundredths",
    ["GetAutocompleter"] = "ExplorerFilterAutocompleter",
    ["GetAvailableConnection"] = "DebuggerConnection",
    ["GetAvailableSubscriptionProductsAsync"] = "AvailableSubscriptionProducts",
    ["GetAvailableThemes"] = "AvailableThemes",
    ["GetAvailableTintModes"] = "AvailableTintModes",
    ["GetAvatarRules"] = "AvatarRulesList",
    ["GetAvatarRulesAsync"] = "AvatarRulesList",
    ["GetAwakeContactNormals"] = "AwakeContactNormals",
    ["GetAwakeContactParts"] = "AwakeContactParts",
    ["GetAwakeContactPositions"] = "AwakeContactPositions",
    ["GetAwakeRootParts"] = "AwakeRootParts",
    ["GetAwardablePoints"] = "AwardablePoints",
    ["GetAxis"] = "Axis",
    ["GetBadgeConfigureUrl"] = "BadgeConfigureUrl",
    ["GetBadgeUploadUrl"] = "BadgeUploadUrl",
    ["GetBanHistoryAsync"] = "BanHistoryPages",
    ["GetBaseCategories"] = "BaseCategories",
    ["GetBaseMaterialOverride"] = "BaseMaterialOverride",
    ["GetBaseSets"] = "BaseSets",
    ["GetBatchItemDetails"] = "BatchItemDetails",
    ["GetBatchItemDetailsAsync"] = "BatchItemDetails",
    ["GetBatchTokenDetailsAsync"] = "BatchTokenDetails",
    ["GetBatchWindowDelayMax"] = "BatchWindowDelayMax",
    ["GetBatchWindowDelayMin"] = "BatchWindowDelayMin",
    ["GetBinaryContents"] = "BinaryContents",
    ["GetBlock"] = "Block",
    ["GetBodyPartR15"] = "BodyPartR15",
    ["GetBoneByName"] = "BoneByName",
    ["GetBoneCFrame"] = "BoneCFrame",
    ["GetBoneName"] = "BoneName",
    ["GetBoneParent"] = "BoneParent",
    ["GetBones"] = "Bones",
    ["GetBoundCoreActionInfo"] = "BoundCoreActionInfo",
    ["GetBoundTracks"] = "BoundTracks",
    ["GetBoundingBoxManipulationData"] = "BoundingBoxManipulationData",
    ["GetBoundingRect"] = "BoundingRect",
    ["GetBranchesAsync"] = "Branches",
    ["GetBreadcrumbs"] = "Breadcrumbs",
    ["GetBreakpointById"] = "MetaBreakpoint",
    ["GetBreakpoints"] = "Breakpoints",
    ["GetBrickCount"] = "BrickCount",
    ["GetBrowserTrackerId"] = "BrowserTrackerId",
    ["GetBrowserTrackerLayerLoadingStatus"] = "BrowserTrackerLayerLoadingStatus",
    ["GetBrowserTrackerLayerVariables"] = "BrowserTrackerLayerVariables",
    ["GetBrowserTrackerStatusForLayer"] = "BrowserTrackerStatusForLayer",
    ["GetBuffer"] = "Buffer",
    ["GetBundlesByAssetIdAsync"] = "CatalogPages",
    ["GetCageOffset"] = "CageOffset",
    ["GetCallingState"] = "CallingState",
    ["GetCameraDevices"] = "CameraDevices",
    ["GetCameraState"] = "CameraState",
    ["GetCameraYInvertValue"] = "CameraYInvertValue",
    ["GetCampaignEligibilityAsync"] = "CampaignEligibility",
    ["GetCapabilitiesAsync"] = "Capabilities",
    ["GetCapabilitiesUsedInPackageAsync"] = "CapabilitiesUsedInPackage",
    ["GetCaptureFilePathAsync"] = "CaptureFilePath",
    ["GetCaptureSizeAsync"] = "CaptureSize",
    ["GetCaptureStorageSizeAsync"] = "CaptureStorageSize",
    ["GetCaptureUploadDataAsync"] = "CaptureUploadData",
    ["GetCenter"] = "Center",
    ["GetChainCount"] = "ChainCount",
    ["GetChainLength"] = "ChainLength",
    ["GetChangeType"] = "ChangeType",
    ["GetChangedState"] = "ChangedState",
    ["GetChannelId"] = "ChannelId",
    ["GetChannelPreferenceAsync"] = "ChannelPreference",
    ["GetChatGroupsAsync"] = "ChatGroups",
    ["GetChatableUserCountAsync"] = "ChatableUserCount",
    ["GetClassIcon"] = "ClassIcon",
    ["GetClientFeaturesAsync"] = "ClientFeatures",
    ["GetClientId"] = "ClientId",
    ["GetClosestDialogToPosition"] = "ClosestDialogToPosition",
    ["GetClosestVisibleDialogToPosition"] = "Dialog",
    ["GetCollaboratorsList"] = "CollaboratorsList",
    ["GetCollection"] = "Collection",
    ["GetCollisionGroups"] = "CollisionGroups",
    ["GetColor"] = "Color",
    ["GetColorAlpha"] = "ColorAlpha",
    ["GetColors"] = "Colors",
    ["GetCommerceProductInfoAsync"] = "CommerceProductInfo",
    ["GetComponentCurves"] = "ComponentCurves",
    ["GetCondition"] = "Condition",
    ["GetConditions"] = "Conditions",
    ["GetConfigAsync"] = "ConfigSnapshot",
    ["GetConfigForPlayerAsync"] = "ConfigSnapshot",
    ["GetConnectedWires"] = "ConnectedWires",
    ["GetConnectionById"] = "DebuggerConnection",
    ["GetConstraints"] = "Constraints",
    ["GetContainedJointLabels"] = "ContainedJointLabels",
    ["GetContent"] = "Content",
    ["GetContentMemoryData"] = "ContentMemoryData",
    ["GetContents"] = "Contents",
    ["GetContextBreakpoints"] = "ContextBreakpoints",
    ["GetControlPoint"] = "ControlPoint",
    ["GetControlPoints"] = "ControlPoints",
    ["GetCoreScriptVersion"] = "CoreScriptVersion",
    ["GetCorescriptLocalizations"] = "CorescriptLocalizations",
    ["GetCoverageStats"] = "CoverageStats",
    ["GetCreatedTimestampUtcMs"] = "CreatedTimestampUtcMs",
    ["GetCreatorLayerLoadingStatus"] = "CreatorLayerLoadingStatus",
    ["GetCreatorLayerVariables"] = "CreatorLayerVariables",
    ["GetCreatorStatusForLayer"] = "CreatorStatusForLayer",
    ["GetCreatorStoreProductInfoAsync"] = "CreatorStoreProductInfo",
    ["GetCredentialsHeaders"] = "CredentialsHeaders",
    ["GetCurrentDeviceId"] = "CurrentDeviceId",
    ["GetCurrentLocalToolIcon"] = "CurrentLocalToolIcon",
    ["GetCurrentOrientation"] = "CurrentOrientation",
    ["GetCurrentPlaybackRestartFrames"] = "CurrentPlaybackRestartFrames",
    ["GetCurrentPlayers"] = "PlayerList",
    ["GetCurrentState"] = "CurrentState",
    ["GetCurrentValue"] = "CurrentValue",
    ["GetData"] = "PlayerData",
    ["GetDataInRange"] = "DataInRange",
    ["GetDataSize"] = "DataSize",
    ["GetDebugAppliedForce"] = "DebugAppliedForce",
    ["GetDebugData"] = "DebugData",
    ["GetDebuggers"] = "Debuggers",
    ["GetDecompressedBufferSize"] = "DecompressedBufferSize",
    ["GetDefaultFramerateCap"] = "DefaultFramerateCap",
    ["GetDefaultPropertyTransition"] = "DefaultPropertyTransition",
    ["GetDefaultValue"] = "DefaultValue",
    ["GetDeformedCFrameAsync"] = "DeformedCFrame",
    ["GetDependencyContentIds"] = "DependencyContentIds",
    ["GetDerives"] = "Derives",
    ["GetDetailedFailedRequests"] = "DetailedFailedRequests",
    ["GetDeviceAcceleration"] = "InputObject",
    ["GetDeviceAccessToken"] = "DeviceAccessToken",
    ["GetDeviceAsync"] = "Device",
    ["GetDeviceCameraCFrame"] = "DeviceCameraCFrame",
    ["GetDeviceCameraCFrameForSelfView"] = "DeviceCameraCFrameForSelfView",
    ["GetDeviceGravity"] = "InputObject",
    ["GetDeviceId"] = "DeviceId",
    ["GetDeviceInfo"] = "DeviceInfo",
    ["GetDeviceInfoAsync"] = "DeviceInfo",
    ["GetDeviceIntegrityToken"] = "DeviceIntegrityToken",
    ["GetDeviceIntegrityTokenYield"] = "DeviceIntegrityTokenYield",
    ["GetDeviceLevel"] = "DeviceLevel",
    ["GetDeviceListAsync"] = "DeviceList",
    ["GetDeviceType"] = "DeviceType",
    ["GetDiffAsync"] = "DataModelDiff",
    ["GetDistanceAttenuation"] = "DistanceAttenuation",
    ["GetDistributedCounter"] = "MemoryStoreDistributedCounter",
    ["GetDocumentationUrl"] = "DocumentationUrl",
    ["GetDraftStatus"] = "DraftStatus",
    ["GetDrafts"] = "Drafts",
    ["GetDurationLoggerTimestamp"] = "DurationLoggerTimestamp",
    ["GetEditableImageSize"] = "EditableImageSize",
    ["GetEditableMeshTriCount"] = "EditableMeshTriCount",
    ["GetEditableMeshVertColors"] = "EditableMeshVertColors",
    ["GetEditableMeshVerts"] = "EditableMeshVerts",
    ["GetEditorSource"] = "EditorSource",
    ["GetEditors"] = "Editors",
    ["GetEffectiveUIScaleHundredths"] = "EffectiveUIScaleHundredths",
    ["GetEmotes"] = "Emotes",
    ["GetEmulatedPartyAsync"] = "EmulatedParty",
    ["GetEmulatedPartyConfiguration"] = "EmulatedPartyConfiguration",
    ["GetEmulatedPolicyInfo"] = "EmulatedPolicyInfo",
    ["GetEnemiesAsync"] = "StandardPages",
    ["GetEntries"] = "Entries",
    ["GetEnumItems"] = "EnumItems",
    ["GetEnums"] = "EnumsList",
    ["GetEquippedEmotes"] = "EquippedEmotes",
    ["GetErrorCode"] = "ErrorCode",
    ["GetErrorDetails"] = "ErrorDetails",
    ["GetErrorMessage"] = "ErrorMessage",
    ["GetErrorType"] = "ErrorType",
    ["GetErrors"] = "Errors",
    ["GetEventRsvpStatusAsync"] = "EventRsvpStatus",
    ["GetEventsOfClass"] = "EventsOfClass",
    ["GetExecutingPlayer"] = "Player",
    ["GetExpectedTposeRotation"] = "ExpectedTposeRotation",
    ["GetExperienceEventAsync"] = "ExperienceEvent",
    ["GetFVariable"] = "FVariable",
    ["GetFaceColors"] = "FaceColors",
    ["GetFaceNormals"] = "FaceNormals",
    ["GetFaceUVs"] = "FaceUVs",
    ["GetFaceVertices"] = "FaceVertices",
    ["GetFaces"] = "FacesList",
    ["GetFacesWithAttribute"] = "FacesWithAttribute",
    ["GetFacesWithColor"] = "FacesWithColor",
    ["GetFacesWithNormal"] = "FacesWithNormal",
    ["GetFacesWithUV"] = "FacesWithUV",
    ["GetFacsCorrectivePoses"] = "FacsCorrectivePoses",
    ["GetFacsPoses"] = "FacsPoses",
    ["GetFailedRequests"] = "FailedRequests",
    ["GetFamilyInfoAsync"] = "FamilyInfo",
    ["GetFastInt"] = "FastInt",
    ["GetFastString"] = "FastString",
    ["GetFilename"] = "Filename",
    ["GetFilesInDirAsync"] = "FilesInDir",
    ["GetFingerControl"] = "FingerControl",
    ["GetFingerTip"] = "FingerTip",
    ["GetFocusedContextId"] = "FocusedContextId",
    ["GetFollowUserId"] = "FollowUserId",
    ["GetFontMemoryData"] = "FontMemoryData",
    ["GetFrame"] = "Frame",
    ["GetFrameById"] = "StackFrame",
    ["GetFrameNames"] = "FrameNames",
    ["GetFreeDecals"] = "FreeDecals",
    ["GetFreeDecalsAsync"] = "FreeDecals",
    ["GetFreeModelsAsync"] = "FreeModels",
    ["GetFriendStatus"] = "FriendStatus",
    ["GetFriendsInUniverseAsync"] = "FriendsInUniverse",
    ["GetFriendsOnlineAsync"] = "FriendsOnline",
    ["GetFriendsWhoPlayedAsync"] = "FriendsWhoPlayed",
    ["GetGainAt"] = "GainAt",
    ["GetGamePlacesAsync"] = "GamePlaces",
    ["GetGamePointBalance"] = "GamePointBalance",
    ["GetGamepadCursorPosition"] = "GamepadCursorPosition",
    ["GetGlobalUserId"] = "GlobalUserId",
    ["GetGlobals"] = "Globals",
    ["GetGroupId"] = "GroupId",
    ["GetGuiObjectsInCircle"] = "GuiObjects",
    ["GetHardwareSafeViewport"] = "HardwareSafeViewport",
    ["GetHarmonyQualityLevel"] = "HarmonyQualityLevel",
    ["GetHash"] = "Hash",
    ["GetHashMap"] = "MemoryStoreHashMap",
    ["GetHeadShapesAsync"] = "HeadShapes",
    ["GetHistory"] = "History",
    ["GetHttpResultHistory"] = "HttpResultHistory",
    ["GetHumanoidDescriptionFromOutfitIdAsync"] = "HumanoidDescription",
    ["GetHumanoidDescriptionFromUserIdAsync"] = "HumanoidDescription",
    ["GetIdentities"] = "Identities",
    ["GetImportTree"] = "ImportTree",
    ["GetInputActions"] = "InputActions",
    ["GetInputBindings"] = "InputBindings",
    ["GetInputContexts"] = "InputContexts",
    ["GetInputPins"] = "InputPins",
    ["GetInputSchemaKeyCodeTree"] = "InputSchemaKeyCodeTree",
    ["GetInsetArea"] = "InsetArea",
    ["GetInstanceByRfc4122String"] = "InstanceByRfc4122String",
    ["GetInstanceCompositionAsync"] = "InstanceComposition",
    ["GetInstanceConflicts"] = "InstanceConflicts",
    ["GetInstances"] = "Instances",
    ["GetInteractingEmitters"] = "InteractingEmitters",
    ["GetInteractingListeners"] = "InteractingListeners",
    ["GetInternalUri"] = "InternalUri",
    ["GetInventory"] = "InventoryPages",
    ["GetInventoryAsync"] = "InventoryPages",
    ["GetItem"] = "Item",
    ["GetItemDetails"] = "ItemDetails",
    ["GetItemDetailsAsync"] = "ItemDetails",
    ["GetJobStatus"] = "JobStatus",
    ["GetJobsInfo"] = "JobsInfo",
    ["GetJoinMode"] = "JoinMode",
    ["GetJoint"] = "Joint",
    ["GetJointFromName"] = "JointFromName",
    ["GetJointLabels"] = "JointLabels",
    ["GetJointNames"] = "JointNames",
    ["GetJointRangeMax"] = "JointRangeMax",
    ["GetJointRangeMin"] = "JointRangeMin",
    ["GetJointSize"] = "JointSize",
    ["GetKeyAtIndex"] = "KeyAtIndex",
    ["GetKeyIndicesAtTime"] = "KeyIndicesAtTime",
    ["GetKeyframeSequence"] = "KeyframeSequence",
    ["GetKeyframeSequenceAsync"] = "KeyframeSequence",
    ["GetKeyframeSequenceById"] = "KeyframeSequenceById",
    ["GetKeyframeSequences"] = "KeyframeSequences",
    ["GetKeyframes"] = "Keyframes",
    ["GetKeys"] = "Keys",
    ["GetLabels"] = "Labels",
    ["GetLargestCutoffDistance"] = "LargestCutoffDistance",
    ["GetLast"] = "Last",
    ["GetLastForce"] = "LastForce",
    ["GetLastLuaUrl"] = "LastLuaUrl",
    ["GetLatestAssetVersionAsync"] = "LatestAssetVersion",
    ["GetLayoutNodeTree"] = "LayoutNodeTree",
    ["GetLength"] = "Length",
    ["GetLexemes"] = "Lexemes",
    ["GetLimb"] = "Limb",
    ["GetLine"] = "Line",
    ["GetLineCount"] = "LineCount",
    ["GetLocalFileContents"] = "LocalFileContents",
    ["GetLocalFrameId"] = "LocalFrameId",
    ["GetLocals"] = "Locals",
    ["GetLogHistory"] = "LogHistory",
    ["GetLogHistoryAsync"] = "LogHistory",
    ["GetLogPath"] = "LogPath",
    ["GetLogger"] = "Logger",
    ["GetLogicalCaptionButtonsBounds"] = "LogicalCaptionButtonsBounds",
    ["GetLuauHeapInstanceReferenceReport"] = "LuauHeapInstanceReferenceReport",
    ["GetLuauHeapMemoryReport"] = "LuauHeapMemoryReport",
    ["GetMainViewSessionId"] = "MainViewSessionId",
    ["GetMarkerAtIndex"] = "MarkerAtIndex",
    ["GetMarkers"] = "Markers",
    ["GetMaterialColor"] = "MaterialColor",
    ["GetMaterialVariant"] = "MaterialVariant",
    ["GetMaxCollisionGroups"] = "MaxCollisionGroups",
    ["GetMaxControlPoints"] = "MaxControlPoints",
    ["GetMaxQualityLevel"] = "MaxQualityLevel",
    ["GetMaximalJointDistancesWithinFacs"] = "MaximalJointDistancesWithinFacs",
    ["GetMemStats"] = "MemStats",
    ["GetMemoryCategoryNames"] = "MemoryCategoryNames",
    ["GetMemoryUsageMbAllCategories"] = "MemoryUsageMbAllCategories",
    ["GetMemoryUsageMbForTag"] = "MemoryUsageMbForTag",
    ["GetMergeChanges"] = "DataModelDiff",
    ["GetMergeResolution"] = "MergeResolution",
    ["GetMergeStatus"] = "MergeStatus",
    ["GetMeshDataBinaryString"] = "BinaryStringValue",
    ["GetMeshIdFromAliasName"] = "MeshIdFromAliasName",
    ["GetMeshIdFromAssetId"] = "MeshIdFromAssetId",
    ["GetMeshIdsHash"] = "MeshIdsHash",
    ["GetMeshVerts"] = "MeshVerts",
    ["GetMessage"] = "Message",
    ["GetMessageId"] = "MessageId",
    ["GetMetadata"] = "Metadata",
    ["GetMethodsOfClass"] = "MethodsOfClass",
    ["GetMinAndMaxMeshSizeAcrossAllFacs"] = "MinAndMaxMeshSizeAcrossAllFacs",
    ["GetMixerTime"] = "MixerTime",
    ["GetModelSize"] = "ModelSize",
    ["GetMoonPhase"] = "MoonPhase",
    ["GetMoveVelocity"] = "MoveVelocity",
    ["GetNames"] = "Names",
    ["GetNativeTitleBarControlsPosition"] = "NativeTitleBarControlsPosition",
    ["GetNoCollisionConstraints"] = "NoCollisionConstraints",
    ["GetNodeLocalCFrame"] = "NodeLocalCFrame",
    ["GetNodeWorldCFrame"] = "NodeWorldCFrame",
    ["GetNormal"] = "Normal",
    ["GetNormals"] = "Normals",
    ["GetNotificationTypeList"] = "NotificationTypeList",
    ["GetOTAPluginVersion"] = "OTAPluginVersion",
    ["GetObjects"] = "Objects",
    ["GetObjectsAllOrNone"] = "ObjectsAllOrNone",
    ["GetObjectsAsync"] = "Objects",
    ["GetObjectsList"] = "ObjectsList",
    ["GetOpaqueContentMetadataMap"] = "OpaqueContentMetadataMap",
    ["GetOrCreateUniqueId"] = "OrCreateUniqueId",
    ["GetOrCreateUniqueIdRemoteCommand"] = "OrCreateUniqueIdRemoteCommand",
    ["GetOrderedInputPinNames"] = "OrderedInputPinNames",
    ["GetOrientationAsync"] = "Orientation",
    ["GetOutfitDetails"] = "OutfitDetails",
    ["GetOutfitDetailsAsync"] = "OutfitDetails",
    ["GetOutfits"] = "OutfitPages",
    ["GetOutfitsAsync"] = "OutfitPages",
    ["GetOutputPins"] = "OutputPins",
    ["GetOverrideStatus"] = "OverrideStatus",
    ["GetOverrides"] = "DataModelDiff",
    ["GetPackageInfo"] = "PackageInfo",
    ["GetPaginatedMemoryByTexture"] = "PaginatedMemoryByTexture",
    ["GetPanSpeed"] = "PanSpeed",
    ["GetParameter"] = "Parameter",
    ["GetParameterDefaults"] = "ParameterDefaults",
    ["GetParents"] = "Parents",
    ["GetPartGroup"] = "TextureGenerationPartGroup",
    ["GetParticipants"] = "Participants",
    ["GetPartyAsync"] = "Party",
    ["GetPartyMembers"] = "PartyMembers",
    ["GetPasteText"] = "PasteText",
    ["GetPendingJoinAttempt"] = "PendingJoinAttempt",
    ["GetPermissions"] = "Permissions",
    ["GetPersistentPlayers"] = "PersistentPlayers",
    ["GetPhysicsCost"] = "PhysicsCost",
    ["GetPhysicsStepId"] = "PhysicsStepId",
    ["GetPhysicsThrottling"] = "PhysicsThrottling",
    ["GetPioneerRootPlaceId"] = "PioneerRootPlaceId",
    ["GetPioneerSource"] = "PioneerSource",
    ["GetPixelDensityAsync"] = "PixelDensity",
    ["GetPlaceJoinState"] = "PlaceJoinState",
    ["GetPlacePreference"] = "PlacePreference",
    ["GetPlacePreferenceAsync"] = "PlacePreference",
    ["GetPlaceholderInstanceTree"] = "PlaceholderInstanceTree",
    ["GetPlatform"] = "Platform",
    ["GetPlatformFriends"] = "PlatformFriends",
    ["GetPlaySessionId"] = "PlaySessionId",
    ["GetPlaybackCurrentFrame"] = "PlaybackCurrentFrame",
    ["GetPlaybackMode"] = "PlaybackMode",
    ["GetPlayer"] = "Player",
    ["GetPlayerSegmentsAsync"] = "PlayerSegments",
    ["GetPlayersByPartyId"] = "PlayersByPartyId",
    ["GetPlayingAnimationTracksCoreScript"] = "PlayingAnimationTracksCoreScript",
    ["GetPluginComponent"] = "PluginComponent",
    ["GetPluginConnectionsOfType"] = "PluginConnectionsOfType",
    ["GetPluginPolicy"] = "PluginPolicy",
    ["GetPointCoordinates"] = "PointCoordinates",
    ["GetPolicyInfoForPlayerAsync"] = "PolicyInfoForPlayer",
    ["GetPolicyInfoForServerRobloxOnlyAsync"] = "PolicyInfoForServerRobloxOnly",
    ["GetPoses"] = "Poses",
    ["GetPosition"] = "Position",
    ["GetPositionOnCurve"] = "PositionOnCurve",
    ["GetPositionOnCurveArcLength"] = "PositionOnCurveArcLength",
    ["GetPostTransforms"] = "PostTransforms",
    ["GetPreTransforms"] = "PreTransforms",
    ["GetPredictedInstances"] = "PredictedInstances",
    ["GetPredictionStatus"] = "PredictionStatus",
    ["GetPreferredBindingList"] = "PreferredBindingList",
    ["GetPrefetchDownloadStatus"] = "PrefetchDownloadStatus",
    ["GetPreset"] = "Preset",
    ["GetPresetsAsync"] = "Presets",
    ["GetPreview"] = "Preview",
    ["GetProductInfoAsync"] = "ProductInfo",
    ["GetProfileConfigurationFromUserIdAsync"] = "ProfileConfigurationFromUserId",
    ["GetProperties"] = "Properties",
    ["GetPropertiesResolved"] = "PropertiesResolved",
    ["GetProperty"] = "Property",
    ["GetPropertyNames"] = "PropertyNames",
    ["GetPropertyResolved"] = "PropertyResolved",
    ["GetPropertyTransitions"] = "PropertyTransitions",
    ["GetPropertyValue"] = "PropertyValue",
    ["GetProtocolLaunchUpdateName"] = "ProtocolLaunchUpdateName",
    ["GetProtocolLaunchUpdateType"] = "ProtocolLaunchUpdateType",
    ["GetProtocolMethodRequestMessageId"] = "ProtocolMethodRequestMessageId",
    ["GetProtocolMethodResponseMessageId"] = "ProtocolMethodResponseMessageId",
    ["GetQueue"] = "MemoryStoreQueue",
    ["GetQueuePosition"] = "QueuePosition",
    ["GetQuotasAsync"] = "Quotas",
    ["GetR15JointLabels"] = "R15JointLabels",
    ["GetR15JointNames"] = "R15JointNames",
    ["GetR6JointLabels"] = "R6JointLabels",
    ["GetR6JointNames"] = "R6JointNames",
    ["GetRangeAsync"] = "Range",
    ["GetRankInGroupAsync"] = "RankInGroup",
    ["GetRawFinalTarget"] = "RawFinalTarget",
    ["GetRawScreenScale"] = "RawScreenScale",
    ["GetRecommendedAssets"] = "RecommendedAssets",
    ["GetRecommendedAssetsAsync"] = "RecommendedAssets",
    ["GetRecommendedBundles"] = "RecommendedBundles",
    ["GetRecommendedBundlesAsync"] = "RecommendedBundles",
    ["GetRecordAsync"] = "PlayerDataRecord",
    ["GetRecordConfig"] = "PlayerDataRecordConfig",
    ["GetRecordingDevices"] = "RecordingDevices",
    ["GetReferenceFrame"] = "ReferenceFrame",
    ["GetReferencePosition"] = "ReferencePosition",
    ["GetReferenceRotation"] = "ReferenceRotation",
    ["GetRegionWireframe"] = "RegionWireframe",
    ["GetRegisteredComputerMovementModes"] = "RegisteredComputerMovementModes",
    ["GetRegisteredContexts"] = "RegisteredContexts",
    ["GetRegisteredCreatorLayersToStatus"] = "RegisteredCreatorLayersToStatus",
    ["GetRegisteredOrchestrators"] = "RegisteredOrchestrators",
    ["GetRegisteredTouchMovementModes"] = "RegisteredTouchMovementModes",
    ["GetRegisteredUserLayersToStatus"] = "RegisteredUserLayersToStatus",
    ["GetRelativeMousePosition"] = "RelativeMousePosition",
    ["GetRelativeVelocityAtFloor"] = "RelativeVelocityAtFloor",
    ["GetRemoteWorldStepId"] = "RemoteWorldStepId",
    ["GetReplicationWeight"] = "ReplicationWeight",
    ["GetReportAdInfo"] = "ReportAdInfo",
    ["GetRequests"] = "Requests",
    ["GetResolutionAsync"] = "Resolution",
    ["GetResolutionScale"] = "ResolutionScale",
    ["GetResourceByCategory"] = "ResourceByCategory",
    ["GetResponseDelayMax"] = "ResponseDelayMax",
    ["GetResponseDelayMin"] = "ResponseDelayMin",
    ["GetRigVisualization"] = "RigVisualization",
    ["GetRobloxClientChannel"] = "RobloxClientChannel",
    ["GetRobloxSubscriptionDetailsAsync"] = "RobloxSubscriptionDetails",
    ["GetRobloxVersion"] = "RobloxVersion",
    ["GetRobuxBalance"] = "RobuxBalance",
    ["GetRoleInGroupAsync"] = "RoleInGroup",
    ["GetRolesInGroupAsync"] = "RolesInGroup",
    ["GetRoll"] = "Roll",
    ["GetRootSID"] = "RootSID",
    ["GetRootVariables"] = "RootVariables",
    ["GetRotationAtTime"] = "RotationAtTime",
    ["GetSafeZoneOffsets"] = "SafeZoneOffsets",
    ["GetSampledInertialVelocity"] = "SampledInertialVelocity",
    ["GetSamplesAtTimesAsync"] = "SamplesAtTimes",
    ["GetScalingModeAsync"] = "ScalingMode",
    ["GetScheduledNotifications"] = "ScheduledNotifications",
    ["GetSchema"] = "Schema",
    ["GetScreenResolution"] = "ScreenResolution",
    ["GetScreenSpaceBounds"] = "ScreenSpaceBounds",
    ["GetScreenshotCaptureObject"] = "Capture",
    ["GetScript"] = "LuaSourceContainer",
    ["GetScriptDocuments"] = "ScriptDocuments",
    ["GetScriptFilePath"] = "ScriptFilePath",
    ["GetScriptMemoryAsync"] = "ScriptMemory",
    ["GetScrollVelocity"] = "ScrollVelocity",
    ["GetSdk"] = "Sdk",
    ["GetSearchResults"] = "SearchResults",
    ["GetSeatRequested"] = "SeatRequested",
    ["GetSecondaryAxis"] = "SecondaryAxis",
    ["GetSecret"] = "Secret",
    ["GetSegmentCount"] = "SegmentCount",
    ["GetSelectedRibbonTool"] = "SelectedRibbonTool",
    ["GetSelectedText"] = "SelectedText",
    ["GetSerializedSizeExcludingCollisionAsync"] = "SerializedSizeExcludingCollision",
    ["GetServerFeaturesAsync"] = "ServerFeatures",
    ["GetServerView"] = "ServerView",
    ["GetSessionID"] = "SessionID",
    ["GetSessionId"] = "SessionId",
    ["GetSessionTag"] = "SessionTag",
    ["GetSetting"] = "Setting",
    ["GetSharedTable"] = "SharedTable",
    ["GetSingleReportAdInfo"] = "SingleReportAdInfo",
    ["GetSize"] = "Size",
    ["GetSizeAsync"] = "Size",
    ["GetSizeInVoxels"] = "SizeInVoxels",
    ["GetSmoothedFinalTarget"] = "SmoothedFinalTarget",
    ["GetSnapshot"] = "Snapshot",
    ["GetSortedMap"] = "MemoryStoreSortedMap",
    ["GetSoundMemoryData"] = "SoundMemoryData",
    ["GetSource"] = "Source",
    ["GetSourceContainerByScriptGuid"] = "LuaSourceContainer",
    ["GetSpectrum"] = "Spectrum",
    ["GetStack"] = "Stack",
    ["GetStackTrace"] = "StackTrace",
    ["GetStandardQueue"] = "StandardQueue",
    ["GetStartupAssetId"] = "StartupAssetId",
    ["GetStartupMessage"] = "StartupMessage",
    ["GetStartupPluginId"] = "StartupPluginId",
    ["GetStatus"] = "Status",
    ["GetStatuses"] = "Statuses",
    ["GetString"] = "String",
    ["GetStringUniqueId"] = "StringUniqueId",
    ["GetStyleInfo"] = "StyleInfo",
    ["GetStyleRules"] = "StyleRules",
    ["GetStyleSheetDerivesChain"] = "StyleSheetDerivesChain",
    ["GetStyleSheetInfo"] = "StyleSheetInfo",
    ["GetStyled"] = "Styled",
    ["GetStyledPropertyNames"] = "StyledPropertyNames",
    ["GetSubPoses"] = "SubPoses",
    ["GetSubscriptionPurchaseInfoAsync"] = "SubscriptionPurchaseInfo",
    ["GetSuggestions"] = "Suggestions",
    ["GetSupportedGamepadKeyCodes"] = "SupportedGamepadKeyCodes",
    ["GetSyncedInstance"] = "SyncedInstance",
    ["GetSyncingCollaborators"] = "SyncingCollaborators",
    ["GetTableEntries"] = "TableEntries",
    ["GetTangentOnCurve"] = "TangentOnCurve",
    ["GetTangentOnCurveArcLength"] = "TangentOnCurveArcLength",
    ["GetTargetInstance"] = "TargetInstance",
    ["GetTargetNames"] = "TargetNames",
    ["GetTeams"] = "TeamList",
    ["GetTeleportSetting"] = "TeleportSetting",
    ["GetTemporaryContent"] = "TemporaryContent",
    ["GetTermsOfUseUrl"] = "TermsOfUseUrl",
    ["GetTerrainWireframe"] = "TerrainWireframe",
    ["GetTestArgs"] = "TestArgs",
    ["GetTestControlSchema"] = "TestControlSchema",
    ["GetTestControls"] = "TestControls",
    ["GetText"] = "Text",
    ["GetTextBoundsAsync"] = "TextBounds",
    ["GetTextChannelWindows"] = "TextChannelWindows",
    ["GetTextSizeOffsetAsync"] = "TextSizeOffset",
    ["GetTextureIdFromAliasName"] = "TextureIdFromAliasName",
    ["GetTextureIdFromAssetId"] = "TextureIdFromAssetId",
    ["GetThreadById"] = "ThreadState",
    ["GetThreads"] = "Threads",
    ["GetTiltSpeed"] = "TiltSpeed",
    ["GetTintMode"] = "TintMode",
    ["GetTitleBarMode"] = "TitleBarMode",
    ["GetToolRequested"] = "ToolRequested",
    ["GetTooltip"] = "Tooltip",
    ["GetTopbarTransparency"] = "TopbarTransparency",
    ["GetTotalMemoryUsageMb"] = "TotalMemoryUsageMb",
    ["GetTotalScriptPlusExecutionTime"] = "TotalScriptPlusExecutionTime",
    ["GetTouchpadMode"] = "TouchpadMode",
    ["GetTposeAdjustment"] = "TposeAdjustment",
    ["GetTrack"] = "AnimatedImageTrack",
    ["GetTrackByAnimationId"] = "AnimationTrack",
    ["GetTrackerLodController"] = "TrackerLodController",
    ["GetTransforms"] = "Transforms",
    ["GetTranslationForLocale"] = "TextFilterResult",
    ["GetTranslations"] = "Translations",
    ["GetTranslator"] = "Translator",
    ["GetTriangleCompositionAsync"] = "TriangleComposition",
    ["GetUV"] = "UV",
    ["GetUVs"] = "UVs",
    ["GetUiMessage"] = "UiMessage",
    ["GetUnderlyingAudioPlayer"] = "AudioPlayer",
    ["GetUniversalAppAdsEligibility"] = "UniversalAppAdsEligibility",
    ["GetUnparentedInstancesAsync"] = "UnparentedInstances",
    ["GetUnrecordableInstancesAsync"] = "UnrecordableInstances",
    ["GetUpcomingExperienceEventsAsync"] = "UpcomingExperienceEvents",
    ["GetUploadStatus"] = "UploadStatus",
    ["GetUpvalues"] = "Upvalues",
    ["GetUri"] = "Uri",
    ["GetUserAgent"] = "UserAgent",
    ["GetUserBadgesAsync"] = "UserBadges",
    ["GetUserCFrame"] = "UserCFrame",
    ["GetUserCategories"] = "UserCategories",
    ["GetUserDataAsync"] = "UserData",
    ["GetUserFromGlobalUserIdAsync"] = "UserFromGlobalUserId",
    ["GetUserId"] = "UserId",
    ["GetUserIdAccessList"] = "UserIdAccessList",
    ["GetUserIds"] = "UserIds",
    ["GetUserLayerLoadingStatus"] = "UserLayerLoadingStatus",
    ["GetUserLayerVariables"] = "UserLayerVariables",
    ["GetUserPlatformName"] = "UserPlatformName",
    ["GetUserSets"] = "UserSets",
    ["GetUserStatusForLayer"] = "UserStatusForLayer",
    ["GetUserSubscriptionDetailsAsync"] = "UserSubscriptionDetails",
    ["GetUserSubscriptionDetailsInternalAsync"] = "UserSubscriptionDetailsInternal",
    ["GetUserSubscriptionPaymentHistoryAsync"] = "UserSubscriptionPaymentHistory",
    ["GetUsersPriceLevelsAsync"] = "UsersPriceLevels",
    ["GetValidationRules"] = "ValidationRules",
    ["GetValueAtTime"] = "ValueAtTime",
    ["GetValueString"] = "ValueString",
    ["GetVariableById"] = "DebuggerVariable",
    ["GetVariableByIndex"] = "DebuggerVariable",
    ["GetVariableByName"] = "DebuggerVariable",
    ["GetVariables"] = "Variables",
    ["GetVertexBoneWeights"] = "VertexBoneWeights",
    ["GetVertexBones"] = "VertexBones",
    ["GetVertexColors"] = "VertexColors",
    ["GetVertexFaceColor"] = "VertexFaceColor",
    ["GetVertexFaceNormal"] = "VertexFaceNormal",
    ["GetVertexFaceUV"] = "VertexFaceUV",
    ["GetVertexFaces"] = "VertexFaces",
    ["GetVertexNormals"] = "VertexNormals",
    ["GetVertexUVs"] = "VertexUVs",
    ["GetVertices"] = "Vertices",
    ["GetVerticesWithAttribute"] = "VerticesWithAttribute",
    ["GetVerticesWithColor"] = "VerticesWithColor",
    ["GetVerticesWithNormal"] = "VerticesWithNormal",
    ["GetVerticesWithUV"] = "VerticesWithUV",
    ["GetVideoGenTriggersAsync"] = "VideoGenTriggers",
    ["GetVoiceChatApiVersion"] = "VoiceChatApiVersion",
    ["GetVoiceChatAvailable"] = "VoiceChatAvailable",
    ["GetVoiceChatRestrictionStatus"] = "VoiceChatRestrictionStatus",
    ["GetVoiceExperienceId"] = "VoiceExperienceId",
    ["GetWatchValue"] = "WatchValue",
    ["GetWatches"] = "Watches",
    ["GetWaveformAsync"] = "Waveform",
    ["GetWidgetFromLabel"] = "StudioWidget",
    ["GetWidgetFromPluginGui"] = "StudioWidget",
    ["GetWindowState"] = "WindowState",
    ["GetWithPlayerId"] = "WithPlayerId",
    ["GetWorldStepId"] = "WorldStepId",
    ["IterateVoxelsAsync_beta"] = "TerrainIterateOperation",
    ["ListItemsAsync"] = "MemoryStoreHashMapPages",
    ["ListVersionsAsync"] = "DataStoreVersionPages",
    ["LoadAnimationCoreScript"] = "AnimationTrack",
    ["LoadAsync"] = "AssetFetchStatus",
    ["LoadAvatar2DPreviewAsync"] = "EditableImage",
    ["LoadGeneratedAvatarAsync"] = "HumanoidDescription",
    ["LoadGeneratedMeshAsync"] = "MeshPart",
    ["LoadModelFromGlbAsync"] = "Model",
    ["LoadModelFromUrlAsync"] = "Model",
    ["LoadPlatformAsync"] = "AssetFetchStatus",
    ["LoadStreamAnimation"] = "AnimationStreamTrack",
    ["LoadStreamAnimationForSelfieView_deprecated"] = "AnimationStreamTrack",
    ["LoadStreamAnimationV2"] = "AnimationStreamTrack",
    ["ModifyVoxelsAsync_beta"] = "TerrainModifyOperation",
    ["Negate"] = "NegateOperations",
    ["OverrideStudioAction"] = "StudioActionOverride",
    ["PromptExperienceDetailsAsync"] = "PromptExperienceDetailsResult",
    ["PromptJoinAsync"] = "GroupMembershipStatus",
    ["PromptRsvpToEventAsync"] = "RsvpStatus",
    ["QueryDescendants"] = "Descendants",
    ["ReadBufferAsync"] = "VoxelBuffer",
    ["ReadVoxelsAsync_beta"] = "TerrainReadOperation",
    ["RegisterTest"] = "TestCase",
    ["RegisterTestLegacy"] = "TestCase",
    ["RequestAccessTokenScopesAsync"] = "AccessTokenScopes",
    ["RequestAvatarAutosetupAsync"] = "AvatarAutosetup",
    ["RequestInternal"] = "Internal",
    ["RequestLimitedAsync"] = "Limited",
    ["ScaleAsync"] = "StudioScreenshotCapture",
    ["SearchAudio"] = "AudioPages",
    ["SearchAudioAsync"] = "AudioPages",
    ["SearchCatalogAsync"] = "CatalogPages",
    ["SendAsync"] = "TextChatMessage",
    ["SendDictatedSpeechAsync"] = "TextChatMessage",
    ["SendDictatedSpeechUniverseChatAsync"] = "TextChatMessage",
    ["SendInternalAsync"] = "TextChatMessage",
    ["SendPresetAsync"] = "TextChatMessage",
    ["SendUniverseChatMessageAsync"] = "TextChatMessage",
    ["SendUniverseChatPresetAsync"] = "TextChatMessage",
    ["Separate"] = "UnionOperations",
    ["ShowAsync"] = "PluginAction",
    ["ShowRewardedVideoAdAsync"] = "ShowAdResult",
    ["ShowRewardedVideoAdAtClientAsync"] = "ShowAdResult",
    ["StartSessionWithPath"] = "AssetImportSession",
    ["StartSessionWithPathAsync"] = "AssetImportSession",
    ["StartVideoCaptureAsync"] = "VideoCaptureStartedResult",
    ["StartVideoCaptureInternalAsync"] = "VideoCaptureStartedResult",
    ["SubtractAsync"] = "UnionOperation",
    ["SweepPartAsync"] = "MeshPart",
    ["Union"] = "UnionOperation",
    ["UnionAsync"] = "UnionOperation",
    ["WriteVoxelsAsync_beta"] = "TerrainWriteOperation",
}

local PassthroughFunctions = {
    ["cloneref"] = true,
    ["clonereference"] = true,
    ["newcclosure"] = true,
    ["newlclosure"] = true,
}

local ClonedFunctions = {
    ["clonefunc"] = true,
    ["clonefunction"] = true,
    ["copyfunction"] = true,
}

local ArgSuffix = {
    ["GetService"] = "",
    ["WaitForChild"] = "",
    ["FindFirstChild"] = "",
    ["FindFirstChildOfClass"] = "",
    ["FindFirstChildWhichIsA"] = "",
    ["FindFirstAncestor"] = "",
    ["FindFirstAncestorOfClass"] = "",
    ["FindFirstAncestorWhichIsA"] = "",
    ["FindFirstDescendant"] = "",
    ["GetAttribute"] = "",
    ["FireServer"] = "",
    ["InvokeServer"] = "",
    ["GetPropertyChangedSignal"] = "Signal",
    ["GetAttributeChangedSignal"] = "Signal",
}

local BuiltinMethods = {
    ["BindToRenderStep"] = true,
    ["GetCore"] = true,
    ["GetTextSize"] = true,
    ["SetCore"] = true,
    ["UnbindFromRenderStep"] = true,
    ["byte"] = true,
    ["char"] = true,
    ["find"] = true,
    ["format"] = true,
    ["gmatch"] = true,
    ["gsub"] = true,
    ["len"] = true,
    ["lower"] = true,
    ["match"] = true,
    ["rep"] = true,
    ["reverse"] = true,
    ["split"] = true,
    ["sub"] = true,
    ["upper"] = true,
}

local Singulars = {
    ["Children"] = "Child",
    ["children"] = "child",
}

local EventParams = {
    ["PlayerAdded"] = {"Player"},
    ["PlayerRemoving"] = {"Player"},
    ["CharacterAdded"] = {"Character"},
    ["CharacterRemoving"] = {"Character"},
    ["CharacterAppearanceLoaded"] = {"Character"},
    ["Touched"] = {"Hit"},
    ["TouchEnded"] = {"Hit"},
    ["InputBegan"] = {"Input", "GameProcessed"},
    ["InputEnded"] = {"Input", "GameProcessed"},
    ["InputChanged"] = {"Input", "GameProcessed"},
    ["Heartbeat"] = {"DeltaTime"},
    ["RenderStepped"] = {"DeltaTime"},
    ["PreRender"] = {"DeltaTime"},
    ["PreSimulation"] = {"DeltaTime"},
    ["PostSimulation"] = {"DeltaTime"},
    ["Stepped"] = {"Time", "DeltaTime"},
    ["ChildAdded"] = {"Child"},
    ["ChildRemoved"] = {"Child"},
    ["DescendantAdded"] = {"Descendant"},
    ["DescendantRemoving"] = {"Descendant"},
    ["AncestryChanged"] = {"Child", "Parent"},
    ["FocusLost"] = {"EnterPressed", "InputObject"},
    ["Triggered"] = {"Player"},
    ["PromptTriggered"] = {"Prompt", "Player"},
    ["OnServerEvent"] = {"Player"},
    ["Chatted"] = {"Message", "Recipient"},
    ["HealthChanged"] = {"Health"},
    ["StateChanged"] = {"OldState", "NewState"},
    ["Seated"] = {"Active", "Seat"},
    ["Running"] = {"Speed"},
    ["Jumping"] = {"Active"},
    ["Climbing"] = {"Speed"},
    ["Swimming"] = {"Speed"},
    ["MoveToFinished"] = {"Reached"},
    ["Completed"] = {"PlaybackState"},
}

local ShadowAlts = {
    ["Vector3"] = "Vector",
    ["Vector2"] = "Vector",
    ["Color3"] = "Color",
    ["CFrame"] = "Cframe",
    ["UDim2"] = "Udim",
    ["UDim"] = "Udim",
    ["Random"] = "Rng",
    ["TweenInfo"] = "Info",
    ["NumberSequence"] = "Sequence",
    ["ColorSequence"] = "Sequence",
    ["NumberRange"] = "Range",
    ["Region3"] = "Region",
    ["Rect"] = "Rectangle",
}

local Abbrevs = {
    ["plr"] = "Player",
    ["plrs"] = "Players",
    ["char"] = "Character",
    ["chr"] = "Character",
    ["hum"] = "Humanoid",
    ["hrp"] = "HumanoidRootPart",
    ["cb"] = "Callback",
    ["idx"] = "Index",
    ["obj"] = "Object",
    ["inst"] = "Instance",
    ["msg"] = "Message",
    ["btn"] = "Button",
    ["cfg"] = "Config",
    ["pos"] = "Position",
    ["dir"] = "Direction",
    ["dist"] = "Distance",
    ["mag"] = "Magnitude",
    ["val"] = "Value",
    ["ev"] = "Event",
    ["evt"] = "Event",
    ["conn"] = "Connection",
    ["con"] = "Connection",
    ["mdl"] = "Model",
    ["img"] = "Image",
    ["lbl"] = "Label",
    ["frm"] = "Frame",
}

local ShadowAltValues = {
    ["Cframe"] = true,
    ["Color"] = true,
    ["Info"] = true,
    ["Range"] = true,
    ["Rectangle"] = true,
    ["Region"] = true,
    ["Rng"] = true,
    ["Sequence"] = true,
    ["Udim"] = true,
    ["Vector"] = true,
}

local function OnlyUnderscoreGroups(Rest)
    while Rest ~= "" do
        local Digits = string.match(Rest, "^_(%d+)")

        if not Digits then
            return false
        end

        Rest = string.sub(Rest, #Digits + 2)
    end

    return true
end

local function IsUnclearName(Name)
    local Rest = string.match(Name, "^%a%d*(.*)$")

    return Rest ~= nil and string.find(Name, "^%a") ~= nil and OnlyUnderscoreGroups(Rest)
end

local function IsArgName(Name)
    local Rest = string.match(Name, "^%a%d+(.*)$")

    return Rest ~= nil and OnlyUnderscoreGroups(Rest)
end

local function IsGeneratedName(Name)
    local Rest = string.match(Name, "^[vVcC]%d+(.*)$")

    return Rest ~= nil and OnlyUnderscoreGroups(Rest)
end

local LibBases = {string = true, table = true, math = true, task = true, os = true, utf8 = true, bit32 = true, buffer = true, coroutine = true, debug = true}

local function IsValidIdentifier(Text)
    return string.find(Text, "^[A-Za-z_][%w_\128-\255]*$") ~= nil
end

local function NormalizeClassName(Name)
    if IsValidIdentifier(Name) then
        return Name
    end

    return (string.gsub(Name, "[%s_%-]+", ""))
end

local function Camel(Name)
    local Run = string.match(Name, "^[A-Z]+")

    if not Run then
        return Name
    end

    local Size = #Run

    if Size > 1 and Size < #Name and string.find(string.sub(Name, Size + 1, Size + 1), "^%l") then
        Size -= 1
    end

    return string.lower(string.sub(Name, 1, Size)) .. string.sub(Name, Size + 1)
end

local function MatchCase(Source, Name)
    if string.find(Source, "%l") and not string.find(Source, "%u") then
        return string.lower(Name)
    end

    if string.find(string.sub(Source, 1, 1), "^%l") then
        return Camel(Name)
    end

    return Name
end

local function JoinSuffix(Base, Num)
    if Base ~= "" and (IsDigitChar(string.sub(Base, -1)) or ShadowAltValues[Base]) then
        return Base .. "_" .. tostring(Num)
    end

    return Base .. tostring(Num)
end

local function MatchQuoted(Text, Index, Quote)
    local Length = #Text
    local J = Index + 1

    while J < Length do
        local D = CharAt(Text, J)

        if D == "\\" then
            local Next = CharAt(Text, J + 1)

            if Next == "" or Next == "\n" then
                return nil
            end

            J += 2
        elseif D == Quote then
            return J + 1
        else
            J += 1
        end
    end

    return nil
end

local function BlankStrings(Text, Quote)
    local Out = {}
    local Index = 0
    local Length = #Text

    while Index < Length do
        local Ch = CharAt(Text, Index)

        if Ch == Quote then
            local After = MatchQuoted(Text, Index, Quote)

            if After then
                Out[#Out + 1] = Quote .. Quote
                Index = After
            else
                Out[#Out + 1] = Ch
                Index += 1
            end
        else
            Out[#Out + 1] = Ch
            Index += 1
        end
    end

    return table.concat(Out)
end

local function StartsWithName(Text, Name)
    local Stripped = string.gsub(Text, "%-%-[^\n]*", "")
    Stripped = BlankStrings(BlankStrings(Stripped, '"'), "'")
    local Word = string.match(Stripped, "^%s*([A-Za-z_][%w_\128-\255]*)")

    return Word ~= nil and Word == Name
end

local function IsFunctionStart(Text)
    return StartsWith(Text, "function") and not IsWordAt(Text, 9)
end

local function ReadStmt(Code, Start)
    local I = Start
    local N = #Code
    local Depth = 0

    while I < N do
        local C = CharAt(Code, I)

        if C == '"' or C == "'" or C == "`" then
            I += 1

            while I < N and CharAt(Code, I) ~= C do
                if CharAt(Code, I) == "\\" and I + 1 < N then
                    I += 2
                else
                    I += 1
                end
            end

            if I < N then
                I += 1
            end

            continue
        end

        if C == "-" and I + 1 < N and CharAt(Code, I + 1) == "-" then
            local J = FindFrom(Code, "\n", I)

            if J == -1 then
                I = N
            else
                I = J
            end

            if Depth == 0 then
                return Slice(Code, Start, I), I
            end

            continue
        end

        if C == "[" and I + 1 < N and (CharAt(Code, I + 1) == "[" or CharAt(Code, I + 1) == "=") then
            local J = I + 1
            local Eq = 0

            while J < N and CharAt(Code, J) == "=" do
                Eq += 1
                J += 1
            end

            if J < N and CharAt(Code, J) == "[" then
                local Close = "]" .. string.rep("=", Eq) .. "]"
                local End = FindFrom(Code, Close, J + 1)

                if End == -1 then
                    I = N
                else
                    I = End + #Close
                end

                continue
            end
        end

        if C == "(" or C == "[" or C == "{" then
            Depth += 1
        elseif C == ")" or C == "]" or C == "}" then
            if Depth > 0 then
                Depth -= 1
            end
        elseif C == "\n" and Depth == 0 then
            return Slice(Code, Start, I), I
        end

        I += 1
    end

    return Slice(Code, Start, N), N
end

local function SplitCommas(Text)
    local Parts = {}
    local Depth = 0
    local Last = 0
    local I = 0
    local N = #Text

    while I < N do
        local C = CharAt(Text, I)

        if C == '"' or C == "'" or C == "`" then
            I += 1

            while I < N and CharAt(Text, I) ~= C do
                if CharAt(Text, I) == "\\" and I + 1 < N then
                    I += 2
                else
                    I += 1
                end
            end

            if I < N then
                I += 1
            end

            continue
        end

        if C == "-" and I + 1 < N and CharAt(Text, I + 1) == "-" then
            local J = FindFrom(Text, "\n", I)

            if J == -1 then
                I = N
            else
                I = J
            end

            continue
        end

        if C == "(" or C == "[" or C == "{" then
            Depth += 1
        elseif C == ")" or C == "]" or C == "}" then
            if Depth > 0 then
                Depth -= 1
            end
        elseif C == "," and Depth == 0 then
            Parts[#Parts + 1] = Slice(Text, Last, I)
            Last = I + 1
        end

        I += 1
    end

    Parts[#Parts + 1] = string.sub(Text, Last + 1)

    return Parts
end

local function ApplyMap(Text, NameMap)
    if next(NameMap) == nil then
        return Text
    end

    local Result = {}
    local I = 0
    local N = #Text

    while I < N do
        local C = CharAt(Text, I)

        if C == '"' or C == "'" or C == "`" then
            local Start = I
            I += 1

            while I < N and CharAt(Text, I) ~= C do
                if CharAt(Text, I) == "\\" and I + 1 < N then
                    I += 2
                else
                    I += 1
                end
            end

            if I < N then
                I += 1
            end

            Result[#Result + 1] = Slice(Text, Start, I)
            continue
        end

        if C == "-" and I + 1 < N and CharAt(Text, I + 1) == "-" then
            local J = FindFrom(Text, "\n", I)

            if J == -1 then
                J = N
            end

            Result[#Result + 1] = Slice(Text, I, J)
            I = J
            continue
        end

        if IsAlphaChar(C) or C == "_" then
            local Word = string.match(Text, "^[A-Za-z_][%w_\128-\255]*", I + 1)
            local K = I - 1

            while K >= 0 and (CharAt(Text, K) == " " or CharAt(Text, K) == "\t" or CharAt(Text, K) == "\n" or CharAt(Text, K) == "\r") do
                K -= 1
            end

            local IsField = K >= 0 and (CharAt(Text, K) == "." or CharAt(Text, K) == ":")

            if not IsField and NameMap[Word] then
                Result[#Result + 1] = NameMap[Word]
            else
                Result[#Result + 1] = Word
            end

            I += #Word
            continue
        end

        Result[#Result + 1] = C
        I += 1
    end

    return table.concat(Result)
end

local function MatchLongOpen(Text, Index)
    if CharAt(Text, Index) ~= "[" then
        return nil
    end

    local J = Index + 1
    local Eq = 0

    while CharAt(Text, J) == "=" do
        Eq += 1
        J += 1
    end

    if CharAt(Text, J) == "[" then
        return Eq, J + 1
    end

    return nil
end

local function ScanBacktick(Code, I)
    local N = #Code
    local Segs = {}
    local J = I + 1
    local TextStart = I

    while J < N do
        local C = CharAt(Code, J)

        if C == "\\" and J + 1 < N then
            J += 2
        elseif C == "`" then
            Segs[#Segs + 1] = {"btext", TextStart, J + 1}
            return Segs, J + 1
        elseif C == "{" then
            Segs[#Segs + 1] = {"btext", TextStart, J + 1}
            local Depth = 1
            local K = J + 1

            while K < N do
                local D = CharAt(Code, K)

                if D == '"' or D == "'" then
                    K += 1

                    while K < N and CharAt(Code, K) ~= D do
                        if CharAt(Code, K) == "\\" then
                            K += 2
                        else
                            K += 1
                        end
                    end
                elseif D == "{" then
                    Depth += 1
                elseif D == "}" then
                    Depth -= 1

                    if Depth == 0 then
                        break
                    end
                end

                K += 1
            end

            Segs[#Segs + 1] = {"code", J + 1, K}
            TextStart = K
            J = K + 1
        else
            J += 1
        end
    end

    Segs[#Segs + 1] = {"btext", TextStart, N}

    return Segs, N
end

local function Tokenize(Code)
    local Tokens = {}
    local N = 0
    local I = 1

    while true do
        I = string.find(Code, "[^ \t\r\n]", I)

        if not I then
            break
        end

        local B = string.byte(Code, I)

        if B == 45 and string.byte(Code, I + 1) == 45 then
            local Start = I - 1
            local Eq, LongEnd = nil, nil

            if string.byte(Code, I + 2) == 91 then
                Eq, LongEnd = MatchLongOpen(Code, I + 1)
            end

            if Eq then
                local Close = "]" .. string.rep("=", Eq) .. "]"
                local Found, FoundEnd = string.find(Code, Close, LongEnd + 1, true)

                if Found then
                    I = FoundEnd + 1
                else
                    I = #Code + 1
                end
            else
                I = string.find(Code, "\n", I, true) or #Code + 1
            end

            Tokens[N] = {Kind = "comment", Text = string.sub(Code, Start + 1, I - 1), Start = Start, End = I - 1}
            N += 1
            continue
        end

        if B == 96 then
            local Segs, After = ScanBacktick(Code, I - 1)
            I = After + 1

            for _, Seg in ipairs(Segs) do
                if Seg[1] == "btext" then
                    Tokens[N] = {Kind = "btext", Text = Slice(Code, Seg[2], Seg[3]), Start = Seg[2], End = Seg[3]}
                    N += 1
                elseif Seg[3] > Seg[2] then
                    local Inner, InnerCount = Tokenize(Slice(Code, Seg[2], Seg[3]))

                    for K = 0, InnerCount - 1 do
                        Tokens[N] = {Kind = Inner[K].Kind, Text = Inner[K].Text, Start = Inner[K].Start + Seg[2], End = Inner[K].End + Seg[2]}
                        N += 1
                    end
                end
            end

            continue
        end

        if B == 34 or B == 39 then
            local Start = I - 1
            local Pos = I + 1

            while true do
                local Hit = string.find(Code, B == 34 and '[\\"]' or "[\\']", Pos)

                if not Hit then
                    Pos = #Code + 1
                    break
                end

                if string.byte(Code, Hit) == 92 then
                    if Hit < #Code then
                        Pos = Hit + 2
                    else
                        Pos = Hit + 1
                    end

                    if Pos > #Code then
                        break
                    end
                else
                    Pos = Hit + 1
                    break
                end
            end

            I = Pos
            Tokens[N] = {Kind = "string", Text = string.sub(Code, Start + 1, I - 1), Start = Start, End = I - 1}
            N += 1
            continue
        end

        if B == 91 then
            local Next = string.byte(Code, I + 1)

            if Next == 91 or Next == 61 then
                local Eq, LongEnd = MatchLongOpen(Code, I - 1)

                if Eq then
                    local Close = "]" .. string.rep("=", Eq) .. "]"
                    local Found, FoundEnd = string.find(Code, Close, LongEnd + 1, true)
                    local Stop = #Code

                    if Found then
                        Stop = FoundEnd
                    end

                    Tokens[N] = {Kind = "string", Text = string.sub(Code, I, Stop), Start = I - 1, End = Stop}
                    N += 1
                    I = Stop + 1
                    continue
                end
            end
        end

        if B >= 97 and B <= 122 or B >= 65 and B <= 90 or B == 95 or B >= 128 then
            local _, Last = string.find(Code, "^[A-Za-z0-9_\128-\255]*", I)
            local Word = string.sub(Code, I, Last)
            Tokens[N] = {Kind = Keywords[Word] and "kw" or "ident", Text = Word, Start = I - 1, End = Last}
            N += 1
            I = Last + 1
            continue
        end

        if B >= 48 and B <= 57 or B == 46 and (string.byte(Code, I + 1) or 0) >= 48 and (string.byte(Code, I + 1) or 0) <= 57 then
            local _, Last = string.find(Code, "^[A-Za-z0-9_\128-\255.]*", I)
            Tokens[N] = {Kind = "num", Text = string.sub(Code, I, Last), Start = I - 1, End = Last}
            N += 1
            I = Last + 1
            continue
        end

        Tokens[N] = {Kind = "op", Text = string.sub(Code, I, I), Start = I - 1, End = I}
        N += 1
        I += 1
    end

    return Tokens, N
end

local function NoComments(Text)
    if not string.find(Text, "--", 1, true) then
        return Text
    end

    local Out = {}
    local Last = 0
    local Tokens, N = Tokenize(Text)

    for K = 0, N - 1 do
        local T = Tokens[K]

        if T.Kind == "comment" then
            Out[#Out + 1] = Slice(Text, Last, T.Start)
            Last = T.End
        end
    end

    Out[#Out + 1] = string.sub(Text, Last + 1)

    return table.concat(Out)
end

local function Weak(Text)
    local Body = Strip(Text)

    if Body == "" then
        return false
    end

    if string.find(Body, "^%(*%s*[A-Za-z_][%w_\128-\255]*%s*%)*$") then
        return true
    end

    local First = string.sub(Body, 1, 1)

    if First == '"' or First == "'" then
        return MatchQuoted(Body, 0, First) == #Body
    end

    if First == "`" then
        return string.find(Body, "^`[^`]*`$") ~= nil
    end

    return string.find(Body, "^[0-9][%w_.\128-\255]*$") ~= nil
end

local function Singular(Name)
    if Singulars[Name] then
        return Singulars[Name]
    end

    if EndsWith(Name, "ies") and #Name > 3 then
        return string.sub(Name, 1, -4) .. "y"
    end

    if EndsWith(Name, "List") and #Name > 4 then
        return string.sub(Name, 1, -5)
    end

    if EndsWith(Name, "s") and #Name > 1 then
        local Before = string.sub(Name, -2, -2)

        if Before ~= "s" and Before ~= "u" and Before ~= "i" then
            return string.sub(Name, 1, -2)
        end
    end

    return nil
end

local function MatchOp(Kind, Text, Index)
    local C1 = CharAt(Text, Index)
    local C2 = Slice(Text, Index, Index + 2)

    if Kind == "or" then
        if C2 == "or" and not IsWordAt(Text, Index) and not IsWordAt(Text, Index + 3) then
            return Index + 2
        end
    elseif Kind == "and" then
        if Slice(Text, Index, Index + 3) == "and" and not IsWordAt(Text, Index) and not IsWordAt(Text, Index + 4) then
            return Index + 3
        end
    elseif Kind == "cmp" then
        if C2 == "==" or C2 == "~=" or C2 == "<=" or C2 == ">=" then
            return Index + 2
        end

        if C1 == "<" or C1 == ">" then
            return Index + 1
        end
    elseif Kind == "concat" then
        if C2 == ".." and CharAt(Text, Index - 1) ~= "." and CharAt(Text, Index + 2) ~= "." then
            return Index + 2
        end
    else
        if C1 == "+" or C1 == "-" or C1 == "*" then
            return Index + 1
        end

        if C2 == "//" then
            return Index + 2
        end

        if C1 == "/" or C1 == "%" or C1 == "^" then
            return Index + 1
        end
    end

    return nil
end

local function SplitOp(Text, Kind)
    if not string.find(Text, Kind == "or" and "or" or Kind == "and" and "and" or Kind == "cmp" and "[=~<>]" or Kind == "concat" and "%.%." or "[%+%-%*/%%%^]") then
        return {Text}
    end

    local Parts = {}
    local Depth = 0
    local Last = 0
    local I = 0
    local N = #Text

    while I < N do
        local C = string.sub(Text, I + 1, I + 1)

        if C == '"' or C == "'" or C == "`" then
            I += 1

            while I < N and CharAt(Text, I) ~= C do
                if CharAt(Text, I) == "\\" and I + 1 < N then
                    I += 2
                else
                    I += 1
                end
            end

            I += 1
            continue
        end

        local Eq, LongEnd = nil, nil

        if C == "[" then
            Eq, LongEnd = MatchLongOpen(Text, I)
        end

        if Eq then
            local Close = "]" .. string.rep("=", Eq) .. "]"
            local End = FindFrom(Text, Close, LongEnd)

            if End == -1 then
                I = N
            else
                I = End + #Close
            end

            continue
        end

        if C == "(" or C == "[" or C == "{" then
            Depth += 1
        elseif C == ")" or C == "]" or C == "}" then
            if Depth > 0 then
                Depth -= 1
            end
        elseif Depth == 0 and string.find(C, Kind == "or" and "^o$" or Kind == "and" and "^a$" or Kind == "cmp" and "^[=~<>]$" or Kind == "concat" and "^%.$" or "^[%+%-%*/%%%^]$") then
            local Stop = MatchOp(Kind, Text, I)

            if Stop and Stop > I then
                local K = I - 1

                while K >= 0 and string.find(CharAt(Text, K), "%s") do
                    K -= 1
                end

                local PrevChar = ""

                if K >= 0 then
                    PrevChar = CharAt(Text, K)
                end

                if C ~= "-" or (PrevChar ~= "" and (IsAlnumChar(PrevChar) or string.find("_)]}\"'`", PrevChar, 1, true))) then
                    Parts[#Parts + 1] = Slice(Text, Last, I)
                    I = Stop
                    Last = I
                    continue
                end
            end
        end

        I += 1
    end

    Parts[#Parts + 1] = string.sub(Text, Last + 1)

    return Parts
end

local function Unwrap(E)
    if not StartsWith(E, "(") then
        return nil
    end

    local Tokens, N = Tokenize(E)
    local Depth = 0

    for I = 0, N - 1 do
        local T = Tokens[I]

        if T.Kind == "op" then
            if T.Text == "(" or T.Text == "[" or T.Text == "{" then
                Depth += 1
            elseif T.Text == ")" or T.Text == "]" or T.Text == "}" then
                Depth -= 1

                if Depth == 0 then
                    if I == N - 1 then
                        return Slice(E, 1, T.Start)
                    end

                    return nil
                end
            end
        end
    end

    return nil
end

local function ChainOf(E)
    local Tokens, N = Tokenize(E)

    if N == 0 or not (Tokens[0].Kind == "ident" or Tokens[0].Text == "self") then
        return nil
    end

    local Steps = {}
    local I = 1

    while I < N do
        local T = Tokens[I]

        if T.Kind == "op" and (T.Text == "." or T.Text == ":") and I + 1 < N and Tokens[I + 1].Kind == "ident" then
            Steps[#Steps + 1] = {Kind = "m", Text = Tokens[I + 1].Text, Op = T.Text, Start = T.Start, End = Tokens[I + 1].End}
            I += 2
        elseif T.Kind == "string" then
            Steps[#Steps + 1] = {Kind = "c", Text = Slice(E, T.Start, T.End), Op = "", Start = T.Start, End = T.End}
            I += 1
        elseif T.Kind == "op" and (T.Text == "(" or T.Text == "[" or T.Text == "{") then
            local Depth = 0
            local J = I

            while J < N do
                if Tokens[J].Kind == "op" then
                    if Tokens[J].Text == "(" or Tokens[J].Text == "[" or Tokens[J].Text == "{" then
                        Depth += 1
                    elseif Tokens[J].Text == ")" or Tokens[J].Text == "]" or Tokens[J].Text == "}" then
                        Depth -= 1

                        if Depth == 0 then
                            break
                        end
                    end
                end

                J += 1
            end

            if J >= N then
                return nil
            end

            Steps[#Steps + 1] = {Kind = T.Text == "[" and "i" or "c", Text = Slice(E, T.End, Tokens[J].Start), Op = "", Start = T.Start, End = Tokens[J].End}
            I = J + 1
        else
            return nil
        end
    end

    return Tokens[0].Text, Steps
end

local function MatchIfExpr(E)
    if not StartsWith(E, "if") or IsWordAt(E, 3) then
        return nil
    end

    local ThenStart = FindWord(E, "then", 3)

    if not ThenStart then
        return nil
    end

    local WsEnd = ThenStart + 4

    while string.find(string.sub(E, WsEnd, WsEnd), "^%s") do
        WsEnd += 1
    end

    local ElseAt = FindWord(E, "else", WsEnd)
    local ElseIfAt = FindWord(E, "elseif", WsEnd)
    local Q = ElseAt

    if ElseIfAt and (Q == nil or ElseIfAt < Q) then
        Q = ElseIfAt
    end

    if not Q then
        return nil
    end

    return RStrip(string.sub(E, WsEnd, Q - 1))
end

local function ExprKind(Expr)
    local E = Strip(NoComments(Expr))

    if E == "" or IsFunctionStart(E) then
        return nil
    end

    local IfPart = MatchIfExpr(E)

    if IfPart then
        return ExprKind(IfPart)
    end

    local Parts = SplitOp(E, "or")

    if #Parts > 1 then
        for _, Part in ipairs(Parts) do
            local K = ExprKind(Part)

            if K then
                return K
            end
        end

        return nil
    end

    Parts = SplitOp(E, "and")

    if #Parts > 1 then
        return ExprKind(Parts[#Parts])
    end

    if #SplitOp(E, "cmp") > 1 or (StartsWith(E, "not") and not IsWordAt(E, 4)) then
        return "bool"
    end

    if #SplitOp(E, "concat") > 1 then
        return "str"
    end

    if #SplitOp(E, "arith") > 1 or StartsWith(E, "-") then
        return "num"
    end

    if StartsWith(E, "#") then
        return "len"
    end

    local Inner = Unwrap(E)

    if Inner ~= nil then
        return ExprKind(Inner)
    end

    if E == "..." then
        return "args"
    end

    if E == "true" or E == "false" then
        return "bool"
    end

    if string.find(E, "^[0-9][0-9A-Za-z_.]*$") or string.find(E, "^%.[0-9]+$") then
        return "num"
    end

    local First = string.sub(E, 1, 1)

    if ((First == '"' or First == "'") and MatchQuoted(E, 0, First) == #E) or MatchLongOpen(E, 0) ~= nil or (First == "`" and select(2, ScanBacktick(E, 0)) == #E) then
        return "str"
    end

    return nil
end

local function StemName(Filename)
    local Stem = string.gsub(Filename, "%.[A-Za-z0-9]+$", "")
    local Pieces = {}

    for Part in string.gmatch(Stem, "[A-Za-z0-9]+") do
        Pieces[#Pieces + 1] = string.upper(string.sub(Part, 1, 1)) .. string.sub(Part, 2)
    end

    local Name = table.concat(Pieces)

    if IsValidIdentifier(Name) then
        return Name
    end

    return nil
end

local function UrlName(Url)
    local Rest = string.match(Url, "^https?://(.*)$")

    if not Rest then
        return nil
    end

    local After = string.match(Rest, "^[^/%s\"'?#]+/(.*)$")

    if not After then
        return nil
    end

    local Run = string.match(After, "^[^%s\"'?#]*")
    local Segments = Split(Run, "/")

    for K = #Segments, 1, -1 do
        if Segments[K] ~= "" then
            return StemName(Segments[K])
        end
    end

    return nil
end

local function InferName(Expr)
    local Result = nil

    while true do
        local E = Strip(NoComments(Expr))

        if E == "" or IsFunctionStart(E) then
            break
        end

        local Ident = string.match(E, "^[\"']([A-Za-z_][A-Za-z0-9_]*)[\"']$")

        if Ident then
            Result = Ident
            break
        end

        local Url = string.match(E, '^"(https?://[^"]+)"$') or string.match(E, "^'(https?://[^']+)'$")

        if Url then
            local UrlStem = UrlName(Url)

            if UrlStem then
                Result = UrlStem .. "Url"
            end

            break
        end

        local PathText = nil
        local Quote = string.sub(E, 1, 1)

        if (Quote == '"' or Quote == "'") and #E >= 2 and string.sub(E, -1) == Quote then
            local Content = string.sub(E, 2, -2)

            if not string.find(Content, Quote, 1, true) and not string.find(Content, "\\", 1, true) and (EndsWith(Content, ".lua") or EndsWith(Content, ".luau") or EndsWith(Content, ".txt") or EndsWith(Content, ".json")) then
                PathText = Content
            end
        end

        if PathText then
            local PathStem = StemName(string.match(PathText, "[^/]*$"))

            if PathStem then
                Result = PathStem .. "Path"
            end

            break
        end

        local IfPart = MatchIfExpr(E)

        if IfPart then
            if not Weak(IfPart) then
                Result = InferName(IfPart)
            end

            break
        end

        local Inner = Unwrap(E)

        if Inner ~= nil then
            Result = InferName(Inner)
            break
        end

        local Parts = SplitOp(E, "or")

        if #Parts > 1 then
            for _, Part in ipairs(Parts) do
                if not Weak(Part) then
                    local Candidate = InferName(Part)

                    if Candidate then
                        Result = Candidate
                        break
                    end
                end
            end

            break
        end

        Parts = SplitOp(E, "and")

        if #Parts > 1 then
            for K = #Parts, 1, -1 do
                if not Weak(Parts[K]) then
                    local Candidate = InferName(Parts[K])

                    if Candidate then
                        Result = Candidate
                        break
                    end
                end
            end

            break
        end

        if #SplitOp(E, "cmp") > 1 or #SplitOp(E, "concat") > 1 then
            break
        end

        Parts = SplitOp(E, "arith")

        if #Parts > 1 then
            local FirstBase, FirstSteps = ChainOf(Strip(Parts[1]))

            if FirstBase and #FirstSteps > 0 then
                Result = InferName(Parts[1])
            end

            break
        end

        if (StartsWith(E, "not") and not IsWordAt(E, 4)) or StartsWith(E, "#") or StartsWith(E, "-") then
            break
        end

        local Base, Steps = ChainOf(E)

        if not Base then
            break
        end

        if #Steps == 0 then
            Result = Base
            break
        end

        local Last = Steps[#Steps]

        if (Base == "loadstring" or Base == "load") and Steps[1].Kind == "c" and (#Steps == 1 or (#Steps == 2 and Steps[2].Kind == "c" and Strip(Steps[2].Text) == "")) then
            local Found = nil
            local LoadUrl = string.match(Steps[1].Text, "[\"'](https?://[^\"']+)[\"']")

            if LoadUrl then
                Found = UrlName(LoadUrl)
            else
                local FileName = string.match(Steps[1].Text, "readfile%s*%(%s*[\"']([^\"'/\\]+)[\"']")

                if FileName then
                    Found = StemName(FileName)
                else
                    local FileVar = string.match(Steps[1].Text, "readfile%s*%(%s*([A-Za-z_][%w_\128-\255]*)%s*%)")

                    if FileVar and EndsWith(FileVar, "Path") and #FileVar > 4 then
                        Found = string.sub(FileVar, 1, -5)
                    else
                        local StartA, _, VarA = string.find(Steps[1].Text, "HttpGet%s*%(%s*([A-Za-z_][%w_\128-\255]*)%s*[,)]")
                        local StartB, _, VarB = string.find(Steps[1].Text, "HttpGetAsync%s*%(%s*([A-Za-z_][%w_\128-\255]*)%s*[,)]")
                        local UrlVar = nil

                        if StartA and (StartB == nil or StartA < StartB) then
                            UrlVar = VarA
                        elseif StartB then
                            UrlVar = VarB
                        end

                        if UrlVar and EndsWith(UrlVar, "Url") and #UrlVar > 3 then
                            Found = string.sub(UrlVar, 1, -4)
                        end
                    end
                end
            end

            if Found then
                Result = Found
                break
            end
        end

        if Base == "require" and #Steps == 1 and Last.Kind == "c" then
            local Arg = Strip(Last.Text)

            if IsValidIdentifier(Arg) then
                if EndsWith(Arg, "Path") and #Arg > 4 then
                    Result = string.sub(Arg, 1, -5)
                    break
                end
            elseif not Weak(Arg) then
                local Found = InferName(Arg)

                if Found then
                    Result = Found
                    break
                end
            end
        end

        if Last.Kind == "i" then
            local Key = string.match(Last.Text, "^%s*[\"']([A-Za-z_][A-Za-z0-9_]*)[\"']%s*$")

            if Key then
                Result = Key
                break
            end

            local Prefix = InferName(string.sub(E, 1, Last.Start))

            if Prefix then
                Result = Singular(Prefix)
            else
                Result = nil
            end

            break
        end

        if Last.Kind == "c" then
            if #Steps == 1 then
                local FirstIdent = string.match(Last.Text, "^%s*[\"']([A-Za-z_][%w_\128-\255]*)[\"']")

                if PassthroughFunctions[Base] or ClonedFunctions[Base] then
                    local InnerName = InferName(SplitCommas(Last.Text)[1])

                    if InnerName and not IsUnclearName(InnerName) then
                        if ClonedFunctions[Base] then
                            Result = "Cloned" .. string.upper(string.sub(InnerName, 1, 1)) .. string.sub(InnerName, 2)
                        else
                            Result = InnerName
                        end

                        break
                    end
                end

                if GlobalFunctions[Base] then
                    Result = MatchCase(Base, GlobalFunctions[Base])
                else
                    Result = FirstIdent or Base
                end

                break
            end

            local Prev = Steps[#Steps - 1]

            if Prev.Kind ~= "m" then
                break
            end

            local Name = Prev.Text
            local FirstArg = string.match(Last.Text, "^%s*[\"']([^\"']+)[\"']")

            if FirstArg and (ArgSuffix[Name] or (Name == "new" and (Base == "Instance" or Base == "Drawing") and #Steps == 2)) then
                Result = NormalizeClassName(FirstArg) .. (ArgSuffix[Name] or "")
                break
            end

            local Custom = FirstArg ~= nil and IsValidIdentifier(FirstArg) and MethodNames[Name] == nil and not BuiltinMethods[Name] and not LibBases[Base]

            if #Steps == 2 and Prev.Op == "." then
                if string.find(string.sub(Base, 1, 1), "^%u") then
                    if Name == "new" or StartsWith(Name, "from") or StartsWith(Name, "look") or Name == "Angles" or Name == "identity" then
                        Result = Base
                        break
                    end

                    if LibMethods[Base .. "." .. Name] then
                        Result = LibMethods[Base .. "." .. Name]
                        break
                    end

                    if Custom then
                        Result = FirstArg
                        break
                    end

                    Result = NormalizeClassName(Name)
                    break
                end

                if LibMethods[Base .. "." .. Name] then
                    Result = MatchCase(Base .. "." .. Name, LibMethods[Base .. "." .. Name])
                    break
                end
            end

            if Name == "Wait" and #Steps > 2 and Steps[#Steps - 2].Kind == "m" and EventParams[Steps[#Steps - 2].Text] then
                Result = EventParams[Steps[#Steps - 2].Text][1]
                break
            end

            if Custom then
                Result = FirstArg
                break
            end

            if (Name == "Connect" or Name == "Once") and Prev.Op == ":" and #Steps > 2 and Steps[#Steps - 2].Kind == "m" and Steps[#Steps - 2].Op == "." and ({Heartbeat = true, RenderStepped = true, Stepped = true, PreSimulation = true, PostSimulation = true, PreRender = true, PreAnimation = true})[Steps[#Steps - 2].Text] then
                Result = Steps[#Steps - 2].Text .. "Connection"
                break
            end

            Result = MethodNames[Name] or RobloxMethods[Name] or NormalizeClassName(Name)
            break
        end

        local Name = Last.Text

        if Base == "Enum" and #Steps == 2 and Steps[1].Kind == "m" then
            if #Name <= 1 then
                Result = Steps[1].Text .. Name
            else
                Result = Name
            end

            break
        end

        if #Steps == 1 and Last.Op == "." and LibMethods[Base .. "." .. Name] then
            Result = MatchCase(Base .. "." .. Name, LibMethods[Base .. "." .. Name])
            break
        end

        Result = Name
        break
    end

    if Result and IsValidIdentifier(Result) and not Keywords[Result] then
        return Result
    end

    return nil
end

local function FindScopes(Tokens, N)
    local Scopes = {}
    local Stack = {}
    local AwaitingDo = false

    for Ti = 0, N - 1 do
        local Tok = Tokens[Ti]

        if Tok.Kind == "kw" then
            local W = Tok.Text

            if W == "for" or W == "while" then
                AwaitingDo = true
                Stack[#Stack + 1] = {Ti, false, Ti}
            elseif W == "do" then
                if AwaitingDo then
                    AwaitingDo = false
                else
                    Stack[#Stack + 1] = {Ti, false, Ti}
                end
            elseif W == "function" or W == "repeat" then
                Stack[#Stack + 1] = {Ti, false, Ti}
            elseif W == "if" then
                Stack[#Stack + 1] = {Ti, true, Ti}
            elseif W == "elseif" or W == "else" then
                if #Stack > 0 and Stack[#Stack][2] then
                    local Top = table.remove(Stack)
                    Scopes[#Scopes + 1] = {Top[3], Ti}
                    Stack[#Stack + 1] = {Top[1], true, Ti}
                end
            elseif W == "end" or W == "until" then
                if #Stack > 0 then
                    local Top = table.remove(Stack)
                    Scopes[#Scopes + 1] = {Top[3], Ti}
                end
            end
        end
    end

    return Scopes
end

local function BisectLeft(List, Value)
    local Low = 0
    local High = #List

    while Low < High do
        local Mid = (Low + High) // 2

        if List[Mid + 1] < Value then
            Low = Mid + 1
        else
            High = Mid
        end
    end

    return Low
end

local function BisectRight(List, Value)
    local Low = 0
    local High = #List

    while Low < High do
        local Mid = (Low + High) // 2

        if Value < List[Mid + 1] then
            High = Mid
        else
            Low = Mid + 1
        end
    end

    return Low
end

local ConnectNames = {Connect = true, Once = true, ConnectParallel = true}
local AssignScopeOpeners = {["{"] = true, [","] = true, ["("] = true, ["["] = true}
local GlobalMarkers = {getgenv = true, _G = true, shared = true, _ENV = true, getfenv = true, setfenv = true}

local function RenameCode(Code, Style)
    if Style then
        local Lines = Split(Code, "\n")
        local Folded = {}
        local Index = 1

        while Index <= #Lines do
            local Pad, Var = string.match(Lines[Index], "^(%s*)local ([%a_][%w_]*)$")
            local Base = Var and string.match(Lines[Index + 1] or "", "^" .. Pad .. Var .. " = ([%a_][%w_]*)$")
            local EndIndex = nil

            if Base and not Keywords[Base] and Lines[Index + 2] == Pad .. "if " .. Var .. " then" then
                for Scan = Index + 3, #Lines do
                    if Lines[Scan] == Pad .. "end" then
                        EndIndex = Scan
                        break
                    end

                    if string.sub(Lines[Scan], 1, #Pad + 4) ~= Pad .. "    " then
                        break
                    end
                end
            end

            local Parts = EndIndex and {Base}
            local Row = Index + 3

            if EndIndex and Lines[Row] == Pad .. "    " .. Var .. " = " .. Base then
                Row += 1
            end

            while Parts and Row < EndIndex do
                local Suffix = string.match(Lines[Row], "^" .. Pad .. "    " .. Var .. " = " .. Var .. "([%.:%[].*)$")
                local Last = Row

                while Last + 1 < EndIndex and not string.find(Lines[Last + 1], "^" .. Pad .. "    " .. Var .. " = ") do
                    Last += 1
                end

                if Suffix and CountWord(table.concat(Lines, "\n", Row, Last), Var) == 2 then
                    for X = Row + 1, Last do
                        Suffix ..= "\n" .. string.sub(Lines[X], 5)
                    end

                    Parts[#Parts + 1] = Suffix
                else
                    Parts = nil
                end

                Row = Last + 1
            end

            local Expr = Parts and #Parts > 1 and table.concat(Parts)

            if Expr and ChainOf(Expr) then
                for _, Line in ipairs(Split(Pad .. "local " .. Var .. " = " .. Base .. " and " .. Expr, "\n")) do
                    Folded[#Folded + 1] = Line
                end

                Index = EndIndex + 1
            else
                Folded[#Folded + 1] = Lines[Index]
                Index += 1
            end
        end

        Code = table.concat(Folded, "\n")
    end

    local Tokens, N = Tokenize(Code)

    if N > 0 then
        local Scopes = FindScopes(Tokens, N)
        local TokenStarts = {}

        for K = 0, N - 1 do
            TokenStarts[K + 1] = Tokens[K].Start
        end

        for Si = 1, #Scopes do
            local Sc = Scopes[Si]

            if Tokens[Sc[2]].Text == "until" then
                local _, CondEnd = ReadStmt(Code, Tokens[Sc[2]].End)
                Scopes[Si] = {Sc[1], BisectLeft(TokenStarts, CondEnd)}
            end
        end

        table.sort(Scopes, function(A, B)
            if A[1] ~= B[1] then
                return A[1] < B[1]
            end

            return A[2] < B[2]
        end)

        local ScopeStarts = {}

        for K, Sc in ipairs(Scopes) do
            ScopeStarts[K] = Sc[1]
        end

        local function ScopeChainOf(Ti)
            local Chain = {}

            for Sid = 1, BisectRight(ScopeStarts, Ti) do
                if Ti < Scopes[Sid][2] then
                    Chain[#Chain + 1] = Sid
                end
            end

            return Chain
        end

        local Assigns = {}
        local Ai = 0

        while Ai < N - 1 do
            if Tokens[Ai].Kind ~= "ident" then
                Ai += 1
                continue
            end

            if Tokens[Ai + 1].Kind ~= "op" or Tokens[Ai + 1].Text ~= "=" then
                Ai += 1
                continue
            end

            if Ai + 2 < N and Tokens[Ai + 2].Kind == "op" and Tokens[Ai + 2].Text == "=" then
                Ai += 2
                continue
            end

            if Ai > 0 then
                if Tokens[Ai - 1].Kind == "kw" and Tokens[Ai - 1].Text == "for" then
                    Ai += 1
                    continue
                end

                if Tokens[Ai - 1].Kind == "op" and (Tokens[Ai - 1].Text == "." or Tokens[Ai - 1].Text == ":") then
                    Ai += 1
                    continue
                end
            end

            local AssignRhs = ReadStmt(Code, Tokens[Ai + 1].End)
            local GroupStart = Ai

            while GroupStart >= 2 and Tokens[GroupStart - 1].Kind == "op" and Tokens[GroupStart - 1].Text == "," and Tokens[GroupStart - 2].Kind == "ident" and not (GroupStart >= 3 and Tokens[GroupStart - 3].Kind == "op" and (Tokens[GroupStart - 3].Text == "." or Tokens[GroupStart - 3].Text == ":")) do
                GroupStart -= 2
            end

            if GroupStart < Ai and (GroupStart == 0 or not (Tokens[GroupStart - 1].Kind == "op" and AssignScopeOpeners[Tokens[GroupStart - 1].Text])) then
                local GroupParts = SplitCommas(AssignRhs)
                local GroupSingle = #GroupParts == 1
                local GroupPcall = nil

                if GroupSingle then
                    GroupPcall = string.match(GroupParts[1], "^%s*(x?pcall)%s*%(")
                end

                local Gi = 0

                for Gt = GroupStart, Ai, 2 do
                    local Name = Tokens[Gt].Text

                    if not Assigns[Name] then
                        Assigns[Name] = {}
                    end

                    if Gi < #GroupParts and (Gi == 0 or not GroupSingle) then
                        table.insert(Assigns[Name], {Gt, GroupParts[Gi + 1], nil})
                    elseif GroupSingle and Gi == 1 and GroupPcall then
                        table.insert(Assigns[Name], {Gt, "", GroupPcall .. "result"})
                    end

                    Gi += 1
                end
            else
                local Name = Tokens[Ai].Text

                if not Assigns[Name] then
                    Assigns[Name] = {}
                end

                table.insert(Assigns[Name], {Ai, AssignRhs, nil})
            end

            Ai += 1
        end

        local ScopeUsed = {}
        local UsedNames = {}
        local Fields = {}
        local TableKeys = {}
        local Openers = {}

        for Ki = 0, N - 1 do
            local Kt = Tokens[Ki]

            if Kt.Kind == "op" then
                if Kt.Text == "(" or Kt.Text == "[" or Kt.Text == "{" then
                    Openers[#Openers + 1] = Ki
                elseif (Kt.Text == ")" or Kt.Text == "]" or Kt.Text == "}") and #Openers > 0 then
                    table.remove(Openers)
                end
            elseif Kt.Kind == "ident" and #Openers > 0 and Tokens[Openers[#Openers]].Text == "{" and (Tokens[Ki - 1].Text == "{" or Tokens[Ki - 1].Text == "," or Tokens[Ki - 1].Text == ";") and Ki + 1 < N and Tokens[Ki + 1].Text == "=" and not (Ki + 2 < N and Tokens[Ki + 2].Text == "=") then
                local Chain = ScopeChainOf(Ki)

                if #Chain == 0 or Scopes[Chain[#Chain]][1] < Openers[#Openers] then
                    TableKeys[Ki] = true
                end
            end
        end

        for Ui = 0, N - 1 do
            local Ut = Tokens[Ui]

            if Ut.Kind == "ident" and not TableKeys[Ui] then
                local IsField = false

                if Ui > 0 and Tokens[Ui - 1].Kind == "op" and (Tokens[Ui - 1].Text == "." or Tokens[Ui - 1].Text == ":") then
                    if not (Tokens[Ui - 1].Text == "." and Ui > 1 and Tokens[Ui - 2].Kind == "op" and Tokens[Ui - 2].Text == ".") then
                        Fields[Ui] = true
                        IsField = true
                    end
                end

                if not IsField then
                    UsedNames[Ut.Text] = true
                end
            end
        end

        local Declared = {}

        for Di = 0, N - 1 do
            local Dt = Tokens[Di]

            if Dt.Kind == "kw" then
                if Dt.Text == "local" or Dt.Text == "for" then
                    local Dj = Di + 1

                    while Dj < N and Tokens[Dj].Kind == "ident" do
                        Declared[Tokens[Dj].Text] = true
                        Dj += 1

                        if Dj < N and Tokens[Dj].Text == "," then
                            Dj += 1
                        else
                            break
                        end
                    end
                elseif Dt.Text == "function" then
                    local Dj = Di + 1

                    if Di > 0 and Tokens[Di - 1].Text == "local" and Dj < N and Tokens[Dj].Kind == "ident" then
                        Declared[Tokens[Dj].Text] = true
                    end

                    while Dj < N and Tokens[Dj].Text ~= "(" do
                        Dj += 1
                    end

                    Dj += 1
                    local Depth = 0

                    while Dj < N do
                        if Tokens[Dj].Text == "(" then
                            Depth += 1
                        elseif Tokens[Dj].Text == ")" then
                            if Depth == 0 then
                                break
                            end

                            Depth -= 1
                        elseif Tokens[Dj].Kind == "ident" then
                            Declared[Tokens[Dj].Text] = true
                        end

                        Dj += 1
                    end
                end
            end
        end

        local IdentPos = {}

        for K = 0, N - 1 do
            if Tokens[K].Kind == "ident" then
                if IdentPos[Tokens[K].Text] then
                    table.insert(IdentPos[Tokens[K].Text], K)
                else
                    IdentPos[Tokens[K].Text] = {K}
                end
            end
        end

        local Renames = {}
        local Aliased = {}
        local Drops = {}
        local DeclOps = {}
        local DeclList = {}
        local DeclSorted = true
        local SuffixHints = {}
        local Counters = {}
        local Deferred = {}

        local RenamesByOld = {}

        local function VisibleAt(Pos, Text)
            local Map = {}

            for Word in string.gmatch(Text, "[A-Za-z_][%w_\128-\255]*") do
                if RenamesByOld[Word] and Map[Word] == nil then
                    for _, R in ipairs(RenamesByOld[Word]) do
                        if R.DeclTi <= Pos and Pos < R.EndTi then
                            Map[Word] = R.New
                        end
                    end
                end
            end

            return Map
        end

        local function ConnectEvent(FName, After, End)
            local Positions = IdentPos[FName] or {}

            for K = BisectLeft(Positions, After + 1) + 1, #Positions do
                local Ui = Positions[K]

                if Ui > End - 1 then
                    break
                end

                if Ui >= 4 and Ui + 1 < N and Tokens[Ui + 1].Text == ")" and Tokens[Ui - 1].Text == "(" and ConnectNames[Tokens[Ui - 2].Text] and (Tokens[Ui - 3].Text == "." or Tokens[Ui - 3].Text == ":") and Tokens[Ui - 4].Kind == "ident" then
                    return Tokens[Ui - 4].Text
                end
            end

            return nil
        end

        local function CollectDecls(From, To)
            local Set = {}
            local Start = 1

            if DeclSorted then
                local Low = 1
                local High = #DeclList + 1

                while Low < High do
                    local Mid = (Low + High) // 2

                    if DeclList[Mid][1] > From then
                        High = Mid
                    else
                        Low = Mid + 1
                    end
                end

                Start = Low
            end

            for Index = Start, #DeclList do
                local Entry = DeclList[Index]

                if Entry[1] > From and Entry[1] < To then
                    Set[Entry[2]] = true
                elseif DeclSorted and Entry[1] >= To then
                    break
                end
            end

            return Set
        end

        local function ChainHas(Chain, Name)
            if ScopeUsed[-1] and ScopeUsed[-1][Name] then
                return true
            end

            for _, Sid in ipairs(Chain) do
                if ScopeUsed[Sid] and ScopeUsed[Sid][Name] then
                    return true
                end
            end

            return false
        end

        local StateUiFields = {Text = true, Parent = true, Visible = true, Enabled = true, Name = true, Image = true}

        local function Declare(NameTi, OldName, Rhs, ScopeTi, SearchAssigns, Kind, VisTi, Hint, Final)
            if StartsWith(OldName, "_") then
                return
            end

            local OrigArgs = {NameTi = NameTi, OldName = OldName, Rhs = Rhs, ScopeTi = ScopeTi, SearchAssigns = SearchAssigns, Kind = Kind, VisTi = VisTi, Hint = Hint}
            local ScopeEndTi = N
            local ScopePos = BisectRight(ScopeStarts, ScopeTi)

            while ScopePos >= 1 do
                if Scopes[ScopePos][2] > ScopeTi then
                    ScopeEndTi = Scopes[ScopePos][2]
                    break
                end

                ScopePos -= 1
            end

            local Unclear = IsUnclearName(OldName)
            local RawName = nil
            local Counted = false
            local SwappedRhs = ""
            local FromRhs = false

            if Unclear and Kind == nil and Rhs ~= nil then
                if IsFunctionStart(LStrip(Rhs)) then
                    Kind = "fn"
                elseif StartsWith(LStrip(Rhs), "{") then
                    Kind = "tbl"
                end
            end

            local Generic = Unclear and Kind ~= nil

            if not Generic and Rhs ~= nil then
                SwappedRhs = ApplyMap(Rhs, VisibleAt(NameTi, Rhs))
                RawName = InferName(SwappedRhs)
                FromRhs = RawName ~= nil
            end

            if not RawName and SearchAssigns and not Generic then
                local AssignKinds = {}

                for _, Entry in ipairs(Assigns[OldName] or {}) do
                    local Ati = Entry[1]
                    local Atext = Entry[2]
                    local Athint = Entry[3]

                    if Ati > NameTi and Ati < ScopeEndTi then
                        if string.find(Atext, "^%s*nil%s*$") then
                            continue
                        end

                        local Swapped = ApplyMap(Atext, VisibleAt(Ati, Atext))
                        local Cand = InferName(Swapped)

                        if Cand then
                            AssignKinds[#AssignKinds + 1] = {"n", Cand, Swapped, nil, nil, Ati}
                        elseif IsFunctionStart(LStrip(Atext)) then
                            AssignKinds[#AssignKinds + 1] = {"fn", nil, "", string.match(Atext, "^%s*function%s*%b()%-%-%[%[dn:([%w_]+)%]%]")}
                        elseif Athint and Unclear then
                            AssignKinds[#AssignKinds + 1] = {"h", Athint, "", nil, Swapped}
                        else
                            AssignKinds[#AssignKinds + 1] = {"u", nil, "", nil, Swapped}
                        end
                    end
                end

                if #AssignKinds > 0 then
                    local Same = true

                    for K = 2, #AssignKinds do
                        if AssignKinds[K][1] ~= AssignKinds[1][1] or AssignKinds[K][2] ~= AssignKinds[1][2] then
                            Same = false
                            break
                        end
                    end

                    if not Same and Final then
                        local CallIndex = nil
                        local Plain = true

                        for K, Entry in ipairs(AssignKinds) do
                            if Entry[1] == "n" and string.match(Entry[3], "^%s*[%a_][%w_%.:]*%b()%s*$") and not string.find(Entry[3], "%.new%s*%(") then
                                if CallIndex == nil then
                                    CallIndex = K
                                elseif Entry[2] ~= AssignKinds[CallIndex][2] then
                                    Plain = false
                                end
                            elseif Entry[1] == "h" or not string.match(Entry[1] == "n" and Entry[3] or Entry[5] or "", "^%s*[%a_][%w_%.]*%s*$") then
                                Plain = false
                            end
                        end

                        if CallIndex and Plain then
                            AssignKinds[1], AssignKinds[CallIndex] = AssignKinds[CallIndex], AssignKinds[1]
                            Same = true
                        end
                    end

                    if Same then
                        local Atag = AssignKinds[1][1]

                        if Atag == "fn" then
                            Kind = "fn"
                            Generic = Unclear

                            local SameDn = true

                            for K = 2, #AssignKinds do
                                if AssignKinds[K][4] ~= AssignKinds[1][4] then
                                    SameDn = false
                                    break
                                end
                            end

                            if SameDn and AssignKinds[1][4] and Unclear then
                                RawName = AssignKinds[1][4]
                                Generic = false
                            end
                        elseif Atag == "n" then
                            RawName = AssignKinds[1][2]
                            SwappedRhs = AssignKinds[1][3]

                            if Unclear and IsGeneratedName(RawName) and ScopeEndTi == N then
                                local AllTables = true
                                local OwnPositions = IdentPos[OldName] or {}

                                for K = BisectLeft(OwnPositions, NameTi + 1) + 1, #OwnPositions do
                                    local Pos = OwnPositions[K]
                                    local After = Tokens[Pos + 1]
                                    local Member = Tokens[Pos + 2]

                                    if After and After.Text == ":" or After and After.Text == "." and Member and StateUiFields[Member.Text] then
                                        AllTables = false
                                        break
                                    end
                                end

                                for _, Pos in ipairs(IdentPos["State"] or {}) do
                                    if Fields[Pos] or TableKeys[Pos] then
                                        AllTables = false
                                        break
                                    end
                                end

                                for _, Entry in ipairs(AssignKinds) do
                                    local Src = string.match(Entry[3], "^%s*([%a_][%w_]*)%s*$")
                                    local IsTable = false

                                    if Src and Entry[6] then
                                        local SrcPositions = IdentPos[Src] or {}

                                        for K = BisectLeft(SrcPositions, Entry[6]), 1, -1 do
                                            local Pos = SrcPositions[K]

                                            if Pos >= 2 and Tokens[Pos - 1].Text == "local" and Tokens[Pos + 1].Text == "=" then
                                                IsTable = Tokens[Pos + 2].Text == "{"
                                                break
                                            end
                                        end
                                    end

                                    if not IsTable then
                                        AllTables = false
                                        break
                                    end
                                end

                                if AllTables then
                                    RawName = "State"
                                    SwappedRhs = ""
                                end
                            end
                        elseif Atag == "h" then
                            RawName = AssignKinds[1][2]
                        end
                    end
                end
            end

            if not RawName and Unclear then
                local Positions = IdentPos[OldName] or {}

                for K = BisectLeft(Positions, math.max(NameTi + 1, 2)) + 1, #Positions do
                    local Ui = Positions[K]

                    if Ui > ScopeEndTi - 1 then
                        break
                    end

                    if not Fields[Ui] and not TableKeys[Ui] and Tokens[Ui - 1].Text == "=" and Tokens[Ui - 2].Kind == "ident" and (Fields[Ui - 2] or TableKeys[Ui - 2]) and (Ui + 1 >= N or Tokens[Ui + 1].Kind ~= "op" or Tokens[Ui + 1].Text == ")" or Tokens[Ui + 1].Text == "}" or Tokens[Ui + 1].Text == "," or Tokens[Ui + 1].Text == ";") then
                        RawName = Tokens[Ui - 2].Text
                        SwappedRhs = ""
                        break
                    end
                end
            end

            if not RawName and Kind == "fn" and (Unclear or Abbrevs[string.lower(OldName)]) then
                local Event = ConnectEvent(OldName, NameTi, ScopeEndTi)

                if Event then
                    if StartsWith(Event, "On") then
                        RawName = Event
                    else
                        RawName = "On" .. Event
                    end
                end
            end

            if not RawName and Abbrevs[string.lower(OldName)] then
                RawName = Abbrevs[string.lower(OldName)]
            end

            if not RawName and Unclear and Hint then
                RawName = Hint
            end

            if not RawName and Unclear and Kind == nil and Rhs ~= nil then
                Kind = ExprKind(Rhs)
                Generic = Kind ~= nil
            end

            local DebugName = Rhs and string.match(Rhs, "^%s*function%s*%b()%-%-%[%[dn:([%w_]+)%]%]")

            if DebugName and Unclear then
                RawName = DebugName
                Generic = false
            end

            if not RawName and Generic then
                local ScopeChain = ScopeChainOf(ScopeTi)
                local FnScope = -1

                for K = #ScopeChain, 1, -1 do
                    if Tokens[Scopes[ScopeChain[K]][1]].Text == "function" then
                        FnScope = ScopeChain[K]
                        break
                    end
                end

                local Taken = CollectDecls(NameTi, ScopeEndTi)

                local CountKey = tostring(FnScope) .. ":" .. Kind
                local Count = Counters[CountKey] or 0

                if Count ~= 0 then
                    RawName = Kind .. tostring(Count + 1)
                else
                    RawName = Kind
                end

                while UsedNames[RawName] or Taken[RawName] or ChainHas(ScopeChain, RawName) do
                    Count += 1
                    RawName = Kind .. tostring(Count + 1)
                end

                Counters[CountKey] = Count + 1
                Counted = true
            end

            if not RawName then
                if Unclear then
                    if SearchAssigns and not Final and Assigns[OldName] then
                        Deferred[#Deferred + 1] = OrigArgs
                    end

                    return
                end

                RawName = OldName
                SwappedRhs = ""
            end

            if FromRhs and not EndsWith(RawName, "Path") and not EndsWith(RawName, "Url") and not StartsWithName(SwappedRhs, "require") then
                local Hit = false

                local Positions = IdentPos[OldName] or {}

                for K = BisectLeft(Positions, NameTi + 1) + 1, #Positions do
                    local Ui = Positions[K]

                    if Ui > ScopeEndTi - 1 then
                        break
                    end

                    if Ui >= 2 and Ui + 1 < N and Tokens[Ui + 1].Text == ")" and Tokens[Ui - 1].Text == "(" and Tokens[Ui - 2].Text == "require" then
                        Hit = true
                        break
                    end
                end

                if Hit then
                    RawName = RawName .. "Path"
                end
            end

            if FromRhs and ShadowAlts[RawName] and StartsWithName(SwappedRhs, RawName) then
                RawName = ShadowAlts[RawName]
            end

            local NewName = RawName

            if not Counted then
                local Trimmed = string.gsub(RawName, "^_+", "")

                if Trimmed ~= "" then
                    NewName = Trimmed
                end
            end

            if Keywords[NewName] or IsGeneratedName(NewName) then
                return
            end

            local Shadow = StartsWithName(SwappedRhs, RawName)
            local BareRhs = Strip((string.gsub(SwappedRhs, "%-%-[^\n]*", "")))
            local GlobalAlias = FromRhs and Shadow and NewName == RawName and not Declared[RawName] and BareRhs == RawName

            if FromRhs and BareRhs == OldName then
                local Covered = false

                for _, Al in ipairs(Aliased) do
                    if Al[1] == OldName and Al[2] <= NameTi and NameTi < Al[3] then
                        Covered = true
                        break
                    end
                end

                if Covered then
                    if Tokens[(NameTi - 1) % N].Text == "local" and Tokens[NameTi + 1].Text == "=" then
                        Drops[#Drops + 1] = NameTi
                    end
                else
                    Aliased[#Aliased + 1] = {OldName, VisTi, ScopeEndTi}
                end

                return
            end

            if NewName == OldName and (not Shadow or GlobalAlias) then
                return
            end

            local Chain = ScopeChainOf(ScopeTi)
            local Candidate = nil
            local Suffix = nil

            if Shadow and not GlobalAlias then
                Candidate = JoinSuffix(NewName, 2)
                Suffix = 3
            else
                Candidate = NewName
                Suffix = 2
            end

            local Inner = CollectDecls(NameTi, ScopeEndTi)

            local HintKey = tostring(Chain[#Chain] or -1) .. "|" .. NewName .. "|" .. Candidate .. "|" .. tostring(Suffix)
            local Hint = SuffixHints[HintKey]

            if Hint then
                Candidate = Hint[1]
                Suffix = Hint[2]
            end

            local Extending = true

            while ChainHas(Chain, Candidate) or Inner[Candidate] or Candidate == OldName or (UsedNames[Candidate] and not (GlobalAlias and Candidate == NewName)) do
                Extending = Extending and (ChainHas(Chain, Candidate) or UsedNames[Candidate] and Candidate ~= NewName)
                Candidate = JoinSuffix(NewName, Suffix)
                Suffix += 1

                if Extending then
                    SuffixHints[HintKey] = {Candidate, Suffix}
                end
            end

            local Innermost = -1

            if #Chain > 0 then
                Innermost = Chain[#Chain]
            end

            if not ScopeUsed[Innermost] then
                ScopeUsed[Innermost] = {}
            end

            ScopeUsed[Innermost][Candidate] = true
            Renames[#Renames + 1] = {Old = OldName, New = Candidate, DeclTi = VisTi == nil and NameTi or VisTi, EndTi = ScopeEndTi}

            if not RenamesByOld[OldName] then
                RenamesByOld[OldName] = {}
            end

            table.insert(RenamesByOld[OldName], Renames[#Renames])

            if GlobalAlias and Candidate == NewName then
                Aliased[#Aliased + 1] = {Candidate, VisTi, ScopeEndTi}
            end

            DeclOps[NameTi] = Candidate
            if #DeclList > 0 and DeclList[#DeclList][1] > NameTi then
                DeclSorted = false
            end

            DeclList[#DeclList + 1] = {NameTi, Candidate}
        end

        local Ti = 0

        while Ti < N do
            local Tok = Tokens[Ti]

            if Tok.Kind == "kw" and Tok.Text == "local" then
                local Names = {}
                local J = Ti + 1

                while J < N do
                    local T = Tokens[J]

                    if T.Kind == "ident" then
                        Names[#Names + 1] = {J, T.Text}
                        J += 1

                        if J < N and Tokens[J].Kind == "op" and (Tokens[J].Text == ":" or Tokens[J].Text == "<") then
                            local Depth = 0

                            while J < N do
                                local U = Tokens[J]

                                if U.Kind == "op" then
                                    if U.Text == "(" or U.Text == "[" or U.Text == "{" or U.Text == "<" then
                                        Depth += 1
                                    elseif U.Text == ")" or U.Text == "]" or U.Text == "}" then
                                        Depth -= 1
                                    elseif U.Text == ">" and Tokens[J - 1].Text ~= "-" then
                                        Depth -= 1
                                    elseif (U.Text == "," or U.Text == "=") and Depth == 0 then
                                        break
                                    end
                                end

                                J += 1
                            end
                        end

                        if J < N and Tokens[J].Kind == "op" and Tokens[J].Text == "," then
                            J += 1
                            continue
                        else
                            break
                        end
                    else
                        break
                    end
                end

                if #Names == 0 then
                    Ti += 1
                    continue
                end

                local HasEq = J < N and Tokens[J].Kind == "op" and Tokens[J].Text == "="
                local RhsParts = {}
                local VisTi = nil

                if HasEq then
                    local RhsText, RhsEnd = ReadStmt(Code, Tokens[J].End)
                    RhsParts = SplitCommas(RhsText)
                    VisTi = BisectLeft(TokenStarts, RhsEnd)
                end

                for Idx = 0, #Names - 1 do
                    local NameTi = Names[Idx + 1][1]
                    local OldName = Names[Idx + 1][2]
                    local Hint = nil

                    if Idx == 1 and #RhsParts == 1 then
                        local Pm = string.match(RhsParts[1], "^%s*(x?pcall)%s*%(")

                        if Pm then
                            Hint = Pm .. "result"
                        end
                    end

                    Declare(NameTi, OldName, RhsParts[Idx + 1], NameTi, true, nil, VisTi, Hint)
                end
            elseif Tok.Kind == "kw" and Tok.Text == "for" then
                local J = Ti + 1
                local ForVarsList = {}

                while J < N and Tokens[J].Kind == "ident" do
                    ForVarsList[#ForVarsList + 1] = J
                    J += 1

                    if J < N and Tokens[J].Kind == "op" and Tokens[J].Text == "," then
                        J += 1
                    else
                        break
                    end
                end

                local ForHints = {}

                if J < N and Tokens[J].Text == "in" then
                    local Dj = J + 1

                    while Dj < N and Tokens[Dj].Text ~= "do" do
                        Dj += 1
                    end

                    local IterExpr = ""

                    if Dj < N then
                        IterExpr = Slice(Code, Tokens[J].End, Tokens[Dj].Start)
                    end

                    local PairsName, PairsArg = string.match(RStrip(IterExpr), "^%s*(i?pairs)%s*%((.*)%)$")

                    if PairsName then
                        local Coll = InferName(ApplyMap(PairsArg, VisibleAt(J, PairsArg)))
                        local Singled = nil

                        if Coll then
                            Singled = Singular(Coll)
                        end

                        ForHints = {PairsName == "ipairs" and "index" or "key", Singled or "value"}
                    elseif #ForVarsList > 1 then
                        local Coll = InferName(ApplyMap(IterExpr, VisibleAt(J, IterExpr)))
                        local Singled = nil

                        if Coll then
                            Singled = Singular(Coll)
                        end

                        ForHints = {"key", Singled or "value"}
                    end
                elseif J < N and Tokens[J].Text == "=" and #ForVarsList > 0 and string.find(Tokens[ForVarsList[1]].Text, "%d") then
                    ForHints = {"index"}
                end

                for Fi, Fj in ipairs(ForVarsList) do
                    Declare(Fj, Tokens[Fj].Text, nil, Fj, false, nil, nil, ForHints[Fi])
                end
            elseif Tok.Kind == "kw" and Tok.Text == "function" then
                if Ti > 0 and Tokens[Ti - 1].Kind == "kw" and Tokens[Ti - 1].Text == "local" and Ti + 1 < N and Tokens[Ti + 1].Kind == "ident" then
                    Declare(Ti + 1, Tokens[Ti + 1].Text, nil, Ti - 1, false, "fn")
                end

                local J = Ti + 1

                while J < N and not (Tokens[J].Kind == "op" and Tokens[J].Text == "(") do
                    J += 1
                end

                J += 1
                local Depth = 0
                local AtStart = true
                local Pidx = 0
                local Hints = {}
                local FName = nil
                local FAfter = nil

                if Ti >= 4 and Tokens[Ti - 1].Text == "(" and ConnectNames[Tokens[Ti - 2].Text] and (Tokens[Ti - 3].Text == "." or Tokens[Ti - 3].Text == ":") and EventParams[Tokens[Ti - 4].Text] then
                    Hints = EventParams[Tokens[Ti - 4].Text]
                elseif Ti >= 1 and Tokens[Ti - 1].Text == "local" and Ti + 1 < N and Tokens[Ti + 1].Kind == "ident" then
                    FName = Tokens[Ti + 1].Text
                    FAfter = Ti + 1
                elseif Ti >= 3 and Tokens[Ti - 1].Text == "=" and Tokens[Ti - 2].Kind == "ident" and Tokens[Ti - 3].Text == "local" then
                    FName = Tokens[Ti - 2].Text
                    FAfter = Ti - 2
                end

                if FName then
                    local Event = ConnectEvent(FName, FAfter, N)

                    if EventParams[Event] then
                        Hints = EventParams[Event]
                    end
                end

                while J < N do
                    local T = Tokens[J]
                    local Advance = true

                    if T.Kind == "op" then
                        if T.Text == "(" or T.Text == "[" or T.Text == "{" or T.Text == "<" then
                            Depth += 1
                        elseif T.Text == ")" or T.Text == "]" or T.Text == "}" then
                            if Depth == 0 then
                                break
                            end

                            Depth -= 1
                        elseif T.Text == ">" and Tokens[J - 1].Text ~= "-" then
                            Depth -= 1
                        elseif T.Text == "," and Depth == 0 then
                            AtStart = true
                            Pidx += 1
                            J += 1
                            Advance = false
                        end
                    elseif T.Kind == "ident" and AtStart then
                        local PHint = Hints[Pidx + 1]

                        if not PHint and FName then
                            for Ci = FAfter + 1, N - 2 do
                                if Tokens[Ci].Kind == "ident" and Tokens[Ci].Text == FName and Tokens[Ci + 1].Text == "(" and Tokens[Ci - 1].Text ~= "." and Tokens[Ci - 1].Text ~= ":" and Tokens[Ci - 1].Text ~= "function" then
                                    Depth = 0
                                    local Cj = Ci + 1

                                    while Cj < N do
                                        if Tokens[Cj].Kind == "op" then
                                            if Tokens[Cj].Text == "(" or Tokens[Cj].Text == "[" or Tokens[Cj].Text == "{" then
                                                Depth += 1
                                            elseif Tokens[Cj].Text == ")" or Tokens[Cj].Text == "]" or Tokens[Cj].Text == "}" then
                                                Depth -= 1

                                                if Depth == 0 then
                                                    break
                                                end
                                            end
                                        end

                                        Cj += 1
                                    end

                                    if Cj >= N then
                                        break
                                    end

                                    local Args = SplitCommas(Slice(Code, Tokens[Ci + 1].End, Tokens[Cj].Start))

                                    if Pidx < #Args then
                                        local Arg = Strip(Args[Pidx + 1])
                                        local ChainBase, ChainSteps = ChainOf(Arg)

                                        if ChainBase and #ChainSteps > 0 then
                                            local Cand = InferName(ApplyMap(Arg, VisibleAt(Ci, Arg)))

                                            if Cand and not IsUnclearName(Cand) and Cand ~= FName then
                                                PHint = Cand
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        local ArgKind = nil

                        if IsArgName(T.Text) then
                            ArgKind = "arg"
                        end

                        Declare(J, T.Text, nil, J, false, ArgKind, nil, PHint)
                    end

                    if Advance then
                        AtStart = false
                        J += 1
                    end
                end
            end

            Ti += 1
        end

        local Pending = Deferred

        while #Pending > 0 do
            local Remaining = {}

            for _, Args in ipairs(Pending) do
                Declare(Args.NameTi, Args.OldName, Args.Rhs, Args.ScopeTi, Args.SearchAssigns, Args.Kind, Args.VisTi, Args.Hint, true)

                if DeclOps[Args.NameTi] == nil then
                    Remaining[#Remaining + 1] = Args
                end
            end

            if #Remaining == #Pending then
                break
            end

            Pending = Remaining
        end

        local HasGlobalMarker = false

        for Marker in pairs(GlobalMarkers) do
            if UsedNames[Marker] then
                HasGlobalMarker = true
            end
        end

        if not HasGlobalMarker then
            local GDefs = {}
            local GOrder = {}

            for Gi = 0, N - 1 do
                local Gt = Tokens[Gi]

                if Gt.Kind ~= "ident" or Fields[Gi] or TableKeys[Gi] or Declared[Gt.Text] or StartsWith(Gt.Text, "_") then
                    continue
                end

                if not (IsUnclearName(Gt.Text) or Abbrevs[string.lower(Gt.Text)]) then
                    continue
                end

                local Prev = nil

                if Gi > 0 then
                    Prev = Tokens[Gi - 1]
                end

                local Entry = nil

                if Prev and Prev.Kind == "kw" and Prev.Text == "function" then
                    if Gi + 1 < N and (Tokens[Gi + 1].Text == "(" or Tokens[Gi + 1].Text == "<") and not (Gi > 1 and Tokens[Gi - 2].Text == "local") then
                        Entry = {Gi, nil, "fn"}
                    end
                elseif Gi + 1 < N and Tokens[Gi + 1].Kind == "op" and Tokens[Gi + 1].Text == "=" and not (Gi + 2 < N and Tokens[Gi + 2].Text == "=") then
                    local Grhs = ReadStmt(Code, Tokens[Gi + 1].End)
                    Entry = {Gi, Grhs, nil}
                end

                if Entry then
                    if not GDefs[Gt.Text] then
                        GDefs[Gt.Text] = {}
                        GOrder[#GOrder + 1] = Gt.Text
                    end

                    table.insert(GDefs[Gt.Text], Entry)
                end
            end

            for _, GName in ipairs(GOrder) do
                if not ScopeUsed[-1] then
                    ScopeUsed[-1] = {}
                end

                for _, Set in pairs(ScopeUsed) do
                    for Name in pairs(Set) do
                        ScopeUsed[-1][Name] = true
                    end
                end

                local Before = #Renames

                for _, Entry in ipairs(GDefs[GName]) do
                    Declare(Entry[1], GName, Entry[2], -1, Entry[2] ~= nil, Entry[3], 0)

                    if #Renames > Before then
                        break
                    end
                end
            end
        end

        if #Renames > 0 or #Drops > 0 then
            local ByName = {}

            for _, R in ipairs(Renames) do
                if not ByName[R.Old] then
                    ByName[R.Old] = {}
                end

                table.insert(ByName[R.Old], {R.New, R.DeclTi, R.EndTi})
            end

            local Ops = {}

            for _, D in ipairs(Drops) do
                Ops[#Ops + 1] = {Tokens[(D - 1) % N].Start, Tokens[D].Start, ""}
            end

            for Ti2 = 0, N - 1 do
                local Tok = Tokens[Ti2]

                if Tok.Kind == "btext" then
                    local NewText = {}
                    local WordEnd = 1
                    local Position = 1

                    while true do
                        local WStart, WStop = string.find(Tok.Text, "[A-Za-z_][%w_\128-\255]*", Position)

                        if not WStart then
                            break
                        end

                        local Word = string.sub(Tok.Text, WStart, WStop)
                        local BestName = Word
                        local BestDecl = -1

                        for _, Rule in ipairs(ByName[Word] or {}) do
                            if Rule[2] <= Ti2 and Ti2 < Rule[3] and Rule[2] > BestDecl then
                                BestName = Rule[1]
                                BestDecl = Rule[2]
                            end
                        end

                        NewText[#NewText + 1] = string.sub(Tok.Text, WordEnd, WStart - 1) .. BestName
                        WordEnd = WStop + 1
                        Position = WStop + 1
                    end

                    NewText[#NewText + 1] = string.sub(Tok.Text, WordEnd)
                    local Joined = table.concat(NewText)

                    if Joined ~= Tok.Text then
                        Ops[#Ops + 1] = {Tok.Start, Tok.End, Joined}
                    end
                elseif Tok.Kind == "ident" then
                    if DeclOps[Ti2] then
                        Ops[#Ops + 1] = {Tok.Start, Tok.End, DeclOps[Ti2]}
                    elseif not (Fields[Ti2] or TableKeys[Ti2]) then
                        local Rules = ByName[Tok.Text]

                        if Rules then
                            local BestName = nil
                            local BestDecl = -1

                            for _, Rule in ipairs(Rules) do
                                if Rule[2] <= Ti2 and Ti2 < Rule[3] and Rule[2] > BestDecl then
                                    BestName = Rule[1]
                                    BestDecl = Rule[2]
                                end
                            end

                            if BestName ~= nil then
                                Ops[#Ops + 1] = {Tok.Start, Tok.End, BestName}
                            end
                        end
                    end
                end
            end

            if #Ops > 0 then
                table.sort(Ops, function(A, B)
                    if A[1] ~= B[1] then
                        return A[1] < B[1]
                    end

                    if A[2] ~= B[2] then
                        return A[2] < B[2]
                    end

                    return A[3] < B[3]
                end)

                local Out = {}
                local Last = 0

                for _, Op in ipairs(Ops) do
                    if Op[1] >= Last then
                        Out[#Out + 1] = Slice(Code, Last, Op[1])
                        Out[#Out + 1] = Op[3]
                        Last = Op[2]
                    end
                end

                Out[#Out + 1] = string.sub(Code, Last + 1)
                Code = table.concat(Out)
            end
        end
    end

    local Tokens2, N2 = Tokenize(Code)
    local Scopes2 = FindScopes(Tokens2, N2)

    table.sort(Scopes2, function(A, B)
        if A[1] ~= B[1] then
            return A[1] < B[1]
        end

        return A[2] < B[2]
    end)

    local Starts2 = {}

    for K, Sc in ipairs(Scopes2) do
        Starts2[K] = Sc[1]
    end

    local LastDecl = {}
    local Ops2 = {}

    for Ti = 0, N2 - 1 do
        local Tok = Tokens2[Ti]

        if Tok.Kind ~= "kw" or Tok.Text ~= "local" then
            continue
        end

        local Names = {}
        local J = Ti + 1

        while J < N2 and Tokens2[J].Kind == "ident" do
            Names[#Names + 1] = Tokens2[J].Text
            J += 1

            if J < N2 and Tokens2[J].Text == "," then
                J += 1
            else
                break
            end
        end

        if #Names == 0 then
            continue
        end

        local Inner = -1

        for Sid = BisectRight(Starts2, Ti), 1, -1 do
            if Ti < Scopes2[Sid][2] then
                Inner = Sid
                break
            end
        end

        local Removed = false

        if #Names == 1 and J < N2 and Tokens2[J].Text == "=" and LastDecl[tostring(Inner) .. ":" .. Names[1]] ~= nil then
            local Prev = LastDecl[tostring(Inner) .. ":" .. Names[1]]
            local Blocked = false

            for _, Sc in ipairs(Scopes2) do
                if Tokens2[Sc[1]].Text == "function" and Prev < Sc[1] and Sc[1] < Ti then
                    for K = Sc[1], Sc[2] - 1 do
                        if Tokens2[K].Text == Names[1] then
                            Blocked = true
                            break
                        end
                    end
                end

                if Blocked then
                    break
                end
            end

            if not Blocked then
                Ops2[#Ops2 + 1] = {Tok.Start, Tokens2[Ti + 1].Start, ""}
                Removed = true
            end
        end

        if not Removed then
            for _, Name in ipairs(Names) do
                LastDecl[tostring(Inner) .. ":" .. Name] = Ti
            end
        end
    end

    if Style then
        local Openers2 = {}

        for Ki = 0, N2 - 1 do
            local Kt = Tokens2[Ki]

            if Kt.Kind == "op" then
                if Kt.Text == "(" or Kt.Text == "[" or Kt.Text == "{" then
                    Openers2[#Openers2 + 1] = Ki
                elseif (Kt.Text == ")" or Kt.Text == "]" or Kt.Text == "}") and #Openers2 > 0 then
                    table.remove(Openers2)
                end
            elseif Kt.Kind == "ident" and Ki > 0 and #Openers2 > 0 and Tokens2[Openers2[#Openers2]].Text == "{" and (Tokens2[Ki - 1].Text == "{" or Tokens2[Ki - 1].Text == "," or Tokens2[Ki - 1].Text == ";") and Ki + 1 < N2 and Tokens2[Ki + 1].Text == "=" and not (Ki + 2 < N2 and Tokens2[Ki + 2].Text == "=") then
                local Inner = -1

                for Sid, Sc in ipairs(Scopes2) do
                    if Sc[1] <= Ki and Ki < Sc[2] then
                        Inner = Sid
                    end
                end

                if Inner == -1 or Scopes2[Inner][1] < Openers2[#Openers2] then
                    Ops2[#Ops2 + 1] = {Kt.Start, Kt.End, '["' .. Kt.Text .. '"]'}
                end
            end
        end

        table.sort(Ops2, function(A, B)
            return A[1] < B[1]
        end)
    end

    if #Ops2 > 0 then
        local Out = {}
        local Last = 0

        for _, Op in ipairs(Ops2) do
            Out[#Out + 1] = Slice(Code, Last, Op[1])
            Out[#Out + 1] = Op[3]
            Last = Op[2]
        end

        Out[#Out + 1] = string.sub(Code, Last + 1)
        Code = table.concat(Out)
    end

    if Style then
        local StyledLines = Split(Code, "\n")

        for Index, Line in ipairs(StyledLines) do
            local Spaces = #Line - #LStrip(Line)
            local Rest = string.sub(Line, Spaces + 1)
            local Name, Params = string.match(Rest, "^local ([%a_][%w_]*) = function(%(.*)$")

            if Name then
                Rest = "local function " .. Name .. Params
            else
                local Path, PathParams = string.match(Rest, "^([%a_][%w_]*%.[%a_][%w_%.]*) = function(%(.*)$")

                if Path then
                    Rest = "function " .. Path .. PathParams
                end
            end

            StyledLines[Index] = string.rep("\t", math.floor(Spaces / 4)) .. string.rep(" ", Spaces % 4) .. Rest
        end

        Code = table.concat(StyledLines, "\n")

        local Lines = StyledLines
        local Pending = true

        local Indents = {}

        local function SetRow(Row)
            if string.match(Lines[Row], "^[\t ]*$") then
                Indents[Row] = -1
            else
                Indents[Row] = #string.match(Lines[Row], "^[\t ]*")
            end
        end

        for Row = 1, #Lines do
            SetRow(Row)
        end

        local function DropRow(Row)
            table.remove(Lines, Row)
            table.remove(Indents, Row)
        end

        local function StmtEnd(Row)
            local Last = Row
            local Level = Indents[Row]

            for Scan = Row + 1, #Lines do
                local Lead = Indents[Scan]

                if Lead >= 0 then
                    local Rest = string.sub(Lines[Scan], Lead + 1)

                    if Lead > Level or Lead == Level and (Rest == "end" or string.find(Rest, "^end[^%w_]") or string.find(Rest, "^[%)%}%]]")) then
                        Last = Scan
                    else
                        break
                    end
                end
            end

            return Last
        end

        local function ScopeEnd(Row)
            local Level = Indents[Row]

            if Level <= 0 then
                return #Lines
            end

            for Scan = Row + 1, #Lines do
                local Lead = Indents[Scan]

                if Lead >= 0 and Lead < Level then
                    if StartsWith(string.sub(Lines[Scan], Lead + 1), "until") then
                        return StmtEnd(Scan)
                    end

                    return Scan - 1
                end
            end

            return #Lines
        end

        local function Mentioned(From, To, Name)
            for Scan = From, To do
                if string.find(Lines[Scan], Name, 1, true) and FindWord(Lines[Scan], Name) then
                    return true
                end
            end

            return false
        end

        local function Classify(Full)
            if StartsWith(Full, "function") and not IsWordAt(Full, 9) then
                return "drop"
            end

            local Toks, Count = Tokenize(Full)
            local Pure = true

            for T = 0, Count - 1 do
                if Toks[T].Text == "(" or Toks[T].Kind == "btext" or Toks[T].Text == "function" then
                    Pure = false
                    break
                end
            end

            if Pure then
                return "drop"
            end

            local Base, Steps = ChainOf(Full)

            if Base and EndsWith(Full, ")") and Steps[#Steps].Kind == "c" then
                return "call"
            end

            return nil
        end

        while Pending do
            Pending = false

            local Index = 1

            while Index <= #Lines do
                local Pad, Name, Rest = string.match(Lines[Index], "^(\t*)local function ([%a_][%w_]*)(%(.*)$")
                local Mode = "fn"

                if not Name then
                    Pad, Name, Rest = string.match(Lines[Index], "^(\t*)local ([%a_][%w_]*) = (.*)$")
                    Mode = "var"
                end

                if not Name then
                    Pad, Name = string.match(Lines[Index], "^(\t*)local ([%a_][%w_]*)$")
                    Mode = "bare"
                end

                local Last = Name and StmtEnd(Index)
                local Limit = Name and ScopeEnd(Index)
                local Used = Name and Last < Limit and Mentioned(Last + 1, Limit, Name)
                local Removed = false

                if Name and not Used then
                    if Mode ~= "var" then
                        Removed = true
                    else
                        local Full = Rest

                        for X = Index + 1, Last do
                            Full ..= "\n" .. Lines[X]
                        end

                        local Action = Classify(Full)

                        if Action == "drop" then
                            Removed = true
                        elseif Action == "call" then
                            Lines[Index] = Pad .. Rest
                            SetRow(Index)
                            Pending = true
                        end
                    end
                end

                if Removed then
                    for Row = Last, Index, -1 do
                        DropRow(Row)
                    end

                    Pending = true
                else
                    if Used and Mode == "var" and Rest == "{}" then
                        local Escapes = false
                        local Reads = {}
                        local Writes = {}
                        local Row = Last + 1

                        while Row <= Limit and not Escapes do
                            local Lead, Field, Tail = string.match(Lines[Row], "^(\t*)" .. Name .. "%.([%a_][%w_]*) = (.*)$")
                            local Form = "set"

                            if not Field then
                                Lead, Field, Tail = string.match(Lines[Row], "^(\t*)function " .. Name .. "%.([%a_][%w_]*)(%(.*)$")
                                Form = "def"
                            end

                            local Stop = Field and StmtEnd(Row)

                            if Field and CountWord(table.concat(Lines, "\n", Row, Stop), Name) == 1 then
                                Writes[#Writes + 1] = {Row, Stop, Field, Form, Lead, Tail}
                                Row = Stop + 1
                            else
                                local Position = 1

                                while true do
                                    local Start = FindWord(Lines[Row], Name, Position)

                                    if not Start then
                                        break
                                    end

                                    local After = string.match(Lines[Row], "^%.([%a_][%w_]*)", Start + #Name)

                                    if After then
                                        Reads[After] = true
                                    else
                                        Escapes = true
                                    end

                                    Position = Start + 1
                                end

                                Row += 1
                            end
                        end

                        if not Escapes then
                            for K = #Writes, 1, -1 do
                                local W = Writes[K]

                                if not Reads[W[3]] then
                                    local Full = W[6]

                                    for X = W[1] + 1, W[2] do
                                        Full ..= "\n" .. Lines[X]
                                    end

                                    local Action = W[4] == "def" and "drop" or Classify(Full)

                                    if Action == "drop" then
                                        for X = W[2], W[1], -1 do
                                            DropRow(X)
                                        end

                                        Pending = true
                                    elseif Action == "call" then
                                        Lines[W[1]] = W[5] .. W[6]
                                        SetRow(W[1])
                                        Pending = true
                                    end
                                end
                            end
                        end
                    end

                    Index += 1
                end
            end
        end

        local Merged = {}
        local Row = 1

        while Row <= #Lines do
            local Pad, Name = string.match(Lines[Row], "^(\t*)local ([%a_][%w_]*)$")
            local Head, Rest = nil, nil
            local EndRow = nil

            if Name then
                Head, Rest = string.match(Lines[Row + 1] or "", "^" .. Pad .. Name .. " = function(%b())(.*)$")
            end

            if Head and string.sub(Rest, -3) ~= "end" then
                for X = Row + 2, #Lines do
                    if Lines[X] == Pad .. "end" then
                        EndRow = X
                        break
                    elseif Lines[X] ~= "" and string.sub(Lines[X], 1, #Pad + 1) ~= Pad .. "\t" then
                        break
                    end
                end
            end

            if EndRow then
                Merged[#Merged + 1] = Pad .. "local function " .. Name .. Head .. Rest

                for X = Row + 2, EndRow do
                    Merged[#Merged + 1] = Lines[X]
                end

                Row = EndRow + 1
            else
                Merged[#Merged + 1] = Lines[Row]
                Row += 1
            end
        end

        Code = table.concat(Merged, "\n")
    end

    return Code
end

local CompoundTier = {
    ["or"] = 1, ["and"] = 2, ["<"] = 3, [">"] = 3, ["<="] = 3, [">="] = 3, ["~="] = 3, ["=="] = 3,
    [".."] = 4, ["+"] = 5, ["-"] = 5, ["*"] = 6, ["/"] = 6, ["//"] = 6, ["%"] = 6, ["^"] = 8,
}

local CompoundOps = {"//", "..", "+", "-", "*", "/", "%", "^"}

local function ScanTopLevel(Text)
    local Found = {}
    local Depth = 0
    local Quote = nil
    local Index = 1

    while Index <= #Text do
        local Char = string.sub(Text, Index, Index)

        if Quote then
            if Char == "\\" then
                Index += 1
            elseif Char == Quote then
                Quote = nil
            end
        elseif Char == "\"" or Char == "'" or Char == "`" then
            Quote = Char
        elseif Char == "(" or Char == "[" or Char == "{" then
            local Next = string.sub(Text, Index + 1, Index + 1)

            if Char == "[" and (Next == "[" or Next == "=") then
                return nil
            end

            Depth += 1
        elseif Char == ")" or Char == "]" or Char == "}" then
            Depth -= 1

            if Depth < 0 then
                return nil
            end
        elseif Depth == 0 and Char == " " then
            for Op in pairs(CompoundTier) do
                if string.sub(Text, Index, Index + #Op + 1) == " " .. Op .. " " then
                    Found[#Found + 1] = Op
                    Index += #Op + 1
                    break
                end
            end
        end

        Index += 1
    end

    if Depth ~= 0 or Quote then
        return nil
    end

    return Found
end

local function WholeWrapped(Text)
    if string.sub(Text, 1, 1) ~= "(" or string.sub(Text, -1) ~= ")" then
        return false
    end

    local Depth = 0
    local Quote = nil
    local Index = 1

    while Index <= #Text do
        local Char = string.sub(Text, Index, Index)

        if Quote then
            if Char == "\\" then
                Index += 1
            elseif Char == Quote then
                Quote = nil
            end
        elseif Char == "\"" or Char == "'" or Char == "`" then
            Quote = Char
        elseif Char == "(" or Char == "[" or Char == "{" then
            Depth += 1
        elseif Char == ")" or Char == "]" or Char == "}" then
            Depth -= 1

            if Depth == 0 and Index < #Text then
                return false
            end
        end

        Index += 1
    end

    return Depth == 0 and Quote == nil
end

local function CompoundLine(Line)
    local Pad, Lhs, Rhs = string.match(Line, "^(%s*)([%a_\128-\255][%w_%.\128-\255]*) = (.+)$")

    if not Lhs or string.find(Line, "--", 1, true) or string.find(Rhs, "[,;]$") then
        return Line
    end

    local Inner = Rhs

    if WholeWrapped(Inner) then
        Inner = string.sub(Inner, 2, -2)
    end

    if string.sub(Inner, 1, #Lhs + 1) ~= Lhs .. " " then
        return Line
    end

    local After = string.sub(Inner, #Lhs + 2)
    local Op = nil

    for _, Candidate in ipairs(CompoundOps) do
        if string.sub(After, 1, #Candidate + 1) == Candidate .. " " then
            Op = Candidate
            break
        end
    end

    if not Op then
        return Line
    end

    local Rest = string.sub(After, #Op + 2)

    if Rest == "" or FindWord(Rest, "function") or FindWord(Rest, "if") then
        return Line
    end

    local Found = ScanTopLevel(Rest)

    if Found == nil then
        return Line
    end

    local Own = CompoundTier[Op]
    local RightAssoc = Op == ".." or Op == "^"

    for _, Other in ipairs(Found) do
        local Tier = CompoundTier[Other]

        if Tier < Own or Tier == Own and not RightAssoc then
            return Line
        end
    end

    return Pad .. Lhs .. " " .. Op .. "= " .. Rest
end

local function CompoundAssign(Code)
    local Out = {}

    for Line in string.gmatch(Code .. "\n", "(.-)\n") do
        Out[#Out + 1] = CompoundLine(Line)
    end

    return table.concat(Out, "\n")
end

local function IsBoolExpr(E)
    E = Strip(E)

    local Inner = Unwrap(E)

    if Inner then
        return IsBoolExpr(Inner)
    end

    for _, Kind in ipairs({"or", "and"}) do
        local Parts = SplitOp(E, Kind)

        if #Parts > 1 then
            for _, Part in ipairs(Parts) do
                if not IsBoolExpr(Part) then
                    return false
                end
            end

            return true
        end
    end

    if StartsWith(E, "not ") or E == "true" or E == "false" then
        return true
    end

    return #SplitOp(E, "cmp") > 1
end

local function SingleLine(Value)
    local Plain = string.gsub(Value, '"[^"]*"', '""')

    if string.find(Plain, "function", 1, true) then
        return false
    end

    local _, Open1 = string.gsub(Plain, "%(", "")
    local _, Close1 = string.gsub(Plain, "%)", "")
    local _, Open2 = string.gsub(Plain, "{", "")
    local _, Close2 = string.gsub(Plain, "}", "")
    local _, Open3 = string.gsub(Plain, "%[", "")
    local _, Close3 = string.gsub(Plain, "%]", "")

    return Open1 == Close1 and Open2 == Close2 and Open3 == Close3
end

local function IfChain(Lines, I)
    local Pad, Cond = string.match(Lines[I], "^( *)if (.+) then$")

    if not Pad then
        return nil
    end

    local Conds = {Cond}
    local Values = {}
    local Name = nil
    local J = I + 1

    while true do
        local Target, Value = string.match(Lines[J] or "", "^" .. Pad .. "    ([%a_][%w_%.]*) = (.+)$")

        if not Target or (Name and Name ~= Target) or not SingleLine(Value) then
            return nil
        end

        Name = Target
        Values[#Values + 1] = Value
        J += 1

        local Next = Lines[J]
        local ElseifCond = Next and string.match(Next, "^" .. Pad .. "elseif (.+) then$")

        if ElseifCond then
            Conds[#Conds + 1] = ElseifCond
            J += 1
        elseif Next == Pad .. "else" then
            local Target2, Value2 = string.match(Lines[J + 1] or "", "^" .. Pad .. "    ([%a_][%w_%.]*) = (.+)$")

            if Target2 ~= Name or not SingleLine(Value2) or Lines[J + 2] ~= Pad .. "end" then
                return nil
            end

            Values[#Values + 1] = Value2

            return Pad, Name, Conds, Values, J + 3
        else
            return nil
        end
    end
end

local function CollapseBools(Text)
    local Lines = Split(Text, "\n")
    local Out = {}
    local I = 1

    while I <= #Lines do
        local Pad, Name, Conds, Values, Next = IfChain(Lines, I)

        if Pad then
            local Value = nil

            if #Conds == 1 and ((Values[1] == "true" and Values[2] == "false") or (Values[1] == "false" and Values[2] == "true")) and IsBoolExpr(Conds[1]) then
                Value = Values[1] == "true" and Conds[1] or "not (" .. Conds[1] .. ")"
            else
                local Parts = {}

                for K, Cond in ipairs(Conds) do
                    Parts[#Parts + 1] = (K == 1 and "if " or "elseif ") .. Cond .. " then " .. Values[K]
                end

                Value = table.concat(Parts, " ") .. " else " .. Values[#Values]
            end

            local Referenced = FindWord(Value, Name) ~= nil

            if Out[#Out] == Pad .. "local " .. Name and not Referenced then
                Out[#Out] = Pad .. "local " .. Name .. " = " .. Value
            else
                Out[#Out + 1] = Pad .. Name .. " = " .. Value
            end

            I = Next
        else
            Out[#Out + 1] = Lines[I]
            I += 1
        end
    end

    return table.concat(Out, "\n")
end

local BinaryPrec = {
    ["or"] = 1,
    ["and"] = 2,
    ["<"] = 3,
    [">"] = 3,
    ["<="] = 3,
    [">="] = 3,
    ["~="] = 3,
    ["=="] = 3,
    [".."] = 4,
    ["+"] = 5,
    ["-"] = 5,
    ["*"] = 6,
    ["/"] = 6,
    ["//"] = 6,
    ["%"] = 6,
    ["^"] = 8,
}

local LeftAssoc = {["+"] = true, ["-"] = true, ["*"] = true, ["/"] = true, ["//"] = true, ["%"] = true, ["and"] = true, ["or"] = true}
local Comparison = {["<"] = true, [">"] = true, ["<="] = true, [">="] = true, ["~="] = true, ["=="] = true}
local FlipOp = {["<"] = ">=", [">"] = "<=", ["<="] = ">", [">="] = "<", ["=="] = "~=", ["~="] = "=="}
local MirrorOp = {["<"] = ">", [">"] = "<", ["<="] = ">=", [">="] = "<=", ["=="] = "==", ["~="] = "~="}
local AssignOps = {["="] = true, ["+="] = true, ["-="] = true, ["*="] = true, ["/="] = true, ["%="] = true, ["^="] = true, ["..="] = true, ["//="] = true}
local ContextKw = {["if"] = true, ["elseif"] = true, ["return"] = true, ["while"] = true, ["until"] = true, ["in"] = true, ["then"] = true, ["else"] = true}
local ForbiddenKw = {["function"] = true, ["if"] = true, ["then"] = true, ["else"] = true, ["elseif"] = true, ["end"] = true, ["do"] = true, ["for"] = true, ["while"] = true, ["repeat"] = true, ["until"] = true, ["return"] = true, ["local"] = true, ["break"] = true, ["continue"] = true, ["in"] = true}
local StopKw = {["and"] = true, ["or"] = true, ["then"] = true, ["do"] = true, ["until"] = true, ["else"] = true, ["elseif"] = true, ["end"] = true, ["return"] = true}
local OpenerOf = {[")"] = "(", ["]"] = "[", ["}"] = "{"}
local MergeOps = {"...", "..=", "//=", "==", "~=", "<=", ">=", "..", "//", "+=", "-=", "*=", "/=", "%=", "^="}

local function LineTokens(Line)
    if string.find(Line, "`", 1, true) or string.find(Line, "[[", 1, true) or string.find(Line, "--", 1, true) then
        return nil
    end

    local Raw, Count = Tokenize(Line)
    local Tokens = {}
    local I = 0

    while I < Count do
        local Tok = Raw[I]
        local Merged = false

        if Tok.Kind == "op" and string.find(Tok.Text, "[%./=~<>%+%-%*%%%^]") then
            for _, Op in ipairs(MergeOps) do
                local Ok = true

                for K = 0, #Op - 1 do
                    local Next = Raw[I + K]

                    if not Next or Next.Kind ~= "op" or Next.Text ~= string.sub(Op, K + 1, K + 1) or (K > 0 and Next.Start ~= Raw[I + K - 1].End) then
                        Ok = false
                        break
                    end
                end

                if Ok then
                    Tokens[#Tokens + 1] = {Kind = "op", Text = Op, Start = Tok.Start, End = Raw[I + #Op - 1].End}
                    I += #Op
                    Merged = true
                    break
                end
            end
        end

        if not Merged then
            Tokens[#Tokens + 1] = Tok
            I += 1
        end
    end

    return Tokens
end

local function EndsOperand(Tok)
    if not Tok then
        return false
    end

    if Tok.Kind == "ident" or Tok.Kind == "num" or Tok.Kind == "string" then
        return true
    end

    if Tok.Kind == "kw" then
        return Tok.Text == "true" or Tok.Text == "false" or Tok.Text == "nil"
    end

    return Tok.Text == ")" or Tok.Text == "]" or Tok.Text == "}" or Tok.Text == "..."
end

local function PairsOf(Tokens)
    local Stack = {}
    local Found = {}

    for I, Tok in ipairs(Tokens) do
        if Tok.Kind == "op" then
            if Tok.Text == "(" or Tok.Text == "[" or Tok.Text == "{" then
                Stack[#Stack + 1] = I
            elseif OpenerOf[Tok.Text] then
                local Open = table.remove(Stack)

                if Open and Tokens[Open].Text == OpenerOf[Tok.Text] then
                    Found[#Found + 1] = {Open, I}
                end
            end
        end
    end

    return Found
end

local function IsOpener(Tok)
    return Tok.Kind == "op" and (Tok.Text == "(" or Tok.Text == "[" or Tok.Text == "{")
end

local function IsCloser(Tok)
    return Tok.Kind == "op" and OpenerOf[Tok.Text] ~= nil
end

local function LeftContext(Tokens, A)
    local Prev = Tokens[A - 1]

    if not Prev then
        return nil
    end

    if Prev.Kind == "kw" then
        if Prev.Text == "not" then
            return 7
        end

        if Prev.Text == "and" then
            return 2
        end

        if Prev.Text == "or" then
            return 1
        end

        if ContextKw[Prev.Text] then
            return 0
        end

        return nil
    end

    if Prev.Kind ~= "op" then
        return nil
    end

    if BinaryPrec[Prev.Text] then
        if Prev.Text == "-" and not EndsOperand(Tokens[A - 2]) then
            return 7
        end

        return BinaryPrec[Prev.Text]
    end

    if Prev.Text == "#" then
        return 7
    end

    if Prev.Text == "(" or Prev.Text == "," or Prev.Text == "{" or Prev.Text == "[" or AssignOps[Prev.Text] then
        return 0
    end

    return nil
end

local function RightContext(Tokens, B)
    local Next = Tokens[B + 1]

    if not Next then
        return 0
    end

    if Next.Kind == "kw" then
        if Next.Text == "and" then
            return 2
        end

        if Next.Text == "or" then
            return 1
        end

        return 0
    end

    if Next.Kind == "op" then
        if BinaryPrec[Next.Text] then
            return BinaryPrec[Next.Text]
        end

        if Next.Text == "." or Next.Text == ":" or Next.Text == "[" or Next.Text == "(" or Next.Text == "{" then
            return nil
        end

        return 0
    end

    return nil
end

local function InnerInfo(Tokens, A, B)
    local Depth = 0
    local MinPrec = nil
    local Unary = false

    for I = A + 1, B - 1 do
        local Tok = Tokens[I]

        if Tok.Kind == "kw" and ForbiddenKw[Tok.Text] then
            return false
        end

        if Tok.Text == "..." then
            return false
        end

        if IsOpener(Tok) then
            Depth += 1
        elseif IsCloser(Tok) then
            Depth -= 1
        elseif Depth == 0 then
            local P = nil

            if Tok.Kind == "op" and BinaryPrec[Tok.Text] then
                if Tok.Text == "-" and not EndsOperand(Tokens[I - 1]) then
                    Unary = true
                else
                    P = BinaryPrec[Tok.Text]
                end
            elseif Tok.Kind == "kw" and (Tok.Text == "and" or Tok.Text == "or") then
                P = BinaryPrec[Tok.Text]
            elseif (Tok.Kind == "kw" and Tok.Text == "not") or Tok.Text == "#" then
                Unary = true
            end

            if P and (not MinPrec or P < MinPrec) then
                MinPrec = P
            end
        end
    end

    return true, MinPrec, Unary
end

local function EndsWithCall(Tokens, A, B)
    local Last = Tokens[B - 1]

    if Last.Text ~= ")" and Last.Text ~= "}" then
        return false
    end

    local Depth = 0

    for I = B - 1, A + 1, -1 do
        local Tok = Tokens[I]

        if IsCloser(Tok) then
            Depth += 1
        elseif IsOpener(Tok) then
            Depth -= 1

            if Depth == 0 then
                return I > A + 1 and EndsOperand(Tokens[I - 1])
            end
        end
    end

    return false
end

local function RemovablePair(Tokens, A, B)
    if B == A + 1 then
        return false
    end

    local LP = LeftContext(Tokens, A)
    local RP = RightContext(Tokens, B)

    if not LP or not RP then
        return false
    end

    local Ok, MinPrec, Unary = InnerInfo(Tokens, A, B)

    if not Ok then
        return false
    end

    local P = MinPrec

    if not P then
        if Unary then
            P = 7
        else
            if EndsWithCall(Tokens, A, B) and LP == 0 and RP == 0 then
                return false
            end

            P = math.huge
        end
    end

    local Prev = Tokens[A - 1]
    local First = Tokens[A + 1]

    if Prev.Kind == "op" and Prev.End == Tokens[A].Start and ((Prev.Text == "-" and First.Text == "-") or (Prev.Text == ".." and (First.Kind == "num" or First.Text == "."))) then
        return false
    end

    if P > LP and P > RP then
        return true
    end

    local Next = Tokens[B + 1]

    return MinPrec ~= nil and P == RP and P > LP and Next ~= nil and LeftAssoc[Next.Text] == true
end

local function RemoveParensOnce(Line, Tokens)
    for _, Pair in ipairs(PairsOf(Tokens)) do
        local A = Pair[1]
        local B = Pair[2]

        if Tokens[A].Text == "(" and RemovablePair(Tokens, A, B) then
            local Open = Tokens[A]
            local Close = Tokens[B]
            local Prev = Tokens[A - 1]
            local Next = Tokens[B + 1]
            local OpenRepl = ""
            local CloseRepl = ""

            if Prev.Kind == "kw" and Prev.End == Open.Start then
                OpenRepl = " "
            end

            if Next and Next.Kind ~= "op" and Next.Start == Close.End then
                CloseRepl = " "
            end

            return string.sub(Line, 1, Open.Start) .. OpenRepl .. string.sub(Line, Open.End + 1, Close.Start) .. CloseRepl .. string.sub(Line, Close.End + 1)
        end
    end

    return nil
end

local function FlipNotOnce(Line, Tokens)
    for _, Pair in ipairs(PairsOf(Tokens)) do
        local A = Pair[1]
        local B = Pair[2]
        local NotTok = Tokens[A - 1]

        if Tokens[A].Text == "(" and NotTok and NotTok.Kind == "kw" and NotTok.Text == "not" and B > A + 3 then
            local Ok = true
            local Depth = 0
            local CmpAt = nil
            local Count = 0

            for I = A + 1, B - 1 do
                local Tok = Tokens[I]

                if Tok.Kind == "kw" and (ForbiddenKw[Tok.Text] or Tok.Text == "and" or Tok.Text == "or") then
                    Ok = false
                    break
                end

                if IsOpener(Tok) then
                    Depth += 1
                elseif IsCloser(Tok) then
                    Depth -= 1
                elseif Depth == 0 and Tok.Kind == "op" and Comparison[Tok.Text] then
                    CmpAt = I
                    Count += 1
                end
            end

            if Ok and Count == 1 and CmpAt > A + 1 and CmpAt < B - 1 then
                local Left = string.sub(Line, Tokens[A + 1].Start + 1, Tokens[CmpAt].Start)
                local Right = string.sub(Line, Tokens[CmpAt].End + 1, Tokens[B - 1].End)
                Left = Strip(Left)
                Right = Strip(Right)
                local Op = FlipOp[Tokens[CmpAt].Text]

                if CmpAt == A + 2 and Tokens[A + 1].Kind == "num" and not (CmpAt + 1 == B - 1 and Tokens[B - 1].Kind == "num") then
                    Left, Right = Right, Left
                    Op = MirrorOp[Op]
                end

                return string.sub(Line, 1, NotTok.Start) .. "(" .. Left .. " " .. Op .. " " .. Right .. ")" .. string.sub(Line, Tokens[B].End + 1)
            end
        end
    end

    return nil
end

local function MirrorOnce(Line, Tokens)
    for C, Tok in ipairs(Tokens) do
        local Num = Tokens[C - 1]
        local Before = Tokens[C - 2]

        if Tok.Kind == "op" and Comparison[Tok.Text] and Num and Num.Kind == "num" then
            local Clean = Before == nil or (Before.Kind == "op" and (Before.Text == "(" or Before.Text == "," or Before.Text == "{" or AssignOps[Before.Text])) or (Before.Kind == "kw" and (Before.Text == "and" or Before.Text == "or" or ContextKw[Before.Text]))

            if Clean then
                local Depth = 0
                local Stop = nil
                local Abort = false

                for I = C + 1, #Tokens do
                    local T = Tokens[I]

                    if T.Kind == "kw" and T.Text == "function" then
                        Abort = true
                        break
                    end

                    if IsOpener(T) then
                        Depth += 1
                    elseif IsCloser(T) then
                        if Depth == 0 then
                            Stop = I
                            break
                        end

                        Depth -= 1
                    elseif Depth == 0 and ((T.Kind == "kw" and StopKw[T.Text]) or (T.Kind == "op" and (T.Text == "," or Comparison[T.Text] or AssignOps[T.Text]))) then
                        Stop = I
                        break
                    end
                end

                if not Abort and Depth == 0 then
                    local Last = (Stop or #Tokens + 1) - 1

                    if Last > C and not (Last == C + 1 and Tokens[C + 1].Kind == "num") then
                        local Right = string.sub(Line, Tokens[C + 1].Start + 1, Tokens[Last].End)

                        return string.sub(Line, 1, Num.Start) .. Right .. " " .. MirrorOp[Tok.Text] .. " " .. Num.Text .. string.sub(Line, Tokens[Last].End + 1)
                    end
                end
            end
        end
    end

    return nil
end

local function SimpleKeysOnce(Line, Tokens)
    for I = 1, #Tokens - 3 do
        local Open = Tokens[I]
        local Key = Tokens[I + 1]
        local Close = Tokens[I + 2]
        local Eq = Tokens[I + 3]

        if Open.Text == "[" and Key.Kind == "string" and Close.Text == "]" and Eq.Text == "=" then
            local Prev = Tokens[I - 1]
            local Name = string.match(Key.Text, '^"([%a_][%w_]*)"$')

            if Name and not Keywords[Name] and (Prev == nil or Prev.Text == "{" or Prev.Text == ",") then
                return string.sub(Line, 1, Open.Start) .. Name .. string.sub(Line, Close.End + 1)
            end
        end
    end

    return nil
end

local function SimplifyLine(Line)
    if not (string.find(Line, "[%(%[<>]") or string.find(Line, "==", 1, true) or string.find(Line, "~=", 1, true)) then
        return Line
    end

    for _ = 1, 60 do
        local Tokens = LineTokens(Line)

        if not Tokens then
            return Line
        end

        local New = SimpleKeysOnce(Line, Tokens) or FlipNotOnce(Line, Tokens) or MirrorOnce(Line, Tokens) or RemoveParensOnce(Line, Tokens)

        if not New then
            return Line
        end

        Line = New
    end

    return Line
end

local function BlockEndLine(Lines, I, Pad)
    for J = I + 1, #Lines do
        local Line = Lines[J]

        if Line ~= "" and string.sub(Line, 1, #Pad + 1) ~= Pad .. "\t" and string.sub(Line, 1, #Pad + 1) ~= Pad .. " " then
            if Line == Pad .. "end" then
                return J
            end

            return nil
        end
    end

    return nil
end

local function Beautify(Code)
    local Lines = Split(Code, "\n")

    for I, Line in ipairs(Lines) do
        Lines[I] = SimplifyLine(Line)
    end

    for I, Line in ipairs(Lines) do
        local Pad, Name, Params = string.match(Line, "^(%s*)([%a_][%w_]*) = function(%b())$")
        local IsLocal = false

        if not Pad then
            Pad, Name, Params = string.match(Line, "^(%s*)local ([%a_][%w_]*) = function(%b())$")
            IsLocal = Pad ~= nil
        end

        if Pad then
            local End = BlockEndLine(Lines, I, Pad)

            if End then
                local SelfUse = false

                if IsLocal then
                    for J = I + 1, End - 1 do
                        if FindWord(Lines[J], Name) then
                            SelfUse = true
                            break
                        end
                    end
                end

                if not SelfUse then
                    Lines[I] = Pad .. (IsLocal and "local function " or "function ") .. Name .. Params
                end
            end
        end
    end

    for I, Line in ipairs(Lines) do
        local Pad, First, Second, Rest = string.match(Line, "^(%s*)for ([%a_][%w_]*), ([%a_][%w_]*) in (.+) do$")
        local Numeric = false

        if not Pad then
            Pad, First, Rest = string.match(Line, "^(%s*)for ([%a_][%w_]*) in (.+) do$")
        end

        if not Pad then
            Pad, First, Rest = string.match(Line, "^(%s*)for ([%a_][%w_]*) = (.+) do$")
            Numeric = Pad ~= nil
        end

        if Pad then
            local End = BlockEndLine(Lines, I, Pad)

            if End then
                local Body = table.concat(Lines, "\n", I + 1, End - 1)
                local FirstUnused = First ~= "_" and not FindWord(Body, First)
                local SecondUnused = Second ~= nil and Second ~= "_" and not FindWord(Body, Second)

                if Numeric then
                    if FirstUnused then
                        Lines[I] = Pad .. "for _ = " .. Rest .. " do"
                    end
                elseif Second then
                    if FirstUnused and SecondUnused then
                        Lines[I] = Pad .. "for _ in " .. Rest .. " do"
                    elseif FirstUnused then
                        Lines[I] = Pad .. "for _, " .. Second .. " in " .. Rest .. " do"
                    elseif SecondUnused then
                        Lines[I] = Pad .. "for " .. First .. " in " .. Rest .. " do"
                    end
                elseif FirstUnused then
                    Lines[I] = Pad .. "for _ in " .. Rest .. " do"
                end
            end
        end
    end

    return table.concat(Lines, "\n")
end

local function IndentOf(Line)
    return #Line - #LStrip(Line)
end

local function RenameWordInRows(Lines, From, To, First, Last)
    local Edits = {}

    for Row = First, Last do
        local Line = Lines[Row]

        if FindWord(Line, From) then
            local Tokens = LineTokens(Line)

            if not Tokens then
                return false
            end

            local Hits = {}

            for I, Tok in ipairs(Tokens) do
                if Tok.Kind == "ident" and Tok.Text == From then
                    local Prev = Tokens[I - 1]
                    local Next = Tokens[I + 1]

                    if Prev and Prev.Kind == "op" and (Prev.Text == "." or Prev.Text == ":") then
                        continue
                    end

                    if Prev and Prev.Kind == "op" and (Prev.Text == "{" or Prev.Text == ",") and Next and Next.Kind == "op" and Next.Text == "=" then
                        return false
                    end

                    Hits[#Hits + 1] = Tok
                end
            end

            Edits[#Edits + 1] = {Row, Hits}
        end
    end

    for _, Edit in ipairs(Edits) do
        local Line = Lines[Edit[1]]

        for K = #Edit[2], 1, -1 do
            local Tok = Edit[2][K]
            Line = string.sub(Line, 1, Tok.Start) .. To .. string.sub(Line, Tok.End + 1)
        end

        Lines[Edit[1]] = Line
    end

    return true
end

local function HasIdent(Line, Name)
    if not FindWord(Line, Name) then
        return false
    end

    local Tokens = LineTokens(Line)

    if not Tokens then
        return true
    end

    for _, Tok in ipairs(Tokens) do
        if Tok.Kind == "ident" and Tok.Text == Name then
            return true
        end
    end

    return false
end

local function UniqueNameIn(Lines, Base, First, Last)
    local Candidate = Base
    local Count = 1

    while true do
        local Taken = Keywords[Candidate] ~= nil

        for Row = First, Last do
            if HasIdent(Lines[Row], Candidate) then
                Taken = true
                break
            end
        end

        if not Taken then
            return Candidate
        end

        Count += 1
        Candidate = Base .. tostring(Count)
    end
end

local function MemberName(Arg)
    local Lit = string.match(Arg, '^"([%a_][%w_]*)"$')

    if Lit then
        return Lit
    end

    local Owner, Member = string.match(Arg, "([%a_][%w_]*)%.([%a_][%w_]*)$")

    if not Member then
        return nil
    end

    local Short = string.match(Member, "^(.-)Name$")

    if Short and #Short >= 3 then
        Member = Short
    end

    return string.upper(string.sub(Owner, 1, 1)) .. string.sub(Owner, 2) .. string.upper(string.sub(Member, 1, 1)) .. string.sub(Member, 2)
end

local ChildMethods = {FindFirstChild = true, WaitForChild = true, FindFirstChildOfClass = true, FindFirstChildWhichIsA = true}

local function DeriveName(Lines, Row, Expr, Depth)
    if Depth > 6 then
        return nil
    end

    Expr = Strip(Expr)

    local Rhs = string.match(Expr, "^[%w_%.]+ and (.+)$") or string.match(Expr, "^if .- then nil else (.+)$") or string.match(Expr, "^if .- then (.+) else nil$") or string.match(Expr, "^(.+):Clone%(%)$")

    if Rhs then
        return DeriveName(Lines, Row, Rhs, Depth + 1)
    end

    local Method, Arg = string.match(Expr, "^.+:(%a+)%((.+)%)$")

    if Method and ChildMethods[Method] then
        local First = string.match(Arg, "^([^,]+)")

        if Method == "FindFirstChildOfClass" or Method == "FindFirstChildWhichIsA" then
            return string.match(First, '^"([%a_][%w_]*)"$')
        end

        return MemberName(Strip(First))
    end

    local Id = string.match(Expr, "^([%a_][%w_]*)$")

    if Id then
        for K = Row - 1, math.max(1, Row - 80), -1 do
            local Def = string.match(Lines[K], "^%s*local " .. Id .. " = (.+)$") or string.match(Lines[K], "^%s*" .. Id .. " = (.+)$")

            if Def then
                return DeriveName(Lines, K, Def, Depth + 1)
            end
        end
    end

    return nil
end

local function NameByInstance(Code, Hints)
    local Lines = Split(Code, "\n")
    local Cands = {}

    for I, Line in ipairs(Lines) do
        local Pad, Name = string.match(Line, '^(%s*)local ([%a_][%w_]*) = Instance%.new%("%a+"%)$')
        local Declared = Pad ~= nil

        if not Pad then
            Pad, Name = string.match(Line, '^(%s*)([%a_][%w_]*) = Instance%.new%("%a+"%)$')
        end

        if Pad then
            local Lit = nil

            for J = I + 1, math.min(I + 6, #Lines) do
                local Found = string.match(Lines[J], "^" .. Pad .. Name .. '%.Name = "([%a_][%w_]*)"$')

                if Found then
                    Lit = Found
                    break
                end
            end

            local DeclRow = I

            if Lit and not Declared then
                DeclRow = nil
                local Limit = IndentOf(Line)

                for K = I - 1, 1, -1 do
                    local Prev = Lines[K]

                    if Strip(Prev) ~= "" then
                        local Ind = IndentOf(Prev)

                        if Ind <= Limit and string.find(Prev, "^%s*local .*%f[%w_]" .. Name .. "%f[^%w_]") then
                            DeclRow = K
                            break
                        end

                        if Ind < Limit then
                            Limit = Ind
                        end
                    end
                end
            end

            if Lit and DeclRow and not Keywords[Lit] and #Lit >= 3 and IndentOf(Lines[DeclRow]) > 0 then
                local EndRow = #Lines

                for K = DeclRow + 1, #Lines do
                    if Strip(Lines[K]) ~= "" and IndentOf(Lines[K]) < IndentOf(Lines[DeclRow]) then
                        EndRow = K - 1
                        break
                    end
                end

                Cands[#Cands + 1] = {Name = Name, Lit = Lit, First = DeclRow, Last = EndRow}
            end
        end
    end

    for I, Line in ipairs(Lines) do
        local Var = string.match(Line, "^local (v%d+) = nil$")

        if Var then
            local Lit = nil
            local Ok = true
            local Seen = false

            for Row, Text in ipairs(Lines) do
                local Rhs = string.match(Text, "^%s*" .. Var .. " = (.+)$")

                if Rhs and Rhs ~= "nil" then
                    local Matched = nil

                    for _, Cand in ipairs(Cands) do
                        if Cand.Name == Rhs and Cand.First <= Row and Row <= Cand.Last then
                            Matched = Cand
                            break
                        end
                    end

                    if not Matched or (Lit and Lit ~= Matched.Lit) then
                        Ok = false
                        break
                    end

                    Lit = Matched.Lit
                    Seen = true
                end
            end

            if Ok and Seen then
                local New = UniqueNameIn(Lines, Lit, 1, #Lines)
                RenameWordInRows(Lines, Var, New, 1, #Lines)
            end
        end
    end

    for _, Cand in ipairs(Cands) do
        local New = UniqueNameIn(Lines, Cand.Lit, Cand.First, Cand.Last)
        RenameWordInRows(Lines, Cand.Name, New, Cand.First, Cand.Last)
    end

    for _, Line in ipairs(Lines) do
        local Var = string.match(Line, "^local (v%d+) = nil$")

        if Var then
            local Base = Hints[Var]

            if not Base then
                local Ok = true

                for Row, Text in ipairs(Lines) do
                    local Rhs = string.match(Text, "^%s*" .. Var .. " = (.+)$")

                    if Rhs and Rhs ~= "nil" then
                        local Derived = DeriveName(Lines, Row, Rhs, 0)

                        if not Derived or (Base and Base ~= Derived) then
                            Ok = false
                            break
                        end

                        Base = Derived
                    end
                end

                if not Ok then
                    Base = nil
                end
            end

            if Base and IsValidIdentifier(Base) then
                RenameWordInRows(Lines, Var, UniqueNameIn(Lines, Base, 1, #Lines), 1, #Lines)
            end
        end
    end

    return table.concat(Lines, "\n")
end

return function(Input, SkipRename)
    if typeof(Input) ~= "Instance" and typeof(Input) ~= "string" then
        return "Decompile Failed: invalid input (" .. typeof(Input) .. ")"
    end

    local Bytecode = Input

    if typeof(Input) == "Instance" then
        if not getscriptbytecode then
            return "Decompile Failed: getscriptbytecode not supported."
        end

        local Ok, Result = pcall(getscriptbytecode, Input)

        if not Ok then
            return "Decompile Failed: " .. tostring(Result)
        end

        Bytecode = Result
    end

    local First, Second = string.byte(Bytecode, 1, 2)

    if typeof(Input) == "Instance" or First == nil or (First == 9 or First == 13) and Second ~= nil and Second >= 1 and Second <= 3 or First < 32 and First ~= 9 and First ~= 10 and First ~= 13 then
        local Text, Succeeded = Decompile(Bytecode)

        if not Succeeded then
            return Text
        end

        Text = CollapseBools(Text)

        local RenameOk, Renamed = true, Text

        if not SkipRename then
            RenameOk, Renamed = pcall(RenameCode, Text, true)
        end

        if not RenameOk then
            return "Rename failed: " .. tostring(Renamed)
        end

        local Hints = {}

        for Name, Dn in string.gmatch(Renamed, "\n%s*([%a_][%w_]*) = function%b()%-%-%[%[dn:([%w_]+)%]%]") do
            Hints[Name] = Dn
        end

        return Beautify(NameByInstance(CompoundAssign((string.gsub(Renamed, "%-%-%[%[dn:[%w_]+%]%]", ""))), Hints))
    end

    return RenameCode(Bytecode)
end
