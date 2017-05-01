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
  
## 1. Object Orientation Approach  
When we first started this project, we knew from the start we would need to use some sort of object oriented approach in order to save the state of different things of Rack-Man. We began the project by just using a global variable and changing it using '''set!'''. I was able to take this change this into an object to be used.

```
;;;;;;;;;;;;;;;;;;;;;;; 
;;;; RACK-MAN OBJECT ;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;CREATES LEFT, RIGHT, UP, DOWN, AND SCORE VARIABLES AND STORES IN THE OBJECT
(define (make-rackman scores go-left go-right go-up go-down)
	(define (set-left)
		(begin (set! go-left #t)
			(set! go-right #f)
			(set! go-up #f)
			(set! go-down #f)))
	(define (set-right)
		(begin (set! go-left #f)
			(set! go-right #t)
			(set! go-up #f)
			(set! go-down #f)))
	(define (set-up)
		(begin (set! go-left #f)
			(set! go-right #f)
			(set! go-up #t)
			(set! go-down #f)))
	(define (set-down)
		(begin (set! go-left #f)
			(set! go-right #f)
			(set! go-up #f)
			(set! go-down #t)))
	(define (addScore)
		(set! scores (+ scores 1)))
	(define (getScore)
		scores)
	(define (get-left)
		go-left)
	(define (get-right)
		go-right)
	(define (get-up)
		go-up)
	(define (get-down)
		go-down) 
	(define (dispatch m)
		(cond ((eq? m 'set-left) set-left)
			  ((eq? m 'set-right) set-right)
			  ((eq? m 'set-up) set-up)
			  ((eq? m 'set-down) set-down)
			  ((eq? m 'addScore) addScore)
			  ((eq? m 'getScore) getScore)
			  ((eq? m 'get-left) get-left)
			  ((eq? m 'get-right) get-right)
			  ((eq? m 'get-up) get-up)
			  ((eq? m 'get-down) get-down)
			  (else (error "Unknown request "
						   m))))
  dispatch)
 ```
This piece of code keeps track of the score as well as the direction that Rack-Man is facing. When the player hits the right key, Rack-Man changes the booleans of each variable in the object. This code is very similar to the work we did in PS4 using the the example of bank accounts. 

```
(define rack-man (make-rackman 0 #t #f #f #f))
```
This next piece of code creates the actual object. It sets the score to 0 and sets the direction to go to left. The parameters read as left, right, up down. Only one of the parameters will show as true which is be the direction Rack-Man is going.

## 2. State Modification
```
        ((key=? x "left") (begin
                            (set! RACKMAN (bitmap/file "./rackman_left.png"))
                            ((rack-man 'set-left))
                            w))
        ((key=? x "right") (begin
                             (set! RACKMAN (bitmap/file "./rackman_right.png"))
                             ((rack-man 'set-right))
                             w))
        ((key=? x "up") (begin
                          (set! RACKMAN (bitmap/file "./rackman_up.png"))
                          ((rack-man 'set-up))
                          w))
        ((key=? x "down") (begin
                            (set! RACKMAN (bitmap/file "./rackman_down.png"))
                            ((rack-man 'set-down))
                            w))
        (else w))) ; any other key press, just return an unaltered world state
```

This piece of code just changes the state of Rack-Man by updating the boolean that Rack-Man is going in. When ```(key=? x "right")``` is true, the rack-man object sets all the variables except up to false. Kevin's code then updates the list with rackman's posotion so it actually moves up.
There was also state modification in the creation of the object.

## 3. Constructing a link using various strings
The high scores was what I wanted to do to include an external source. I decided that I wanted to create a page using PHP and MYSQL for the database.
```
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GETHIGHSCORELINK ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; build the url for the high-score server
(define(getHighScoresLink)
  (begin
    (set! hsURL (string-append ip (~a NAME)))
    (set! hsURL (string-append hsURL addAnd))
    (set! hsURL (string-append hsURL scoreParam))
    (set! hsURL (string-append (~a hsURL ((rack-man 'getScore)))))
    (call/input-url (string->url hsURL)
                get-pure-port
                port->string))
  )
```
I'm not sure if there is an easier way of doing this but from previous assignments I decided to do it like this. 
This function takes a global variable named ```hsURL``` and combines it with string ip and another variable which is turned into a string named NAME. It is then appended with ```addAnd``` which is just a &. The next thing that is add is a string named ```scoreParam``` which just holds the string ```score=``` for the url. The final thing that is added is ```((rack-man 'getScore))```. This pulls the score from the rack-man object and places it to the end of the link. 
The call/input-url function then takes ```hsURL``` and then opens it within a browser so the player can view it.

