local roles = {}

-- properties to make your own roles:
-- weapon: string or false, use to give the player a weapon when the round starts, weapon must be valid
-- name: name on hud
-- desc: description on hud, table to say multiple things lol
-- color: color on hud
-- team: team depends on whether this is true or false
-- friendlyfire: false by default, if true, players wont die for killing their team mates
-- cankillmates: true by default, if false, players wont even be able to harm their mates
-- colorcode: escape code to color (ex. "\x85")

-- innocent
roles[MMROLE_INNOCENT] = {}
roles[MMROLE_INNOCENT].weapon = false
roles[MMROLE_INNOCENT].name = "Innocent"
roles[MMROLE_INNOCENT].desc = {"Find clues", "Don't trust nobody.", "Stay alive."}
roles[MMROLE_INNOCENT].color = V_GREENMAP
roles[MMROLE_INNOCENT].team = false
roles[MMROLE_INNOCENT].friendlyfire = true
roles[MMROLE_INNOCENT].cankillmates = false
roles[MMROLE_INNOCENT].colorcode = "\x83"

-- sheriff
roles[MMROLE_SHERIFF] = {}
roles[MMROLE_SHERIFF].weapon = "gun"
roles[MMROLE_SHERIFF].name = "Sheriff"
roles[MMROLE_SHERIFF].desc = {"Protect the innocents.", "Investigate murders.", "Find the murderer."}
roles[MMROLE_SHERIFF].color = V_BLUEMAP
roles[MMROLE_SHERIFF].team = false
roles[MMROLE_SHERIFF].friendlyfire = true
roles[MMROLE_SHERIFF].cankillmates = false
roles[MMROLE_SHERIFF].colorcode = "\x84"

-- murderer
roles[MMROLE_MURDERER] = {}
roles[MMROLE_MURDERER].weapon = "knife"
roles[MMROLE_MURDERER].name = "Murderer"
roles[MMROLE_MURDERER].desc = {"Shhhh... Kill in silence.", "Make sure there are no witnesses."}
roles[MMROLE_MURDERER].color = V_REDMAP
roles[MMROLE_MURDERER].team = true
roles[MMROLE_MURDERER].friendlyfire = false
roles[MMROLE_MURDERER].cankillmates = false
roles[MMROLE_MURDERER].colorcode = "\x85"

// TODO: make a metatable that defaults to the default variables if table index is nil

return roles