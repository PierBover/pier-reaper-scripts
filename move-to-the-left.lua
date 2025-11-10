-- this script moves the selected item to the end of the previous item

local selectedItem = reaper.GetSelectedMediaItem(0, 0)

if not selectedItem then
	reaper.ShowConsoleMsg("Please select a media item!\n")
	return
end

-- get the track the item is on
local track = reaper.GetMediaItemTrack(selectedItem)

-- find the selected item's index in the track
local totalItems = reaper.CountTrackMediaItems(track)
local selectedItemIndex = -1

for i = 0, totalItems - 1 do
	local item = reaper.GetTrackMediaItem(track, i)
	if item == selectedItem then
		selectedItemIndex = i
		break
	end
end

-- find the previous item

if selectedItemIndex == 0 then
	reaper.ShowConsoleMsg("There is no previous item!\n")
	return
end

local previousItemId = selectedItemIndex - 1
local previousItem = reaper.GetTrackMediaItem(track, previousItemId)
local startPosition = reaper.GetMediaItemInfo_Value(previousItem, "D_POSITION")
local length = reaper.GetMediaItemInfo_Value(previousItem, "D_LENGTH")

local newPosition = startPosition + length
reaper.SetMediaItemInfo_Value(selectedItem, "D_POSITION", newPosition)