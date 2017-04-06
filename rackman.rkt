#lang racket
;; RACK-MAN
;; Kevin Fossey @kfozz
;; Mohammed Nayeem @mohammednayeem

;Libraries
(require 2htdp/universe
         2htdp/image
         RSound)

; GLOBAL VARIABLES
(define LEFT #f)
(define RIGHT #f)
(define DOWN #f)
(define UP #f)
(define START #f)
(define SPEED 3)
(define OPEN 0)
(define SPLASH (bitmap/file "./splash.png"))
(define RACKMAN (bitmap/file "./rackman_right_c.png"))
(define INKY (bitmap/file "./inky.png"))

; DRAW THE WORLD
; take in the world state 't' and render the appropriate scene
(define (myWorld t) ;<-- the t-parameter is our WorldState
  (if (list? t)
      ;START GAME STATE -- if 't' is a list, it indicates the game running state, so we draw 
      (place-image (scale/xy .1 .1 RACKMAN) ; place Rack-Man in the word at the given coordinates
                   (car t)  ; x
                   (cadr t) ; y
                   (place-image (scale/xy .2 .2 INKY) ; place the ghost in the world at the given coordinates
                                (third t)  ; x
                                (fourth t) ; y
                                (rectangle 500 500 "solid" "black")))
      ;SPLASH SCREEN STATE -- if 't' is not a list, it indicates the initial world state, so display the splash screen
      (place-image (text "press shift to start!" 24 "white")
                   250 250 ; x y
                   (place-image SPLASH
                                250 250
                                (rectangle 500 500 "outline" "black")))))
                 
; KEY PRESS HANDLER
; if the user presses any arrow key, update the state variable for those keys, and reset the state for each other key
(define (react w x)
  (cond ((key=? x "rshift") (if(equal? START #f)
                              (begin
                                (set! START #t)
                                (list 50 50 75 75))
                              w))
        ((key=? x "left") (begin
                            (set! RACKMAN (bitmap/file "./rackman_left_c.png"))
                            (set! LEFT #t)
                            (set! RIGHT #f)
                            (set! DOWN #f)
                            (set! UP #f)
                            w))
                          ; old method, manually updating movement on key press
                          ;(begin
                            ;(play ding)
                            ;(list (- (car w) 3) (cadr w) (third w) (fourth w))))
        ((key=? x "right") (begin
                             (set! RACKMAN (bitmap/file "./rackman_right_c.png"))
                             (set! LEFT #f)
                             (set! RIGHT #t)
                             (set! DOWN #f)
                             (set! UP #f)
                             w));
                           ; old method, manually updating movement on key press
                           ;(begin
                            ;(play ding)
                            ;(list (+ (car w) 3) (cadr w) (third w) (fourth w))))
        ((key=? x "up") (begin
                          (set! RACKMAN (bitmap/file "./rackman_up_c.png"))
                          (set! LEFT #f)
                          (set! RIGHT #f)
                          (set! DOWN #f)
                          (set! UP #t)
                          w))
                         ; old method, manually updating movement on key press
                         ;(begin
                            ;(play ding)
                            ;(list (car w) (- (cadr w) 3) (third w) (fourth w))))
        ((key=? x "down") (begin
                            (set! RACKMAN (bitmap/file "./rackman_down_c.png"))
                            (set! LEFT #f)
                            (set! RIGHT #f)
                            (set! DOWN #t)
                            (set! UP #f)
                            w))
                           ; old method, manually updating movement on key press
                           ;(begin
                            ;(play ding)
                            ;(list (car w) (+ (cadr w) 3) (third w) (fourth w))))
        (else w))) ; any other key press, just return an unaltered world state

; ON TICK HANDLER
; every tick (default 28/second),
;  check the state for the key presses
;  if the state is true, move rackman in that direction by updating his X,Y cooridantes
(define (tick-handler w)
  (begin
    ;(if(equal? (remainder OPEN 28) 0) ;
    ;   (begin (set! OPEN 0) (set! RACKMAN (bitmap/file "./rackman_right_o.png")))
    ;   (begin (set! OPEN (add1 OPEN)) (set! RACKMAN (bitmap/file "./rackman_right_c.png"))))
    (cond ((not (list? w)) w)
          ;HANDLE ARROW KEY COMMANDS
          ((equal? LEFT #t)
             (list (- (car w) SPEED) (cadr w) (third w) (fourth w)))
          ((equal? RIGHT #t)
             (list (+ (car w) SPEED) (cadr w) (third w) (fourth w)))
          ((equal? DOWN #t)
             (list (car w) (+ (cadr w) SPEED) (third w) (fourth w)))
          ((equal? UP #t)
             (list (car w) (- (cadr w) SPEED) (third w) (fourth w)))
          (else w))))

; WORLD
(big-bang 0;'(50 50 75 75)
          (on-tick tick-handler)
          (to-draw myWorld)
          (on-key react))




