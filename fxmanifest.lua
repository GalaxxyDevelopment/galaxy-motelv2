fx_version 'cerulean'
game 'gta5'

author 'Galaxy'
description 'Galaxy-Motelv2'
version '1.0.1'

dependencies {
    'qb-core',
    'qb-target',
    'bob74_ipl'
}

shared_script 'config.lua'

client_script 'client/client.lua'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

lua54 'yes'
