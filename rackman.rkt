#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;;;; RACK-MAN ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; WRITTEN BY ;;;;;;;;;;;;;;
;;      Kevin Fossey @kfozz        ;;
;; Mohammed Nayeem @mohammednayeem ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; a reaction of pac-man in racket ;;

; Libraries
(require 2htdp/universe
         2htdp/image
         lang/posn
         RSound
         net/url
         net/sendurl)
(require "coords.rkt")

; GLOBAL VARIABLES
(define LEFT #f)
(define RIGHT #f)
(define DOWN #f)
(define UP #f)
(define NAME "RackManPlayer")
(define SCORE 0)
(define NEXT-DIR 0)
(define START #f)
(define SPEED 2)
(define GHOST-SPEED 2)
(define GHOST-DIR 1)
(define DEBUGGER 0)
(define GHOST-CHECK 13)
(define GHOSTX-OFFSET 8)
(define GHOSTY-OFFSET 10)
(define X-OFFSET 10)
(define Y-OFFSET 10)
(define OPEN 0)
(define hsURL "")
(define WONGAME 0)
(define website "http://107.170.57.126")
(define ip "http://107.170.57.126/addscore.php?name=")
(define addAnd "&")
(define scoreParam "score=")
(define THEME (rs-read "./racktheme_01.wav"))
(define EATSOUND (rs-read "./pacman_chomp.wav"))
(define SPLASH (bitmap/file "./splash.png"))
(define END-SCREEN (bitmap/file "./end.png"))
(define MAZE (bitmap/file "./maze_v3.png"))
(define RACKMAN (bitmap/file "./rackman_right.png"))
(define INKY (bitmap/file "./inky.png"))
(define PELLET (circle 3 "solid" "white"))
(define SCENE (rectangle 500 515 "solid" "black"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PEL-POS (build-pel-xy 25 35)) ;; Makes the call to build the list of posn objects for the pellets

;;;;;;;;;;;;;;;;;;;;;;; 
;;;; BUILD-PEL-IMG ;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;returns a list of image objects equal to the number of positions created above
(define (build-pel-img img)
  (define (builder-img count img lst)
    (if (= count (length PEL-POS))
        lst
        (builder-img (add1 count) img (append lst (list img)))))
  (builder-img 0 img '()))

(define PEL-IMG (build-pel-img PELLET)) ;; Makes the call to build the list of image objects for the pellets

(define PELLETS (length PEL-POS)) ;; variable to hold the number of pellets
 

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;; KEY-PRESS-HANDLER  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if the user presses any arrow key, update the state variable for those keys, and reset the state for each other key
(define (key-press-handler w x)
  (cond ((key=? x "shift") (if(equal? START #f)
                              (begin
                                ;(play THEME)
                                (set! START #t)
                                (list 250 374 250 186)) ;; starting position of RackMan and Ghost
                              w))
        ((key=? x "rshift") (if(equal? START #f)
                              (begin
                                (default-sample-rate 44100)
                                (play THEME)                                
                                (set! START #t)
                                (list 250 374 250 186))  ;; starting position of RackMan and Ghost
                              w))
        ((key=? x "left") (begin
                            (set! RACKMAN (bitmap/file "./rackman_left.png"))
                            (set! LEFT #t)
                            (set! RIGHT #f)
                            (set! DOWN #f)
                            (set! UP #f)
                            w))
        ((key=? x "right") (begin
                             (set! RACKMAN (bitmap/file "./rackman_right.png"))
                             (set! LEFT #f)
                             (set! RIGHT #t)
                             (set! DOWN #f)
                             (set! UP #f)
                             w))
        ((key=? x "up") (begin
                          (set! RACKMAN (bitmap/file "./rackman_up.png"))
                          (set! LEFT #f)
                          (set! RIGHT #f)
                          (set! DOWN #f)
                          (set! UP #t)
                          w))
        ((key=? x "down") (begin
                            (set! RACKMAN (bitmap/file "./rackman_down.png"))
                            (set! LEFT #f)
                            (set! RIGHT #f)
                            (set! DOWN #t)
                            (set! UP #f)
                            w))
        (else w))) ; any other key press, just return an unaltered world state

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

;;;;;;;;;;;;;;;;;;;; 
;;;; CHECK MAZE ;;;;
;;;;;;;;;;;;;;;;;;;;
;;; x -> Rack-Mans x pos
;;; y -> Rack-mans y pos
;;; lst -> The list of walls that Rack-man could run into given his current direction
;;; using foldl to check Rack-Mans x or y (check x if moving left/right, check y if moving up/down)
;;  against each element in the wall list. If a match is found, 
;;; Returns #t if a collision is detected (match found)
;;; Returns #f if no collision is detected (no match found)
(define (maze-check x y lst)
  (begin
    (if (equal? (check-pel x y) #t)
        0;(display "YES") ; increase score
        0);(display "NO")); nothing
    (cond ((equal? lst L-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (<= x (+ (first wall) X-OFFSET)) (>= x (first wall))) ;; check if rackman is lined up along X with any walls
                                            (if (and (>= y (- (second wall) Y-OFFSET)) (<= y (+ (fourth wall) Y-OFFSET))) ;; check if rackman is is lined up along Y with any walls
                                                (begin
                                                  (when (equal? DEBUGGER 1) 
                                                    (begin(display "LEFT: (")
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
          ((equal? lst D-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (>= y (- (second wall) Y-OFFSET)) (<= y (second wall))) ;; check if rackman is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) X-OFFSET)) (<= x (+ (third wall) X-OFFSET))) ;; check if rackman is lined up along X with any walls
                                                (begin
                                                  (when (equal? DEBUGGER 1) 
                                                    (begin(display "DOWN: (")
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
          ((equal? lst U-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (<= y (+ (second wall) Y-OFFSET)) (>= y (second wall))) ;; check if rackman is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) X-OFFSET)) (<= x (+ (third wall) X-OFFSET))) ;; check if rackman is lined up along X with any walls
                                                (begin
                                                  (when (equal? DEBUGGER 1) 
                                                    (begin(display "UP: (")
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
          (else #f))))

;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;; GHOST-MAZE-CHECK ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; x -> Ghost x pos
;;; y -> Ghost y pos
;;; lst -> The list of walls that the ghost could run into given his current direction
;;; using foldl to check the ghosts x or y (check x if moving left/right, check y if moving up/down)
;;  against each element in the wall list. If a match is found, 
;;; Returns #t if a collision is detected (match found)
;;; Returns #f if no collision is detected (no match found)
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
          ((equal? lst R-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (>= x (- (first wall) GHOSTX-OFFSET)) (<= x (first wall))) ;; check if ghost is lined up along X with any walls
                                            (if (and (>= y (- (second wall) GHOSTY-OFFSET)) (<= y (+ (fourth wall) GHOSTY-OFFSET))) ;; check if ghost is is lined up along Y with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          ((equal? lst D-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (>= y (- (second wall) GHOSTY-OFFSET)) (<= y (second wall))) ;; check if ghost is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) GHOSTX-OFFSET)) (<= x (+ (third wall) GHOSTX-OFFSET))) ;; check if ghost is lined up along X with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          ((equal? lst U-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (<= y (+ (second wall) GHOSTY-OFFSET)) (>= y (second wall))) ;; check if ghost is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) GHOSTX-OFFSET)) (<= x (+ (third wall) GHOSTX-OFFSET))) ;; check if ghost is lined up along X with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          (else #f))))

;;;;;;;;;;;;;;;;;;; 
;;;; CHECK-PEL ;;;;
;;;;;;;;;;;;;;;;;;;
;;; x -> Rack-Mans x pos
;;; y -> Rack-mans y pos
;;; check if rackmans position matches the position of any pellets,
;;; if it does, remove that pellet
(define (check-pel x y)
  (cond ((equal? LEFT #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (<= x (+ (posn-x pel) X-OFFSET)) (>= x (posn-x pel))) ;; check if rackman is lined up along X with any pellets
                                          (if (and (>= y (- (posn-y pel) Y-OFFSET)) (<= y (+ (posn-y pel) Y-OFFSET))) ;; check if rackman is is lined up along Y with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                ;(play EATSOUND)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? RIGHT #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (>= x (- (posn-x pel) X-OFFSET)) (<= x (posn-x pel))) ;; check if rackman is lined up along X with any pellets
                                          (if (and (>= y (- (posn-y pel) Y-OFFSET)) (<= y (+ (posn-y pel) Y-OFFSET))) ;; check if rackman is is lined up along Y with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                ;(play EATSOUND)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? DOWN #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (>= y (- (posn-y pel) Y-OFFSET)) (<= y (posn-y pel))) ;; check if rackman is is lined up along Y with any pellets
                                          (if (and (>= x (- (posn-x pel) X-OFFSET)) (<= x (+ (posn-x pel) X-OFFSET))) ;; check if rackman is lined up along X with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                ;(play EATSOUND)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? UP #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (<= y (+ (posn-y pel) Y-OFFSET)) (>= y (posn-y pel))) ;; check if rackman is is lined up along Y with any pellets
                                          (if (and (>= x (- (posn-x pel) X-OFFSET)) (<= x (+ (posn-x pel) X-OFFSET))) ;; check if rackman is lined up along X with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                ;(play EATSOUND)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        (else #f)))

;;;;;;;;;;;;;;; 
;;;; GHOST ;;;;
;;;;;;;;;;;;;;;
; handles ghost movement
; calls ghost-maze-check to check for collisions with walls.
; if no collisions are detected it returns an updated x/y position for the ghost,
; otherwise it returns x/y positions to bounce the ghost back
(define (ghost d w)
  (cond ((= GHOST-DIR 1);LEFT
         (if (equal? d "x")
             (if (equal? (ghost-maze-check (third w) (fourth w) L-DIR-WALLS) #t)
                 (begin
                   (set! GHOST-DIR (next-ghost-dir (third w) (fourth w) (first w) (second w))) ;change ghost direction
                   (+ (third w) 2)) ; bounce the ghost back
                 (- (third w) GHOST-SPEED)) ; return updated x value
             (fourth w))) ; return y value
        ((= GHOST-DIR 2);RIGHT
         (if (equal? d "x")
             (if (equal? (ghost-maze-check (third w) (fourth w) R-DIR-WALLS) #t)
                 (begin
                   (set! GHOST-DIR (next-ghost-dir (third w) (fourth w) (first w) (second w))) ;change ghost direction
                   (- (third w) 2)) ; bounce the ghost back
                 (+ (third w) GHOST-SPEED)) ; return updated x value
             (fourth w))) ; return y value
        ((= GHOST-DIR 3);DOWN
         (if (equal? d "x")
             (third w) ; return x value
             (if (equal? (ghost-maze-check (third w) (fourth w) D-DIR-WALLS) #t)
                 (begin
                   (set! GHOST-DIR (next-ghost-dir (third w) (fourth w) (first w) (second w))) ;change ghost direction
                   (- (fourth w) 2)) ; bounce the ghost back
                 (+ (fourth w) GHOST-SPEED)))) ; return updated y value
        ((= GHOST-DIR 4);UP
         (if (equal? d "x")
             (third w) ; return x value
             (if (equal? (ghost-maze-check (third w) (fourth w) U-DIR-WALLS) #t)
                 (begin
                   (set! GHOST-DIR (next-ghost-dir (third w) (fourth w) (first w) (second w))) ;change ghost direction
                   (+ (fourth w) 2)) ; bounce the ghost back
                 (- (fourth w) GHOST-SPEED)))))) ; return updated y value


;;;;;;;;;;;;;;;;;;;;;;;; 
;;;; NEXT-GHOST-DIR ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; depending on the direction the ghost is moving and
;; his location relative to Rack-Man determine which
;; direction to move in. (this is called after the ghost hits a wall)
(define (next-ghost-dir gx gy rx ry)
  (cond ((equal? GHOST-DIR 1);LEFT
         (begin
         (if (<= rx gx)
             (if (>= ry gy);;pick between up and down
                 (cond ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); move down if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); if not, move up if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                 (cond ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); move up if possible
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); if not, move down if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                 )
             (if (>= (abs (- gx rx)) (abs (- gy ry)));;pick between up and down and right
                 (cond ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2) ; move right if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4)
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3))
                 (if (>= ry gy);;pick between up and down
                     (cond ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); move down if possible
                           ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); if not, move up if possible
                           ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                     (cond ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); move up if possible
                           ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); if not, move down if possible
                           ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                     )))))
        ((equal? GHOST-DIR 2);RIGHT
         (if (>= rx gx)
             (if (>= ry gy);;pick between up and down
                 (cond ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); move down if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); if not, move up if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1)); if not move left
                 (cond ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); move up if possible
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); if not, move down if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1)); if not move left
                 )
             (if (>= (abs (- gx rx)) (abs (- gy ry)));;pick between up and down and left
                 (cond ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); move left if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); if not, move up if possible
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3)); if not move down
                 (if (>= ry gy);;pick between up and down
                     (cond ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); move down if possible
                           ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); if not, move up if possible
                           ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1)); if not move left
                     (cond ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); move up if possible
                           ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); if not, move down if possible
                           ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1)); if not move left
                     ))))
        ((equal? GHOST-DIR 3);DOWN
         (if (>= ry gy)
             (if (>= rx gx);;pick between left and right
                 (cond ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); move right if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4)); if not move up
                 (cond ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); move left if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); if not, move right if possible
                       ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4)); if not move up
                 )
             (if (<= (abs (- gy ry)) (abs (- gx rx)));;pick between left and righ and up
                 (if (>= rx gx);;pick between left and right
                     (cond ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); move right if possible
                           ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                           ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4)); if not move up
                     (cond ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); move left if possible
                           ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); if not, move right if possible
                           ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4))); if not move up
                  (cond ((equal? (ghost-maze-check gx gy U-DIR-WALLS) #f) 4); move up if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                     )))
        ((equal? GHOST-DIR 4);UP
         (if (<= ry gy)
             (if (>= rx gx);;pick between left and right
                 (cond ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); move right if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3)); if not move down
                 (cond ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); move left if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); if not, move right if possible
                       ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3)); if not move down
                 )
             (if (<= (abs (- gy ry)) (abs (- gx rx)));;pick between left and righ and down
                 (if (>= rx gx);;pick between left and right
                     (cond ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); move right if possible
                           ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                           ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3)); if not move down
                     (cond ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); move left if possible
                           ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2); if not, move right if possible
                           ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3))); if not move down
                 (cond ((equal? (ghost-maze-check gx gy D-DIR-WALLS) #f) 3); move down if possible
                       ((equal? (ghost-maze-check gx gy L-DIR-WALLS) #f) 1); if not, move left if possible
                       ((equal? (ghost-maze-check gx gy R-DIR-WALLS) #f) 2)); if not move right
                     )))))

;;;;;;;;;;;;;;;;;;; 
;;;; GAME-OVER ;;;;
;;;;;;;;;;;;;;;;;;;
;; checks for a collision between ghost and player
;; -or-
;; checks for all the pellets to be collected
;; either result in the game ending, and start the high-score process
(define (game-over w)
  (cond ((equal? w 0) #f)
        ((equal? (check-ghost (list (first w) (second w)) (list (third w) (fourth w))) #t)#t)
        ((equal? SCORE 268)(begin (set! WONGAME 1) #t))
        (else #f)))


;;;;;;;;;;;;;;;;;;;;; 
;;;; CHECK-GHOST ;;;;
;;;;;;;;;;;;;;;;;;;;;
; check the position of the ghost relative to rack-man
; r -> '(x y) for rack-man
; g -> '(x y) for ghost
; To account for the size of rack-man and the ghost, an offset is used to check positions
(define (check-ghost r g)
  (cond ((equal? LEFT #t)
           (if (and (>= (first g) (- (first r) GHOST-CHECK)) (<= (first g) (first r)))
                (if (and (>= (second g) (- (second r) GHOST-CHECK)) (<= (second g) (+ (second r) GHOST-CHECK)))
                    #t
                    #f)
                #f))
        ((equal? RIGHT #t)
         (if (and (<= (first g) (+ (first r) GHOST-CHECK)) (>= (first g) (first r)))
                (if (and (>= (second g) (- (second r) GHOST-CHECK)) (<= (second g) (+ (second r) GHOST-CHECK)))
                    #t
                    #f)
                #f))
        ((equal? UP #t)
         (if (and (>= (second g) (- (second r) GHOST-CHECK)) (<= (second g) (second r)))
                (if (and (>= (first g) (- (first r) GHOST-CHECK)) (<= (first g) (+ (first r) GHOST-CHECK)))
                    #t
                    #f)
                #f))
        ((equal? DOWN #t)
         (if (and (<= (second g) (+ (second r) GHOST-CHECK)) (>= (second g) (second r)))
                (if (and (>= (first g) (- (first r) GHOST-CHECK)) (<= (first g) (+ (first r) GHOST-CHECK)))
                    #t
                    #f)
                #f))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GETHIGHSCORELINK ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; build the url for the high-score server
(define(getHighScoresLink)
  (begin
    (set! hsURL (string-append ip (~a NAME)))
    (set! hsURL (string-append hsURL addAnd))
    (set! hsURL (string-append hsURL scoreParam))
    (set! hsURL (string-append (~a hsURL SCORE)))
    (call/input-url (string->url hsURL)
                get-pure-port
                port->string))
  )

;;;;;;;;;;;;;;;;;;;; 
;;;; HIGH-SCORE ;;;;
;;;;;;;;;;;;;;;;;;;;
; High Scores to save online
; 1. Gets the user's name from the terminal
; 2. Constructs the link for the high scores and sends it to the web server
; 3. Opens the high score page for users to check out
(define (high-score w)
  (begin
    (set! NAME (read))
    (getHighScoresLink)
    (send-url website))
  (if(equal? WONGAME 1)
       (place-image (text "Woah, you actually won! GOOD JOB!" 24 "white")
                   250 400 ; x y
                   (place-image END-SCREEN
                                250 250
                                (rectangle 500 500 "outline" "black")))
         (place-image (text "Game Over! Better luck next time!" 24 "white")
                   250 400 ; x y
                   (place-image END-SCREEN
                                250 250
                                (rectangle 500 500 "outline" "black"))))
)

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




