-- Small Blue Lightning beam




local function createBeam(beamObj,world, startx,starty,endx,endy)
	local function my_little_callback(beam)
		beam:begin_update()
			LOG("BM03 callback")
		local max_num = beam:points_size() - 1
		for i=2,max_num do--skips start and end	
			local x, y, r, g, b, a, width = beam:get_point(i)
			beam:set_point(i, x + math.random(-2,2), y + math.random(-2,2), r, g, b, a, width)
		end
		
		beam:end_update()
		
	end
	if startx==endx and starty==endy then
		endx=startx+4
		endy=starty+4
	end
	local joints = 3
	local xdif = math.floor((endx - startx)/(joints+1))
	local ydif = math.floor((endy - starty)/(joints+1))

	local randx = math.abs(math.floor(xdif /3))
	local randy = math.abs(math.floor(ydif /3))
	local width = 4

	local beam = create_beam("Assets/Beams/shield.png", 0, 100, my_little_callback, 50)
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, width)
		for i = 1, joints do
			width = math.max(1, width - 1)
			--beam:push_back_point(startx+xdif*i+math.random(-randx,randx), starty+ydif*i+math.random(-randy,randy), 0, 0, 0, 1, width)
		end
		beam:push_back_point(endx, endy, 0, 0, 0, 1, width)
	beam:end_update()
	
	
	
	
end


return {
	CreateBeam = createBeam;
}