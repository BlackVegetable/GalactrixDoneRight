This is a revision of the old BlackVegetable Comprehensive Balance Mod (CBM) for Galactrix.

This will include bug fixes, additional balance changes, typo fixes, and additional content.

I hope you enjoy,
BlackVegetable

Below is the game manual in a web-viewable format:

# Attribute (Levelup skills) Changes

## Pilot (Shields)

Shields now grant much more benefit per point of pilot skill. The AI is now much more resilient as it has been changed to prefer blue gems more than before. More importantly, shielding prevents nearly all status ailments from targeting your ship! Keeping your shields intact at even 1 point will prevent many nasty effects. Once a status ailment is on your ship, however, it will remain there even if you later restore shields. Piloting also contributes 3 points per point of piloting to *initiative*.

## Gunnery

Gunnery was easily the most powerful statistic in vanilla Galactrix. Now, gunnery grants up to +5 bonus damage when matching mines, with one point granted per 49 points of the skill. Note that the damage of mines bonus from your level has been reduced from 1 per 5 levels to 1 per 10 levels, effectively splitting the bonus evenly between the gunnery skill and your level (as the maximum player level is still 50.) Additionally, the bonus damage to mine matches are also applied to *laser*, *blaster*, and *ion* weapons.

## Science

Science skill now grants an in-combat bonus and a non-combat bonus. First, when your skill reaches 75 points of science, you will have your first level of *cooldown reduction* which will lower the turns you must wait for an item to be usable again by one turn, down to a minimum of a 1 turn wait.

The non-combat bonus givven is *hacking key reduction* through which the number of matches required for any hcking mini-game is reduced. You will begin to benefit from this with 25 points in the science skill.

## Engineer

The engineering skill also grants both an in-combat bonus and a non-combat bonus. For every 25 points in this skill, you will be able to repair your hull (automatically) by 1 point each turn. At 245 points of engineer you will have 10 points each turn (not at the expected 250 -- the last level requires fewer points to reach) This hull repair effect is limited by *battle fatigue* which is explained later.

This skill also makes you better at the mining mini-game, giving you bonuses to resource collection per match. This bonus becomes available when you have 40 engineering points. Each additional 50 points from there grants the next level of bonus.

Engineering also contributes 2 points per point of engineering to *initiative*.

### Battle Fatigue

When a battle has drawn on for a long period of time, both you and your opponent's crew are unable to perform optimally. Specifically, the ability of crews to repair either ship is diminished. This feature comes in three stages:

- Battle Weariness: Repairs reduced to 75%. Starts after 25 turns each.
- Battle Fatigue: Repairs reduced to 50%. Starts after 50 turns each.
- Battle Exhaustion: Repairs set to 0%. Starts after 87 turns each.

### Intermediate Points

Whenever you have skill points in engineering, gunnery, or science that don't quite add up to a new level of benefits, your points are not wasted. Rather, they add to the probability that you will be getting benefits from the next level of benefits instead of the previous one. This probability is proportional to how close you are to the next level of benefits.

### Initiative

If you and your opponent are both using ships with equal speed, determining which ship gets the first turn falls to the players' initiatives. Initiative is defined as `Initiative = 3 * Pilot + 2 * Engineering`. If initiative happens to also be matched, there are many other rules that dictate this secondary tiebreaker but the situation is rare enough to not be worth detailing.

# Hacking Rewards

When you have successfully hacked a leapgate, you have freed travel for millions of individuals inhabiting the system. It is only natural the citizens would show their appreciation for the (temporary) opening of their gate with a sum of credits. However, criminals are not rewarded, and even being under suspicion of unwarrented acts will lead to a reduction of your payment.

| Gate Difficulty | Criminal | Suspect | Neutral | Friendly | Allied |
| :-------------: | :------: | :-----: | :-----: | :------: | :----: |
| Easy | 0 | 75 | 150 | 225 | 300 |
| Medium | 0 | 125 | 250 | 375 | 500 |
| Hard | 0 | 175 | 350 | 525 | 700 |

If a gate closes again, you are eligible to open it again and gain another reward.

# Time Warp Mechanics

The way that time warps (stuns) interact with status effects has been tweaked. The following are the rules that are followed with an effort to make them as strategically intuitive as possible (even if the rules themselves appear complex when spelled out.)

- Draining Effects are frozen in place.
- Effects that can grant you some benefit or harm even while stunned will not be frozen with you.
- Evasive Action is a special case and will not be frozen, nor will it aid you (it is hard-countered by stuns.)
- Everything else is frozen in place.
- No items "cool down" while either player is stunned.

