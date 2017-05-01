# Rack-Man  
  
## Mohammed Nayeem  
### April 30, 2017  
  
# Overview  
  
This project is a resemblance of the classic game "Pac-Man". The game was written in Racket using many different libraries.

The goal of the game is to collect all the pellets and avoid being eaten by the ghost. 

  
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
  
* The ```2htdp/universe``` library allows us to create an environment where we can manipulate certain objects based on our logic.  
* The ```2htdp/image``` library provides us with the ability to create images with different properties.
* The ```lang/posn``` library is used to create position objects for graphics objects in the game  
* The ```RSound``` library is used play sound from a file within the game.
* The ```net/url``` library allows us to send the player's name and score to a database which is then stored on the server.  
* The ```net/sendurl``` library is used to open the created url within the game in a browser. 
  
# Key Code Excerpts  
  
Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.  
  
## 1. Object Orientation Approach  
When we first started this project, we knew from the start we would need to use some sort of object oriented approach to save the state of different things of Rack-Man. We began the project by just using a global variable and changing it using '''set!'''. I cleaned up the code by converting it over to an object.

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
This piece of code creates five different variables within the object. There are many setter and getter function that I created that was used to change the direction of Rack-Man as well as being able to add a point when a pellet is eaten. This code is like what we had to do in PS4 where we had to change the way the bank account worked with a secret password. 

```
(define rack-man (make-rackman 0 #t #f #f #f))
```
This next piece of code holds the object named as rack-man. It sets the score to 0 and sets the direction to go to left. The parameters read as left, right, up down. Only one of the parameters will show as true which is be the direction Rack-Man is going.

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

This piece of code just changes the state of Rack-Man by updating the Boolean that Rack-Man is going in. When ```(key=? x "right")``` is true, the rack-man object sets all the variables except up to false. Kevin's code then updates the list with rackman's position so it moves up.
There was also state modification in the creation of the object.

## 3. Constructing a link using various strings
The high scores were what I wanted to do to include an external source. I decided that I wanted to create a page using PHP and MYSQL for the database.
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

I was very happy that I got to do this because it gave me the opportunity to not only learn a bit about another language but also being able to learn about the things needed to set up things server sided.

## 4. Foldl
When we first started working on the maze, we couldn't come up with a solution on how to get the maze working. We knew we'd have the map out the entire maze (very big pain in the butt) but we didn't know what approach we would take to complete it. At first Kevin recommended we use recursion like all the other functions he created to make it work. We looked around and I came up with the idea to use foldl. We'd essentially create some lists of all the walls in each direction and then use fold to determine if it's within the list.
```
((equal? lst R-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (>= x (- (first wall) X-OFFSET)) (<= x (first wall))) ;; check if rackman is lined up along X with any walls
                                            (if (and (>= y (- (second wall) Y-OFFSET)) (<= y (+ (fourth wall) Y-OFFSET))) ;; check if rackman is is lined up along Y with any walls
                                                (begin
                                                  (when (equal? DEBUGGER 1) 
                                                    (begin(display "RIGHT: (")
                                                          (display (first wall))
                                                          (display " ")
                                                          (display (second wall))
                                                          (display " ")
                                                          (display (third wall))
                                                          (display " ")
                                                          (display (fourth wall))
                                                          (display ")")
                                                          (display " \n")))
                                                  #t)
                                                #f))
                                           (else #f)))
                  #f
                  lst))
```

After agreeing on using fold, Kevin came up with the code to make the maze walls work. This same logic was then implemented into the ghost check too which uses fold as well.

