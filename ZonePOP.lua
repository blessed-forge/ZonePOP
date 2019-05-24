ZonePOP = {}

local version = "1.3.1"

function ZonePOP.init() 
	CreateWindow("ZonePOPWnd", true)

WindowSetDimensions("ZonePOPWnd",270,60)
	
--	LayoutEditor.RegisterWindow( windowName, windowDisplayName, windowDesc, allowSizeWidth, allowSizeHeight, allowHiding, setHiddenCallback, allowableAnchorList, neverLockAspect, minSize, resizeEndCallback, moveEndCallback )
	LayoutEditor.RegisterWindow( "ZonePOPWnd", L"ZonePOP", L"Zone population", true, true, true, nil )

CreateWindow("ZonePOPEXTRA", false)
ZonePOP.SelectedSearchZoneList = {}	
	
TextLogAddEntry("Chat", 0, L"<icon57> ZonePOP "..towstring(version)..L" Loaded.")
	
isSearching = false
ZonepopSearch = false
ZonePOP.Index = 1
ZonePOP.Timer = 0
ZonePOP.Anon = 0
ZonePOP.Destro = 0
ZonePOP.Order = 0
ZonePOP.Sort ={L"a",L"b",L"c",L"d",L"e",L"f",L"g",L"h",L"i",L"j",L"k",L"l",L"m",L"n",L"o",L"p",L"q",L"r",L"s",L"t",L"u",L"v",L"w",L"x",L"y",L"z"}
ZonePOP.CareerDestro = {24,25,26,27,64,65,66,67,104,105,106,107}
ZonePOP.CareerOrder = {20,21,22,23,61,60,63,62,100,102,103,101}

ZonePOP.DestroCount = {0,0,0,0,0,0,0,0,0,0,0,0}
ZonePOP.OrderCount = {0,0,0,0,0,0,0,0,0,0,0,0}

ZonePOP.CurrentSelectedZone = GameData.Player.zone
ZonePOP.DropBoxSelect = 1

	--RegisterEventHandler(SystemData.Events["SOCIAL_SEARCH_UPDATED"], "HandleSearchResults" ) 
--RegisterEventHandler(SystemData.Events.LOADING_END, "ZonePOP.Search" ) 
RegisterEventHandler(SystemData.Events.PLAYER_ZONE_CHANGED, "ZonePOP.Zoning" ) 
RegisterEventHandler(TextLogGetUpdateEventId("System"), "ZonePOP.OnChatLogUpdated")
RegisterEventHandler(SystemData.Events.INTERFACE_RELOADED, "ZonePOP.Reloaded" ) 



ZonePOP.UpdateZoneList()

for i=1,12 do
LabelSetText("DestroLabel"..i,L"--")	
LabelSetText("OrderLabel"..i,L"--")	
end

LibSlash.RegisterSlashCmd("zonepop", ZonePOP.Search)
LibSlash.RegisterSlashCmd("zonetell", ZonePOP.Tell)
LibSlash.RegisterSlashCmd("zonetelladd", ZonePOP.AddTell)

local CURRENTZONENAME = GetZoneName(ZonePOP.CurrentSelectedZone)
for i=2,111 do
local SEACHZONENAME = ZonePOP.SelectedSearchZoneList[i].name
 
LabelSetText("ZonePOPWndDestroCount",L"Destro: --")
LabelSetText("ZonePOPWndOrderCount",L"Order: --")
LabelSetText("ZonePOPWndZoneName",towstring(GetZoneName(GameData.Player.zone)))
LabelSetTextColor("ZonePOPWndDestroCount",255,255,125)
LabelSetTextColor("ZonePOPWndOrderCount",255,255,125)	
 
if CURRENTZONENAME == SEACHZONENAME then
d(L"Zonenumber = "..towstring(i))
TextLogAddEntry("Chat", 0, L"Dopbox Number = "..towstring(i))
SEACHZONENUMBER = i
break
end 
end

ZonePOP.Reloaded()

end




function ZonePOP.OnChatLogUpdated(updateType, filterType)

	if( updateType == SystemData.TextLogUpdate.ADDED ) then 
		local _, filterId, text = TextLogGetEntry( "System", TextLogGetNumEntries("System") - 1 ) 

		
