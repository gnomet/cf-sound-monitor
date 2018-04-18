#!/usr/bin/ruby
require 'net/http'

# This script reads an Invesdor campaign banner and plays 
# sounds if the sum is bigger than last time this was run.


# Config
address = "https://www.invesdor.com/en/pitches/903/banner"
sum_per_coin = 500
filepath = "latest_sum.txt"
soundpath = "coin.wav"

lifeupinterval = 30000 # How often should a 1up sound be played (set to 0 to disable)
lifeupsoundpath = "1up.wav"

levelupinterval = 500000  # How often should a level up sound be played (set to 0 to disable)
levelupsoundpath = "levelup.wav"

announcement_voice = "Alex" #set to nil to skip Mac say command announcement
repeat_after = 300 #number of seconds to wait between polls. Set 0 to turn of repeating.
                    # NOTE: if this is above zero, the program never stops automatically


while repeat_after > 0 do

    print "\nChecking campaign status at #{Time.now}: "


    # Check latest sum online
    uri = URI.parse(address)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    sum = response.body.match(/<span>([\d\.]+)..EUR<\/span>/)[1].delete(".").to_i


    # Read the earlier sum from file
    latest_sum = 0
    if File.file?(filepath)
        File.open(filepath, 'r') do |f|  
            latest_sum = f.gets.to_i  
        end  
    else
        # if the file was not found, this is probably the first time running
        # and then it doesn't make sense to play all the sounds from 0 to sum
        latest_sum = sum 
    end


    print "#{latest_sum} -> #{sum}"



    # Play the sounds
    if sum > latest_sum
        extra_coins = 0
        diff = sum-latest_sum
        if diff > sum_per_coin
            extra_coins = (diff-501)/sum_per_coin + 1
        end
        print " x #{extra_coins + 1}"
        
        while extra_coins > 0 do
            Thread.new do
                `afplay #{soundpath}`
            end
            extra_coins -= 1
            sleep 0.35
        end
        
        `afplay #{soundpath}`

        # check if level up reached
        if sum/levelupinterval > latest_sum/levelupinterval
            `afplay #{levelupsoundpath}`
        end

        # check if 1up reached
        if sum/lifeupinterval > latest_sum/lifeupinterval 
            `afplay #{lifeupsoundpath}`
        end

        sleep 1

        sum_to_say = sum
        if sum > 1000000
            sum_to_say = "1 million #{sum-1000000}"
        end

        `say -v "#{announcement_voice}" "The current sum of investments is #{sum_to_say}."` if announcement_voice
    end



    # Write this sum to file
    File.open(filepath, 'w') do |f|  
        # use "\n" for two lines of text  
        f.puts sum  
    end 

sleep repeat_after
end