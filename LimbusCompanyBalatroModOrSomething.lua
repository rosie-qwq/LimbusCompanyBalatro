SMODS.Atlas {
    key = "lcb_jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "lcb_tags",
    path = "tags.png",
    px = 34,
    py = 34
}

SMODS.Atlas {
    key = "lcb_boosters",
    path = "boosters.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
}

SMODS.Atlas {
    key = "sins",
    path = "sins.png",
    px = 256,
    py = 256
}

-- TODO: All O sinners (remaining Yi Sang, Faust, Hong Lu)
-- Start with Shi Ishmael for the OO sinners

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local lcb_config = SMODS.current_mod.config

function G.FUNCS.lcb_switch_pack_music(arg)
    lcb_config.limbus_pack_music = arg.to_key
    SMODS.save_mod_config(SMODS.current_mod)
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    --ret.lcb_blind_effects = {burn = {0,0}, bleed = {0,0}, poise = {0,0}}
    ret.lcb_blind_effects = {tremor = 0, rupture = {0,0}} -- Tremor only has Potency here
    -- The first value is Potency, the second is Count
    -- !! Rupture: Each card gives (Rupture * 10) Chips and decreases count by 1 (DONE)
    -- !! Time Moratorium: After playing a hand, sets Chips and Mult to 0
    --                     On last hand of round, gives (Total chips and mult collected * 1.2) split evenly between Chips and Mult
    -- !! Charge: just decreases by 1 after hand is played lol
    -- !! Poise: gives X(1 + potency / 4) Mult, decreases count by 1 (on joker) (DONE)
    -- !! Sinking & Burn still left to do
    ret.lcb_sins = {0,0,0,0,0,0,0}
    -- The sin is a number from 1 to 7, 1 being wrath, 2 being lust etc.
    -- Using a skill of the said sin gives you one of that sin
    -- E.G.O. skills consume sins for better effects
    -- E.G.O. are obtained from packs
    ret.pool_flags.cannot_spawn = true -- Anything with the no_pool_flag of this just, won't spawn
    return ret
end

function SMODS.current_mod.config_tab()
    local sprite = Sprite(34, 34, 1, 1, G.ASSET_ATLAS["lcb_modicon"])
    local config_nodes = {n=G.UIT.ROOT, config = {align = "cm", colour = G.C.L_BLACK, minw = 4, minh = 4}, nodes = {
        {n = G.UIT.C, config = {align = "cm"}, nodes = {}}
    }}
    config_nodes.nodes[1].nodes[1] = create_toggle{
        label = "Does Don Quixote do the funny?",
        ref_table = lcb_config,
        ref_value = "don_is_funny"
    }
    config_nodes.nodes[1].nodes[2] = create_option_cycle{
        label = "Limbus Pack Music",
        w = 6.3,
        scale = 0.9,
        options = {
            "Extraction Theme",
            "Abnormality Extraction Theme",
            "Oh Crab, So Crab",
            "La Mancha Carnival",
            "A Midspring Night's Dream 2"
        },
        opt_callback = "lcb_switch_pack_music",
        current_option = lcb_config.limbus_pack_music
    }
    config_nodes.nodes[1].nodes[3] = {
        n = G.UIT.R, config = { align = "cm"}, nodes = {{
            n = G.UIT.O, config = { object = sprite, juice = true}
        }}
    }
    return config_nodes
end

function SMODS.current_mod.reset_game_globals(run_start)
    --[[
    G.GAME.lcb_blind_effects.burn = {0,0}
    G.GAME.lcb_blind_effects.bleed = {0,0}
    if run_start then
        add_tag(Tag("tag_lcb_burn_indicator"))
        add_tag(Tag("tag_lcb_bleed_indicator"))
        add_tag(Tag("tag_lcb_poise_indicator"))
    end
    if G.GAME.blind and G.GAME.blind.boss then G.GAME.lcb_blind_effects.poise = {0,0} end
    ]]
    G.GAME.lcb_blind_effects.tremor = 0
    G.GAME.lcb_blind_effects.rupture = {0,0}
end

