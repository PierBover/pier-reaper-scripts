-- this script adds 50ms to the start of audio clips so the clip starts sooner by 50ms
-- then enlarges the clip so the ending of the clip remains the same
-- finally it moves the clip so that the initial position of the audio remains the same

-- get the total items in the project
local totalItems = reaper.CountMediaItems(0)
-- the offset we want to apply in seconds so this is 50ms
local offset = 0.050

if totalItems > 0 then
	-- iterate over all the items
	for i = 0, totalItems - 1 do
		-- get the item
		local item = reaper.GetMediaItem(0, i)

		-- if the item is currently selected...
		-- this is recommended in the docs over using GetSelectedMediaItem as it's slower
		if reaper.IsMediaItemSelected(item) then

			-- get the take of the item (the audio bit contained in the clip)
			local itemTake = reaper.GetActiveTake(item)

			-- change take start offset in the audio
			local itemAudioOffset = reaper.GetMediaItemTakeInfo_Value(itemTake, "D_STARTOFFS")
			local newAudioOffset = itemAudioOffset - offset
			reaper.SetMediaItemTakeInfo_Value(itemTake, "D_STARTOFFS", newAudioOffset)

			-- change item length
			local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
			local newLength = length + offset
			reaper.SetMediaItemInfo_Value(item, "D_LENGTH", newLength)

			-- change item start time
			local startTime = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
			local newStartTime = startTime - offset
			reaper.SetMediaItemInfo_Value(item, "D_POSITION", newStartTime)
		end
	end
end