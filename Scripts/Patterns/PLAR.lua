
-- PLAR
--  Pattern Left Arrow
--




return{
obj = "Pttn";
extra_turn = 1;
name = "[ARROW]";
bonus = 3;


-------------------------------------------------------------------------------
-- Arrow Pattern                              
--                                         
--                            0         2     
--                          X         0                      
--                        0         5     
--                          0         4           
--                            0         {3}        
--                                                
-------------------------------------------------------------------------------


pattern = {[2]=true,[4]={[3]=true},[5]=true};--left arrow

--pattern = {[2]=true,[5]=true};--3 of a kind -- used for testing

center = 27;

}