local function sin_to_text(sin)
    local sins = { "Wrath", "Lust", "Sloth", "Gluttony", "Gloom", "Pride", "Envy" }
    return sins[sin]
end

local function skill_switch(context, card)
    if not context or not card or not card.ability or not card.ability.extra then return nil end
    if context.after then
        card.ability.extra.times_skill_used = card.ability.extra.times_skill_used + 1
        local sin = card.ability.extra.sin[card.ability.extra.current_skill]
        G.GAME.lcb_sins[sin] = G.GAME.lcb_sins[sin] + 1
        if (card.ability.extra.times_skill_used == 3 and card.ability.extra.current_skill == 1) or
        (card.ability.extra.times_skill_used == 2 and card.ability.extra.current_skill == 2) or
        (card.ability.extra.times_skill_used == 1 and card.ability.extra.current_skill == 3) then
            card.ability.extra.times_skill_used = 0
            card.ability.extra.current_skill = card.ability.extra.current_skill + 1
            if card.ability.extra.current_skill == 4 then card.ability.extra.current_skill = 1 end
        end
        sendInfoMessage(sin_to_text(sin).." sin granted, you now have "..G.GAME.lcb_sins[sin])
    end
end

local function modify_blind(blind_mod)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * blind_mod)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

            local chips_UI = G.hand_text_area.blind_chips
            G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
            G.HUD_blind:recalculate()
            chips_UI:juice_up()

            if not silent then play_sound('lcb_bleed') end
            return true
        end
    }))
end

local function modify_blind_add(blind_mod) modify_blind((G.GAME.blind.chips + blind_mod) / G.GAME.blind.chips) end

SMODS.Rarity {
    key = "tier_i",
    badge_colour = HEX("f9c400")
}

SMODS.Rarity {
    key = "tier_ii",
    badge_colour = HEX("f9c400")
}

SMODS.Rarity {
    key = "tier_iii",
    badge_colour = HEX("fcbe38")
}

SMODS.Rarity {
    key = "tier_iv",
    badge_colour = HEX("fff465")
}

SMODS.Rarity {
    key = "tier_v",
    badge_colour = HEX("fff465")
}

SMODS.Rarity {
    key = "o",
    badge_colour = HEX("a96d37")
}

SMODS.Rarity {
    key = "oo",
    badge_colour = HEX("e5931e")
}

SMODS.Rarity {
    key = "ooo",
    badge_colour = HEX("f3c131")
}

-- dundun......
SMODS.Sound {
    key = "tremor_burst",
    path = "limbus_tremor_burst.mp3",
}

-- Limbus Pack Music --

SMODS.Sound {
    key = "music_extraction_theme",
    path = "Extraction Theme 2.wav",
    pitch = 1, -- why do i have to do this?
    -- definetly not yoinked from aikoyori's shenanigans, what are you talking about
    select_music_track = function()
        if not SMODS.OPENED_BOOSTER or lcb_config.limbus_pack_music ~= 1 then return false end
        return G.booster_pack and not G.booster_pack.REMOVED and
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_limbus_pack" or
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_three_star_pack" and 100 or nil
    end,
}

SMODS.Sound {
    key = "music_abnormality_extration",
    path = "Abnormality Choice Theme.wav",
    pitch = 1,
    select_music_track = function()
        if not SMODS.OPENED_BOOSTER or lcb_config.limbus_pack_music ~= 2 then return false end
        return G.booster_pack and not G.booster_pack.REMOVED and
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_limbus_pack" or
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_three_star_pack" and 100 or nil
    end,
}

-- bless your ears, listen to this
SMODS.Sound {
    key = "music_oh_crab_so_crab",
    path = "Oh Crab, So Crab.wav",
    pitch = 1,
    select_music_track = function()
        if not SMODS.OPENED_BOOSTER or lcb_config.limbus_pack_music ~= 3 then return false end
        return G.booster_pack and not G.booster_pack.REMOVED and
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_limbus_pack" or
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_three_star_pack" and 100 or nil
    end,
}

SMODS.Sound {
    key = "music_la_mancha_carnival",
    path = "La Mancha Carnival.wav",
    pitch = 1,
    select_music_track = function()
        if not SMODS.OPENED_BOOSTER or lcb_config.limbus_pack_music ~= 4 then return false end
        return G.booster_pack and not G.booster_pack.REMOVED and
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_limbus_pack" or
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_three_star_pack" and 100 or nil
    end,
}

