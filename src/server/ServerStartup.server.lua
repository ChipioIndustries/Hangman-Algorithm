local ServerScriptService = game:GetService("ServerScriptService")

local HangmanAI = require(ServerScriptService.HangmanAI)

while true do
	HangmanAI.playGame()
	print("---------------------------------")
	task.wait(0.5)
end