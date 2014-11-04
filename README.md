ScriptableStatusBar
===================

A tool for adding, setting, and removing status bar items (with menus!) from the command line.

## Usage

    sbar set <id> <string> [menu-item-title:bash-command] [...]
    sbar remove <id>
    
so
    
    sbar set face 😃 'Bye!:sbar remove face'
    
Creates a face in the status bar. The menu will have an option `Bye!` that runs `sbar remove face` getting rid of the menu it creates.
