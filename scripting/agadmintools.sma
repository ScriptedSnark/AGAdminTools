// AG Admin Tools plugin

#include <amxmodx>
#include <amxmisc>
#include <hl>

public plugin_init()
{
	register_plugin("AG Admin Tools", "0.1", "ScriptedSnark")
	// register_concmd("agadminmenu", "cmdToSpec", ADMIN_RCON, "- AG admin menu")
	register_concmd("ag_tospec", "cmdToSpec", ADMIN_BAN, "- Transfer to spectator (ag_tospec #USERID)")
	register_clcmd("ag_start", "cmdAGStart", ADMIN_RCON)
	register_clcmd("ag_pause", "cmdAGPause", ADMIN_RCON)
	register_concmd("ag_gamemode", "cmdAGGamemode", ADMIN_RCON, "- Change AG gamemode (ag_gamemode tdm)")
	register_concmd("ag_timelimit", "cmdAGtimelimit", ADMIN_RCON, "- Change match timelimit (ag_timelimit TIME)")
}

public cmdToSpec(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new arg[32]
	read_argv(1, arg, charsmax(arg))
	new player = cmd_target(id, arg, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF)
	
	if (!player)
		return PLUGIN_HANDLED;
	
	new name2[MAX_NAME_LENGTH], name[MAX_NAME_LENGTH]
	get_user_name(player, name2, charsmax(name2))
	get_user_name(id, name, charsmax(name))
	
	if (!hl_get_user_spectator(player))
	{
		engclient_cmd(player, "spectate");
		client_print(0, print_chat, "ADMIN %s^^0 transferred %s^^0 to spectator!", name, name2);
	}
	else
	{
		client_print(id, print_console, "%s is already spectator!", name2)
	}
	
	return PLUGIN_HANDLED;
}

public cmdAGStart(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new name[MAX_NAME_LENGTH]
	get_user_name(id, name, charsmax(name))
	server_cmd("agstart")
	client_print(0, print_chat, "ADMIN %s^^0 started the match!", name);
	
	return PLUGIN_CONTINUE;
}

public cmdAGPause(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	server_cmd("agpause")
	return PLUGIN_CONTINUE;
}

public cmdAGGamemode(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new gamemode[16]
	new name[MAX_NAME_LENGTH]
	read_argv(1, gamemode, charsmax(gamemode))
	get_user_name(id, name, charsmax(name))
	
	server_cmd("sv_ag_gamemode %s", gamemode)
	client_print(0, print_chat, "ADMIN %s^^0 changed gamemode to %s!", name, gamemode);
	
	return PLUGIN_CONTINUE;
}

public cmdAGtimelimit(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new timelimit[8]
	new name[MAX_NAME_LENGTH]
	read_argv(1, timelimit, charsmax(timelimit))
	get_user_name(id, name, charsmax(name))
	
	server_cmd("mp_timelimit %s", timelimit)
	client_print(0, print_chat, "ADMIN %s^^0 changed timelimit to %s!", name, timelimit);
	
	return PLUGIN_CONTINUE;
}