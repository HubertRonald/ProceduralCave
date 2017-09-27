----------------------------------------
--	FIX DIMENSION DEVICE
----------------------------------------
application:setOrientation(Application.LANDSCAPE_LEFT)  

--all change
_W = application:getContentWidth()
_H  = application:getContentHeight()		--reverse
print(_W,_H)
application:setLogicalDimensions(_W, _H)

Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()
_WD,_HD  = application:getDeviceWidth(), application:getDeviceHeight()		--reverse
_Diag, _DiagD = _W/_H, _WD/_HD

application:setBackgroundColor("0x3E8B7B")


--take some distance
local base=Bitmap.new(Texture.new("tile.png"))
local w=base:getWidth()


--create procedural cave
local cave=require "cave"
local world=cave.new({ mapheight=_HD/w, mapwidth=_WD/w})
world:verticalBoundaries()
world:horizontalBoundaries()


local tile
for a=1,world.conf.mapheight do
	for b=1,world.conf.mapwidth do
		if world.map[a][b]==1 then
			tile = Bitmap.new(Texture.new("tile.png"))
			tile:setAnchorPoint(0,0)
			tile:setPosition((a-1)*w,(b-1)*w)
			base:addChild(tile)
		end
	end
end

--add child to scene
base:setPosition(-Wdx,-Hdy)
stage:addChild(base)

