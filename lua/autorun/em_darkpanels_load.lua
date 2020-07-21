--[[---------------------------------------------------------------------------
Copyright (c) 2020 TheAsian EggrollMaker & MelonShooter. All rights reserved.
--]]---------------------------------------------------------------------------

-- Automatically load the necessary components of em_darkpanels. Parts not packaged in this addon will not be included.

local dark_panels_content_found = file.Find( "em_darkpanels/*.lua", "LUA" )

if SERVER then
	for _, v in pairs( dark_panels_content_found ) do
		AddCSLuaFile( v )
	end
end

if CLIENT then
	for _, v in pairs( dark_panels_content_found ) do
		include( v )
	end
end