SMODS.Sound {
    key = "music_midspring_dream",
    path = "A Midspring Night’s Dream 2.wav",
    pitch = 1,
    select_music_track = function()
        if not SMODS.OPENED_BOOSTER or lcb_config.limbus_pack_music ~= 5 then return false end
        return G.booster_pack and not G.booster_pack.REMOVED and
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_limbus_pack" or
            SMODS.OPENED_BOOSTER.config.center.key == "p_lcb_three_star_pack" and 100 or nil
    end,
}


-- LIMBUS COMPANYYYYYYYYYYYYYYYYYYYYYYY
SMODS.Sound {
    key = "limbus_company_yayy",
    path = "LIMBUS.mp3"
}

-- average london experience
SMODS.Sound {
    key = "bleed",
    path = "tingtang_honglu_skill2-2.wav"
}

SMODS.Booster {
    key = "limbus_pack",
    config = {extra = 3, choose = 1},
    cost = 12,
    weight = 0.3,
    atlas = "lcb_boosters",
    pos = {x=0,y=0},
    group_key = "k_lcb_limbus_pack",
    create_card = function(self, card, i)
        local random = pseudorandom("limbus_booster")
        local rarity = (random <= 0.7 and "lcb_o" or random <= 0.95 and "lcb_oo") or "lcb_ooo"
        -- !! TODO: REMEMBER TO DELETE THIS WHEN I ADD OO AND OOO RARITY JOKERS!!!!!!!!!!!!!!!!!!!
        if rarity ~= "lcb_o" then rarity = "lcb_o" end

        return SMODS.create_card{
            set = "Joker",
            rarity = rarity
        }
    end
}

SMODS.Booster {
    key = "three_star_pack",
    config = { extra = 2, choose = 1 },
    cost = 40,
    weight = 0.3,
    atlas = "lcb_boosters",
    pos = { x = 1, y = 0 },
    group_key = "k_lcb_three_star_pack",
    create_card = function(self, card, i)
        --[[
        return SMODS.create_card {
            set = "Joker",
            rarity = "lcb_ooo",
            skip_materialize = true
        }]]
        return SMODS.create_card {
            set = "Joker",
            key = "j_joker"
        }
    end
}

SMODS.Joker {
    key = "white_gossypium",
    rarity = "lcb_tier_ii",
    atlas = "lcb_jokers",
    pos = {x=0,y=0},
    config = { extra = { required_score = 50, reached_requirement = false, blind_increase = 1.2, blind_decrease = 0.9 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (card.ability.extra.blind_increase - 1) * 100,
                (1 - card.ability.extra.blind_decrease) * 100
            }
        }
    end,
    calculate = function(self, card, context)
        if context.after and hand_chips and mult and G.GAME.chips >= (hand_chips * mult) + math.floor(G.GAME.blind.chips / 2) and card.ability.extra.reached_requirement == false then
            modify_blind(card.ability.extra.blind_increase)
            card.ability.extra.reached_requirement = true
            card_eval_status_text(card, "extra", nil, nil, nil, {message = "Active!"})
        end
        if context.before and card.ability.extra.reached_requirement then
            modify_blind(card.ability.extra.blind_decrease)
            card_eval_status_text(card, "extra", nil, nil, nil, {message = "Bleed!"})
        end
        if context.setting_blind then card.ability.extra.reached_requirement = false end
    end
}

