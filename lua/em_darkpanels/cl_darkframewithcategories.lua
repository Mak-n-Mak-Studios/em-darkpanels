--[[---------------------------------------------------------------------------
Copyright (c) 2020 TheAsian EggrollMaker & MelonShooter. All rights reserved.
--]]---------------------------------------------------------------------------

--[[---------------------------------------------------------------------------

DEVELOPER API:

EggrollMelonAPI_DarkFrameWithCategories - A panel based off of EggrollMelonAPI_DarkFrame.

	- Functions:
		- PANEL:SetSizeUpdate( number w, number h ) - Sets the size of the panel. Use this instead of PANEL:SetSize. - Returns nothing.
		- PANEL:SetTitle( string title ) - Sets the title of the panel. - Returns nothing.
		- PANEL:AddCategory( string name ) - Creates a category with the given name. - Returns the ID of the newly created category (number).
		- PANEL:RemoveCategory( number id ) - Removes a category of the given ID. - Returns nothing.
		- PANEL:RemoveCategoriesIfEmpty( ) - Removes all categories without content. - Returns nothing.
		- PANEL:AddContentToCategory( number id, (Panel, string, table) element, function init ) - Adds content to a category. Second argument can be a panel, the class name of a panel, or a panel table. Third argument is the function that gets run when the category is loaded and is optional. The init function has one argument, the created panel. - Returns nothing.
		- PANEL:GetCurrentCategoryID( ) - Gets the current category's ID. - Returns the current category's ID (number).
		- PANEL:GetCurrentCategoryName( ) - Gets the current category's name. - Returns the current category's name (string).
		- PANEL:GetCurrentCategoryButton( ) - Gets the current category's button. - Returns the current category's button (Panel).
		- PANEL:GetCategoryName( number id ) - Gets the category name of the given ID. - Returns the category name of the given ID (string).
		- PANEL:GetCategoryButton( number id ) - Gets the category button of the given ID. - Returns the category button of the given ID (Panel).
		- PANEL:GetCategories( ) - Gets a table of all categories. - Returns a table of tables (categories) formatted like { name, button } (table).
		- PANEL:SetCategory( number id ) - Sets the category to the given ID. - Returns nothing.
		- PANEL:SetCurrentCategoryRefresh( boolean refresh_current_category ) - Sets whether the current category will reload its contents after clicking on the current category. True by default. - Returns nothing.

--]]---------------------------------------------------------------------------

local PANEL = { }

