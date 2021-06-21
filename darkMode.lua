local darkMode
function script:buildCityGUI()
	script:enterStage()
end
function script:enterStage()
	if not darkMode then
		darkMode = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())
		darkMode.darkMode = darkMode.darkMode or 0
	end
	TheoTown.darkUIMode = function()
		return (darkMode.darkMode or 0) >= 1
	end
end
function script:settings()
	return {
		{
			name = "Dark UI mode",
			value = darkMode.darkMode or 0,
			values = {0, 1, 2},
			valueNames = {"a", "b", "c"},
			onChange = function(v)
				darkMode.darkMode = v
			end
		}
	}
end