Once a player is released from a time warp, all status effects that were froen will resume their effects and countdown on their remaining duration.

# Combat Experience

Winning a battle now rewards you with not only the intel (white gems) you gather in battle, but also grant a set amount of intel based on the level of the opponent you just bested.

| Level Range | Bonus Intel |
| :---: | :---: |
| 1 to 10 | +8 |
| 11 to 20 | +16 |
| 21 to 30 | +24 |
| 31 to 40 | +32 |
| 41 to 49 | +40 |
| 50 | +45 |

# Rumor Experience

Rumors now give considerably less experience. However, completing a set number of rumors is now required to unlock certain special quests.

| Moves Required | Intel Given |
| :---: | :---: |
| 5 Moves | 15 |
| 10 Moves | 30 |
| 15 Moves | 60 |
| 20 Moves | 100 |
| 25 Moves | 180 |

## Rumor Levels

A higher *rumor level* will unlock more quests than a lower one.

| Rumor Level | Rumors Required |
| :---: | :---: |
| Level 1 | 4 |
| Level 2 | 8 |
| Level 3 | 12 |
| Level 4 | 15 |
| Level 5 | 20 |

# Item Changes

## Balance Tweaks

A number of existing in-game items that were overly powerful have been tweaked to be less powerful. These tweaks are both numerous and minor and will not be enumerated. However, many items have been added to the game to make the game strategy more interesting and to counter some existing items. Additionally, many items interact with smaller ships (ships with fewer item slots) differently than with larger ships. This will be discussed elsewhere.

## New Weapons

### Ion Weapons

Ion weapons are similar to your basic laser weapons but have an important difference. While they can deal normal damage against shields, their damage is halved against ship hulls. If they deal any damage to a ship's hull, it will can temporarily add turns to the cooldowns of various items on the impacted ship. Every 4 points of ion damage to hull will ensure a 2 turn delay hits a random item. (As mentioned eariler, ion weapons gain the bonus damage from the gunnery skill.)

### Precision Rockets

These rockets deal damage to enemy ships and reduce the energy of a random subsystem (Weapons/Engines/CPU) at the same time. Three rockets are fired per use but the probability of a rocket hitting the opponent is far higher when fired from a smaller ship than a larger one.

| Ship Size (in slots) | Probability of 3 hits | Probability of 2 hits | Probability of 1 hit |
| :---: | :---: | :---: | :---: |
| 3 Slots | 80% | 15% | 5% |
| 4 Slots | 50% | 35% | 15% |
| 5 Slots | 10% | 70% | 20% |
| 6+ Slots | 1% | 4% | 95% |

### Manual Control Chip

Allows captains to temporarily trade some of their science skill for additional pilot skill. The amount of pilot skill gained is better for smaller ships. The amount of science lost is smaller for smaller ships. Overall, this makes the most sense to use when you are either in a tiny ship or when you have little to no science skill anyway.

| Ship Size (in slots) | Pilot Skill Gain | Science Skill Loss |
| :---: | :---: | :---: |
| 3 Slots | +80% | -30% |
| 4 Slots | +65% | -40% |
| 5+ Slots | +50% | -50% |

### Optimal Position CPU

Allows you to enter the blindspot of opponents, effectively giving a "backstab"-like damage bonus to all of your attacks. Smaller ships gain a far larger damage bonus than larger ships. Your science skill helps determine how long this effect lasts (up to 1 extra turn.) One large advantage of this item is that it does not end your turn to activate, allowing you to wait until the board is full of mines to use it.

| Ship Size (in slots) | Damage Bonus per hit |
| :---: | :---: |
| 3 Slots | +9 |
| 4 Slots | +5 |
| 5 Slots | +3 |
| 6+ Slots | +2 |

The normal duration for this item is 3 turns. There is a chance of getting an extra turn from having a high science skill as follows:

| Science Skill | Probability of 1 Extra Turn Duration |
| :---: | :---: |
| 1 to 49 | 50% |
| 50 to 99 | 60% |
| 100 to 149 | 70% |
| 150 to 199 | 80% |
| 200+ | 90% |

### Advanced Position CPU

Grants a very similar bonus to the Optimal Position CPU. However, this item ends your turn when used. In return, it always lasts 5 turns (instead of 3 or 4) and grants a higher "backstab" bonus:

| Ship Size (in slots) | Damage Bonus per hit |
| :---: | :---: |
| 3 Slots | +12 |
| 4 Slots | +8 |
| 5 Slots | +6 |
| 6+ Slots | +5 |

### Critical Trajectory Processor

