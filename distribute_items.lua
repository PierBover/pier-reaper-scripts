-- this script distributes the selected items between the first and last selected item start time

-- get the total items in the project
local totalItems = reaper.CountMediaItems(0)
local selectedItems = {}
local startPosition = 0;
local endPosition = 0;

if totalItems > 0 then

	-- iterate over all the items to get the selected item
	for i = 0, totalItems - 1 do
		local item = reaper.GetMediaItem(0, i)

		-- if the item is currently selected...
		if reaper.IsMediaItemSelected(item) then
			-- get the item position
			local itemPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

			-- init the position variables
			if startPosition == 0 then startPosition = itemPosition end
			if endPosition == 0 then endPosition = itemPosition end

			-- find the min and max position values
			if itemPosition < startPosition then startPosition = itemPosition end
			if itemPosition > endPosition then endPosition = itemPosition end

			table.insert(selectedItems, item)
		end
	end

	local spacing = (endPosition - startPosition) / (#selectedItems - 1)

	--reaper.ShowConsoleMsg(startPosition)
	--reaper.ShowConsoleMsg('\n')
	--reaper.ShowConsoleMsg(endPosition)
	--reaper.ShowConsoleMsg('\n')
	--reaper.ShowConsoleMsg(spacing)

	for j = 1, #selectedItems do
		if j == 1 then reaper.SetMediaItemInfo_Value(selectedItems[j], "D_POSITION", startPosition)
		elseif j == #selectedItems then reaper.SetMediaItemInfo_Value(selectedItems[j], "D_POSITION", endPosition)
		else reaper.SetMediaItemInfo_Value(selectedItems[j], "D_POSITION", startPosition + (spacing * (j - 1))) end
	end

end

-- update the GUI so that the fades are displayed in the clips
reaper.UpdateArrange()