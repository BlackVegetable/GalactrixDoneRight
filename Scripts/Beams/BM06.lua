-- Small Blue Lightning beam




local function createBeam(beamObj,world, startx,starty,endx,endy)
	local function my_callback(beam)
		beam:begin_update()
			for i=2,beam:points_size()-1 do
				local x,y,r,g,b,a,width = beam:get_point(i)
				beam:set_point(i, x+math.random(-1,1), y+math.random(-1,1), r,g,b,a, width + math.random(-1,1))
			end
		beam:end_update()
	end
	local joints = 12
	local xdif = math.floor((endx - startx)/(joints+1))
	local ydif = math.floor((endy - starty)/(joints+1))

	local randx = math.abs(math.floor(xdif /4))
	local randy = math.abs(math.floor(ydif /4))
	local width = 6
	
	local beam = create_beam("Assets/Beams/damage1.png", 0, 800, my_callback, 10)
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, width)
		
		for i=1, joints do
			width = math.max(width - 1, 1)
			beam:push_back_point(startx+xdif*i+math.random(-randx, randx), starty+ydif*i+math.random(-randy, randy), 0, 0, 0, 1, width - 1)
		end
	
		beam:push_back_point(endx, endy, 0, 0, 0, 1, width)
	beam:end_update()
end


return {
	CreateBeam = createBeam;
}