SMODS.Joker {
    key = "ardent_flower",
    rarity = "lcb_tier_iii",
    atlas = "lcb_jokers",
    pos = {x=1,y=0},
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "effect_applies",
            set = "Other"
        }
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            if G.jokers.cards[1] == context.other_joker or G.jokers.cards[2] == context.other_joker and context.other_joker ~= card then
                local blind_mod = (100 - G.GAME.round_resets.ante * context.other_joker.config.center.rarity) / 100
                if blind_mod * 100 > 30 then blind_mod = 0.3 end
                modify_blind(blind_mod)
                card_eval_status_text(card, "extra", nil, nil, nil, {message = "Burn!"})
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.1,
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker {
    key = "voodoo_doll",
    rarity = "lcb_tier_i",
    atlas = "lcb_jokers",
    pos = {x=2,y=0},
    config = {extra = {xmult = 2}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            key = "blind_start",
            set = "Other"
        }
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            modify_blind_add(-5) -- real
            card_eval_status_text(card, "extra", nil, nil, nil, {message = "Blind Reduced by 5!"})
        end
        if hand_chips and mult and G.GAME.chips + (hand_chips * mult) >= math.floor(G.GAME.blind.chips / 2) and context.joker_main then
            return {
                x_mult = card.ability.extra.xmult,
                card = card
            }
        end
    end
}

