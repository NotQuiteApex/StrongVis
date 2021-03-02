# StrongVis - MC Stronghold Visualizer [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/notquiteapex)
Draw angles given from Eyes of Ender and F3+C to get a good idea of where the stronghold may be.

Made with [LÖVE](https://love2d.org/). To run source, open the cloned repo with the LÖVE executable. To build, use build-win.bat, you must have curl and 7z installed and in your PATH.

# Usage
Let's get familiar with the UI. There's a lot here, so lemme try to talk it out by color. White text is just general info, like controls and cursor info. Green lines point to the origin, where you throw the first Eye of Ender. Red lines are every 10 chunks. Dark blue lines are chunk outlines, pink dots are the centers of chunks (where Eyes of Ender point to). Yellow numbers are the number of horizontal chunks in a direction, Cyan numbers are the same but vertical.

First up, open the program. Controls are listed in the bottom right corner. When in your run you get some proper Eyes of Ender and are ready to go looking for the stronghold, go to the intersection of 4 chunks, throw the eye, match up your crosshair with the eye, and press F3+C. Now, switch to the program, press Ctrl+V, and draw the line to the pink circle. Next, move a few chunks (4 to 5 is good), throw another eye, F3+C again. When you paste, make sure your cursor is placed on the block that is in the direction you traveled, that many chunks, click and create your line with the pink dot. The intersection between the two lines should be near where the stronghold chunk is. Happy running!

# License
All code in this repository is licensed under the zlib license, please see LICENSE.md for more details.

Copyright (c) 2021 Logan "NotQuiteApex" Hickok-Dickson
