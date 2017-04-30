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
To map out the maze, which is just an image, we created 4 lists containing the x/y coordinates of the end points of each wall. The lists were separated into 4 lists, one for each direction the player/ghost can move,  
  
  Here is an excerpt of one of the lists
```  
(define L-DIR-WALLS  
  (list (list 96 47 96 77) (list 203 47 203 77) ...  
```  
So ```L-DIR-WALLS``` is a list of lists, containing the x/y points of the end points of the walls that the player/ghost could potentially run into when moving to the left  
  
  We had to do this because the ```2htdp/image``` unfortunately doesn't contain a built in image object collision detection, and so we had to create our own.  
  
  To do this, I created ```ghost-maze-check```/```maze-check``` procedures. Below is an excerpt  
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
It works by using ```foldl```, which applies a procedure to each element of a list, passing its result forward, ultimately returning a single result. So I created a lambda procedure which takes a wall piece from the list, and the results of the last call. If the result of the last call was #t, it means a collision was detected, so pass it forward. If the result is false, it takes the x/y coordinates of the ghost/player (which are measured as a single point in the center of the image) and checks if that point is in line with the current wall piece (using the offsets to account for how the x/y is measured). If that check returns true then that #t result is passed forward through the rest of the fold, and ultimately passed back to the caller of ```maze-check``` to indicate that the player or the ghost has hit a wall of the maze. 
  
Figuring out how to keep the player/ghost inside the maze was a challenge, but by utilizing the ideas taught in class about fold and list management I was able to come up with the above solution.  
  
## 2. Using Recursion to build a list  
  
To create the pellets in the game I knew I would need to have an image object and a x/y coordinates for each one. As there needed to be 250+ pellets I wanted to avoid having to come up with those coordinates by hand like we did for the walls.  
  
In class there was a heavy focus on recursion, and the different ways to utilize it. One of the utilizations was building a list using recursion, which is what I decided to do for this project.  
  
  Here is a piece of the code I wrote to build the list of pellet positions  
```  
(define (build-pel-xy x y)  
  (define (builder-xy x y count lst)  
          ;;;;;;;;;;;; ROW 1 ;;;;;;;;;;;;  
    (cond ((and (>= count 0) (< count 12)) ;; 12 Pellets  
           (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y)))))  
          ((and (>= count 12) (<= count 24))  
           (if (= count 12)  
               (builder-xy (+ x 37) y (add1 count) (append lst (list (make-posn (+ x 37) y))))    
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))  
```  
  
There is an initial call in the main source file ```(define PEL-POS (build-pel-xy 25 35))``` which calls ```build-pel-xy``` with the starting coordinates of the first pellet in the upper left corner of the maze. ```build-pel-xy``` then calls its helper function ```builder-xy``` with ```(builder-xy x y 0 '())``` to start. Passing 0 as the ```count``` parameter, and ```'()``` as the initial list.  
  
Then, ```builder-xy``` uses a series of ```cond``` statements to determine a starting point for coordinates (changing the x or y values to start the building of a new row/column, based on the current value of the count) and calls itself, passing an updated x/y, an updated count, and appending the new x/y to the list argument and passing the updated list as well.  
  
The end result is a list of positions that can be used with ```2htdp/image```'s ```place-images``` function to draw all the pellets in one simple call.  
  
## 3. Data Abstraction  
  
The same procedure mentioned above, ```builder-pel-xy``` also utilizes another idea from the class. Data Abstraction.  
  
The ```lang/posn``` library provided the position object that we used for the pellet locations.  

  In the code below  
```(builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y)))```  
  
the ```make-posn``` call is a constructor for the ```posn``` struct. Like the examples in class (ps2b) ```make-posn``` creates an object that we can use to manage an x and y value for an image objects position.  
  
in the ```check-pel``` procedure I used the ```posn-x``` and ```posn-y``` getters to get the data from these objects, so I could check to see if the player is close enough to collect it, which can be seen the code excerpt below  
```  
...  
((and (<= x (+ (posn-x pel) X-OFFSET)) (>= x (posn-x pel))) ;; check if rackman is lined up along X with any pellets  
                                          (if (and (>= y (- (posn-y pel) Y-OFFSET)) (<= y (+ (posn-y pel) Y-OFFSET))) ;; check if rackman is lined up along Y with any pellets  
...  
```  
  
## 4. State Modification and Management  
  
We used a number of different state variables to note player/ghost direction. However, a core piece of the games logic is based on the state of the game "world".  
  
