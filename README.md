# daring Widget

A circular display widget that uses a 0-100 input.

tested under:
awesome-4.8.2

A volume widget included uses amixer. The amixer function taken from blingbling under GPL

I will hopefully add more.

## Usage

    cd ~/.config/awesome
    git clone git://github.com/DocOcassi/daring.git

### In you rc.lua

    -- first
    local daring = require("daring")

    -- then add the volume widget
    davolume = daring_volume()
    
    -- in layout widget
    right_layout:add(davolume)


## Customizations

look at the code, and hack.

## License

Copyright 2014, DocOcassi

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

    Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

    0. You just DO WHAT THE FUCK YOU WANT TO.
