--loads the config file
local config = {} 
local f = loadfile("config.txt", "t", config)
if f then
    f()
    URL = config.URL
    verticalOffset = config.verticalOffset
    horizontalOffset = config.horizontalOffset
    sheetName = config.sheetName
end
print("URL: " .. URL)
print("verticalOffset: " .. verticalOffset)
print("horizontalOffset: " .. horizontalOffset)
print("sheetName: " .. sheetName)

-- buffeer make horizontalOffset not an upvalue 
-- upvalues :(
local o = horizontalOffset

local function horizontalOffset(offset)
    return string.char(64 + offset + o)
end

local function writeCells(sheetName, map, deleteRows, compact)
    local writes = {}

    for cell, value in pairs(map or {}) do
        table.insert(writes, {
            cell = cell,
            value = value
        })
    end

    local payload = {
        sheet = sheetName,
        writes = writes
    }

    if deleteRows then
        payload.deleteRows = deleteRows
    end

    if compact then
        payload.compact = true
    end

    local json = textutils.serializeJSON(payload)

    local response = http.post(URL, json, {
        ["Content-Type"] = "application/json"
    })

    if response then
        response.close()
    end
end
function clone(original)
    copy = {table.unpack(original)}
    return copy
end

local MEBridge = peripheral.wrap("bottom")


local oldItems = {}
local oldFluids = {}

i = 0
while true do
    payload = {}
    local curItems = {}

    local spreadsheetWrites = {}
    local items = MEBridge.listItems()
    
    for k, m in pairs(items) do
        local name = m.displayName
        local count = m.amount
        local id = m.name
        
        curItems[k] = m.displayName
        local curItem = curItems[k]
        local oldItem = oldItems[k]
        
        spreadsheetWrites[horizontalOffset(1) .. k + verticalOffset] = name
        spreadsheetWrites[horizontalOffset(2) .. k + verticalOffset] = count
        spreadsheetWrites[horizontalOffset(3) .. k + verticalOffset] = id
    end

    if #curItems < #oldItems then
        for i = #oldItems, 1, -1 do
            local exists = false

            for j = 1, #curItems do
                if oldItems[i] == curItems[j] then
                    exists = true
                    break
                end
            end

            if not exists then
                table.insert(payload, i + verticalOffset)
                table.remove(oldItems, i)

            end
        end
    end
    oldItems = clone(curItems)

    local curFluids = {}

-- FLUIDS!! YAY!!!!!- --
    local fluids = MEBridge.listFluid()

    for k, m in pairs(fluids) do
        local name = m.displayName
        local count = m.amount
        local id = m.name
        
        curFluids[k] = m.displayName

        -- formats buckets nicely
        wholeCount = math.floor(count / 1000)
        remainderCount = count % 1000
        count = tostring(wholeCount) .. "B " .. tostring(remainderCount) .. "mB"
        ----------------
        
        spreadsheetWrites[horizontalOffset(4) .. k + verticalOffset] = name
        spreadsheetWrites[horizontalOffset(5) .. k + verticalOffset] = count 
        spreadsheetWrites[horizontalOffset(6) .. k + verticalOffset] = id
    end

    -- prints which fluid was removed since this iteration and the last. including its ID
    if #curFluids < #oldFluids then
        for i = #oldFluids, 1, -1 do
            local exists = false

            for j = 1, #curFluids do
                if oldFluids[i] == curFluids[j] then
                    exists = true
                    break
                end
            end

            if not exists then
                table.insert(payload, i + verticalOffset)
                table.remove(oldFluids, i)

            end
        end
    end
    oldFluids = clone(curFluids)
    writeCells(sheetName, spreadsheetWrites, payload, true)
end