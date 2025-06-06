---@class Challenge
---@field count { min: number, max: number } How many fishes you will have to catch (random value between those)
---@field price? number Price per one fish (it's not constant so for instance: if you have to catch 15 fishes then reward will be 15 * price)
---@field account? 'money' | 'bank' | 'black_money' How the player will get paid, default is money

---@class FishChallenge : Challenge
---@field fishList { fish: string, price: number }[] Price per fish (in anchovy f.e. you have to catch 10 fish, it's 10 per fish so the reward of the challenge is $100)

---@alias ChallengeType 'amount' | 'fish'

---@type table<ChallengeType, Challenge>
return {
    amount = {
        count = { min = 10, max = 20 },
        price = 75,
        account = 'money'
    },

    ---@type FishChallenge
    fish = {
        count = { min = 10, max = 20 },
        fishList = {
            { fish = 'anchovy', price = 10 },
            { fish = 'trout', price = 12 },
            { fish = 'haddock', price = 14 },
            { fish = 'salmon', price = 16 },
            { fish = 'grouper', price = 18 },
        }
    }
}