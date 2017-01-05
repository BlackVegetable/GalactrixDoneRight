
-- PTR1
--  Pattern Left Arrow
--




return{
obj = "Pttn";
extra_turn = 0;
name = "";
bonus = 0;



-------------------------------------------------------------------------------
-- Triangle Pattern 1                             
--                                         
--                                           
--                      0   0       6   2                    
--                        X           0     
--                        0           4           
--                                              
--                                                
-------------------------------------------------------------------------------




pattern = {[2]=true,[4]=true,[6]=true};

center = 28;
min_gems = 4;

board = {
			  [20]="GBLA", 
			  [21]="GCPU", 
			  [27]="GCPU",  
			  [28]="GCPU",  
			  [29]="GBLA", 
			  [35]="GBLA", 
			  [36]="GCPU", };


}
