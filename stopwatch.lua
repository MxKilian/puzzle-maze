
StopWatch = {}
StopWatch.__index = StopWatch

function StopWatch:initialize(stopWatchElement)    

    local instance = {}
    setmetatable(instance, StopWatch)

    self.textToBeUpdated = stopWatchElement
    self.hours = 0
    self.minutes = 0
    self.seconds = 0

    return instance

end

function StopWatch:update()

    self.seconds = self.seconds + 1

    if self.seconds > 59 then
        self.minutes = self.minutes + 1
        self.seconds = 0
    end

    if self.minutes > 59 then
        self.hours = self.hours + 1
        self.minutes = 0
    end

    self.textToBeUpdated.text = StopWatch:toString()

end

function StopWatch:start()
    self.myTimer = timer.performWithDelay(1000, function() StopWatch:update() end, -1)
end

function StopWatch:pause()
    timer.pause(self.myTimer)
end

function StopWatch:cancel()
    if(self.myTimer ~= nil) then
        timer.cancel(self.myTimer)
    end
end

function StopWatch:reset()
    self.hours = 0
    self.minutes = 0
    self.seconds = 0
end

function StopWatch:toString()

    local hours = "0"
    local minutes = "0"
    local seconds = "0"

    if self.hours <= 10 then
        hours = "0" .. hours
    elseif self.minutes < 10 then
        minutes = "0" .. minutes
    elseif self.seconds < 10 then
        seconds = "0" .. seconds
    end

    return self.hours .. ":" .. self.minutes .. ":" .. self.seconds 
end