function PANEL:Init( )
	self.CategoriesPanel = vgui.Create( "DScrollPanel", self.Window )
	self.CategoriesPanel:Dock( LEFT )
	self.CategoriesPanel:SetSize( 0.3 * self:GetWide( ), self.Window:GetTall( ) )

	self.CategoriesPanel.Paint = function( _, w, h )
		surface.SetDrawColor( Color( 40, 40, 40 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	local scrollbar = self.CategoriesPanel:GetVBar( )
	scrollbar:SetSize( ScrW( ) / 600, self.CategoriesPanel:GetTall( ) )
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

	self.ContentPanel = vgui.Create( "DPanel", self.Window )
	self.ContentPanel:Dock( LEFT )
	self.ContentPanel:SetSize( 0.7 * self:GetWide( ), self.Window:GetTall( ) )

	self.ContentPanel.Paint = function( _, w, h )
		surface.SetDrawColor( Color( 30, 30, 30 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	self.ContentDScrollPanel = vgui.Create( "DScrollPanel", self.ContentPanel )
	self.ContentDScrollPanel:Dock( FILL )
	self.ContentDScrollPanel:DockMargin( 0, 5, 0, 5 )
	self.ContentDScrollPanel:GetCanvas( ).DarkFrame = self

	scrollbar = self.ContentDScrollPanel:GetVBar( )
	scrollbar:SetSize( ScrW( ) / 600, self.CategoriesPanel:GetTall( ) )
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

	self.Contents = { }
	self.CategoriesPanel.CategoryBtns = { }
	self:SetCurrentCategoryRefresh( true )
end

function PANEL:SetSizeUpdate( w, h )
	self:SetSize( w, h )
	self:Center( )
	self.Title:SetPos( 7, 0 )
	self.Title:CenterVertical( 0.0135 )
	self.CloseButton:SetSize( self:GetTall( ) / 35, self:GetTall( ) / 35 )
	self.CloseButton:SetPos( self:GetWide( ) - self.CloseButton:GetWide( ) - 2, 0 )
	self.Window:SetSize( self:GetWide( ), self:GetTall( ) * 0.973 )
	self.CategoriesPanel:SetSize( 0.3 * self:GetWide( ), self.Window:GetTall( ) )
	self.ContentPanel:SetSize( 0.7 * self:GetWide( ), self.Window:GetTall( ) )
end

function PANEL:AddCategory( cat_name )
	local targetButtonColor = 80

	local i = table.insert( self.Contents, { } )
	table.insert( self.CategoriesPanel.CategoryBtns, { cat_name, self.CategoriesPanel:Add( "EggrollMelonAPI_DarkButton" ) } )
	self.CategoriesPanel.CategoryBtns[ i ][ 2 ]:SetText( cat_name )
	self.CategoriesPanel.CategoryBtns[ i ][ 2 ]:SetTall( self.CategoriesPanel.CategoryBtns[ i ][ 2 ]:GetTall( ) + ScrH( ) / 35 )
	self.CategoriesPanel.CategoryBtns[ i ][ 2 ]:Dock( TOP )

	self.CategoriesPanel.CategoryBtns[ i ][ 2 ].DoClick = function( )
		if not self.CurrentCategoryRefresh and self.CurrentCategory == i then return end
		self:SetCategory( i )
	end

	self.CategoriesPanel.CategoryBtns[ i ][ 2 ].Paint = function( btn, w, h )
		local btncolor = btn.BtnColor or Color(40, 40, 40)

		if btn.BtnColor and self.clicked ~= btn then
			surface.SetDrawColor( btn.BtnColor )
			surface.DrawRect( 0, 0, w, h )
		end

		if IsValid( btn.tooltip ) and btn:IsHovered( ) then
			btn.tooltip:Show( )
		elseif IsValid( btn.tooltip ) and not btn:IsHovered( ) and btn.tooltip:IsVisible( ) then
			btn.tooltip:Hide( )
		end

		if self.clicked == btn then
			if not btn.clicklerp then
				btn.clicklerp = 0
			elseif btn.clicklerp < 1 then
				btn.clicklerp = btn.clicklerp + 0.025
			end

			surface.SetDrawColor( Color( Lerp( btn.clicklerp, btncolor.r, targetButtonColor ),
										 Lerp( btn.clicklerp, btncolor.g, targetButtonColor ),
										 Lerp( btn.clicklerp, btncolor.b, targetButtonColor ) ) )
			surface.DrawRect( 0, 0, w, h )
			return
		elseif btn.clicklerp then
			btn.clicklerp = nil
		end

		if btn:IsHovered( ) then
			if not btn.hoverlerp then
				btn.hoverlerp = 0
			elseif btn.hoverlerp < 1 then
				btn.hoverlerp = btn.hoverlerp + 0.075
			end

			surface.SetDrawColor( btn.HoverColor or Color( 50, 50, 50 ) )
			surface.DrawRect( 0, 0, Lerp( btn.hoverlerp, 0, btn:GetWide( ) ), h )
		elseif btn.hoverlerp then
			btn.hoverlerp = btn.hoverlerp - 0.075

			surface.SetDrawColor( btn.HoverColor or Color( 50, 50, 50 ) )
			surface.DrawRect( 0, 0, Lerp( btn.hoverlerp, 0, btn:GetWide( ) ), h )

			if btn.hoverlerp <= 0 then
				btn.hoverlerp = nil
			end
		end
	end

	return i
end

function PANEL:RemoveCategory( i )
	self.Contents[ i ] = nil
	self.CategoriesPanel.CategoryBtns[ i ][ 2 ]:Remove( )
	self.CategoriesPanel.CategoryBtns[ i ] = nil

	if self.CurrentCategory == i then
		self.ContentDScrollPanel:Clear( )
		self.CurrentCategory = nil
	end
end

function PANEL:RemoveCategoriesIfEmpty( )
	for k, v in pairs( self.Contents ) do
		if #v ~= 0 then continue end
		self.Contents[ k ] = nil
		self.CategoriesPanel.CategoryBtns[ k ][ 2 ]:Remove( )
		self.CategoriesPanel.CategoryBtns[ k ] = nil

		if self.CurrentCategory == k then
			self.ContentDScrollPanel:Clear( )
			self.CurrentCategory = nil
		end
	end
end

function PANEL:AddContentToCategory( i, element, init )
	table.insert( self.Contents[ i ], { [ "element" ] = element, [ "init" ] = init } )
end

function PANEL:GetCurrentCategoryID( )
	return self.CurrentCategory
end

function PANEL:GetCurrentCategoryName( )
	return self.CategoriesPanel.CategoryBtns[ self.CurrentCategory ][ 1 ]
end

function PANEL:GetCurrentCategoryButton( )
	return self.CategoriesPanel.CategoryBtns[ self.CurrentCategory ][ 2 ]
end

function PANEL:GetCategoryName( i )
	return self.CategoriesPanel.CategoryBtns[ i ][ 1 ]
end

function PANEL:GetCategoryButton( i )
	return self.CategoriesPanel.CategoryBtns[ i ][ 2 ]
end

function PANEL:GetCategories( )
	return self.CategoriesPanel.CategoryBtns
end

function PANEL:GetCategoryContents( i )
	return self.Contents[ i ]
end

function PANEL:SetCategory( i )
	if not self.Contents[ i ] then
		return
	end

	self.clicked = self.CategoriesPanel.CategoryBtns[ i ][ 2 ]
	self.ContentDScrollPanel:Clear( )

	for _, v in pairs( self.Contents[ i ] ) do
		local element = self.ContentDScrollPanel:Add( v.element )
		element:Dock( TOP )
		element:DockMargin( 0, ScrH( ) / 270, 0, ScrH( ) / 270 )

		if v.init then
			v.init( element )
		end
	end

	self.CurrentCategory = i
end

function PANEL:SetCurrentCategoryRefresh( refresh_current_category )
	self.CurrentCategoryRefresh = refresh_current_category
end

vgui.Register( "EggrollMelonAPI_DarkFrameWithCategories", PANEL, "EggrollMelonAPI_DarkFrame" )
