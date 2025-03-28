# Game notes

## Scenes

- comics like

- use roman numerals
  - arabian faded in bg

1. intro scene
   - hero in front of blackboard
   - interactive 
     - player will have to solve problems
     - last problem needs zero
   - guy gives him map

2. minigame scenes

3. getting to zeroland scene
   - zeros with legs?
   - zero everywhere
     - flags
     - boards with zero
   - he gets his own zero

4. minigame scenes again
   - same minigame but harder, only one button

## HUD

- numeral boards
  - roman numerals but nine of them (like digits)


## Game architecture

- map systematically changing based on `quests_completed`

- hud to communicate with any minigame
  - use signals that will be OR funcions throught game manager

- game manager
  - list of string paths to scenes

- when minigame ends
  - send signal OR call function of game manager

## Minigames

0. solving math formulas
   - addition, multiplication,subtraction!!!

1. how many people to sacrifice

2. shooting balls with different weights
   - zero flys straight
   - heavy or negative weight objects have different arcs

3. creating password (need to change password of your ship)
   - no digit hud
   - text field
   - recommended password - zero but illegible
     - at least 3 digits

4. vladik's sracka somewhere
   - x * y + z = 21
   - x != y != z != x

5. math formulas again but with zero
    - addition, multiplication, subtraction, divison!!!