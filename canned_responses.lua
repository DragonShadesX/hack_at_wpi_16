--[[

23/1/16
#Version: 1.0
#Authors: Greg Tighe (DragonShadesX), Alan Fernandez (GranTotem)
#Hardware: Myo Armband V1

#Our entry for the WPI Hackathon 2016. The script allows the user to enter predefined responses into any text field using gestures recognized by the myo armband (Fist, Wave In, Wave Out and Spread Fingers)
#The accompanying Python script creates a GUI where the user can enter the desired canned responses. The script then edits the .lua file and modifies lines 68-71 which are the strings containing these responses.
#Scripts that modify scripts sound like viruses, but this is a hackathon and Myo doesn't allow scripts to interact directly with the filesystem.

#NOTE: If the number of lines changes, THE PYTHON SCRIPT WILL NO LONGER WORK! You must edit the lines in the python script.
]]--

scriptId = ''
scriptDetailsUrl = ''
scriptTitle = 'Canned Responses'

function onForegroundWindowChange(app, title)
    local uppercaseApp = string.upper(app)
    return true
end

function activeAppName()
    return "Canned Responses"
end

-- flag to de/activate shuttling feature
supportShuttle = false

-- Helpers

function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

-- Shuttle

function shuttleBurst()
    if shuttleDirection == "forward" then
        forward()
    elseif shuttleDirection == "backward" then
        backward()
    end
end

--
function magic(arrayToPrint)
    --Magic begins here
    local message_array = {}
    arrayToPrint:gsub(".", function(c) table.insert(message_array,c) end)
    count = 1
	for Index, Value in pairs(message_array) do
	    count = count + 1
	end
    local i = 1
    while (i<count) do
        if message_array[i] == " " then message_array[i] = "space" end
        myo.keyboard(message_array[i], "press")
        i = i + 1
        end
    myo.keyboard("return", "press")
    --No more magic
end
waveInGestureString = "left"
waveOutGestureString = "right"
fistGestureString = "bro fist"
openHandGestureString = "high five"

function onPoseEdge(pose, edge)
    --Wave Gestures
    if pose == "waveIn" or pose == "waveOut" then
        local now = myo.getTimeMilliseconds()

        if edge == "on" then
            -- Deal with direction and arm
            pose = conditionallySwapWave(pose)

            if pose == "waveIn" then
                magic(waveInGestureString)
                elseif pose == "waveOut" then
                magic(waveOutGestureString)
            end
            -- Extend unlock and notify user
            myo.unlock("hold")
            myo.notifyUserAction()

            -- Initial burst
            shuttleBurst()
            shuttleSince = now
            shuttleTimeout = SHUTTLE_CONTINUOUS_TIMEOUT
        end
        if edge == "off" then
            myo.unlock("timed")
            shuttleTimeout = nil
        end
    end

    --Open Hand Gesture
    if pose == "fingersSpread" then
        if edge == "on" then
            if pose  == "fingersSpread" then
                magic(openHandGestureString)
            end
        end
    end

    --Fist Gesture
    if pose == "fist" then
        if edge == "on" then
            if pose  == "fist" then
                magic(fistGestureString)
            end
        end
    end
end
-- All timeouts in milliseconds
SHUTTLE_CONTINUOUS_TIMEOUT = 600
SHUTTLE_CONTINUOUS_PERIOD = 300

function onPeriodic()
    local now = myo.getTimeMilliseconds()
    if supportShuttle and shuttleTimeout then
        if (now - shuttleSince) > shuttleTimeout then
            shuttleBurst()
            shuttleTimeout = SHUTTLE_CONTINUOUS_PERIOD
            shuttleSince = now
        end
    end
end

