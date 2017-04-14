#lang racket
;; RACK-MAN
;; Kevin Fossey @kfozz
;; Mohammed Nayeem @mohammednayeem

; Libraries
(require 2htdp/universe
         2htdp/image
         RSound)

; GLOBAL VARIABLES
(define LEFT #f)
(define RIGHT #f)
(define DOWN #f)
(define UP #f)
(define START #f)
(define SPEED 2)
(define GHOST-SPEED 0)
(define OFFSET 5)
(define OPEN 0)
(define THEME (rs-read "./racktheme_01.wav"))
(define SPLASH (bitmap/file "./splash.png"))
(define END-SCREEN (bitmap/file "./end.png"))
(define MAZE (bitmap/file "./maze_v2.png"))
(define RACKMAN (bitmap/file "./rackman_right_c.png"))
(define INKY (bitmap/file "./inky.png"))

;;; MAZE WALL COORDINATES ;;;
(define R-DIR-WALLS
  (list (list 44 47 44 77) (list 133 47 133 77) (list 240 15 240 77) (list 294 47 294 77)
        (list 401 47 401 77) (list 489 15 489 155) (list 44 109 44 124) (list 98 109 96 124)
        (list 133 109 133 218) (list 186 203 186 264) (list 240 125 240 171) (list 294 156 294 171)
        (list 347 109 347 218) (list 401 156 401 218) (list 401 109 401 124) (list 133 250 133 311)
        (list 186 297 186 311) (list 240 311 240 358) (list 347 250 347 311) (list 401 250 401 311)
        (list 44 344 44 358) (list 79 358 79 405) (list 133 344 133 358) (list 294 344 294 358)
        (list 401 344 401 405) (list 8 390 8 405) (list 44 437 44 452) (list 133 390 133 437)
        (list 186 390 186 405) (list 240 405 240 452) (list 294 437 294 452) (list 347 390 347 437)
        (list 454 389 454 405)))
(define L-DIR-WALLS
  (list (list 96 47 96 77) (list 203 47 203 77) (list 257 15 257 77) (list 364 47 364 77)
        (list 453 47 453 77) (list 96 156 96 218) (list 96 109 96 124) (list 150 109 150 218)
        (list 203 156 203 171) (list 257 125 257 171) (list 364 109 364 218) (list 453 109 453 124)
        (list 310 203 310 264) (list 310 109 310 124) (list 7 15 7 155) (list 150 250 150 311)
        (list 310 297 310 311) (list 257 311 257 358) (list 364 250 364 311) (list 488 250 488 311)
        (list 96 344 96 405) (list 203 344 203 358) (list 364 344 364 358) (list 418 358 418 405)
        (list 453 344 453 358) (list 43 390 43 405) (list 203 437 203 452) (list 150 390 150 437)
        (list 310 390 310 405) (list 257 405 257 452) (list 453 437 453 452) (list 364 390 364 437)
        (list 490 390 490 405)))
(define D-DIR-WALLS
  (list (list 44 47 96 47) (list 133 47 203 47) (list 294 47 354 47) (list 401 47 453 47)
        (list 44 109 96 109) (list 133 109 150 109) (list 186 109 310 109) (list 347 109 364 109)
        (list 401 109 453 109) (list 8 156 96 156) (list 151 156 203 156) (list 294 156 346 156)
        (list 401 156 489 156) (list 186 203 310 203) (list 133 250 150 250) (list 186 297 310 297)
        (list 347 250 364 250) (list 401 250 488 250) (list 44 344 96 344) (list 133 344 263 344)
        (list 294 344 364 344) (list 401 344 453 344) (list 8 390 43 390) (list 44 437 203 437)
        (list 133 390 150 390) (list 186 390 310 390) (list 294 437 453 437) (list 347 390 364 390)
        (list 454 390 490 390)))
(define U-DIR-WALLS
  (list (list 44 77 96 77) (list 133 77 203 77) (list 294 77 364 77) (list 401 77 453 77)
        (list 44 124 96 124) (list 0 218 96 218) (list 133 218 150 218) (list 151 171 203 171)
        (list 186 264 310 264) (list 186 124 310 124) (list 240 171 257 171) (list 296 171 346 171)
        (list 401 218 499 218) (list 347 218 364 218) (list 401 124 453 124) (list 240 77 247 77)
        (list 133 311 150 311) (list 186 311 310 311) (list 240 358 257 358) (list 347 311 364 311)
        (list 401 311 489 311) (list 44 358 79 358) (list 79 405 96 405) (list 133 358 203 358)
        (list 294 358 361 358) (list 418 358 453 358) (list 401 405 418 405) (list 8 405 43 405)
        (list 44 452 203 452) (list 186 405 310 405) (list 240 452 257 452) (list 294 452 453 452)
        (list 454 405 490 405)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
                                (place-image MAZE
                                             250 250
                                             (rectangle 500 500 "solid" "black"))))
      ;SPLASH SCREEN STATE -- if 't' is not a list, it indicates the initial world state, so display the splash screen
      (place-image (text "Press Shift to Start!" 24 "white")
                   250 400 ; x y
                   (place-image SPLASH
                                250 250
                                (rectangle 500 500 "outline" "black")))))
                 
; KEY PRESS HANDLER
; if the user presses any arrow key, update the state variable for those keys, and reset the state for each other key
(define (react w x)
  (cond ((key=? x "shift") (if(equal? START #f)
                              (begin
                                (play THEME)
                                (set! START #t)
                                (list 250 375 250 250))
                              w))
        ((key=? x "rshift") (if(equal? START #f)
                              (begin
                                (play THEME)
                                (set! START #t)
                                (list 250 375 250 250))
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
    (if (equal? w 0)
        w
        (cond ((not (list? w)) w)
              ;HANDLE ARROW KEY COMMANDS
              ((equal? LEFT #t)
               (if (equal? (maze-check (car w) (cadr w) L-DIR-WALLS) #t) 
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   (list (- (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))
              ((equal? RIGHT #t)
               (if (equal? (maze-check (car w) (cadr w) R-DIR-WALLS) #t)
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   (list (+ (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))
              ((equal? DOWN #t)
               (if (equal? (maze-check (car w) (cadr w) D-DIR-WALLS) #t)
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   (list (car w) (+ (cadr w) SPEED) (ghost "x" w) (ghost "y" w))))
              ((equal? UP #t)
               (if (equal? (maze-check (car w) (cadr w) U-DIR-WALLS) #t)
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   (list (car w) (- (cadr w) SPEED) (ghost "x" w) (ghost "y" w))))
              (else w)))))
;;;;;;;;;;;;;;;;;;;; 
;;;; CHECK MAZE ;;;;
;;;;;;;;;;;;;;;;;;;;
;;; x -> Rack-Mans x pos
;;; y -> Rack-mans y pos
;;; lst -> The list of walls that Rack-man could run into given his current direction
(define (maze-check x y lst)
  ; INCOMPLETE
  (cond ((equal? LEFT #t) ;#f)
         (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                         ((and (<= x (+ (first wall) OFFSET)) (>= x (first wall)))
                                         ;((and (<= x (- (car wall) OFFSET)) (>= x (+ (car wall) OFFSET)))
                                          (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                                                    ((and (>= y (- (second wall) OFFSET)) (<= y (+ (fourth wall) OFFSET))) #t)
                                                                    (else #f)))
                                                 #f
                                                 lst))
                                         (else #f)))
         #f
         lst))
        ((equal? RIGHT #t) ;#f)
         (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                         ((and (>= x (- (first wall) OFFSET)) (<= x (first wall)))
                                         ;((and (<= x (- (car wall) OFFSET)) (>= x (+ (car wall) OFFSET)))
                                          (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                                                    ((and (>= y (- (second wall) OFFSET)) (<= y (+ (fourth wall) OFFSET))) #t)
                                                                    (else #f)))
                                                 #f
                                                 lst))
                                         (else #f)))
         #f
         lst))
        ((equal? DOWN #t) ;#f)
         (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                         ;((>= y (- (second wall) OFFSET))
                                         ((and (>= y (- (second wall) OFFSET)) (<= y (second wall)))
                                          (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                                                          ((and (>= x (- (first wall) OFFSET)) (<= x (+ (third wall) OFFSET))) #t)
                                                                          (else #f)))
                                                 #f
                                                 lst))
                                         (else #f)))
         #f
         lst))
        ((equal? UP #t) ;#f)
         (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                         ;((<= y (+ (second wall) 12))
                                         ((and (<= y (+ (second wall) OFFSET)) (>= y (second wall)))
                                          (foldl (lambda (wall res) (cond ((equal? res #t) #t)
                                                                    ((and (>= x (- (first wall) OFFSET)) (<= x (+ (third wall) OFFSET))) #t)
                                                                    (else #f)))
                                                 #f
                                                 lst))
                                         (else #f)))
         #f
         lst))
        (else #f)))

; GHOST
(define (ghost d w)
  (if (equal? d "x")
      (if (< (third w) (first w))
          (+ (third w) GHOST-SPEED)
          (- (third w) GHOST-SPEED))
      (if (< (fourth w) (second w))
          (+ (fourth w) GHOST-SPEED)
          (- (fourth w) GHOST-SPEED))))

; GAME OVER MAN! GAME OVER!
(define (game-over w)
  (cond ((equal? w 0) #f)
        ((equal? (check-ghost (list (first w) (second w)) (list (third w) (fourth w))) #t) #t)
        (else #f)))

; check the position of the ghost relative to rack-man
; r -> '(x y) for rack-man
; g -> '(x y) for ghost
; To account for the size of rack-man and the ghost, it recursively compares the next 10 values of the x/y
(define (check-ghost r g)
  (define (check-iter r_pos g_pos count)
    (if (> count 0)
        (if (equal? r_pos g_pos)
            #t
            (check-iter r_pos (add1 g_pos) (sub1 count)))
        #f))
  (cond ((and (equal? (check-iter (first r) (first g) 10) #t) (equal? (check-iter (second r) (second g) 10) #t))  #t)
        (else #f)))

; NOT COMPLETE YET 
; Dipsplay Local high-score
(define (high-score w)
  (place-image (text "GAME OVER MAN! GAME OVER!" 24 "white")
                   250 400 ; x y
                   (place-image END-SCREEN
                                250 250
                                (rectangle 500 500 "outline" "black"))))
; WORLD
(big-bang 0
          (on-tick tick-handler)
          (to-draw myWorld)
          (on-key react)
          (name "Rack-Man v0.3")
          (stop-when game-over high-score))




