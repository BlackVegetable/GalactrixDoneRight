-- Yellow wave (engine) beam




local function createBeam(beamObj,world,startx,starty,endx,endy)
	local function my_callback(beam)
		local dir = 1
		local midpoint = math.floor(beam:points_size() / 2)
		for i=2, beam:points_size() - 1 do
			local x,y,r,g,b,a,w = beam:get_point(i)
			local offset = offset + 1 * dir
			if i == midpoint then
				dir = dir * -1
			end
			beam:set_point(i, x + offset, y + offset, r, g, b, a, w)
		end		
	end

	local joints = 2
	local xdif = (endx - startx)/(joints-1)
	local ydif = (endy - starty)/(joints-1)
	local width = 6
	
	local beam = create_beam("Assets/Beams/engine.png", 0, 600, my_callback, 20)
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, width)
	
	for i=1, joints-2 do
		width = math.max(width-1, 1)
		beam:push_back_point(startx+xdif*i, starty+ydif*i, 0, 0, 0, 1, width)
	end

	beam:push_back_point(endx, endy, 0, 0, 0, 1, width)
	beam:end_update()
	
	AttachParticles(world, "YellowBeam", world:ScreenToWorld(startx,starty))	
	AttachParticles(world, "YellowBeam", world:ScreenToWorld(endx,endy))	
end


return {
	CreateBeam = createBeam;
}