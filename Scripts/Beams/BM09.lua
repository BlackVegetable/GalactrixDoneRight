-- Small Red Lightning (Weapon beam)




local function createBeam(beamObj,world,startx,starty,endx,endy)
	local function my_callback(beam)
		beam:begin_update()
			for i=2, beam:points_size()-1 do
				local x,y,r,g,b,a,w = beam:get_point(i)
				beam:set_point(i, x+math.random(-2, 2), y+math.random(-2, 2), r, g, b, a, w + math.random(-1, 1))
			end
		beam:end_update()
	end
	
	
	local joints = 6
	local xdif = math.floor((endx - startx)/(joints+1))
	local ydif = math.floor((endy - starty)/(joints+1))

	local randx = math.abs(math.floor(xdif /3))
	local randy = math.abs(math.floor(ydif /3))
	local width = 7
	
	local beam = create_beam("Assets/Beams/weapon.png", 0, 600, my_callback, 20)
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, width)
	
		for i=1, joints do
			width = width - 1
			if width < 1 then
				width = 2
			end
			beam:push_back_point(startx+xdif*i+math.random(-randx,randx), starty+ydif*i+math.random(-randy,randy), 0, 0, 0, 1, width)
		end

		beam:push_back_point(endx, endy, 0, 0, 0, 1, width)
	beam:end_update()

	--AttachParticles(world, "GreenBeam", world:ScreenToWorld(startx,starty))	
	--AttachParticles(world, "GreenBeam", world:ScreenToWorld(endx,endy))	
end


return {
	CreateBeam = createBeam;
}