The ```2htdp/universe``` library uses a state variable known as [WorldState](https://docs.racket-lang.org/teachpack/2htdpuniverse.html#%28tech._world._worldstate%29). This state is used to determine how to draw the scenes, and what to do on each tick.  
  
Below is the initialization of the games world.  
```  
;;;;;;;;;;;;;;;;;;   
;;;; BIG-BANG ;;;;  
;;;;;;;;;;;;;;;;;;  
;; defines the functions that run the world  
;; tick-handler      - runs every tick and updates the world sate  
;; draw-world        - takes in the world state and draws the appropriate scene  
;; key-press-handler - handles user inputs from keyboard  
;; game-over         - determines when to end the world  
;; high-score        - score tracking service, runs when game-over returns true  
(big-bang 0  
          (on-tick tick-handler)  
          (to-draw draw-world)  
          (on-key key-press-handler)  
          (name "Rack-Man v3.0")  
          (stop-when game-over high-score))  
```  
  
The 0 after ```big-bang``` is the initial WorldState. This is passed to each of the functions listed in ```big-bang```. These function read in the world state, and determine the appropriate course of action, and return the world state, either modified or left unchanged.  
  
For example, the ```draw-world``` function below.  
```  
;;;;;;;;;;;;;;;;;;;;    
;;;; DRAW-WORLD ;;;;  
;;;;;;;;;;;;;;;;;;;;  
; take in the world state 't' and render the appropriate scene  
(define (draw-world t) ;<-- the t-parameter is our WorldState  
  (if (list? t)  
      ;START GAME STATE -- if 't' is a list, it indicates the game running state, so we draw  
      (begin  
        (place-image RACKMAN;(scale/xy .1 .1 RACKMAN) ; place Rack-Man in the word at the given coordinates  
                     (car t)  ; x  
                     (cadr t) ; y  
                     (place-image (scale/xy .2 .2 INKY) ; place the ghost in the world at the given coordinates  
                                  (third t)  ; x  
                                  (fourth t) ; y  
                                  (place-image MAZE  
                                               250 250  
                                               (place-images PEL-IMG PEL-POS (place-image (text "Score: " 24 "white") 40 505 (place-image (text (~a SCORE) 24 "white") 87 505 SCENE)))))))  
      ;SPLASH SCREEN STATE -- if 't' is not a list, it indicates the initial world state, so display the splash screen  
      (place-image (text "Press Shift to Start!" 24 "white")  
                   250 400 ; x y  
                   (place-image SPLASH  
                                250 250  
                                SCENE))))  
```  
  
This code takes the world state ```t``` as an argument, and first checks if it is a list or not. This check is performed because, the initial state of the world is just 0, not a list, and so by determining the state is not a list, we know to draw the initial splash screen for the game using the ```2htdp/image``` library.  
  
If it is a list, the we know player has started the game, and our world state is now in the form ```'( Player X, Player Y, Ghost X, Ghost Y)```. So ```draw-world``` now can take this state and draw the scene and place the player and ghost in their correct place.  
  
The actual modification of the state is done through the ```tick-handler```.  
```  
;;;;;;;;;;;;;;;;;;;;;;   
;;;; TICK-HANDLER ;;;;  
;;;;;;;;;;;;;;;;;;;;;;  
; every tick (default 28/second),  
;  check the state for the key presses  
;  if the state is true, move rackman in that direction by updating his X,Y cooridantes  
(define (tick-handler w)  
  (begin  
    (if (equal? w 0)  
        w  
        (cond ((not (list? w)) w)  
              ;HANDLE ARROW KEY COMMANDS  
              ((equal? LEFT #t)  
               (if (equal? (maze-check (car w) (cadr w) L-DIR-WALLS) #t) ;; check for collision with maze  
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))  
                   ; move to the opposite end when passing through the left opening  
                   (cond ((<= (car w) 0) (list (+ (car w) 495) (cadr w) (ghost "x" w) (ghost "y" w)))  
                         (else (list (- (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))))  
              ((equal? RIGHT #t)  
               (if (equal? (maze-check (car w) (cadr w) R-DIR-WALLS) #t) ;; check for collision with maze  
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))  
                   ; move to the opposite end when passing through the right opening  
                   (cond ((>= (car w) 500) (list (- (car w) 495) (cadr w) (ghost "x" w) (ghost "y" w)))  
                         (else (list (+ (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))))  
              ((equal? DOWN #t)  
               (if (equal? (maze-check (car w) (cadr w) D-DIR-WALLS) #t) ;; check for collision with maze  
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))  
                   (list (car w) (+ (cadr w) SPEED) (ghost "x" w) (ghost "y" w))))  
              ((equal? UP #t)  
               (if (equal? (maze-check (car w) (cadr w) U-DIR-WALLS) #t) ;; check for collision with maze  
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))  
                   (list (car w) (- (cadr w) SPEED) (ghost "x" w) (ghost "y" w))))  
              (else w)))))  
```  
  
This is the main driver for the game. On every tick (which is running at 28 ticks/second, the default), it takes in the world state ```w``` and checks the player movement states (UP,DOWN,LEFT,RIGHT) to determine which direction the player is moving. It then updates the WorldState to reflect the movement of the player, and passes off to the ```ghost``` function to update the ghosts position.  
  
This function returns an updated WorldState, which is read by ```draw-world``` so the scene can be drawn, and read again by the next tick and so on until the win or lose conditions are met.  
