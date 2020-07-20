--[[---------------------------------------------------------------------------
Copyright (c) 2020 TheAsian EggrollMaker & MelonShooter. All rights reserved.
--]]---------------------------------------------------------------------------

--[[---------------------------------------------------------------------------

DEVELOPER API:

EggrollMelonAPI_DarkButton - A Panel based off of DButton.

--]]---------------------------------------------------------------------------

local PANEL = { }

function PANEL:Init( )
	self:SetFont( "CloseCaption_Normal" )
	self:SetTextColor( Color( 200, 200, 200 ) )
	self:SetText( "Button" )
	self:SizeToContents( )

	self.Paint = function( _, w, h )
		if self.BtnColor then
			surface.SetDrawColor( self.BtnColor )
			surface.DrawRect( 0, 0, w, h )
		end

		if self:IsHovered( ) then
			if not self.hoverlerp then
				self.hoverlerp = 0
			elseif self.hoverlerp < 1 then
				self.hoverlerp = self.hoverlerp + 0.075
			end

			surface.SetDrawColor( self.HoverColor or Color( 50, 50, 50 ) )
			surface.DrawRect( 0, 0, Lerp( self.hoverlerp, 0, self:GetWide( ) ), h )
		elseif self.hoverlerp then
			self.hoverlerp = self.hoverlerp - 0.075

			surface.SetDrawColor( self.HoverColor or Color( 50, 50, 50 ) )
			surface.DrawRect( 0, 0, Lerp( self.hoverlerp, 0, self:GetWide( ) ), h )

			if self.hoverlerp <= 0 then
				self.hoverlerp = nil
			end
		end

		if IsValid( self.tooltip ) and self:IsHovered( ) then
			self.tooltip:Show( )
		elseif IsValid( self.tooltip ) and not self:IsHovered( ) and self.tooltip:IsVisible( ) then
			self.tooltip:Hide( )
		end
	end

	self.UpdateColours = function( )
	end
end

vgui.Register( "EggrollMelonAPI_DarkButton", PANEL, "DButton" )
