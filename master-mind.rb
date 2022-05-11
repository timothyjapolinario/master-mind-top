require 'pry-byebug'
class Game
    @@rounds = 11
    def initialize(player_1_class, player_2_class)
        @clues = {}
        set_players(player_1_class, player_2_class)
        #print @@master.secret_codes
        puts ""
        play_game()
    end
    def set_players(player_1_class, player_2_class)
        puts "Input 1 to play as Master"
        puts "Input 2 to play as Cracker"
        player_1_mode = gets.chomp.to_i
        if(player_1_mode == 1)
            @@master = Master.new(player_1_class)
            @@cracker = Cracker.new(player_2_class, @clues)

            puts "Select 4 number from 1 to 6 to set secret code."
            @@master.generate_secret_codes()
        elsif(player_1_mode == 2)
            @@master = Master.new(player_2_class)
            @@cracker = Cracker.new(player_1_class, @clues)

            @@master.generate_secret_codes()
        end
    end

    def play_game
        while(@@rounds > 0)
            @@cracker.guess_secret_code
            give_feedback()
            if(secret_codes_guessed?)
                puts "THE CODE HAS BEEN CRACKED!"
                return
            end
            @@rounds -= 1
        end
        puts "THE CODE DIDN'T BREAK"
        print @@master.secret_codes
        puts ""
    end
    
    def give_feedback()
        print "Guessed Code is: "
        @clues = {}
        @@cracker.guess_codes.each_with_index do |code, index|
            print "-#{code}"
            code_index_in_master = @@master.secret_codes.index(code)
            if(code_index_in_master)
                if(index == code_index_in_master)
                    @clues[code_index_in_master] = " (*) "
                else
                    @clues[code_index_in_master] = " ( ) "
                end
            end
        end
        puts "-#{@clues.values.join}"
        print @clue_correct_place
        puts ""
        print @clue_incorrect_place
        puts ""
    end
    
    def secret_codes_guessed?
        return (@@master.secret_codes == @@cracker.guess_codes)
    end

    class Master
        attr_reader :secret_codes
        def initialize(player_class)
            @secret_codes = []
            @@player = player_class.new()
        end
    
        def generate_secret_codes()
            @secret_codes = @@player.get_number
        end
    end
    class Cracker
        @guess_codes = Array.new(3, 1)
        attr_reader :guess_codes
        def initialize(player_class, clues)
            @@player = player_class.new()
            @clues = clues
        end

        def get_number
            number = @@player.get_number
            return number
        end

        def guess_secret_code
            puts "Cracker is guessing the codes"
            @guess_codes = @@player.guess_secret_code(@guess_codes, @clues)
        end
    end
end

class Human
    def get_number
        number = gets.chomp.split("")
        if(number.length == 4)
            return number
        end
    end
    def guess_secret_code(*)
        number = gets.chomp.split("")
        if(number.length == 4)
            return number
        end
    end
end

class Computer
    def get_number
        counter = 0
        all_number = ""
        while(counter < 4)
            number = random_number()
            all_number += number
            counter += 1
        end
        return all_number.split("")
    end

    def guess_secret_code(guess_codes, clues)
        if(clues.length == 0)
            return Array.new(4 ,random_number())
        end
    end

    def random_number
        return ["1", "2", "3", "4", "5", "6"].shuffle[0]
    end
end
Game.new(Human, Computer)