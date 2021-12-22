local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HangmanGame = require(ServerScriptService.HangmanGame)
local Words = require(ReplicatedStorage.Words)
local Letters = require(ReplicatedStorage.Letters)

local HangmanAI = {}

function HangmanAI.playGame()
	local startTimestamp = tick()
	local newGame = HangmanGame.new()
	repeat
		local filteredList = {}
		for _, word in pairs(Words) do
			if #word == newGame.state.wordLength then
				local atomizedGuess = newGame:getAtomizedGuess()
				local matchesGuess = true
				for _, letter in pairs(atomizedGuess) do
					if word:sub(letter.position, letter.position) ~= letter.letter then
						matchesGuess = false
						break
					end
				end
				local noIncorrectLetters = true
				for _, letter in pairs(newGame.state.incorrectGuesses) do
					if word:find(letter) then
						noIncorrectLetters = false
						break
					end
				end
				if matchesGuess and noIncorrectLetters then
					table.insert(filteredList, word)
				end
			end
		end
		print(#filteredList, "possible words")
		if #filteredList < 50 then
			print(filteredList)
		end
		local letterPopularity = {}
		for _, letter in pairs(Letters) do
			if not table.find(newGame.state.incorrectGuesses, letter) then
				local isGuessed = false
				for _, guess in pairs(newGame.state.correctGuesses) do
					if guess.letter == letter then
						isGuessed = true
						break
					end
				end
				if not isGuessed then
					letterPopularity[letter] = 0
				end
			end
		end
		for _, word in pairs(filteredList) do
			for letter, _ in pairs(letterPopularity) do
				local _, popularity = word:gsub(letter, letter)
				letterPopularity[letter] += popularity
			end
		end
		local bestLetter, bestLetterPopularity = "", 0
		for letter, popularity in pairs(letterPopularity) do
			if popularity > bestLetterPopularity then
				bestLetter = letter
				bestLetterPopularity = popularity
			end
		end
		newGame:guess(bestLetter)
	until newGame:checkEnd()
	print("Game lasted", tostring(tick() - startTimestamp):sub(1, 4), "seconds")
end

return HangmanAI