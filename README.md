# CC-Tweaked-spreadsheet-via-AE2



This program is used to display an AE2 system to a Google Spreadsheet using CC: Tweaked.



**MODS REQUIRED**

Applied Energistics 2

CC: Tweaked

Advanced peripherals



**SETUP (spreadsheet)**

1. Open a google spreadsheet and go to Extensions > Apps script
2. paste `spreadsheet.js` into the text editor that opens.

3\. press the blue deploy button and press \[New Deployment].

4\. Select the type \[Web App] and set access to anyone.

5\. Select \[deploy] and copy the Deployment ID



**SETUP (IN WORLD)**

Place down an MEBridge advancedperipherals:me\\\_bridge and a computer `computercraft:computer\\\_normal`. ensure the computer is ontop of, but touching the MEbridge



**SETUP (IN YOUR COMPUTER)**

1. Find the folder that the computer you just placed is.

 Should look something like this: .Minecraft\\saves\\\[WORLD]\\computercraft\\computer\\\[X]

2\. paste `items.lua` and `config.txt` into the computers file.

3\. paste your deployment ID into the config file.

4\. paste your sheetName into the config file. sheet name refers to the name of the sheet found at the bottom of the google sheets UI, not the name of the entire document.



**FINAL**

Now, you can run items.lua in the computer in world and your AE2 system will appear in your spreadsheet

