# Rack-Man  
  
## Mohammed Nayeem  
### April 30, 2017  
  
# Overview  
  
This project is a resemblance of the classic game "Pac-Man". The game was written in Racket using many different libraries.

The goal of the game is to collect all of the pellets and avoid being eaten by the ghost. 

  
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

 
  
