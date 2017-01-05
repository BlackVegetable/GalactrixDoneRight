
-- PRAR
--  Pattern Right Arrow
--




return{
obj = "Pttn";
extra_turn = 1;
name = "[ARROW]";
bonus = 3;


-------------------------------------------------------------------------------
-- Arrow Pattern                              
--                                         
--                           0         6     
--                             X         0                      
--                               0         3     
--                             0         4           
--                           0        {5}        
--                                                
-------------------------------------------------------------------------------


pattern = {[3]=true,[4]={[5]=true},[6]=true};--right arrow

--pattern = {[2]=true,[5]=true}--3 of a kind -- used for testing

center = 27;

}