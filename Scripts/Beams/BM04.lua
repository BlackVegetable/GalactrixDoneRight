-- Green Lightning (CPU beam)




local function createBeam(beamObj,world,startx,starty,endx,endy)
	local function my_callback(beam)
		beam:begin_update()
			for i = 2, beam:points_size() do
				local x, y, r, g, b, a, width = beam:get_point(i)
				beam:set_point(i, x + math.random(-2, 2), y + math.random(-2, 2), r, g, b, a, width)
			end
		beam:end_update()
	end
	
	local beam = create_beam("Assets/Beams/cpu.png", 0, 700, my_callback, 0)
	
	local joints = 6
	local xdif = math.floor((endx - startx)/(joints+1))
	local ydif = math.floor((endy - starty)/(joints+1))
	local randx = math.abs(math.floor(xdif /3))
	local randy = math.abs(math.floor(ydif /3))
	
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, 12)
		for i=1, joints - 1 do
			beam:push_back_point(startx + xdif * i + math.random(-randx,randx), starty + ydif * i + math.random(-randy,randy), 0, 0, 0, 1, 12 - i*2)
		end
		beam:push_back_point(endx, endy, 0, 0, 0, 1, 2)
	beam:end_update()
	
	AttachParticles(world, "GreenBeam", world:ScreenToWorld(startx,starty))
	AttachParticles(world, "GreenBeam", world:ScreenToWorld(endx,endy))	
	
			
	BEAMS["BM07"]:CreateBeam(world, startx, starty, endx + math.random(-10,10), endy + math.random(-10,10))		
	
	
end


return {
	CreateBeam = createBeam;
}