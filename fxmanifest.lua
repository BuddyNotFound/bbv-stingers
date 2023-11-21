fx_version 'cerulean'
game 'gta5'

description 'bbv-stingers'
version '1.0.0'

this_is_a_map 'yes'

client_scripts {
    'config.lua',
    'wrapper/cl_wrapper.lua',
    'client/cl_main.lua',
}

server_scripts {
    'wrapper/sv_wrapper.lua',
    'server/server.lua',
}

shared_scripts {
    'config.lua',
    'Lang.lua'
}


lua54 'yes'