This item grants your ship a "critical hit" style bonus to your damage. That is, it activates some of the time, and grants +50% to any damage dealt when it does. It can only be used on ships of size 3, 4, or 5. One downside of this item is that, upon item use, all remaining CPU (Green) energy will be lost.

| Ship Size (in slots) | Percent Damage Bonus | Probability of Activation |
| :---: | :---: | :---: |
| 3 Slots | +50% | 50% |
| 4 Slots | +50% | 35% |
| 5 Slots | +50% | 20% |

### Mobility Core

This item allows you a chance to "dodge" 75% of damage while your ship is under its effect. The higher a captain's piloting skill, the longer it will last and the higher your chance to dodge. This effect is hard-countered by any time warp effect which will then disable the benefits of the mobility core's effect while you are frozen in time. Ships of size 6+ are unable to use this item.

The probability of dodging is your modified pilot skill divided by 210. The following charts will explain:

| Ship Size | Duration | Modified Pilot Skill |
| :---: | :---: | :---: |
| 3 Slots | 8 Turns | Pilot x 2 |
| 4 Slots | 7 Turns | Pilot x 1.5 |
| 5 Slots | 6 Turns | Pilot x 1 |

Examples:

| Modified Pilot Skill | Dodge Chance |
| :---: | :---: |
| 240 | 75% (maximum) |
| 210 | 75% (maximum) |
| 158 | 75% (maximum) |
| 110 | 52% |
| 70 | 33% |
| 35 | 17% |
| 21 | 10% (minimum) |
| 1 | 10% (minimum) |

(Thus, if a 3 slot ship is used by a captain with 79 piloting, it will reach the maximum dodge chance of 75% but the same level of piloting by someone in a 5 slot ship would only have a 38% chance to dodge.)

### Density Field

This is an environmental effect that increases the gain of engine energy (yellow) for smaller ships, and reduce the same energy gain for larger ships.

| Ship Size | Change to Yellow Energy Gained |
| :---: | :---: |
| 3 Slots | +200% Energy |
| 4 Slots | +100% Energy |
| 5 Slots | +1 Energy |
| 6 Slots | -1 Energy |
| 7 Slots | -50% Energy |
| 8 Slots | -67% Energy |

### Impervious Shielding

This item grants total invulnerability for a short time but can only be used once per battle. Also, once its effects expire, all shields are lost from the ship that used it. It cannot be used on ships with more than 5 slots. It lasts longer for smaller ships.

| Ship Size | Duration |
| :---: | :---: |
| 3 Slots | 6 Turns |
| 4 Slots | 4 Turns |
| 5 Slots | 2 Turns |

### Contingency Tool

This item applies a debuff to the opposing vessel (supposing their shields are down) for a time. If the opponent gets a Nova, they take 10 points of damage. If they get a supernova, they take an additional 20 points of damage.

### Reverse-Engineering Probe

This item turns a crew's auto-repair skill against itself. This debuff will cause the auto-repair to deal damage instead of hull repair each turn, but will be capped at 7 points of damage/turn, even if they would normally repair more than that. There is a 10% chance per turn of damage that the probe will be discovered by the affected crew and removed.

### Angst Machine

This item causes an environmental effect that causes the auto-repair of both ships to be set to 0 while it is active.

### Heat Ray

The heat ray lowers the enemy's gunnery skill to 10% of its maximum value. Each turn the gunnery skill will slowly recover, and it will be instantly restored by a degausser. If used repeatedly on the same target, it can lower the gunnery skill even lower than 10%.

### Paralyzation Emitter

This item lowers the opposing ship's crew's engineering skill by 35%. Additionally, every turn the opposing ship holds onto 7 or more yellow energy there is a 20% chance they will lose all of it via an "engine leak".

### PSI Augmenter

This is a passive item that increases your PSI points gained by matching purple gems.

### Hull Patches

These are passive items that grant maximum hull points in return for taking up a slot on a ship.

## PSI Items

An additional set of quest lines added by the CBM include rewards of PSI weapons/items. These will use your PSI points as a resource as well as your energy levels in combat. The permanent resource cost that will add up quickly for the more powerful PSI items.

### Psi Micro-Charge Cannon

Deals a modest amount of damage to both shields and hull. Because the hull is auto-repaired in the CBM, this skill shouldn't be used until the hull has already been damaged a bit as the hull damage will likely be wasted otherwise.

### Psionic Dual-Core

Regenerates 10% of total shields (or 3, whichever is higher) and 2 points of CPU (Green) energy per turn for several turns.

### Psi Mega-Charge Cannon

Similar to the micro-charge cannon but deals slightly more damage.

