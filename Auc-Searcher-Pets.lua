-- Create a new instance of our lib with our parent
local lib, parent, private = AucSearchUI.NewSearcher("Pets")
if not lib then return end
local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "Pets"

private.missingMap = {};
private.hasMap = false;

function private.buildMap()

	if (private.hasMap) then
		return;
	end

	local numPets = C_PetJournal.GetNumPets();
	local i;
	local c= 0;

	for i=1, numPets, 1 do
		local guid, petID, owned, _, _, _, _, name = C_PetJournal.GetPetInfoByIndex(i);

		if (not owned) then
			private.missingMap[name] = 1;
			c = c + 1;
		end
	end

	private.hasMap = true;
end

function private.dumpTable(t)

	local i,v;

	for i,v in pairs(t) do
		print(i..': '..v);
	end

end

-- **************************************************

function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")

	-- Add the help
	gui:AddSearcher("Pets", "Search for missing pets", 100);
end

function lib.Search(item)

	private.buildMap();


	--
	-- check it's a valid type
	--

	local ok_type = false;

	if (item[Const.ITYPE] == "Battle Pets") then
		ok_type = true;
	end
	if (item[Const.ITYPE] == "Miscellaneous") then
		if (item[Const.ISUB] == "Companion Pets") then
			ok_type = true;
		end
	end

	if (not ok_type) then

		return false, "nope";
	end


	--
	-- is it in our missing map?
	--

	if (private.missingMap[item[Const.NAME]]) then

		return "missing";
	end


	--
	-- drop out
	--

	return false, "nope";
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$");
