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
(define SPEED 3)
(define RACKMAN (bitmap/file "./rackman1.png"))
(define INKY (bitmap/file "./inky.png"))

; WORLD STATE
(define (myWorld t) ;<-- the t-parameter is our WorldState
    (place-image (scale/xy .1 .1 RACKMAN);(circle 10 "solid" "yellow")
                 (car t) ;<-- here now x variable coordinate
                 (cadr t) ;<-- here now y variable, instead of 150
                 (place-image (scale/xy .2 .2 INKY);(circle 10 "solid" "green")
                              (third t) ;<-- here now x variable coordinate
                              (fourth t) ;<-- here now y variable, instead of 150
                              (rectangle 500 500 "solid" "black"))))
                 
; KEY PRESS HANDLER
; if the user presses any arrow key, update the state variable for those keys, and reset the state for each other key
(define (react w x)
  (cond ((key=? x "left") (begin (set! LEFT #t)
                                 (set! RIGHT #f)
                                 (set! DOWN #f)
                                 (set! UP #f)
                                 w))
                          ; old method, manually updating movement on key press
                          ;(begin
                            ;(play ding)
                            ;(list (- (car w) 3) (cadr w) (third w) (fourth w))))
        ((key=? x "right") (begin
                             (set! LEFT #f)
                             (set! RIGHT #t)
                             (set! DOWN #f)
                             (set! UP #f)
                             w));(begin
                            ;(play ding)
                            ;(list (+ (car w) 3) (cadr w) (third w) (fourth w))))
        ((key=? x "up") (begin
                          (set! LEFT #f)
                          (set! RIGHT #f)
                          (set! DOWN #f)
                          (set! UP #t)
                          w));(begin
                            ;(play ding)
                            ;(list (car w) (- (cadr w) 3) (third w) (fourth w))))
        ((key=? x "down") (begin
                            (set! LEFT #f)
                            (set! RIGHT #f)
                            (set! DOWN #t)
                            (set! UP #f)
                            w));(begin
                            ;(play ding)
                            ;(list (car w) (+ (cadr w) 3) (third w) (fourth w))))
        (else w)))

; ON TICK HANDLER
; every tick (default 28/second),
;  check the state for the key presses
;  if the state is true, move rackman in that direction by updating his X,Y cooridantes
(define (tick-handler w)
  (cond ((equal? LEFT #t)
         (list (- (car w) SPEED) (cadr w) (third w) (fourth w)))
        ((equal? RIGHT #t)
         (list (+ (car w) SPEED) (cadr w) (third w) (fourth w)))
        ((equal? DOWN #t)
         (list (car w) (+ (cadr w) SPEED) (third w) (fourth w)))
        ((equal? UP #t)
         (list (car w) (- (cadr w) SPEED) (third w) (fourth w)))
        (else w)))

; WORLD
(big-bang '(50 50 75 75)
          (on-tick tick-handler)
          (to-draw myWorld)
          (on-key react))