### Psi Giga-Charge Cannon

Similar to the micro-charge cannon but deals significantly more damage.

### Psi Entropy Field

Causes ships to take a small amount of damage to both hull and shields every time they match purple gems. Useful against the AI when no "good" matches are readily available as they will still match purple gems despite the danger.

### Psi Aggression Drone

Deals a small amount of damage to both enemy hull and shields over time. Cannot completely destroy enemy ships by itself.

### Psi Havoc Drone

Deals a tiny amount of damage to both enemy hull and shields over time and also reduces your enemy's skills by 20% for the duration. Also cannot completely destroy enemy ships by itself.

### Psi Sacrifice Cannon

Deals moderate shield and hull damage to the user but massive damage to the enemy and destroys all purple gems on the board.

### Psi Endurance Matrix

Increases all maximum energy levels by 8. May be used multiple times in a battle.

### Psi Shield Emancipator

Reduces enemy shield capacity (maximum shields) by 15% for the remainder of the battle.

# Small Ship Bonuses

Other than new-item-related bonuses, smaller ships gain a few other perks to make them attractive even in the late game:

- Small ships take a percentage less damage from blaster weapons.
- Small ships take a reduced amount of damage from the Vortraag Death Ray.
- Small ships gain bonus duration to armor buffing abilities.
- Small ships gain bonus duration to engine buffing abilities.
- Small ships gain a bonus from the "Flightpath Analyzer" vanilla item to both current and maximum shields.
- Small ships deal bonus damage with missiles.
- Small ships deal bonus damage with torpedoes.

These are summarized in the following table:

| Benefit Type | 3 Slot Ship | 4 Slot Ship | 5 Slot Ship |
| :---: | :---: | :---: | :---: |
| Blaster Defense | 30% reduction | 20% reduction | 10% reduction |
| Death Ray Defense | -8 damage | -5 damage | -2 damage |
| Armor Buff Duration | +2 Turns | +1 Turn | No bonus |
| Engine Buff Duration | +3 Turns | +2 Turns | +1 Turn |
| Flightpath Analyzer | +15 Max/+10 Current Shields | +10 Max/+5 Current Shields | No bonus |
| Missile Damage Bonus | +3 damage | +2 damage | +1 damage |
| Torpedoes Damage Bonus | +5 damage | +3 damage | +1 damage |

# Encounters and the 7th PSI Power

In vanilla Galactrix, the 7th and final PSI power removed all "encounters" from the game. This rendered the importance of faction standings, contraband smuggling, all six of the previous PSI powers, and overall immersion in the Galactrix world moot. Instead of this unsatsifying behavior, the 7th PSI power now simply lowers the probability of an encounter by 20%. Note that the base chance for encoutners in the CBM is already lower than in vanilla Galactrix. The chance of being stopped in an encounter is relative to how disliked you are. The maximum/minimums are given:

| Game | 7th PSI Power? | Minimum "Suspect" Chance | Maximum "Criminal" Chance | Contraband Chance |
| :---: | :---: | :---: | :---: | :---: |
| Vanilla | No | 9% | 90% | 30% (always) |
| Vanilla | Yes | 0% | 0% | 0% |
| CBM | No | 6% | 60% | at least 30% |
| CBM | Yes | 5% | 48% | at least 24% |

Note: In vanilla Galactrix, if you held onto contraband, you could actually be stopped **less** often in territories where you were hated. This has been fixed in the CBM.

# Reputation Quests

The CBM includes some repeatable quests designed to alter your reputation with factions. These currently come in two flavors: *harassment* and *smuggling*. Both types are repeatable for reuptation changes but only give a single point of intel. Altering your reputation may be required to unlock certain quests. Some quests will request you have a high reputation with one or more factions while others will actually require a low reputation with one or more factions.

## Harassment Quests

The system these quests are given in will dictate the faction with which you **gain** reuptation. The title, such as "Harassment: MRI" will tell you which faction you will **lose** reputation with. This is the title dictates which faction's ships you will be attacking. The reputation changes for these quests are +15 with the quest giver, +10 with the in-game enemy of the harassed faction, and -30 with the harassed faction.

## Smuggling Quests

The title of the smuggling quests will tell you who you will **lose** reputation with. Smuggling quests can potentially be completed without any combat. The first leg of a smuggling quest is to take 120 tons of gold to a given location. You will need to come up with the gold yourself. This will be exchanged for 60 contraband. The second leg of the quest is to safely transport the contraband to another given location. The reputation changes for these quests are -15 with the smuggling faction and +15 with pirates. Additionally you will be paid 4,500 credits.


