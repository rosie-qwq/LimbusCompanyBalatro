return {
    descriptions = {
        Booster = {},
        Joker = {
            j_lcb_white_gossypium = {
                name = "White Gossypium",
                text = {
                    "{C:attention}[After reaching 50% of blind's required score]{} {C:red}Increase{} blind size by #1#%",
                    "Playing a hand {C:green}decreases{} blind size by #2#%",
                    "{C:inactive,s:0.7}If you have played Limbus you will know why this joker is so bad."
                }
            },
            j_lcb_ardent_flower = {
                name = "Ardent Flower",
                text = {
                    "{C:attention}[Effect only applies to N°1, N°2 deployed jokers]",
                    "Blind size is reduced by (rarity * ante)%",
                    "{C:inactive}(Max of 30%, only applies to vanilla rarities)",
                    "{C:inactive,s:0.7}Wow there's a lot of Burn gifts based on Ardor Blossom Moth"
                }
            },
            j_lcb_voodoo_doll = {
                name = "Voodoo Doll",
                text = {
                    "{C:attention}[Combat Start]{} Decrease blind size by 5 chips",
                    "{C:attention}[After reaching 50% of blind's required score]{} {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive,s:0.7}In Limbus, this deals 5 damage to all enemies. Not 5% of max hp, just 5."
                }
            },
            --[[
            j_lcb_effect_testing = {
                name = "Effect Testing (debug joker)",
                text = {
                    "{C:attention}[Combat Start]{} Gives 5 Potency and 5 Count of #1#"
                }
            },]]

            -- Listen I know it's bad practice to put numbers in joker descriptions without using loc_vars
            -- but if they never change, does it make any difference?
            j_lcb_don_quixote = {
                name = "LCB Sinner Don Quixote",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Joust]{C:mult} +25{} Mult, on scoring more than 30% of blind's required score, this Joker additionally gives {C:mult}+25{} Mult.",
                    " ",
                    "{C:attention}[Skill 2: Galloping Tilt]{} Inflict 2 {C:attention}[Bleed]{}",
                    "The next time this Skill is used, inflict 4 {C:attention}[Bleed]{} instead. {C:inactive}(Does not work if active skill is changed)",
                    " ",
                    "{C:attention}[Skill 3: For Justice!]{} This Skill has a 50% chance to inflict 1 {C:attention}[Bleed]{}. {C:attention}[Reuse Effect x2]",
                    "Finally, inflict 2 {C:attention}[Bleed]{}.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:inactive}Note: Hand score is calculated when this joker is triggered.",
                    " ",
                    "{C:inactive,s:0.7}Hath my time come? I am Don Quixote!" -- WOOOOOOOOOOOOO YEAHH BABY THATS WHAT WE'VE BEEN WAITING FOR THATS THE ONE WE WANT
                }
            },
            j_lcb_rodya = {
                name = "LCB Sinner Rodya",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Strike Down]{} Inflict 2 {C:attention}[Bleed]{}.",
                    " ",
                    "{C:attention}[Skill 2: Axe Combo]{} Inflict 4 {C:attention}[Bleed]{}. Has a 50% chance to give {C:mult}+20{} Mult.",
                    " ",
                    "{C:attention}[Skill 3: Slay]{} This skill has a 40% chance to inflict 1 {C:attention}[Bleed]{}. {C:attention}[Reuse Effect x3]",
                    "Finally, if {C:red}this Joker{} inflicted 6 or more {C:attention}[Bleed]{} this round, gives {X:mult,C:white}X1.7{} Mult.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    " ",
                    "{C:inactive,s:0.7}Hiya~ I'm Rodya. I have a longer name, but that makes things look cold, so just stick with Rodya~"
                }
            },
            j_lcb_mersault = {
                name = "LCB Sinner Mersualt",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Un, Deux]{} Inflicts +2 {C:attention}[Tremor]{} on Blind.",
                    " ",
                    "{C:attention}[Skill 2: Nailing Fist]{} Trigger {C:attention}[Tremor Burst]{}.",
                    "If {C:attention}[Tremor Burst]{} failed to trigger, gives {C:chips}+50{} Chips",
                    " ",
                    "{C:attention}[Skill 3: Des Coups]{} Inflict +1 {C:attention}[Tremor]{} on Blind at a 50% chance. {C:attention}[Reuse Effect x3]",
                    "Finally, inflict +2 {C:attention}[Tremor]{} on Blind.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Tremor]{} on Blind: {C:attention}#2#",
                    " ",
                    "{C:inactive,s:0.7}Meursault. Please refer to me as such, Manager."
                }
            },
            j_lcb_ishmael = {
                name = "LCB Sinner Ishmael",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Loggerhead]{} Inflicts +1 {C:attention}[Tremor]{} on Blind",
                    " ",
                    "{C:attention}[Skill 2: Slide]{} On scoring more than 40% of Blind's required score,",
                    "this Joker's {C:attention}[Tremor Burst]{} effect is doubled. Finally, inflict +3 {C:attention}[Tremor]{} on Blind.",
                    "{C:inactive}[Tremor Burst] doubling effect resets after using [Tremor Burst]",
                    " ",
                    "{C:attention}[Skill 3: Shield Bash]{} Trigger {C:attention}[Tremor Burst]{}. If {C:attention}[Tremor Burst]{} failed to trigger,",
                    "infict 4 {C:attention}[Bleed]{}. Otherwise, inflict 2 {C:attention}[Bleed]{}.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Tremor]{} on Blind: {C:attention}#2#",
                    "{C:inactive}Note: Hand score is calculated when this joker is triggered.",
                    " ",
                    "{C:inactive,s:0.7}Call me Ishmael, if you please."
                }
            },
            j_lcb_sinclair = {
                name = "LCB Sinner Sinclair",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Downward Swing]{} Inflict +2 {C:attention}[Rupture]{} Potency, +1 {C:attention}[Rupture]{} Count.",
                    " ",
                    "{C:attention}[Skill 2: Halberd Combo]{C:mult} +20{} Mult. If last blind was won with 2 or fewer hands left,",
                    "{C:mult}+50{} Mult instead.",
                    " ",
                    "{C:attention}[Skill 3: Ravaging Cut]{} Has a 50% chance to inflict 1 {C:attention}[Rupture]{} Count. {C:attention}[Reuse Effect x3]",
                    "Finally, if last blind was won with 2 or fewer hands left, {C:mult}+30{} Mult. Otherwise, {C:mult}+10{} Mult.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Rupture]{} on Blind: {C:attention}#2#{} Potency, {C:attention}#3#{} Count",
                    " ",
                    "{C:inactive,s:0.7}I’m Sinclair... Emil Sinclair. Oh, my number is, uhm... eleven." -- he is number ten though!!!!
                }
            },
            j_lcb_heathcliff = {
                name = "LCB Sinner Heathcliff",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Bat Bash]{} Inflict +3 {C:attention}[Tremor]{}.",
                    " ",
                    "{C:attention}[Skill 2: Smackdown]{} Has a 50% chance to inflict +2 {C:attention}[Tremor]{}. {C:mult}+25{} Mult.",
                    " ",
                    "{C:attention}[Skill 3: Upheaval]{} Has a 50% chance to give {C:mult}+25{} Mult. Finally, trigger {C:attention}[Tremor Burst]{}.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Tremor]{} on Blind: {C:attention}#2#",
                    " ",
                    "{C:inactive,s:0.7}Name's Heathcliff. Clobbering people is my specialty. 'Course, only when I fancy it."
                }
            },
            j_lcb_ryoshu = {
                name = "LCB Sinner Ryōshū",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Paint]{} Gain +2 {C:attention}[Poise]{} Potency, +1 {C:attention}[Poise]{} Count.",
                    " ",
                    "{C:attention}[Skill 2: Splatter]{} If last hand scored less than 20% of blind's requirement, gain +3 {C:attention}[Poise]{} Potency.",
                    " ",
                    "{C:attention}[Skill 3: Brushstroke]{} Before hand is played, gain +2 {C:attention}[Poise]{} Count.",
                    "If this Joker has at least 5 {C:attention}[Poise]{} Potency, then {C:attention}[Poise]{} Count is doubled.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Poise]{} on Joker: {C:attention}#2#{} Potency, {C:attention}#3#{} Count",
                    " ",
                    "{C:inactive,s:0.7}It's Ryōshū. Shūre's nice to meet ya. ...Pft."
                }
            },
            j_lcb_outis = {
                name = "LCB Sinner Outis",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Pulled Blade]{} Inflict +2 {C:attention}[Rupture]{} Count. Has a 50% chance to inflict +1 {C:attention}[Rupture]{} Potency.",
                    " ",
                    "{C:attention}[Skill 2: Backslash] {C:mult}+50{} Mult. If last hand scored more than 50% of blind's requirement, inflict +2 {C:attention}[Rupture]{} Count.",
                    " ",
                    "{C:attention}[Skill 3: Piercing Thrust]{} If 50% of blind's requirement has been reached, inflict +1 {C:attention}[Rupture]{} Potency.",
                    "Then, inflict +1 {C:attention}[Rupture]{} Count.",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Rupture]{} on Blind: {C:attention}#2#{} Potency, {C:attention}#3#{} Count",
                    " ",
                    "{C:inactive,s:0.7}My name is Outis. I hope you'll remember it well."
                }
            },
            j_lcb_gregor = {
                name = "LCB Sinner Gregor",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Swipe]{} This skill has a 50% chance to inflict +4 {C:attention}[Rupture]{}",
                    " ",
                    "{C:attention}[Skill 2: Jag]{} Inflict +1 {C:attention}[Rupture]{} Count.",
                    "This skill has a 50% chance to inflict +2 {C:attention}[Rupture]{} and +1 {C:attention}[Rupture]{} Count.",
                    " ",
                    "{C:attention}[Skill 3: Chop Up]{} If blind has {C:attention}[Rupture]{}, {C:chips}+60{} Chips.",
                    "This skill has a 25% chance to give {C:red}+1 discard{} and give -1 {C:attention}[Rupture]{} Count",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Rupture]{} on Blind: {C:attention}#2#{} Potency, {C:attention}#3#{} Count",
                    " ",
                    "{C:inactive,s:0.7}Mm… It’s Gregor. Well, feel free to talk to me unless I’m asleep."
                }
            },
            j_lcb_hong_lu = {
                name = "LCB Sinner Hong Lu",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:inactive}WIP"
                }
            },
            j_lcb_faust = {
                name = "LCB Sinner Faust",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:inactive}WIP"
                }
            },
            j_lcb_yi_sang = {
                name = "LCB Sinner Yi Sang",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:inactive}WIP"
                }
            },
            j_lcb_shi_ishmael = {
                name = "Shi Assoc. South Section 5 Ishmael",
                text = {
                    "{C:gold,E:1}Alternates skills after playing a hand, in the order 1-1-1-2-2-3",
                    " ",
                    "{C:attention}[Skill 1: Flying Sword]{} This joker gains +2 {C:attention}[Poise]{} Potency",
                    "If round score is less than 50% of blind's requirement, this joker additionally gains +3 {C:attention}[Poise]{} Potency",
                    " ",
                    "{C:attention}[Skill 2: Flashing Strike]{} This joker gains +2 {C:attention}[Poise]{} Count",
                    "If round score is less than 50% of blind's requirement, +2 {C:attention}[Poise]{} Count",
                    " ",
                    "{C:attention}[Skill 3: Catch Breath]{} This Skill has a 50% chance to give +2 {C:attention}[Poise]{} Count",
                    "If {C:attention}[Poise]{} Count is more than 5, ×2.5 {C:attention}[Poise]{} Potency {C:inactive}(Rounded down)",
                    "Finally, if round score is less than 25% of blind's requirement, +2 {C:attention}[Poise]{} Count",
                    " ",
                    "{s:1.1}Currently using {C:attention,s:1.1}#1#",
                    "{C:attention}[Poise]{} on Joker: {C:attention}#2#{} Potency, {C:attention}#3#{} Count",
                    " ",
                    "{C:inactive,s:0.7}With impeccable swiftness... I will render them silent."
                }
            }
        },
        Tag = {
            --[[
            tag_lcb_burn_indicator = {
                name = "Burn",
                text = {
                    "The Blind is inflicted with {C:red}#1#{} Potency, {C:red}#2#{} Count Burn",
                    "{C:inactive}Lowers blind size by (Potency)% and decreases Count by 1 after hand played",
                    "{C:inactive}If Count is 0 or Blind is defeated, remove all Burn"
                }
            },
            tag_lcb_bleed_indicator = {
                name = "Bleed",
                text = {
                    "The Blind is inflicted with {C:red}#1#{} Potency, {C:red}#2#{} Count Bleed",
                    "{C:inactive}For every card played, lower blind size by (Potency ÷ 4)% and decrease Count by 1",
                    "{C:inactive}If Count is 0 or Blind is defeated, remove all Bleed"
                }
            },
            tag_lcb_poise_indicator = {
                name = "Poise",
                text = {
                    "You have {C:blue}#1#{} Potency, {C:blue}#2#{} Count Poise",
                    "{C:inactive}During joker scoring, has a (Potency)% chance to give X(Potency ÷ 10 + 1) Mult and decrease Count by 1",
                    "{C:inactive}If Count is 0 or Ante is increased, remove all Poise"
                }
            },]]
        },
        lcb_ego = {
            c_lcb_la_sangre = {
                name = "La Sangre De Sancho",
                text = {
                    "{C:inactive}May only be used if any Don Quixote Identity is present",
                    "Consumes 2 {X:sin_lust,C:white}Lust{} and 2 {X:sin_pride,C:white}Pride{} E.G.O. Resources",
                    "When used, {C:attention}activates on next hand",
                    "{C:attention}[On Use]{} Inflict 14 {C:attention}[Bleed]{}",
                    "{C:gold,s:0.9}E.G.O. Grade: {X:ego_zayin,C:white}ZAYIN",
                    "{C:white,B:1,s:0.8}#1#"
                }
            },
            c_lcb_magic_bullet = {
                name = "Magic Bullet",
                text = {
                    "{C:inactive}May only be used if any Outis Identity is present",
                    "Consumes 2 {X:sin_wrath,C:white}Wrath{}, 2 {X:sin_lust,C:white}Lust{} and 4 {X:sin_pride,C:white}Pride{} E.G.O. Resources",
                    "When used, {C:attention}activates on next hand",
                    "{C:attention}[Before Use]{} Gain {C:attention}[Magic Bullet]{} equal to sum of hands and discards left",
                    "{C:inactive}(Within 1 and 7: if value is 8 or more, subtract 7 until it isn't)",
                    "{C:attention}[On Use] [Magic Bullet]{} value chooses which bullet to fire",
                    "{C:attention}[On Use]{} Inflict Blind with {C:attention}[Burn]{} and {C:attention}[Dark Flame]",
                    "equal to {C:attention}[Magic Bullet]{} value",
                    "{C:gold,s:0.9}E.G.O. Grade: {X:ego_he,C:white}HE",
                    "{C:white,B:1,s:0.8}#1#",
                    "{s:0.7,C:attention}[Magic Bullet]{s:0.7}: {s:0.7,C:white,X:sin_pride}#2#"
                }
            }
        },
        Other = {
            p_lcb_limbus_pack = {
                name = "Limbus Pack",
                text = {
                    "Choose {C:attention}#1#{} of",
                    "up to {C:attention}#2#{} Limbus Company Jokers"
                }
            },
            p_lcb_three_star_pack = {
                name = "OOO Assured Pack",
                text = {
                    "Choose {C:attention}#1#{} of",
                    "up to {C:attention}#2#{} OOO Jokers",
                    "{C:inactive}Note: this only contains Jimbo, due to lack of OOO jokers"
                }
            },
            blind_start = {
                name = "[Combat Start]",
                text = {
                    "When Blind is selected"
                }
            },
            effect_applies = {
                name = "[Effect only applies to N°1, N°2 deployed jokers]",
                text = {
                    "Triggers on the first and second jokers"
                }
            },
            tremor = {
                name = "[Tremor]",
                text = {
                    "When {C:attention}[Tremor Burst]{} is triggered,",
                    "give {C:white,X:mult}XMult{} equal to {C:attention}[Tremor]{} Potency ÷ 2.",
                    "Resets at end of round."
                }
            },
            tremor_burst = {
                name = "[Tremor Burst]",
                text = {
                    "Gives {C:white,X:mult}XMult{} equal to {C:attention}[Tremor]{} Potency ÷ 2.",
                    "Then, remove all {C:attention}[Tremor]{} on Blind."
                }
            },
            reuse = {
                name = "[Reuse Effect x?]",
                text = {
                    "This effect is triggered ? times."
                }
            },
            bleed = {
                name = "[Bleed]",
                text = {
                    "Decrease blind size by {C:attention}(5 × Potency){}%."
                }
            },
            rupture = {
                name = "[Rupture]",
                text = {
                    "Every played card gives {C:chips}(Potency × 10){} Chips.",
                    "Then, decreases Count by 1."
                }
            },
            poise = {
                name = "[Poise]",
                text = {
                    "Gives {X:mult,C:white}XMult{} equal to {C:attention}[Poise]{} Potency ÷ 4.",
                    "Then, decrease {C:attention}[Poise]{} Count by 1.",
                    "{C:inactive}Note: This effect is per-joker."
                }
            },
            magic_bullet_1 = {
                name = "[The First Magic Bullet]",
                text = {
                    "{C:mult}+20{} Mult",
                    "{X:mult,C:white}X1.5{} Mult"
                }
            },
            magic_bullet_2 = {
                name = "[The Second Magic Bullet]",
                text = {
                    "{C:mult}+50{} Mult",
                    "{C:attention}Disable current boss blind"
                }
            },
            magic_bullet_3 = {
                name = "[The Third Magic Bullet]",
                text = { 
                    "{C:mult}+50{} Mult",
                    "Inflict 5 {C:attention}[Burn]{}",
                    ""-- atk weight and attack power down
                }
            },
            magic_bullet_4 = {
                name = "[The Fourth Magic Bullet]",
                text = {
                    "{C:mult}+75{} Mult",
                    "",
                }
            },
            magic_bullet_5 = {
                name = "[The Fifth Magic Bullet]",
                text = { 
                    "WIP"
                }
            },
            magic_bullet_6 = {
                name = "[The Sixth Magic Bullet]",
                text = { 
                    "WIP"
                }
            },
            magic_bullet_7 = {
                name = "[The Seventh Magic Bullet]",
                text = {
                    "Gives {X:mult,C:white}X20{} Mult",
                    "Gives {X:mult,C:white}X0.1{} extra Mult for every",
                    "{C:chips}1,000 Chips{} scored in current blind",
                    "{C:inactive,s:0.8}(Max X50 Mult)",
                    "Gives {X:dark_edition,C:white}^0.25{} Mult for every",
                    "{X:sin_pride,C:white}Pride{C:attention} E.G.O. Resource",
                    "{C:inactive,s:0.8}(Max ^5 Mult)",
                    "{C:red,E:1,s:1.1}After hand is played:",
                    "{C:red,E:1}Consume all {C:attention,E:1}E.G.O. Resources{}",
                    "{C:red,E:1}and remove all {C:attention,E:1}Outis{C:red,E:1} identities"
                }
            },
            dark_flame = {
                name = "[Dark Flame]",
                text = {
                    "When {C:attention}[Burn]{} is triggered:",
                    "Decrease blind size by {C:attention}(Potency × Burn on Blind × 2)%{}",
                    "{C:inactive}(Max value of 7)"
                }
            },
            burn = {
                name = "[Burn]",
                text = {
                    "After scoring more than 50% of blind's required score:",
                    "Decrease blind size by {C:attention}(Potency × 10)%{}"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_lcb_tier_i = "Tier I",
            k_lcb_tier_ii = "Tier II",
            k_lcb_tier_iii = "Tier III",
            k_lcb_tier_iv = "Tier IV",
            k_lcb_tier_v = "Tier V",
            k_lcb_o = "0",
            k_lcb_oo = "00",
            k_lcb_ooo = "000",
            k_lcb_limbus_pack = "Limbus Pack",
            k_lcb_three_star_pack = "OOO Assured Pack",
            k_ego = "E.G.O."
        }
    }
}
