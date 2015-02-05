-- Weapon Lightning (Red beam)




local function createBeam(beamObj,world,startx,starty,endx,endy)
	local function my_callback(beam)
		beam:begin_update()
			for i=2, beam:points_size() - 1 do
				local x,y,r,g,b,a,w = beam:get_point(i)
				beam:set_point(i, x + math.random(-2, 2), y + math.random(-2, 2), r, g, b, a, w)
			end
		beam:end_update()
	end
	
	local joints = 6
	local xdif = math.floor((endx - startx)/(joints+1))
	local ydif = math.floor((endy - starty)/(joints+1))

	local randx = math.abs(math.floor(xdif /3))
	local randy = math.abs(math.floor(ydif /3))
	
	local width = 12
	
	local beam = create_beam("Assets/Beams/weapon.png", 0, 700, my_callback, 10)
	beam:begin_update()
		beam:push_back_point(startx, starty, 0, 0, 0, 1, width)
	
		for i=1, joints do
			width = math.max(width-1, 1)
			beam:push_back_point(startx+xdif*i+math.random(-randx,randx),  starty+ydif*i+math.random(-randy,randy), 0, 0, 0, 1, width)
		end
	
		beam:push_back_point(endx, endy, 0, 0, 0, 1, width)
	beam:end_update()
	
	AttachParticles(world, "RedBeam", world:ScreenToWorld(startx,starty))	
	AttachParticles(world, "RedBeam", world:ScreenToWorld(endx,endy))	
			
	BEAMS["BM09"]:CreateBeam(world,startx,starty,endx+math.random(-10,10),endy+math.random(-10,10))		
	
	
end


return {
	CreateBeam = createBeam;
}