if isSearching == true then					
		if text:find(L"Found") then	
	isSearching = false
ZonePOP.Test()
		end
end
end
end

function ZonePOP.Reloaded()
for i=1,10 do
WindowSetScale("ZonePOPWndComboBoxZoneNamesMenuButton"..i,WindowGetScale("ZonePOPWndComboBoxZoneNames"))
end
WindowSetScale("ZonePOPEXTRA",WindowGetScale("ZonePOPWnd"))

end


function ZonePOP.Search()
if (isSearching == false) and (ZonepopSearch == false) then

ZonePOP.Index = 1
ZonePOP.Timer = 0 
ZonePOP.Anon = 0
ZonePOP.Destro = 0
ZonePOP.Order = 0
ZonePOP.DestroCount = {0,0,0,0,0,0,0,0,0,0,0,0}
ZonePOP.OrderCount = {0,0,0,0,0,0,0,0,0,0,0,0}
ZonePOP.SearchZoneTemp = {}
ZonePOP.ZoneList = {}
isSearching = true
ZonepopSearch = true
--d(#ZonePOP.ZoneList)
end

end

 function ZonePOP.FixString (str)

	if (str == nil) then return nil end

	local str = str
	local pos = str:find (L"^", 1, true)
	if (pos) then str = str:sub (1, pos - 1) end
	
	return str
end

function ZonePOP.Tell()
if ZonePOP.CurrentSelectedZone == -1 then
ZonePOP.ZoneName = L"Server "
else
ZonePOP.ZoneName = GetZoneName(ZonePOP.CurrentSelectedZone)
end
local popstring = towstring(ZonePOP.ZoneName)..L" Population: <LINK data=\"0\" text=\"Destro: "..towstring(ZonePOP.Destro)..L"\" color=\"255,25,25\"> "..L"  <LINK data=\"0\" text=\"Order: "..towstring(ZonePOP.Order)..L"\" color=\"75,75,255\"> "..L"  <LINK data=\"0\" text=\"Anon: "..towstring(ZonePOP.Anon)..L"\" color=\"255,255,55\"> "
EA_ChatWindow.InsertText(popstring)

--<icon23000>
--<icon23007>
end

function ZonePOP.AddZone()

ZonePOP.Add = {}

if ZonePOP.CurrentSelectedZone == -1 then
ZonePOP.ZoneName = L"Server "
else
ZonePOP.ZoneName = GetZoneName(ZonePOP.CurrentSelectedZone)
end

ZonePOP.Add.Destro = ZonePOP.Destro
ZonePOP.Add.Order = ZonePOP.Order
ZonePOP.Add.Zone = ZonePOP.ZoneName
ZonePOP.Add.Anon = ZonePOP.Anon
end

function ZonePOP.AddTell()
if ZonePOP.CurrentSelectedZone == -1 then
ZonePOP.ZoneName = L"Server "
else
ZonePOP.ZoneName = GetZoneName(ZonePOP.CurrentSelectedZone)
end
local popstring = towstring(ZonePOP.ZoneName)..L": <LINK data=\"0\" text=\"D:"..towstring(ZonePOP.Destro)..L"\" color=\"255,25,25\"> "..L"<LINK data=\"0\" text=\"O:"..towstring(ZonePOP.Order)..L"\" color=\"75,75,255\"> "..L"<LINK data=\"0\" text=\"A:"..towstring(ZonePOP.Anon)..L"\" color=\"255,255,55\"> "
local popstringAdd = towstring(ZonePOP.Add.Zone)..L": <LINK data=\"0\" text=\"D:"..towstring(ZonePOP.Add.Destro)..L"\" color=\"255,25,25\"> "..L"<LINK data=\"0\" text=\"O:"..towstring(ZonePOP.Add.Order)..L"\" color=\"75,75,255\"> "..L"<LINK data=\"0\" text=\"A:"..towstring(ZonePOP.Add.Anon)..L"\" color=\"255,255,55\"> "
local popstringTotal = L"Population: <LINK data=\"0\" text=\"Destro: "..towstring(ZonePOP.Destro+ZonePOP.Add.Destro)..L"\" color=\"255,25,25\"> "..L" <LINK data=\"0\" text=\"Order: "..towstring(ZonePOP.Order+ZonePOP.Add.Order)..L"\" color=\"75,75,255\"> "..L" <LINK data=\"0\" text=\"Anon: "..towstring(ZonePOP.Anon+ZonePOP.Add.Anon)..L"\" color=\"255,255,55\"> "
EA_ChatWindow.InsertText(towstring(popstring)..L"+ "..towstring(popstringAdd)..L"= "..towstring(popstringTotal))

--<icon23000>
--<icon23007>
end



function ZonePOP.Update(timeElapsed)

if ZonepopSearch == true then
ComboBoxSetDisabledFlag("ZonePOPWndComboBoxZoneNames",true)
LabelSetText("ZonePOPWndDestroCount",L"Updating: ")
LabelSetText("ZonePOPWndOrderCount",towstring((tonumber(ZonePOP.Index)-1)*4)..L"%")
LabelSetText("ZonePOPWndZoneName",L"")

LabelSetTextColor("ZonePOPWndDestroCount",255,255,125)
LabelSetTextColor("ZonePOPWndOrderCount",255,255,125)

--LabelSetText("ZonePOPWndZoneName",towstring(GetZoneName(ZonePOP.CurrentSelectedZone)))
ZonePOP.SearchZoneTemp[1]=ZonePOP.CurrentSelectedZone
SendPlayerSearchRequest(towstring(ZonePOP.Sort[ZonePOP.Index]),L"",L"",ZonePOP.SearchZoneTemp,1,40,false)
ZonepopSearch = false
end

if isSearching == true then
ZonePOP.Timer = ZonePOP.Timer + timeElapsed
end

if ZonePOP.Timer > 0.6 then
ZonePOP.Timer = 0 
isSearching = false
ZonePOP.Test()
end

end


--[[
function ZonePOP.ListData()
    ZonePOP.playerListData = {}
    local numberFound = 0

    local SearchListData = GetSearchList()
    
    if ( SearchListData ~= nil ) then
		numberFound = #SearchListData
        for key, value in ipairs( SearchListData ) do
            -- These should match the data that was retrived from war_interface::LuaGetSearchList
            ZonePOP.playerListData[key] = {}
            ZonePOP.playerListData[key].name = value.name
            ZonePOP.playerListData[key].career = value.career
            if ( value.zoneID ~= 0 ) then
                ZonePOP.playerListData[key].rankString = L""..value.rank
                ZonePOP.playerListData[key].location = GetZoneName( value.zoneID )
            else
                ZonePOP.playerListData[key].rankString = L""	-- If the person is offline, rank is 0, so don't display it.
                ZonePOP.playerListData[key].guildName  = L""	-- If the player has hidden their details, no Guildname exists.
                ZonePOP.playerListData[key].location = GetStringFromTable( "SocialStrings", StringTables.Social.LABEL_SOCIAL_WINDOW_OFFLINE)
            end

            ZonePOP.playerListData[key].guildName = value.guildName
        end
    end

    if numberFound <= 0 then
		ZonePOP.playerListData[1] = {}
		ZonePOP.playerListData[1].name = GetStringFromTable("SocialStrings", StringTables.Social.TEXT_SOCIAL_NO_RESULTS)
    end


end

]]--











function ZonePOP.Zoning()
--ZonePOP.UpdateZoneList()
if ZonePOP.DropBoxSelect == 1 then
ZonePOP.CurrentSelectedZone = GameData.Player.zone
end


isSearching = false
ZonepopSearch = false
--ComboBoxSetSelectedMenuItem("ZonePOPWndComboBoxZoneNames",)
ZonePOP.Index = 1
ZonePOP.Timer = 0
ZonePOP.Anon = 0
ZonePOP.Destro = 0
ZonePOP.Order = 0
ZonePOP.DestroCount = {0,0,0,0,0,0,0,0,0,0,0,0}
ZonePOP.OrderCount = {0,0,0,0,0,0,0,0,0,0,0,0}
end

function ZonePOP.Test()
ZonePOP.Timer = 0 
 ZonePOP.ZoneList=GetSearchList()
for i, value in ipairs( ZonePOP.ZoneList ) do
local ZPTempName = ZonePOP.FixString (ZonePOP.ZoneList[i].career)
--d(ZPTempName)
for SearchIndex = 1,12 do
if (ZPTempName == ZonePOP.FixString(towstring(GetStringFromTable("CareerNamesMale", ZonePOP.CareerDestro[SearchIndex])))) then
--d(ZPTempName)
 ZonePOP.Destro = ZonePOP.Destro + 1 
 ZonePOP.DestroCount[SearchIndex] = ZonePOP.DestroCount[SearchIndex] + 1
 end
if (ZPTempName == ZonePOP.FixString(towstring(GetStringFromTable("CareerNamesMale", ZonePOP.CareerOrder[SearchIndex])))) then
 ZonePOP.Order = ZonePOP.Order + 1 
 ZonePOP.OrderCount[SearchIndex] = ZonePOP.OrderCount[SearchIndex] +1
 
 end
end

if (ZPTempName == L"" or ZPTempName == nil) then ZonePOP.Anon = ZonePOP.Anon +1 end

end

if ZonePOP.Index <= 26 then 
ZonePOP.Index = ZonePOP.Index+1 
ZonepopSearch = true
isSearching = true
else

TextLogAddEntry("Chat", 0, L"[Zonepop]: Done")
d(L"Destro: "..towstring(ZonePOP.Destro)..L" ("..towstring(ZonePOP.Destro)..L")")
d(L"Order: "..towstring(ZonePOP.Order)..L" ("..towstring(ZonePOP.Order)..L")")
d(L"Anon:"..towstring(ZonePOP.Anon))
--d("---------------------")
for i=1 , 12 do
--d(towstring(GetStringFromTable("CareerNamesMale", ZonePOP.CareerOrder[i]))..L": "..towstring(ZonePOP.OrderCount[i]))
LabelSetText("DestroLabel"..i,towstring( ZonePOP.DestroCount[i]))
LabelSetText("OrderLabel"..i,towstring( ZonePOP.OrderCount[i]))
end
--LabelSetText("ZonePOPWndZoneName",towstring(GetZoneName(GameData.Player.zone))..L" "..towstring(ZonePOP.Anon+ZonePOP.Destro+ZonePOP.Order)..L"("..towstring(ZonePOP.Anon)..L")")
LabelSetText("ZonePOPWndZoneName",towstring(ZonePOP.Anon+ZonePOP.Destro+ZonePOP.Order)..L"("..towstring(ZonePOP.Anon)..L")")
ComboBoxSetDisabledFlag("ZonePOPWndComboBoxZoneNames",false)

LabelSetText("ZonePOPWndDestroCount",L"Destro: "..towstring(ZonePOP.Destro))
LabelSetText("ZonePOPWndOrderCount",L"Order: "..towstring(ZonePOP.Order))

LabelSetTextColor("ZonePOPWndDestroCount",255,75,75)
LabelSetTextColor("ZonePOPWndOrderCount",125,125,255)

ZonepopSearch = false
isSearching = false
ZonePOP.Index = 1
ZonePOP.Timer = 0 
ZonePOP.SearchZoneTemp = nil
ZonePOP.ZoneList = nil
end

end

function ZonePOP.OnMouseover()
WindowSetShowing("ZonePOPEXTRA",true)
--    Tooltips.CreateTextOnlyTooltip( SystemData.ActiveWindow.name )
--	Tooltips.AnchorTooltip( nil )
--	Tooltips.SetTooltipText( 1, 1, L"Order:" )
--	Tooltips.SetTooltipText( 1, 1, L"     ZonePOP     ")
 --  Tooltips.Finalize()

end


function ZonePOP.OnMouseaway()
WindowSetShowing("ZonePOPEXTRA",false)
  
end





function ZonePOP.UpdateZoneList()
    -- Clear ComboBox before populating to avoid duplicates
    ComboBoxClearMenuItems("ZonePOPWndComboBoxZoneNames")

    -- add the all zones option
  --  ComboBoxAddMenuItem("ZonePOPWndComboBoxZoneNames", GetString( StringTables.Default.TEXT_ALL_ZONES ))
	ComboBoxAddMenuItem("ZonePOPWndComboBoxZoneNames",  L"Current Zone")
	ComboBoxAddMenuItem("ZonePOPWndComboBoxZoneNames", GetString( StringTables.Default.TEXT_ALL_ZONES ))
  
    local tempZoneNameRef = {} -- we will use this to make sure we don't have duplicate names in the list
    -- start the count at 2 so that it will skip over the all zones option
    local iCount = 2

    local zoneIDs = GetZoneIDList()
    -- loop over all the zone names, some are blank, some are "Dangerous Territory"
    for index, zoneID in ipairs( zoneIDs )
    do
	
        -- get the zone name for this zoneID
        zoneName = ZonePOP.FixString(GetZoneName(zoneID))
		
        if tempZoneNameRef[zoneName] == nil and not (zoneName == nil or zoneName == L"")
        then
            tempZoneNameRef[zoneName] = iCount
            -- we need to sort this so we will add it to the list
            ZonePOP.SelectedSearchZoneList[iCount] = {}
            ZonePOP.SelectedSearchZoneList[iCount].index = {}
            table.insert(ZonePOP.SelectedSearchZoneList[iCount].index, zoneID)
            ZonePOP.SelectedSearchZoneList[iCount].name = zoneName
            -- increment the count
            iCount = iCount + 1
        else
			if not (zoneName == nil or zoneName == L"") then
            table.insert(ZonePOP.SelectedSearchZoneList[tempZoneNameRef[zoneName]].index, zoneID)
			end
        end
    end

    table.sort( ZonePOP.SelectedSearchZoneList, DataUtils.AlphabetizeByNames )
    -- loop over the sorted zone list
    for index, zoneData in pairs( ZonePOP.SelectedSearchZoneList )
    do
        -- and put the name into the combo box
        ComboBoxAddMenuItem("ZonePOPWndComboBoxZoneNames", zoneData.name)
    end

    ComboBoxSetSelectedMenuItem("ZonePOPWndComboBoxZoneNames", 1)
end

function ZonePOP.OnFilterSelChanged( curSel )
d("# "..curSel)
ZonePOP.DropBoxSelect = curSel
    -- clear out the array
    ZonePOP.ZoneID = {}
    -- if we are on the first selection or for some reason we are past the zone list index we will search all the zones
    if (((curSel - 1) == 0) or (curSel > #ZonePOP.SelectedSearchZoneList))
    then
        -- this is set to -1 when all the zones should be searched
        ZonePOP.ZoneID[1] = GameData.Player.zone
		
		ZonePOP.CurrentSelectedZone = ZonePOP.ZoneID[1]
		
			d(ZonePOP.CurrentSelectedZone)
			d(towstring(GetZoneName(ZonePOP.CurrentSelectedZone)))
		
    -- otherwise we will only search the zone selected
    elseif (((curSel - 1) == 1))
    then
        -- this is set to -1 when all the zones should be searched
        ZonePOP.ZoneID[1] = -1
		
		ZonePOP.CurrentSelectedZone = ZonePOP.ZoneID[1]
			d(ZonePOP.CurrentSelectedZone)
			d(towstring(GetZoneName(ZonePOP.CurrentSelectedZone)))
    -- otherwise we will only search the zone selected
    else
	
	
        for row = 1, #ZonePOP.SelectedSearchZoneList[curSel].index
        do
            ZonePOP.ZoneID[row] = ZonePOP.SelectedSearchZoneList[curSel-1].index[row]
			ZonePOP.CurrentSelectedZone = ZonePOP.ZoneID[row]
			d(ZonePOP.SelectedSearchZoneList[curSel].index[row])
			d(towstring(GetZoneName(ZonePOP.ZoneID[row])))
        end
    end
	
	--d(ZonePOP.CurrentSelectedZone)
end

