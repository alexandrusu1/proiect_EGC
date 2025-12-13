# Game Features

## Player Controls
- **W/A/S/D** - Movement
- **Mouse** - Look around
- **Shift** - Sprint (consumes stamina)
- **Space** - Jump (on ground) / Dash (in air or while sprinting)
- **ESC** - Pause menu

## Gameplay Mechanics

### Sprint System
- Hold Shift to sprint (speed increases from 5.0 to 8.0)
- Consumes 20 stamina per second
- Regenerates 15 stamina per second when not sprinting
- FOV increases from 75° to 85° during sprint

### Dash System
- Press Space while in air or while sprinting to dash
- Dash speed: 15.0
- Cooldown: 2 seconds
- Visual indicator shows when dash is available

### Camera Effects
- Subtle head bobbing when moving (amplitude: 0.05, frequency: 2.0)
- Smooth FOV transitions
- Responsive mouse look with clamped vertical rotation

### Enemy AI
Enemies have 4 states:
1. **PATROL** (Speed 1.5) - Wander randomly, change direction every 3-5 seconds
2. **ALERT** (Speed 2.5) - Detected player at 15m, start slow pursuit
3. **CHASE** (Speed 3.5) - Aggressive chase when player within 10m
4. **ATTACK** (Speed 4.0) - Attack when within 2m range

Features:
- Line of sight detection (can't see through walls)
- Visual indicator (glows red when player detected)
- Smart obstacle navigation

### Collectibles
- 5 golden spheres scattered throughout level
- Constantly rotate and bob up/down
- Collect for +100 score and +30 stamina
- Emit particles and glow

### Score System
- Start with 1000 points
- Lose 1 point per second
- +100 points for each collectible
- -200 points when caught by enemy
- Best score saved locally

### Health System
- 3 lives total
- Lose 1 life when caught by enemy
- Respawn at start position
- Game over at 0 lives

## UI Elements

### HUD (Always Visible)
- **Stamina Bar** (bottom-left) - Color changes: green → yellow → red
- **Health Hearts** (top-left) - Shows remaining lives
- **Score** (top-right) - Current score display
- **Timer** (top-center) - Time in MM:SS format
- **Crosshair** (center) - Aiming reticle
- **Danger Vignette** - Red overlay intensifies when enemy is close (<5m)
- **Dash Indicator** - Shows cooldown status

### Menus
- **Main Menu** - Start game, view best score, settings, quit
- **Pause Menu** (ESC) - Resume, restart, quit
- **Game Over** - Final score, time, stats, retry option

## Level Design
- Multiple enemies patrolling different areas
- Obstacles for cover and strategic gameplay
- Atmospheric lighting (3 point lights)
- Enhanced fog and visual effects
- Trees for environmental detail

## Technical Features
- Glow effects for atmosphere
- Volumetric fog
- Color grading (adjusted brightness, contrast, saturation)
- Smooth interpolations for all transitions
- Optimized AI with state machines
- Signal-based architecture
- Settings persistence (saved to user:// directory)
