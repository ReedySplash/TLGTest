--Created a new module to handle the button jump behaviour that is requested to be recreated for Question 7, also it is necessary to add the new module in interface.otmd for the correct functioning.

-- Define global variable for the test button
testbutton = nil

function init()
  g_ui.importStyle('testwindow')

  -- Add a button to the top menu
  testbutton = modules.client_topmenu.addLeftGameButton('testbutton', tr('Test'), '/images/topbuttons/questlog', function() onTest() end)

  connect(g_game, { 
                    onGameEnd = destroyWindows})
end

function terminate()
  disconnect(g_game, { 
                       onGameEnd = destroyWindows})

  destroyWindows()
  testbutton:destroy()
end

function destroyWindows()
  if testwindow then
    testwindow:destroy()
  end
end

function onTest()
  destroyWindows()

  -- Create the test window and get the reference to the button and the background.
  testwindow = g_ui.createWidget('TestWindow', rootWidget)
  buttonJump = testwindow:getChildById('jumpButton')
  background = testwindow:getChildById('background')

  -- Calculate initial position for the jump button
  initPosX = background:getPosition().x + background:getSize().width - buttonJump:getSize().width
  local initPosY = math.random(background:getPosition().y, background:getPosition().y + background:getSize().height)
  buttonJump:setPosition({x = initPosX, y = initPosY})

  -- Start moving the button
  moveButton()  

  testwindow.onDestroy = function()
    testwindow = nil
    removeEvent(eventId)
  end
end

function moveButton()
  -- Move the button 10 units to the left each time this function is called
  local pos = { x = buttonJump:getPosition().x - 10, y = buttonJump:getPosition().y }
  buttonJump:setPosition(pos)

  -- If the button reaches the left edge, reset its position
  if buttonJump:getPosition().x < background:getPosition().x then
    resetButton();
  end

  -- Schedule the next movement, creating a loop for the button movement
  eventId = scheduleEvent(moveButton, 50)
end

-- Function to reset the button position if it's clicked or reaches the left edge
function resetButton()
  local initPosY = math.random(background:getPosition().y, background:getPosition().y + background:getSize().height - buttonJump:getSize().height)
  buttonJump:setPosition({x = initPosX, y = initPosY})
end