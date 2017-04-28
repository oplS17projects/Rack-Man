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
  
## 1. List Processing and Fold  
To map out the maze, which is just an image, we created 4 lists containing the x/y cooridinates of the end points of each wall. The lists were separated into 4 lists, one for each direction the player/ghost can move,  
  Here is an exceprt of one of the lists
```  
(define L-DIR-WALLS  
  (list (list 96 47 96 77) (list 203 47 203 77) ...  
```  
So ```L-DIR-WALLS``` is a list of lists, containing the x/y points of the end points of the walls that the playey/ghost could potentially run into when moving to the left  
  We had to do this because the ```2htdp/image``` unfortunately doesn't contain a built in image object collision detection, and so we had to create our own.  
  To do this, I created ```ghost-maze-check```/```maze-check``` procedures. Below is an exceprt  
```  
(define (ghost-maze-check x y lst)  
  (begin  
    (cond ((equal? lst L-DIR-WALLS) ;#f)  
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again  
                                           ((and (<= x (+ (first wall) GHOSTX-OFFSET)) (>= x (first wall))) ;; check if ghost is lined up along X with any walls  
                                            (if (and (>= y (- (second wall) GHOSTY-OFFSET)) (<= y (+ (fourth wall) GHOSTY-OFFSET))) ;; check if ghost is is lined up along Y with any walls  
                                                #t  
                                                #f))  
                                           (else #f)))  
                  #f  
                  lst))  
```  
It works by using ```foldl```, which applies a procedure to each element of a list, passing its result forward, ultimately returning a single result. So I created a lambda procedure which takes the a wall piece from the list, and the results of the last call. If the results of the last call was #t, it means a collision was detected, so pass it forward. If the result is false, it takes the x/y cooridnates of the ghost/player (which are measured as a single point in the center of the image) and checks if that point is in line with the current wall piece (using the offsets to account for how the x/y is measured). If that check returns true then that #t result is passed forward through the rest of the fold, and ultimately passed back to the caller of ```maze-check``` to indicate that the player or the ghost has hit a wall of the maze.  
  
## 2. ---  
  
## 3. ---  
  
## 4. ---  
  
## 5. ---  
  
