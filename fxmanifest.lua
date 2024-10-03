fx_version('bodacious')
author('Rkfrmda3 / LSC Development')
game({ 'gta5' })

lua54('yes')

client_script('client/main.lua')
server_script('server/edit_me.lua')

shared_scripts({
    '@ox_lib/init.lua',
    'config.lua'
});