

local add_text_orig = add_text_file
local remove_text_orig = remove_text_file

local textfiles = {}

function add_text_file(f)
	textfiles[f] = debug.traceback()
	--add_text_orig(f)
end

function remove_text_file(f)
	textfiles[f] = nil
	--remove_text_orig(f)
end

function dump_loaded_texts()
	for k,v in pairs(textfiles) do
		LOG ( "" .. k .." added at \n".. v)
	end
end



local LoadAssetGroup_orig = LoadAssetGroup
local UnloadAssetGroup_orig = UnloadAssetGroup

local assetgroups = {}

function LoadAssetGroup(f)
	assetgroups[f] = debug.traceback()
	LoadAssetGroup_orig(f)
end

function UnloadAssetGroup(f)
	assetgroups[f] = nil
	UnloadAssetGroup_orig(f)
end

function dump_loaded_assetgroups()
	for k,v in pairs(assetgroups) do
		LOG ( "" .. k .." added at \n".. v)
	end
end
