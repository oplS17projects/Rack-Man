# Rack-Man  
  
## Kevin Fossey  
### April 30, 2017  
  
# Overview  
  
This project is a recreation of the classic arcade game "Pac-Man" using racket and its libraries.  
Players control the titular Rack-Man to guide him through the maze, collecting pellets and avoiding the ghost.  
Gather all the pellets to win.  
  
# Libraries Used  
The code uses four libraries:

```
(require 2htdp/universe  
         2htdp/image  
         lang/posn  
         RSound  
         net/url  
         net/sendurl)  
```  
  
* The ```2htdp/universe``` library allows us to create the interactive portions of the game, and define a 'world' and its logic  
* The ```2htdp/image``` library is used to create and display the graphics of the game  
* The ```lang/posn``` library is used to create position objects for graphics objects in the game  
* The ```RSound``` libraru is used to play the sound effects for the game  
* The ```net/url``` library allows us to send scoring data out to a database to host high-score information on a sever  
* The ```net/sendurl``` library is used to send out the generated url for the high-score server  
  
# Key Code Excerpts  
  
Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.  
  
## 1. ---  
  
## 2. ---  
  
## 3. ---  
  
## 4. ---  
  
## 5. ---  
  