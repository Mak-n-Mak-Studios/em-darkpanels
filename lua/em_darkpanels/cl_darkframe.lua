--[[---------------------------------------------------------------------------
Copyright (c) 2020 TheAsian EggrollMaker & MelonShooter. All rights reserved.
--]]---------------------------------------------------------------------------

--[[---------------------------------------------------------------------------

DEVELOPER API:

EggrollMelonAPI_DarkFrame - A panel based off of EditablePanel.

	- Functions:
		- PANEL:SetSizeUpdate( number w, number h ) - Sets the size of the panel. Use this instead of PANEL:SetSize. - Returns nothing.
		- PANEL:SetTitle( string title ) - Sets the title of the panel. - Returns nothing.

--]]---------------------------------------------------------------------------

local PANEL = { }

function PANEL:Init( )
	self:SetSize( ScrW( ) / 3, ScrH( ) / 1.5 )
	self:Center( )

	self.Paint = function( _, w, h )
		surface.SetDrawColor( Color( 50, 50, 50 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	self.Title = vgui.Create( "DLabel", self )
	self.Title:SetFont( "DermaDefault" )
	self.Title:SetTextColor( Color( 200, 200, 200 ) )
	self.Title:SetText( "Title" )
	self.Title:SetPos( 7, 0 )
	self.Title:CenterVertical( 0.0135 )

	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetTextColor( Color( 200, 200, 200 ) )
	self.CloseButton:SetText( "X" )
	self.CloseButton:SetSize( self:GetTall( ) / 35, self:GetTall( ) / 35 )
	self.CloseButton:SetPos( self:GetWide( ) - self.CloseButton:GetWide( ) - 2, 0 )

	self.CloseButton.Paint = function( _, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	self.CloseButton.DoClick = function( )
		self:Remove( )
	end

	self.Window = vgui.Create( "DScrollPanel", self )
	self.Window:Dock( BOTTOM )
	self.Window:SetSize( self:GetWide( ), self:GetTall( ) * 0.973 )

	self.Window.Paint = function( _, w, h )
		surface.SetDrawColor( Color( 20, 20, 20 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	local scrollbar = self.Window:GetVBar( )
	scrollbar:SetSize( ScrW( ) / 600, self.Window:GetTall( ) )
	scrollbar.btnUp:SetSize( 0, 0 )
	scrollbar.btnDown:SetSize( 0, 0 )
	scrollbar.btnUp:SetEnabled( false )
	scrollbar.btnDown:SetEnabled( false )

	scrollbar.Paint = function( ) end
	scrollbar.btnUp.Paint = function( ) end
	scrollbar.btnDown.Paint = function( ) end

	scrollbar.btnGrip.Paint = function( pnl, w, h )
		surface.SetDrawColor( Color( 60, 60, 60 ) )
		surface.DrawRect( 0, 0, w, h )
	end
end

function PANEL:SetSizeUpdate( w, h )
	self:SetSize( w, h )
	self:Center( )
	self.Title:SetPos( 7, 0 )
	self.Title:CenterVertical( 0.0135 )
	self.CloseButton:SetSize( self:GetTall( ) / 35, self:GetTall( ) / 35 )
	self.CloseButton:SetPos( self:GetWide( ) - self.CloseButton:GetWide( ) - 2, 0 )
	self.Window:SetSize( self:GetWide( ), self:GetTall( ) * 0.973 )
end

function PANEL:SetTitle( title )
	self.Title:SetText( title )
	self.Title:SizeToContents( )
	self.Title:SetPos( 7, 0 )
	self.Title:CenterVertical( 0.0135 )
end

vgui.Register( "EggrollMelonAPI_DarkFrame", PANEL, "EditablePanel" )
