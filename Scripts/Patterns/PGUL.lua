
-- PGUL
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
--                    0   X   0  {5}  0  {3}  
--                        0           4           
--                                              
--                                                
-------------------------------------------------------------------------------




pattern = {[2]={[3]=true},[4]=true,[6]={[5]=true}};

center = 28;
min_gems = 6;

board = {
			  [12]="GBLA", 
			  [13]="GBLA", 
			  [14]="GBLA",  
			  [19]="GBLA", 
			  [20]="GCPU", 
			  [21]="GCPU", 
			  [22]="GBLA",  
			  [26]="GBLA", 
			  [27]="GCPU", 
			  [28]="GBLA", 
			  [29]="GCPU", 
			  [30]="GBLA", 
			  [34]="GBLA",  
			  [35]="GCPU", 
			  [36]="GCPU", 
			  [37]="GBLA", 
			  [42]="GBLA", 
			  [43]="GBLA", 
			  [44]="GBLA" };

			  
}


