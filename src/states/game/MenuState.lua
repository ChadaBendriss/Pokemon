--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(pokemon, onClose)
    self.pokemon = pokemon
    self.onClose = onClose or function() end
    self.visible = true -- Control whether this state should be rendered/updated
    
    self:calculateStatsAndCreateMenus()
end

function MenuState:calculateStatsAndCreateMenus()
    local HitPts, attack, defense, speed = self.pokemon.HitPts, self.pokemon.attack, self.pokemon.defense, self.pokemon.speed
    local incHitPts, incAtk, incDef, incSpd = self.pokemon:levelUp()

    self.leftMenu = Selection {
        cursor = false,
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH / 2,
        height = 64,
        cursorEnabled = false,
        items = {
            { text = self:generateStatText('HitPts', HitPts, HitPts) },
            { text = self:generateStatText('Attack', attack, incAtk) }
        }
    }

    self.rightMenu = Selection {
        cursor = false,
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH / 2,
        height = 64,
        cursorEnabled = false,
        items = {
            { text = self:generateStatText('Defense', defense, incDef) },
            { text = self:generateStatText('Speed', speed, incSpd) }
        }
    }
end

function MenuState:generateStatText(statName, statValue, increment)
    return string.format('%s: %d + %d = %d', statName, statValue - increment, increment, statValue)
end

function MenuState:update(dt)
    if not self.visible then return end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.visible = false
        gStateStack:pop()
        self.onClose()
    end
end

function MenuState:render()
    if not self.visible then return end

    self.leftMenu:render()
    self.rightMenu:render()
end
