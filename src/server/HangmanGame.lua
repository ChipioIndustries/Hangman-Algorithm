local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Words = require(ReplicatedStorage.Words)

local RNG = Random.new()

local HangmanGame = {}
HangmanGame.__index = HangmanGame

function HangmanGame.new(word)
	if not word then
		word = Words[RNG:NextInteger(1, #Words)]
	end

	if table.find(Words, word) then
		local self = {
			word = word;
			state = {
				wordLength = #word;
				incorrectGuesses = {
					--[[
						"i";
						"k";
					]]
				};
				correctGuesses = {
					--[[
						{
							letter = "h";
							positions = {2, 4, 6};
						}
					]]
				}
			}
		}

		setmetatable(self, HangmanGame)

		print("The word is", self.word)

		return self
	else
		error("invalid word, please choose from the list")
	end
end

function HangmanGame:guess(letter)
	print("Guessing", letter)
	local start = self.word:find(letter)
	if self.word:find(letter) then
		local correctGuess = {
			letter = letter;
			positions = {start}
		}
		repeat
			start = self.word:find(letter, start + 1)
			if start then
				table.insert(correctGuess.positions, start)
			end
		until not start
		print("Correct guess!", letter, "appears", #correctGuess.positions, "times.")
		table.insert(self.state.correctGuesses, correctGuess)
	else
		print("Incorrect guess.")
		table.insert(self.state.incorrectGuesses, letter)
	end
end

function HangmanGame:getAtomizedGuess()
	local result = {}
	for _, guess in pairs(self.state.correctGuesses) do
		for _, index in pairs(guess.positions) do
			table.insert(result, {
				letter = guess.letter;
				position = index;
			})
		end
	end
	return result
end

function HangmanGame:checkEnd()
	local atomizedCorrect = {}
	for _, guess in pairs(self.state.correctGuesses) do
		for _, index in pairs(guess.positions) do
			atomizedCorrect[index] = guess.letter
		end
	end
	for i = 1, #self.word do
		atomizedCorrect[i] = atomizedCorrect[i] or "_"
	end
	print(table.concat(atomizedCorrect))
	if table.concat(atomizedCorrect) == self.word then
		print("AI wins! The word was", self.word, "!")
		print("Total incorrect guesses:", #self.state.incorrectGuesses)
		return true
	end
	return false
end

return HangmanGame