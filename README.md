# Crowdfunding Campaign Sound Monitor

This is a very simple ruby script that monitors a certain URL of a crowdfunding campaign page that has the raised sum visbile. The monitor plays a sound whenever it spots that the money amount has increased, and multiple sounds if the amount has increased a lot.

The script works on Mac when monitoring Invesdor crowdfunding using EUR just by changing the URL, but for other platforms the code needs modifying. 

The coin sound used is a freely downloadable ringtone from: http://www.orangefreesounds.com/mario-coin-sound/ and it can be easily replaced with another sound file if wanted.


## Installation and running (on a Mac)

1. Download or clone the code from Github.
1. Open the Terminal app and go to the folder where the program code is.
1. run with a command: `ruby cf-sound-monitor.rb`
1. Keep the Terminal window open as long as you want to keep the program checking for updates every 5 minutes. You can quit with ctrl+c.
