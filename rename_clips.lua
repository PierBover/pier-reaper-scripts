-- this script renames the selected clips and can add a sequential number

-- ask user for values
local ok, name = reaper.GetUserInputs("Rename clips", 1, "Name,extrawidth=200", "")

if ok then
	-- get the total items in the project
	local totalItems = reaper.CountMediaItems(0)

	if totalItems > 0 then

		local addSerial = reaper.MB("", "Add a sequential number after the name?", 4)
		local serialCounter = 1

		--reaper.ShowConsoleMsg(addSerial)

		-- iterate over all the items
		for i = 0, totalItems - 1 do
			-- get the item
			local item = reaper.GetMediaItem(0, i)

			-- if the item is currently selected...
			if reaper.IsMediaItemSelected(item) then
				local newName = name

				if addSerial == 6 then
					newName = newName .. serialCounter
				end

				-- get the item take
				local itemTake = reaper.GetActiveTake(item)
				-- change the name
				reaper.GetSetMediaItemTakeInfo_String(itemTake, "P_NAME", newName, true)

				serialCounter = serialCounter + 1
			end
		end
	end

	-- update the GUI so that the fades are displayed in the clips
	reaper.UpdateArrange()
end