
--[[
	this script was adapted from
	Rhiannon Michelmore
	https://github.com/RhiannonMichelmore
]]

--helper
local rand = math.random

--[[
	------------------------------------------
	function that counts the number of alive
	neighbours around a cell,
	takes the x and y coordinates of that cell
	------------------------------------------
]]
local countNeighbours = function (x,y,map)
	--initialises the number of alive neighbours
	local count,x,y,map = 0,x,y,map
	local n_X,n_Y
	--iterates through every cell around our target
	for i=-1,1 do
		for j=-1,1 do
			--the current neighbour cell's x coordinate
			n_X = x+i
			--the current neighbour cell's y coordinate
			n_Y = y+j
			--if i and j are 0, then we are on our original cell
			if i==0 and j==0 then
			--so do nothing here
			--this next line makes sure we aren't going to check an
			--invalid index of our map table to stop errors, and instead,
			--if it's out of bounds, we just count it as alive
			elseif n_X<1 or n_Y<1 or n_X>#map[1] or n_Y>#map then
			count = count + 1
			--if its a wall, then its alive so add to our count
			elseif map[n_Y][n_X]==1 then
			count = count + 1
			end
		end
	end
	--finally, return the number of alive neighbours for our given cell
	return count
end


local cave = Core.class(Sprite)

function cave:init(param)
	
	self.conf={
		--allows you to change size of map
		mapheight=45,
		mapwidth=100,
		
		--this is the percentage chance of a cell being "alive" at first,
		--can be tweaked but I find this to be ideal
		chance = 35,
		
		birth = 4,		--the birth limit
		death = 3		--the death limit
	}
	
	if param then
		for k, v in pairs(param) do self.conf[k]=v end
	end
	--creates "self.map" (eventually will be the equivalent of 2D array)
	self.map = {}

	--runs function to populate map so it is your desired size and sets up alive/dead cells
	self:initialise(self.conf.mapwidth, self.conf.mapheight)
	
	--repeats the simulation step 4 times
	--(what I find optimal, can be changed to more or less)
	for s=1,5 do self:simstep() end
	
	-----------------------------------------------------------------------------
	--make the left most and right most columns into walls 
	--(so player can't leave map, could make bottom and top walls too if wanted)
	--self:verticalBoundaries()
	--self:horizontalBoundaries()
	-----------------------------------------------------------------------------
	
end

--[[
	----------------------------------------------
	The function that creates the starting map,
	takes x as map width, y as map height
	----------------------------------------------
]]
function cave:initialise(x,y)
	
	--[[
		----------------------------------------------
		until you get to your desired size,
		this adds a row, then the second
		for loop adds the correct amount of
		columns to your row, then onto the
		next row until map height is reached
		----------------------------------------------
	]]
	for a=1,y do
		self.map[#self.map+1]={}									-- is faster: http://lua-users.org/wiki/OptimisationCodingTips
		for b=1,x do
		  --cell is a 1 (1=wall or "alive") self.conf.chance/100 times
		  self.map[a][#self.map[a]+1]=rand(100)<self.conf.chance and 1 or 0	-- is faster: http://lua-users.org/wiki/OptimisationCodingTips
		end
	end

end


--	left and right walls
function cave:verticalBoundaries()
	for t=1,#self.map do
		self.map[t][1] = 1
		self.map[t][#self.map[1]] = 1
	end
end

--	bottom and top walls
function cave:horizontalBoundaries()
	for t=1,#self.map[1] do
		self.map[1][t] = 1
		self.map[#self.map][t] = 1
	end
end

--the simulation step that actually implements the cellular automata part
--(0 = PASSAGE, 1 = WALL)
function cave:simstep()
	
	local newval
	--iterates through every cell in the map
	for a=1,#self.map do
		for b=1,#self.map[a] do
			--gets the current amount of cells around it (including diagonals)
			newval = countNeighbours(b,a,self.map)
			--if its a wall ("alive") then we need to see if it is lonely, and will "die"
			if self.map[a][b]==1 then
				--it "dies" if there are less than the death limit of "alive" cells around it
				self.map[a][b] = newval < self.conf.death and 0 or 1
			else
				--if its a "dead" square, it can be "born" if it has enough "alive" squares around it, ie if the neighbours are higher than the birth limit
				self.map[a][b] = newval > self.conf.birth and 1 or 0
			end
		end
	end
end


return cave