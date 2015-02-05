-----------------------------------------
--
--  Star-Satellite Linkages
--
--  This file is autogenerated by <StarSystem Editor.exe>
--

use_safeglobals()

local StarTable = {
      ["S000"]={"T002","T003","T004","T005","T006","T007",},
      ["S001"]={"T008","T009","T010","T011","T323",},
      ["S002"]={"T012","T014","T015","T016",},
      ["S003"]={"T042","T043","T045","T044","T046","T013",},
      ["S004"]={"T038","T039","T040","T041",},
      ["S005"]={"T022","T023","T024","T025",},
      ["S006"]={"T017","T018","T019","T020","T021",},
      ["S007"]={"T033","T034","T035","T036","T037",},
      ["S008"]={"T026","T027","T028","T029","T030","T031","T032",},
      ["S009"]={"T057","T058","T059","T060",},
      ["S010"]={"T052","T053","T054","T055","T056",},
      ["S011"]={"T047","T048","T049","T050","T051","T324",},
      ["S012"]={"T061","T063","T062","T064","T065",},
      ["S013"]={"T066","T067","T068","T069",},
      ["S014"]={"T070","T071","T072","T073",},
      ["S015"]={"T074","T076","T077","T078","T075",},
      ["S016"]={"T131","T132","T133",},
      ["S017"]={"T134","T135","T136",},
      ["S018"]={"T126","T127",},
      ["S019"]={"T128","T129","T130","T107",},
      ["S020"]={"T121","T122","T123","T124","T125",},
      ["S021"]={"T079","T080","T082","T081",},
      ["S022"]={"T000","T001",},
      ["S023"]={"T106","T108",},
      ["S024"]={"T083","T084","T085","T086","T087","T088","T089",},
      ["S025"]={"T090","T091","T092","T093",},
      ["S026"]={"T094","T095","T096","T097",},
      ["S027"]={"T098","T099","T101",},
      ["S028"]={"T102","T103","T104","T105",},
      ["S029"]={"T109","T110","T111","T112","T113","T322",},
      ["S030"]={"T166","T167","T168","T169",},
      ["S031"]={"T170","T171","T172","T173",},
      ["S032"]={"T174","T175","T176","T177",},
      ["S033"]={"T216","T217","T218",},
      ["S034"]={"T178","T179","T180","T181","T182",},
      ["S035"]={"T183","T185","T186",},
      ["S036"]={"T187","T188","T189","T190","T191","T320",},
      ["S037"]={"T196","T197","T198","T199",},
      ["S038"]={"T192","T193","T194","T195",},
      ["S039"]={"T212","T213","T214",},
      ["S040"]={"T207","T208","T209","T210","T211",},
      ["S041"]={"T200","T201","T202","T100",},
      ["S042"]={"T114","T115","T116",},
      ["S043"]={"T225","T226","T227","T228",},
      ["S044"]={"T229","T230","T231","T232",},
      ["S045"]={"T233","T234","T235","T236","T321",},
      ["S046"]={"T279","T280","T281",},
      ["S047"]={"T267","T268","T269","T270",},
      ["S048"]={"T275","T276","T277","T278","T317",},
      ["S049"]={"T271","T272","T273","T274",},
      ["S050"]={"T282","T283","T284","T316",},
      ["S051"]={"T285","T286","T287","T288","T289",},
      ["S052"]={"T312","T313","T314",},
      ["S053"]={"T309","T310","T311",},
      ["S054"]={"T305",},
      ["S055"]={"T302","T303","T304",},
      ["S056"]={"T294","T296","T297","T295",},
      ["S057"]={"T298","T299","T300","T301",},
      ["S058"]={"T290","T291","T292","T293",},
      ["S059"]={"T262","T263","T264","T265","T266",},
      ["S060"]={"T259","T260","T261",},
      ["S061"]={"T306","T307","T308","T215",},
      ["S062"]={"T255","T256","T257","T258",},
      ["S063"]={"T251","T252","T253","T254","T319",},
      ["S064"]={"T237","T238","T239",},
      ["S065"]={"T203","T204","T205","T206","T184",},
      ["S066"]={"T219","T220","T221","T222","T223","T224","T325",},
      ["S067"]={"T247","T248","T249","T250","T117",},
      ["S068"]={"T240","T241","T242","T243",},
      ["S069"]={"T244","T245","T246",},
      ["S070"]={"T158","T159","T160",},
      ["S071"]={"T161","T162","T163","T164","T165",},
      ["S072"]={"T147","T148","T149","T150",},
      ["S073"]={"T118","T119","T120","T315",},
      ["S074"]={"T137","T138","T139",},
      ["S075"]={"T140","T141","T142",},
      ["S076"]={"T143","T144","T145","T146","T318",},
      ["S077"]={"T155","T156","T157",},
      ["S078"]={"T151","T152","T153","T154",},
}

for j,l in pairs(_G.DATA.JumpGatesTable) do
   table.insert(StarTable[l[1]],j)
   table.insert(StarTable[l[2]],j)
end
return StarTable
