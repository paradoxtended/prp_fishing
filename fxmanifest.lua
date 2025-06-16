fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
name 'prp_fishing'
author 'Paradoxtended'
version '2.0.0'
repository 'https://github.com/paradoxtended/prp_fishing'
description 'An advanced fishing script for FiveM'

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'ox_lib',
    'ox_inventory',
    'ox_target',
}

ui_page 'web/build/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@prp_lib/init.lua',
}

client_scripts { 'modules/bridge/**/client.lua', 'client.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'modules/bridge/**/server.lua', 'server.lua' }

files {
    'locales/*.json',
    'utils/*.lua',
    'data/*.lua',
    'web/build/index.html',
    'web/build/**/*',
    'modules/**/server.lua',
    'modules/**/client.lua'
}