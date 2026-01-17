# CRP-MaskOff

A simple FiveM script for QB-Core servers that allows players to toggle their mask on and off using commands.

## Features

- `/maskoff` - Removes the currently worn mask and stores it
- `/maskon` - Puts the stored mask back on
- Persistent mask data until player respawns
- QB-Core notification integration
- Simple and lightweight

## Installation

1. Place the `crp-maskoff` folder in your server's `resources` directory
2. Add `ensure crp-maskoff` to your `server.cfg` file
3. Restart your server or refresh the resource

## Configuration

You can customize the commands and notification messages in `config.lua`:

```lua
Config.Commands = {
    maskoff = 'maskoff',  -- Change the command for removing mask
    maskon = 'maskon'     -- Change the command for putting mask on
}

Config.Notifications = {
    mask_removed = 'Mask removed',           -- Message when mask is removed
    mask_added = 'Mask put back on',         -- Message when mask is added
    no_mask = 'You are not wearing a mask'  -- Message when no mask is worn
}
```

## Requirements

- QB-Core Framework
- ESX-Legacy (with minor modifications to client.lua if needed)

## Notes

- The mask data is stored until the player respawns
- Only works with masks (drawable variation 1)
- Uses QB-Core's built-in notification system

## Support

For support or issues, please contact the development team.
