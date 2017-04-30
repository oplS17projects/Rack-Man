# Rack-Man  
  
## Kevin Fossey  
### April 30, 2017  
  
# Overview  
  
This project is a recreation of the classic arcade game "Pac-Man" using racket and its libraries.  
Players control the titular Rack-Man to guide him through the maze, collecting pellets and avoiding the ghost.  
Gather all the pellets to win.  
  
# Libraries Used  
The code uses six libraries:

```
(require 2htdp/universe  
         2htdp/image  
         lang/posn  
         RSound  
         net/url  
         net/sendurl)  
```  
  
* The ```2htdp/universe``` library allows us to create a enviroment where we are able to manipulate certain objects based on our logic.  
* The ```2htdp/image``` library provides us with the ability to create images with different properties.
* The ```lang/posn``` library is used to create position objects for graphics objects in the game  
* The ```RSound``` library is used play sound from a file within the game.
* The ```net/url``` library allows us to send the player's name and score to a database which is then stored on the server.  
* The ```net/sendurl``` library is used to open the created url within the game in a browser. 
  
# Key Code Excerpts  
  
Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.  
  
## 1. State Modification  

 
  
