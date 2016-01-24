scriptId = ''
scriptDetailsUrl = ''
scriptTitle = 'Canned Responses'

function onForegroundWindowChange(app, title)
    local uppercaseApp = string.upper(app)
    return true
end

function activeAppName()
    return "Any"
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

-- Triggers
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
                --No more magic
end
waveInGestureString = "waveingesture"
waveInGestureString = "1"
waveOutGestureString = "2"
fistGestureString = "3"
openHandGestureString = "4"

function onPoseEdge(pose, edge)
    -- Forward/backward and shuttle
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
    if pose == "fingersSpread" then
        if edge == "on" then
            if pose  == "fingersSpread" then
                magic(openHandGestureString)
            end
        end
    end
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

