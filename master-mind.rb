require 'pry-byebug'
class Game
    @@rounds = 11
    def initialize(player_1_class, player_2_class)
        set_players(player_1_class, player_2_class)
        print @@master.secret_codes
        puts ""
    end
    def set_players(player_1_class, player_2_class)
        puts "Input 1 to play as Master"
        puts "Input 2 to play as Cracker"
        player_1_mode = gets.chomp.to_i
        if(player_1_mode == 1)
            @@master = Master.new(player_1_class)
            @@cracker = Cracker.new(player_2_class)

            puts "Select 4 number from 1 to 6 to set secret code."
            @@master.generate_secret_codes()
        elsif(player_1_mode == 2)
            @@master = Master.new(player_2_class)
            @@cracker = Cracker.new(player_1_class)

            @@master.generate_secret_codes()
        end
    end

    class Master
        
        attr_reader :secret_codes
        def initialize(player_class)
            @secret_codes = []
            @@player = player_class.new()
        end
    
        def generate_secret_codes()
            counter = 0
            while(counter < 4)
                secret_code = @@player.get_number()
                @secret_codes.push(secret_code)
                counter += 1
            end
        end
    end
    class Cracker
        @guess_codes = []
    
        def initialize(player_class)
            @@player = player_class.new()
        end

        def get_number
            number = @@player.get_number
            return number
        end
    end
end



class Human
    def get_number
        number = gets.chomp.to_i
        return number
    end
end

class Computer
    def get_number
        number = [1, 2, 3, 4, 5, 6].shuffle[0]
        return number
    end
end


Game.new(Human, Computer)