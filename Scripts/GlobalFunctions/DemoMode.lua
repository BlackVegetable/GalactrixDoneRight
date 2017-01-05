



local function DemoMode()
	return not LicenseMgr:IsLicensed()
	--return false
	--return true
end


return DemoMode;