SMODS.Joker {
    key = "don_quixote",
    rarity = "lcb_o",
    atlas = "lcb_jokers",
    pos = {x=3,y=0},
    config = {extra = {current_skill = 1, times_skill_used = 0, skill2_effect_active = false, sin={2,7,3}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "reuse",
            set = "Other"
        }
        info_queue[#info_queue + 1] = {
            key = "bleed",
            set = "Other"
        }
        return {vars = {
            (card.ability.extra.current_skill == 1 and "[Joust]" or card.ability.extra.current_skill == 2 and "[Galloping Tilt]") or "[For Justice!]"
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 1, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 6, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 2, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if lcb_config.don_is_funny then play_sound("lcb_limbus_company_yayy") end
            if card.ability.extra.current_skill == 1 then
                local mult = hand_chips * mult >= 0.3 * G.GAME.blind.chips and 50 or 25
                return {
                    mult = mult,
                    card = card
                }
            elseif card.ability.extra.current_skill == 2 then
                if card.ability.extra.skill2_effect_active then
                    modify_blind(0.8)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 20%" })
                    card.ability.extra.skill2_effect_active = false
                else
                    modify_blind(0.9)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 10%" })
                    card.ability.extra.skill2_effect_active = true
                end
            else
                for i=1,2 do
                    if pseudorandom("don_quixote") > 0.5 then
                        modify_blind(0.95)
                        card_eval_status_text(card, "extra", nil, nil, nil, {message = "Blind Reduced by 5%"})
                    end
                end
                modify_blind(0.9)
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 10%" })
            end
        end
    end
}

SMODS.Joker {
    key = "rodya",
    rarity = "lcb_o",
    atlas = "lcb_jokers",
    pos = {x=4,y=0},
    config = {extra = {current_skill = 1, times_skill_used = 0, percent_lowered = 0, sin={4,6,1}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "reuse",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "bleed",
            set = "Other"
        }
        return {vars = {
                (card.ability.extra.current_skill == 1 and "[Strike Down]" or card.ability.extra.current_skill == 2 and "[Axe Combo]") or "[Slay]"
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 3, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 5, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 0, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                modify_blind(0.9)
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 10%" })
                card.ability.extra.percent_lowered = card.ability.extra.percent_lowered + 10
            elseif card.ability.extra.current_skill == 2 then
                modify_blind(0.8)
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 20%" })
                card.ability.extra.percent_lowered = card.ability.extra.percent_lowered + 20
                if pseudorandom("rodya") > 0.5 then
                    return {
                        mult = 25,
                        card = card
                    }
                end
            else
                for i = 1, 3 do
                    if pseudorandom("rodya") > 0.5 then
                        modify_blind(0.95)
                        card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 5%" })
                        card.ability.extra.percent_lowered = card.ability.extra.percent_lowered + 5
                    end
                end
                if card.ability.extra.percent_lowered >= 30 then
                    return {
                        xmult = 1.7,
                        card = card
                    }
                end
            end
        end
        if context.setting_blind then card.ability.extra.percent_lowered = 0 end
    end
}

SMODS.Joker {
    key = "mersault",
    rarity = "lcb_o",
    atlas = "lcb_jokers",
    pos = {x=5,y=0},
    config = {extra = {current_skill = 1, times_skill_used = 1, sin={3,6,5}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            key = "tremor",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "tremor_burst",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "reuse",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Un, Deux]" or card.ability.extra.current_skill == 2 and "[Nailing Fist]") or
                "[Des Coups]",
                G.GAME.lcb_blind_effects.tremor
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 2, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 5, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 4, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 2
                if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Tremor" })
            elseif card.ability.extra.current_skill == 2 then
                if G.GAME.lcb_blind_effects.tremor ~= 0 then
                    local xmult = 1 + G.GAME.lcb_blind_effects.tremor / 2
                    G.GAME.lcb_blind_effects.tremor = 0
                    return {
                        xmult = xmult,
                        card = card,
                        message = "Tremor Burst!",
                        sound = "lcb_tremor_burst"
                    }
                else
                    return {
                        chips = 50,
                        message = localize { type = 'variable', key = 'a_chips', vars = { 50 } },
                        card = card
                    }
                end
            else
                for i = 1, 3 do
                    if pseudorandom("mersualt") > 0.5 then
                        G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 1
                        if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                        card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Tremor" })
                    end
                end
                G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 2
                if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Tremor" })
            end
        end
    end
}

SMODS.Joker {
    key = "ishmael",
    rarity = "lcb_o",
    pos = {x=0,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, tremor_burst_doubled = false, sin={1,4,5}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "tremor",
            set = "Other"
        }
        info_queue[#info_queue + 1] = {
            key = "tremor_burst",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "bleed",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Loggerhead]" or card.ability.extra.current_skill == 2 and "[Slide]") or
                "[Shield Bash]",
                G.GAME.lcb_blind_effects.tremor
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 0, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 3, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 4, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 1
                if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Tremor" })
            elseif card.ability.extra.current_skill == 2 then
                if hand_chips * mult >= 0.4 * G.GAME.blind.chips then card.ability.extra.tremor_burst_doubled = true end
                G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 3
                if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+3 Tremor" })
            else
                if G.GAME.lcb_blind_effects.tremor ~= 0 then
                    local xmult = 1 + G.GAME.lcb_blind_effects.tremor / 2
                    if card.ability.extra.tremor_burst_doubled then xmult = xmult * 2 end
                    G.GAME.lcb_blind_effects.tremor = 0
                    modify_blind(0.9)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 10%" })
                    return {
                        xmult = xmult,
                        card = card,
                        message = "Tremor Burst!",
                        sound = "lcb_tremor_burst"
                    }
                else
                    modify_blind(0.8)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "Blind Reduced by 20%" })
                end
            end
        end
    end
}

SMODS.Joker {
    key = "sinclair",
    rarity = "lcb_o",
    pos = {x=1,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, won_last = false, sin={6,1,7}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "rupture",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "reuse",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Downward Swing]" or card.ability.extra.current_skill == 2 and "[Halberd Combo]") or
                "[Ravaging Cut]",
                G.GAME.lcb_blind_effects.rupture[1],
                G.GAME.lcb_blind_effects.rupture[2]
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 5, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 0, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 6, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.individual and context.cardarea == G.play then
            local active = G.GAME.lcb_blind_effects.rupture[1] > 0 and G.GAME.lcb_blind_effects.rupture[2] > 0
            G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] - 1
            if active then return {
                    chips = G.GAME.lcb_blind_effects.rupture[1] * 10,
                    card = card,
                    message = "Rupture! +"..G.GAME.lcb_blind_effects.rupture[1] * 10,
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                G.GAME.lcb_blind_effects.rupture[1] = G.GAME.lcb_blind_effects.rupture[1] + 2
                G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 1
                if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Rupture Potency" })
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Count" })
            elseif card.ability.extra.current_skill == 2 then
                if card.ability.extra.won_last then
                    return {
                        mult = 50,
                        card = card
                    }
                else
                    return {
                        mult = 20,
                        card = card
                    }
                end
            else
                for i = 1, 3 do
                    if pseudorandom("sinclair") > 0.5 then
                        G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 1
                        if G.GAME.lcb_blind_effects.rupture[2] > 99 then G.GAME.lcb_blind_effects.rupture[2] = 99 end
                        card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Count" })
                    end
                end
                if card.ability.extra.won_last then
                    return {
                        mult = 30,
                        card = card
                    }
                else
                    return {
                        mult = 10,
                        card = card
                    }
                end
            end
        end
        if context.end_of_round and not context.game_over and context.main_eval then
            if G.GAME.current_round.hands_left <= 2 then card.ability.extra.won_last = true else card.ability.extra.won_last = false end
        end
    end
}

SMODS.Joker {
    key = "heathcliff",
    rarity = "lcb_o",
    pos = {x=2,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, sin = {7,1,2}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            key = "tremor",
            set = "Other"
        }
        info_queue[#info_queue+1] = {
            key = "tremor_burst",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Bat Bash]" or card.ability.extra.current_skill == 2 and "[Smackdown]") or
                "[Upheaval]",
                G.GAME.lcb_blind_effects.tremor
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 6, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 0, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 1, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 3
                if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+3 Tremor" })
            elseif card.ability.extra.current_skill == 2 then
                if pseudorandom("heathcliff") > 0.5 then
                    G.GAME.lcb_blind_effects.tremor = G.GAME.lcb_blind_effects.tremor + 2
                    if G.GAME.lcb_blind_effects.tremor > 99 then G.GAME.lcb_blind_effects.tremor = 99 end
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Tremor" })
                end
                return {
                    mult = 25,
                    card = card
                }
            else
                if G.GAME.lcb_blind_effects.tremor ~= 0 then
                    local xmult = 1 + G.GAME.lcb_blind_effects.tremor / 2
                    G.GAME.lcb_blind_effects.tremor = 0
                    if pseudorandom("heathcliff") > 0.5 then
                        return {
                            mult = 25,
                            xmult = xmult,
                            card = card,
                            message = "Tremor Burst!",
                            sound = "lcb_tremor_burst"
                        }
                    else
                        return {
                            xmult = xmult,
                            card = card,
                            message = "Tremor Burst!",
                            sound = "lcb_tremor_burst"
                        }
                    end
                end
            end
        end
    end
}

SMODS.Joker {
    key = "ryoshu", -- i am NOT typing ōū every time
    rarity = "lcb_o",
    pos = {x=3,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, skill2_effect_active = false, poise = {0,0}, sin={4,2,6}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "poise",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Paint]" or card.ability.extra.current_skill == 2 and "[Splatter]") or
                "[Brushstroke]",
                card.ability.extra.poise[1],
                card.ability.extra.poise[2]
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 3, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 1, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 5, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                card.ability.extra.poise[1] = card.ability.extra.poise[1] + 2
                card.ability.extra.poise[2] = card.ability.extra.poise[2] + 1
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Poise Potency" })
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Poise Count" })
            elseif card.ability.extra.current_skill == 2 and card.ability.extra.skill2_effect_active then
                card.ability.extra.poise[1] = card.ability.extra.poise[1] + 3
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+3 Poise Potency" })
            elseif card.ability.extra.poise[1] >= 5 then
                card.ability.extra.poise[2] = card.ability.extra.poise[2] <= 99 and card.ability.extra.poise[2] * 2 or 99
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "×2 Poise Count" })
            end
            if card.ability.extra.poise[2] > 0 then
                card.ability.extra.poise[2] = card.ability.extra.poise[2] - 1
                return {
                    xmult = 1 + card.ability.extra.poise[1] / 4,
                    card = card,
                    message = "Poise!"
                }
            else card.ability.extra.poise[1] = 0 end
        end
        if context.before and card.ability.extra.current_skill == 3 then
            card.ability.extra.poise[2] = card.ability.extra.poise[2] + 2
            card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Poise Count" })
        end
        if context.after then
            if hand_chips * mult <= G.GAME.blind.chips * 0.2 then card.ability.extra.skill2_effect_active = true else card.ability.extra.skill2_effect_active = false end
        end
    end
}

SMODS.Joker {
    key = "outis",
    rarity = "lcb_o",
    pos = {x=4,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, last_hand_more_than_half = false, sin = {4,6,5}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "rupture",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Pulled Blade]" or card.ability.extra.current_skill == 2 and "[Backslash]") or
                "[Piercing Thrust]",
                G.GAME.lcb_blind_effects.rupture[1],
                G.GAME.lcb_blind_effects.rupture[2]
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 3, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 5, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 4, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.individual and context.cardarea == G.play then
            local active = G.GAME.lcb_blind_effects.rupture[1] > 0 and G.GAME.lcb_blind_effects.rupture[2] > 0
            G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] - 1
            if active then
                return {
                    chips = G.GAME.lcb_blind_effects.rupture[1] * 10,
                    card = card,
                    message = "Rupture! +" .. G.GAME.lcb_blind_effects.rupture[1] * 10,
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                if pseudorandom("outis") > 0.5 then
                    G.GAME.lcb_blind_effects.rupture[1] = G.GAME.lcb_blind_effects.rupture[1] + 1
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Potency" })
                end
                G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 2
                if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Rupture Count" })
            elseif card.ability.extra.current_skill == 2 then
                if card.ability.extra.last_hand_more_than_half then
                    G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 2
                    if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                    if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Rupture Count" })
                end
                return {
                    mult = 50,
                    card = card
                }
            else
                if hand_chips and mult and G.GAME.chips + (hand_chips * mult) >= math.floor(G.GAME.blind.chips / 2) then
                    G.GAME.lcb_blind_effects.rupture[1] = G.GAME.lcb_blind_effects.rupture[1] + 1
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Potency" })
                end
                G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 1
                if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Count" })
            end
        end
        if context.after then
            if hand_chips * mult >= 0.5 * G.GAME.blind.chips then card.ability.extra.last_hand_more_than_half = true else card.ability.extra.last_hand_more_than_half = false end
        end
    end
}

SMODS.Joker {
    key = "gregor",
    rarity = "lcb_o",
    pos = {x=5,y=1},
    atlas = "lcb_jokers",
    config = {extra = {current_skill = 1, times_skill_used = 0, sin = {5,4,3}}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = "rupture",
            set = "Other"
        }
        return {
            vars = {
                (card.ability.extra.current_skill == 1 and "[Swipe]" or card.ability.extra.current_skill == 2 and "[Jag]") or
                "[Chop Up]",
                G.GAME.lcb_blind_effects.rupture[1],
                G.GAME.lcb_blind_effects.rupture[2]
            },
            main_end = {
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 4, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 3, y = 0 }) } },
                { n = G.UIT.O, config = { object = Sprite(34, 34, 0.75, 0.75, G.ASSET_ATLAS["lcb_sins"], { x = 2, y = 0 }) } },
            }
        }
    end,
    calculate = function(self, card, context)
        skill_switch(context, card)
        if context.individual and context.cardarea == G.play then
            local active = G.GAME.lcb_blind_effects.rupture[1] > 0 and G.GAME.lcb_blind_effects.rupture[2] > 0
            G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] - 1
            if active then
                return {
                    chips = G.GAME.lcb_blind_effects.rupture[1] * 10,
                    card = card,
                    message = "Rupture! +" .. G.GAME.lcb_blind_effects.rupture[1] * 10,
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.current_skill == 1 then
                if pseudorandom("gregor") > 0.5 then
                    G.GAME.lcb_blind_effects.rupture[1] = G.GAME.lcb_blind_effects.rupture[1] + 4
                    if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                    if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+4 Rupture" })
                end
            elseif card.ability.extra.current_skill == 2 then
                if pseudorandom("gregor") > 0.5 then
                    G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 1
                    if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                    if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Rupture Count" })
                else
                    G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] + 2
                    G.GAME.lcb_blind_effects.rupture[1] = G.GAME.lcb_blind_effects.rupture[1] + 2
                    if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                    if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Rupture Count" })
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+2 Rupture Potency" })
                end
            else
                if pseudorandom("gregor") > 0.75 then
                    G.GAME.lcb_blind_effects.rupture[2] = G.GAME.lcb_blind_effects.rupture[2] - 1
                    if G.GAME.lcb_blind_effects.rupture[2] ~= 1 then G.GAME.lcb_blind_effects.rupture[2] = 1 end
                    if G.GAME.lcb_blind_effects.rupture[1] > 99 then G.GAME.lcb_blind_effects.rupture[1] = 99 end
                    ease_discard(1)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+1 Discard", colour = G.C.RED })
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "-1 Rupture Count" })
                end
                if G.GAME.lcb_blind_effects.rupture[1] > 0 and G.GAME.lcb_blind_effects.rupture[2] > 0 then
                    return {
                        chips = 60,
                        card = card,
                        colour = G.C.CHIPS,
                        message = "+60 Chips"
                    }
                end
            end
        end
    end
}

