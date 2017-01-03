This is a revision of the old BlackVegetable Comprehensive Balance Mod (CBM) for Galactrix.

This will include bug fixes, additional balance changes, typo fixes, and additional content.

I hope you enjoy,
BlackVegetable

Below is the game manual in a web-viewable format:

# Attribute (Levelup skills) Changes

## Pilot (Shields)

Shields now grant much more benefit per point of pilot skill. The AI is now much more resilient as it has been changed to prefer blue gems more than before. More importantly, shielding prevents nearly all status ailments from targeting your ship! Keeping your shields intact at even 1 point will prevent many nasty effects. Once a status ailment is on your ship, however, it will remain there even if you later restore shields. Piloting also contributes 3 points per point of piloting to *initiative*.

## Gunnery

Gunnery was easily the most powerful statistic in vanilla Galactrix. Now, gunnery grants up to +5 bonus damage when matching mines, with one point granted per 49 points of the skill. Note that the damage of mines bonus from your level has been reduced from 1 per 5 levels to 1 per 10 levels, effectively splitting the bonus evenly between the gunnery skill and your level (as the maximum player level is still 50.)

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

TO DO

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

# To be continued

The rest of this document will be written at a later date.
