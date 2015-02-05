-- LASER(Damage) Beam



local function createBeam(beamObj,world,startx,starty,endx,endy)
	local function my_callback(beam)
		beam:begin_update()	
			for i=1, 2 do
				local x,y,r,g,b,a,w = beam:get_point(i)
				beam:set_point(i, x, y + math.random(-1,1), r, g, b, a, w + math.random(-1, 1))
			end
		beam:end_update()
	end
	
	AttachParticles(world, "RedBeam", world:ScreenToWorld(startx,starty))	
	AttachParticles(world, "RedBeam", world:ScreenToWorld(endx,endy))
	
	LOG("Creating laser beam")
	
	local beam = create_beam( "Assets/Beams/damage.png",
	             0,
					 800,
					 my_callback,
					 50)
	
	beam:begin_update()
		beam:push_back_point(startx,starty, 0, 0, 0, 1, 10)
		beam:push_back_point(endx, endy, 0, 0, 0, 1, 8)
	beam:end_update()

	BEAMS["BM06"]:CreateBeam(world,startx,starty,endx+math.random(-10,10),endy+math.random(-10,10))	
	BEAMS["BM06"]:CreateBeam(world,startx,starty,endx+math.random(-15,15),endy+math.random(-15,15))	
	BEAMS["BM06"]:CreateBeam(world,startx,starty,endx+math.random(-15,15),endy+math.random(-15,15))	
	
end


return {
	CreateBeam = createBeam;
}