--[[
SMODS.Joker {
    key = "effect_testing",
    rarity = "lcb_tier_v",
    atlas = "lcb_jokers",
    pos = {x=4,y=4},
    config = {extra = "Poise"},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            key = "blind_start",
            set = "Other"
        }
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.lcb_blind_effects[card.ability.extra:lower()][1] = 5
            G.GAME.lcb_blind_effects[card.ability.extra:lower()][2] = 5
            card_eval_status_text(card, "extra", nil, nil, nil, {message = "yoink"})
        end
    end
}

SMODS.Tag {
    key = "burn_indicator",
    atlas = "lcb_tags",
    pos = {x=0,y=0},
    config = {type = "after"},
    loc_vars = function(self, card, context)
        if G.GAME.lcb_blind_effects then return {
            vars = {
                G.GAME.lcb_blind_effects.burn[1],
                G.GAME.lcb_blind_effects.burn[2]
        }} else
            return { vars = { "N/A", "N/A" } }
        end
    end,
    in_pool = function(_, _) return false end,
    apply = function(self, tag, context)
        if context.type == tag.ability.type then
            modify_blind((100 - G.GAME.lcb_blind_effects.burn[1]) / 100)
            G.GAME.lcb_blind_effects.burn[2] = G.GAME.lcb_blind_effects.burn[2] - 1
            if G.GAME.lcb_blind_effects.burn[2] == 0 then G.GAME.lcb_blind_effects.burn[1] = 0 end
            tag:juice_up()
            return {}
        end
    end
}

SMODS.Tag {
    key = "bleed_indicator",
    atlas = "lcb_tags",
    pos = { x = 1, y = 0 },
    loc_vars = function(self, card, context)
        if G.GAME.lcb_blind_effects then return {
            vars = {
                G.GAME.lcb_blind_effects.bleed[1],
                G.GAME.lcb_blind_effects.bleed[2]
        }} else
            return { vars = { "N/A", "N/A" }}
        end
    end,
    in_pool = function(_, _) return false end,
    apply = function(self, tag, context)
        if context.type == "individual" and context.cardarea == G.play and G.GAME.lcb_blind_effects.bleed[1] ~= 0 and G.GAME.lcb_blind_effects.bleed[2] ~= 0 then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()
                    modify_blind((100 - G.GAME.lcb_blind_effects.bleed[1] / 4) / 100)
                    G.GAME.lcb_blind_effects.bleed[2] = G.GAME.lcb_blind_effects.bleed[2] - 1
                    if G.GAME.lcb_blind_effects.bleed[2] == 0 then G.GAME.lcb_blind_effects.bleed[1] = 0 end
                    tag:juice_up()
                end
            }))
            
        end
    end
}

SMODS.Tag {
    key = "poise_indicator",
    atlas = "lcb_tags",
    pos = { x = 0, y = 1 },
    loc_vars = function(self, card, context)
        if G.GAME.lcb_blind_effects then return {
            vars = {
                G.GAME.lcb_blind_effects.poise[1],
                G.GAME.lcb_blind_effects.poise[2]
        }} else
            return { vars = { "N/A", "N/A" } }
        end
    end,
    in_pool = function(_, _) return false end,
    apply = function(self, tag, context)
        if context.type == "joker_main" then 
            if psuedorandom("lcbpoise") > 1 / G.GAME.lcb_blind_effects.poise[1] then
                return {
                    xmult = G.GAME.lcb_blind_effects.poise[1] / 10 + 1,
                    effect = nil,
                    card = G.hand.cards[1] -- you cant put a tag here
                }
            else
                card_eval_status_text(G.hand.cards[1], "extra", nil, nil, nil, {message = "Nope!"})
            end
        end
    end
}
]]