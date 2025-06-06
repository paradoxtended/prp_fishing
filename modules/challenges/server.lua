---@class DailyChallenges
---@field type ChallengeType
---@field total number
---@field catched number
---@field reward number
---@field claimed boolean
---@field fish? string

local challengesData = require 'data.challenges'
local fish = require 'data.fish'

---@type table<string, DailyChallenges[]>
local dailyChallenges = {}

---@return ChallengeType, Challenge
local function getChallengeType()
    local types = {}
    for type in pairs(challengesData) do
        table.insert(types, type)
    end

    local random = types[math.random(#types)]
    return random, challengesData[random]
end

---@param fishList { fish: string, price: number }[]
---@return { fish: string, price: number }
local function getRandomFish(fishList)
    local index = math.random(#fishList)
    return fishList[index]
end

---@param identifier string Player's identifier
local function generateChallenges(identifier)
    for i=1, 3 do
        local type, data = getChallengeType()
        local total = math.random(data.count.min, data.count.max)
        local isFish = data?.fishList and getRandomFish(data.fishList) or nil

        dailyChallenges[identifier][i] = {
            type = type,
            total = total,
            catched = 0,
            fish = isFish?.fish,
            reward = total * (isFish?.price or data?.price),
            claimed = false
        }
    end
end

---@param source number
lib.callback.register('prp_fishing:getDailyChallenges', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local identifier = player:getIdentifier()

    if not dailyChallenges[identifier] then
        dailyChallenges[identifier] = {}

        generateChallenges(identifier)
    end

    return dailyChallenges[identifier]
end)

---@param source number
---@param index integer
lib.callback.register('prp_fishing:claimDailyChallenge', function(source, index)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local identifier = player:getIdentifier()
    if not dailyChallenges[identifier] then return end

    local challenge = dailyChallenges[identifier][index]
    if challenge.catched < challenge.total then return end

    challenge.claimed = true
    local data = challengesData[challenge.type]

    player:addAccountMoney(data?.account or 'money', challenge.reward)

    return true
end)

challenges = {}

---@param identifier string Player's identifier
---@param fishName string Fish
function challenges.addCatchFish(identifier, fishName)
    local player = Framework.getPlayerFromIdentifier(identifier)
    if not player then return end

    -- Check if player has fish in inventory(if he really catched the fish), if not we end this function, 
    -- you can add your own code here, f.e. you can ban the player(possible cheater)
    if not fish[fishName] or not player:hasItem(fishName) then 
        return
    end

    if not dailyChallenges[identifier] then
        dailyChallenges[identifier] = {}
        generateChallenges(identifier)
    end

    for _, challenge in ipairs(dailyChallenges[identifier]) do
        if challenge.type == 'amount' then
            challenge.catched = challenge.catched + 1
        end

        if challenge.type == 'fish' and challenge.fish == fishName then
            challenge.catched = challenge.catched + 1
        end
    end
end