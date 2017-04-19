#lang racket
;; RACK-MAN
;; Kevin Fossey @kfozz
;; Mohammed Nayeem @mohammednayeem

; Libraries
(require 2htdp/universe
         2htdp/image
         lang/posn
         RSound)

; GLOBAL VARIABLES
(define LEFT #f)
(define RIGHT #f)
(define DOWN #f)
(define UP #f)
(define SCORE 0)
(define NEXT-DIR 0)
(define START #f)
(define SPEED 2)
(define GHOST-SPEED 1)
(define GHOST-DIR 1)
(define DEBUGGER 0)
(define OFFSET 8)
(define X-OFFSET 11)
(define Y-OFFSET 11)
(define OPEN 0)
(define THEME (rs-read "./racktheme_01.wav"))
(define SPLASH (bitmap/file "./splash.png"))
(define END-SCREEN (bitmap/file "./end.png"))
(define MAZE (bitmap/file "./maze_v3.png"))
;(define RACKMAN (bitmap/file "./rackman_right_c.png"))
(define RACKMAN (bitmap/file "./rackman_right.png"))
(define INKY (bitmap/file "./inky.png"))
(define PELLET (circle 3 "solid" "white"))
(define SCENE (rectangle 500 500 "solid" "black"))

;;; MAZE WALL COORDINATES ;;;
(define R-DIR-WALLS
  (list (list 44 47 44 77) (list 133 47 133 77) (list 240 15 240 77) (list 294 47 294 77)
        (list 401 47 401 77) (list 489 15 489 155) (list 44 109 44 124) (list 98 109 96 124)
        (list 133 109 133 218) (list 187 203 187 264) (list 240 125 240 171) (list 294 156 294 171)
        (list 347 109 347 218) (list 401 156 401 218) (list 401 109 401 124) (list 133 250 133 311)
        (list 187 297 187 311) (list 240 311 240 358) (list 347 250 347 311) (list 401 250 401 311)
        (list 44 343 44 358) (list 79 358 79 405) (list 133 343 133 358) (list 294 343 294 358)
        (list 401 343 401 405) (list 8 390 8 405) (list 44 437 44 452) (list 133 390 133 437)
        (list 187 390 187 405) (list 240 405 240 452) (list 294 437 294 452) (list 347 390 347 437)
        (list 455 390 455 405) (list 187 109 187 124) (list 6 250 6 311) (list 489 312 489 483)))
(define L-DIR-WALLS
  (list (list 96 47 96 77) (list 203 47 203 77) (list 257 15 257 77) (list 364 47 364 77)
        (list 453 47 453 77) (list 96 156 96 218) (list 96 109 96 124) (list 150 109 150 218)
        (list 203 156 203 171) (list 257 125 257 171) (list 364 109 364 218) (list 453 109 453 124)
        (list 310 203 310 264) (list 310 109 310 124) (list 8 16 8 155) (list 150 250 150 311)
        (list 310 297 310 311) (list 257 311 257 358) (list 364 250 364 311) (list 488 250 488 311)
        (list 96 343 96 405) (list 203 343 203 358) (list 364 343 364 358) (list 418 358 418 405)
        (list 453 343 453 358) (list 42 390 42 405) (list 203 437 203 452) (list 150 390 150 437)
        (list 310 390 310 405) (list 257 405 257 452) (list 453 437 453 452) (list 364 390 364 437)
        (list 490 390 490 405) (list 96 250 96 311) (list 8 312 8 483)))
(define D-DIR-WALLS
  (list (list 44 47 96 47) (list 133 47 203 47) (list 294 47 354 47) (list 401 47 453 47)
        (list 44 109 96 109) (list 133 109 150 109) (list 187 109 310 109) (list 347 109 364 109)
        (list 401 109 453 109) (list 8 156 96 156) (list 151 156 203 156) (list 294 156 346 156)
        (list 401 156 489 156) (list 187 203 310 203) (list 133 250 150 250) (list 187 297 310 297)
        (list 347 250 364 250) (list 401 250 488 250) (list 44 343 96 343) (list 133 343 203 343)
        (list 294 343 364 343) (list 401 343 453 343) (list 8 390 42 390) (list 44 437 203 437)
        (list 133 390 150 390) (list 187 390 310 390) (list 294 437 453 437) (list 347 390 364 390)
        (list 455 390 490 390)(list 1 250 96 250) (list 8 483 489 483)))
(define U-DIR-WALLS
  (list (list 44 77 96 77) (list 133 77 203 77) (list 294 77 364 77) (list 401 77 453 77)
        (list 44 124 96 124) (list 0 218 96 218) (list 133 218 150 218) (list 151 171 203 171)
        (list 187 265 310 265) (list 187 124 310 124) (list 240 171 257 171) (list 296 171 346 171)
        (list 401 218 499 218) (list 347 218 364 218) (list 401 124 453 124) (list 240 77 247 77)
        (list 133 311 150 311) (list 187 311 310 311) (list 240 358 257 358) (list 347 311 364 311)
        (list 401 311 489 311) (list 44 358 79 358) (list 79 405 96 405) (list 133 358 203 358)
        (list 294 358 361 358) (list 418 358 453 358) (list 401 405 418 405) (list 8 405 42 405)
        (list 44 452 203 452) (list 187 405 310 405) (list 240 452 257 452) (list 294 452 453 452)
        (list 455 405 490 405) (list 6 311 96 311) (list 8 16 489 16)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PELLET COORIDATE LIST ;;

(define (build-pel-xy x y)
  (define (builder-xy x y count lst)
          ;;;;;;;;;;;; ROW 1 ;;;;;;;;;;;;
    (cond ((and (>= count 0) (< count 12)) ;; 12 Pellets
           (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y)))))
          ((and (>= count 12) (<= count 24))
           (if (= count 12)
               (builder-xy (+ x 37) y (add1 count) (append lst (list (make-posn (+ x 37) y))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ;;;;;;;;;;;; ROW 2 ;;;;;;;;;;;;
          ((and (> count 24) (<= count 51)) ;; 27 pellets
           (if (= count 25)
               (builder-xy  43 (+ y 55) (add1 count) (append lst (list (make-posn 43 (+ y 55)))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ;;;;;;;;;;;; COLLUM 1 ;;;;;;;;;;;;
          ((and (> count 51) (<= count 58)) ;; 7 pellets
           (if (= count 52)
               (builder-xy 25 53 (add1 count) (append lst (list (make-posn 25 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;;;;;;;;;;; COLLUM 2 ;;;;;;;;;;;;
          ((and (> count 58) (<= count 80)) ;; 22 pellets
           (if (= count 59)
               (builder-xy 115 53 (add1 count) (append lst (list (make-posn 115 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;;;;;;;;;;; COLLUM 3 ;;;;;;;;;;;;
          ((and (> count 80) (<= count 102)) ;; 22 pellets
           (if (= count 81)
               (builder-xy 386 53 (add1 count) (append lst (list (make-posn 386 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;;;;;;;;;;; ROW 3 ;;;;;;;;;;;;
          ((and (> count 102) (<= count 129)) ;; 27 pellets
           (if (= count 103)
               (builder-xy 25 468 (add1 count) (append lst (list (make-posn 25 468))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 129) (<= count 135)) ;; 6 pellets
           (if (= count 130)
               (builder-xy 25 414 (add1 count) (append lst (list (make-posn 25 414))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 135) (<= count 138)) ;; 3 pellets
           (if (= count 136)
               (builder-xy 25 432 (add1 count) (append lst (list (make-posn 25 432))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 138) (<= count 144)) ;; 5 pellets
           (if (= count 139)
               (builder-xy 25 323 (add1 count) (append lst (list (make-posn 25 323))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 144) (<= count 149)) ;; 5 pellets
           (if (= count 145)
               (builder-xy 25 341 (add1 count) (append lst (list (make-posn 25 341))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 149) (<= count 164)) ;; 5 pellets
           (if (= count 150)
               (builder-xy 133 377 (add1 count) (append lst (list (make-posn 133 377))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 164) (<= count 167)) ;; 5 pellets
           (if (= count 165)
               (builder-xy 169 395 (add1 count) (append lst (list (make-posn 25 395))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 167) (<= count 171)) ;; 5 pellets
           (if (= count 168)
               (builder-xy 187 413 (add1 count) (append lst (list (make-posn 187 413))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 171) (<= count 174)) ;; 5 pellets
           (if (= count 172)
               (builder-xy 223 431 (add1 count) (append lst (list (make-posn 223 431))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 174) (<= count 177)) ;; 3 pellets
           (if (= count 175)
               (builder-xy 43 377 (add1 count) (append lst (list (make-posn 43 377))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 177) (<= count 184)) ;; 7 pellets
           (if (= count 178)
               (builder-xy 133 323 (add1 count) (append lst (list (make-posn 133 323))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 184) (<= count 187)) ;; 3 pellets
           (if (= count 185)
               (builder-xy 223 341 (add1 count) (append lst (list (make-posn 223 341))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 187) (<= count 193)) ;; 6 pellets
           (if (= count 188)
               (builder-xy 404 413 (add1 count) (append lst (list (make-posn 404 413))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 193) (<= count 199)) ;; 6 pellets
           (if (= count 194)
               (builder-xy 404 323 (add1 count) (append lst (list (make-posn 404 323))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 199) (<= count 206)) ;; 7 pellets
           (if (= count 200)
               (builder-xy 368 323 (add1 count) (append lst (list (make-posn 368 323))))   
               (builder-xy (- x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 206) (<= count 209)) ;; 3 pellets
           (if (= count 207)
               (builder-xy 278 341 (add1 count) (append lst (list (make-posn 278 341))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;;  ROW ;;;
          ((and (> count 209) (<= count 214)) ;; 4 pellets
           (if (= count 210)
               (builder-xy 43 143 (add1 count) (append lst (list (make-posn 43 143))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 214) (<= count 220)) ;; 5 pellets
           (if (= count 215)
               (builder-xy 404 143 (add1 count) (append lst (list (make-posn 404 143))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ;;; COLLUM ;;
          ((and (> count 220) (<= count 224)) ;; 3 pellets
           (if (= count 221)
               (builder-xy 169 108 (add1 count) (append lst (list (make-posn 169 108))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 224) (<= count 228)) ;; 3 pellets
           (if (= count 225)
               (builder-xy 331 108 (add1 count) (append lst (list (make-posn 331 108))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;;  ROW ;;;
          ((and (> count 228) (<= count 232)) ;; 3 pellets
           (if (= count 229)
               (builder-xy 187 143 (add1 count) (append lst (list (make-posn 187 143))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 232) (<= count 236)) ;; 3 pellets
           (if (= count 233)
               (builder-xy 277 143 (add1 count) (append lst (list (make-posn 277 143))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ;;; COLLUM ;;
          ((and (> count 236) (<= count 239)) ;; 2 pellets
           (if (= count 237)
               (builder-xy 223 53 (add1 count) (append lst (list (make-posn 223 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 239) (<= count 242)) ;; 2 pellets
           (if (= count 240)
               (builder-xy 278 53 (add1 count) (append lst (list (make-posn 278 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 242) (<= count 245)) ;; 2 pellets
           (if (= count 243)
               (builder-xy 476 53 (add1 count) (append lst (list (make-posn 476 53))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 245) (<= count 248)) ;; 2 pellets
           (if (= count 246)
               (builder-xy 476 107 (add1 count) (append lst (list (make-posn 476 107))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 248) (<= count 252)) ;; 3 pellets
           (if (= count 249)
               (builder-xy 476 341 (add1 count) (append lst (list (make-posn 476 341))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 252) (<= count 255)) ;; 2 pellets
           (if (= count 253)
               (builder-xy 476 431 (add1 count) (append lst (list (make-posn 476 431))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 255) (<= count 258)) ;; 2 pellets
           (if (= count 256)
               (builder-xy 331 395 (add1 count) (append lst (list (make-posn 331 395))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 258) (<= count 261)) ;; 2 pellets
           (if (= count 259)
               (builder-xy 440 377 (add1 count) (append lst (list (make-posn 440 377))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ((and (> count 261) (<= count 265)) ;; 2 pellets
           (if (= count 262)
               (builder-xy 277 431 (add1 count) (append lst (list (make-posn 277 431))))   
               (builder-xy x (+ y 18) (add1 count) (append lst (list (make-posn x y))))))
          ;;; ROW ;;;
          ((and (> count 265) (<= count 269)) ;; 3 pellets
           (if (= count 266)
               (builder-xy 277 413 (add1 count) (append lst (list (make-posn 277 413))))   
               (builder-xy (+ x 18) y (add1 count) (append lst (list (make-posn x y))))))
          ((and (= count 270)) (builder-xy 61 395 (add1 count) (append lst (list (make-posn 61 395)))))
          (else lst)))
  (builder-xy x y 0 '()))

(define PEL-POS (build-pel-xy 25 35)) ;; Makes the call to build the list of posn objects for the pellets

;returns a list of image objects equal to the number of positions created above
(define (build-pel-img img)
  (define (builder-img count img lst)
    (if (= count (length PEL-POS))
        lst
        (builder-img (add1 count) img (append lst (list img)))))
  (builder-img 0 img '()))

(define PEL-IMG (build-pel-img PELLET)) ;; Makes the call to build the list of image objects for the pellets

(define PELLETS (length PEL-POS)) ;; variable to hold the number of pellets
 


; DRAW THE WORLD
; take in the world state 't' and render the appropriate scene
(define (myWorld t) ;<-- the t-parameter is our WorldState
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
                                               ;SCENE)))
                                               (place-images PEL-IMG PEL-POS SCENE))));(rectangle 500 500 "solid" "black")))))
        )
                                               ;(rectangle 500 500 "solid" "black"))))
      ;SPLASH SCREEN STATE -- if 't' is not a list, it indicates the initial world state, so display the splash screen
      (place-image (text "Press Shift to Start!" 24 "white")
                   250 400 ; x y
                   (place-image SPLASH
                                250 250
                                SCENE))))
                                ;(rectangle 500 500 "outline" "black")))))


; KEY PRESS HANDLER
; if the user presses any arrow key, update the state variable for those keys, and reset the state for each other key
(define (react w x)
  (cond ((key=? x "shift") (if(equal? START #f)
                              (begin
                                (play THEME)
                                (set! START #t)
                                (list 250 374 250 186)) ;; starting position of RackMan and Ghost
                              w))
        ((key=? x "rshift") (if(equal? START #f)
                              (begin
                                ;(display PEL-POS)
                                ;(display PEL-IMG)
                                ;(play THEME)
                                (set! START #t)
                                (list 250 374 250 186))  ;; starting position of RackMan and Ghost
                              w))
        ((key=? x "left") #|(begin
                            ;(set! RACKMAN (bitmap/file "./rackman_left_c.png"))
                            (set! RACKMAN (bitmap/file "./rackman_left.png"))
                            (set! LEFT #t)
                            (set! RIGHT #f)
                            (set! DOWN #f)
                            (set! UP #f)
                            w))|#
         (if (equal? (maze-check (- (first w) 7) (second w) L-DIR-WALLS) #t)
             (begin
               (set! NEXT-DIR 1)
               w)
             (begin
               ;(set! RACKMAN (bitmap/file "./rackman_left_c.png"))
               (set! RACKMAN (bitmap/file "./rackman_left.png"))
               (set! LEFT #t)
               (set! RIGHT #f)
               (set! DOWN #f)
               (set! UP #f)
               w)))
        ((key=? x "right") #|(begin
                             ;(set! RACKMAN (bitmap/file "./rackman_right_c.png"))
                             (set! RACKMAN (bitmap/file "./rackman_right.png"))
                             (set! LEFT #f)
                             (set! RIGHT #t)
                             (set! DOWN #f)
                             (set! UP #f)
                             w));|#
         (if (equal? (maze-check (+ (first w) 7) (second w) R-DIR-WALLS) #t)
             (begin
               (set! NEXT-DIR 2)
               w)
             (begin
               ;(set! RACKMAN (bitmap/file "./rackman_right_c.png"))
               (set! RACKMAN (bitmap/file "./rackman_right.png"))
               (set! LEFT #f)
               (set! RIGHT #t)
               (set! DOWN #f)
               (set! UP #f)
               w)))
        ((key=? x "up") #|(begin
                          ;(set! RACKMAN (bitmap/file "./rackman_up_c.png"))
                          (set! RACKMAN (bitmap/file "./rackman_up.png"))
                          (set! LEFT #f)
                          (set! RIGHT #f)
                          (set! DOWN #f)
                          (set! UP #t)
                          w))|#
         (if (equal? (maze-check (first w) (- (second w) 7) U-DIR-WALLS) #t)
             (begin
               (set! NEXT-DIR 3)
               w)
             (begin
               ;(set! RACKMAN (bitmap/file "./rackman_up_c.png"))
               (set! RACKMAN (bitmap/file "./rackman_up.png"))
               (set! LEFT #f)
               (set! RIGHT #f)
               (set! DOWN #f)
               (set! UP #t)
               w)))
        ((key=? x "down") #|(begin
                            ;(set! RACKMAN (bitmap/file "./rackman_down_c.png"))
                            (set! RACKMAN (bitmap/file "./rackman_down.png"))
                            (set! LEFT #f)
                            (set! RIGHT #f)
                            (set! DOWN #t)
                            (set! UP #f)
                            w))|#
         (if (equal? (maze-check (first w) (+ (second w) 7) D-DIR-WALLS) #t)
             (begin
               (set! NEXT-DIR 4)
               w)
             (begin
               ;(set! RACKMAN (bitmap/file "./rackman_down_c.png"))
               (set! RACKMAN (bitmap/file "./rackman_down.png"))
               (set! LEFT #f)
               (set! RIGHT #f)
               (set! DOWN #t)
               (set! UP #f)
               w)))
        (else w))) ; any other key press, just return an unaltered world state

; ON TICK HANDLER
; every tick (default 28/second),
;  check the state for the key presses
;  if the state is true, move rackman in that direction by updating his X,Y cooridantes
(define (tick-handler w)
  (begin
    #|
    (cond ((= NEXT-DIR 1)
           (begin
             (set! NEXT-DIR 0)
             (set! LEFT #t)
             (set! RIGHT #f)
             (set! DOWN #f)
             (set! UP #f)))
          ((= NEXT-DIR 2)
           (begin
             (set! NEXT-DIR 0)
             (set! LEFT #f)
             (set! RIGHT #t)
             (set! DOWN #f)
             (set! UP #f)))
          ((= NEXT-DIR 3)
           (begin
             (set! NEXT-DIR 0)
             (set! LEFT #f)
             (set! RIGHT #f)
             (set! DOWN #f)
             (set! UP #t)))
          ((= NEXT-DIR 4)
           (begin
             (set! NEXT-DIR 0)
             (set! LEFT #f)
             (set! RIGHT #f)
             (set! DOWN #t)
             (set! UP #f)))
          (else 0))
    |#
    (if (equal? w 0)
        w
        (cond ((not (list? w)) w)
              ;HANDLE ARROW KEY COMMANDS
              ((equal? LEFT #t)
               (if (equal? (maze-check (car w) (cadr w) L-DIR-WALLS) #t) ;; check for collision with maze
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   ;(list (- (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))
                   ; move to the opposite end when passing through the left opening
                   (cond ((<= (car w) 0) (list (+ (car w) 495) (cadr w) (ghost "x" w) (ghost "y" w)))
                         (else (list (- (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))))
              ((equal? RIGHT #t)
               (if (equal? (maze-check (car w) (cadr w) R-DIR-WALLS) #t) ;; check for collision with maze
                   (list (car w) (cadr w) (ghost "x" w) (ghost "y" w))
                   ;(list (+ (car w) SPEED) (cadr w) (ghost "x" w) (ghost "y" w))))
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
;;; Returns #t if a collision is detected
;;; Returns #f if no collision is detected
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
                                           ;((>= y (- (second wall) OFFSET))
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
                                           ;((<= y (+ (second wall) 12))
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

(define (ghost-maze-check x y lst)
  (begin
    (cond ((equal? lst L-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (<= x (+ (first wall) OFFSET)) (>= x (first wall))) ;; check if ghost is lined up along X with any walls
                                            (if (and (>= y (- (second wall) OFFSET)) (<= y (+ (fourth wall) OFFSET))) ;; check if ghost is is lined up along Y with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          ((equal? lst R-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ((and (>= x (- (first wall) OFFSET)) (<= x (first wall))) ;; check if ghost is lined up along X with any walls
                                            (if (and (>= y (- (second wall) OFFSET)) (<= y (+ (fourth wall) OFFSET))) ;; check if ghost is is lined up along Y with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          ((equal? lst D-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ;((>= y (- (second wall) OFFSET))
                                           ((and (>= y (- (second wall) OFFSET)) (<= y (second wall))) ;; check if ghost is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) OFFSET)) (<= x (+ (third wall) OFFSET))) ;; check if ghost is lined up along X with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          ((equal? lst U-DIR-WALLS) ;#f)
           (foldl (lambda (wall res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                           ;((<= y (+ (second wall) 12))
                                           ((and (<= y (+ (second wall) OFFSET)) (>= y (second wall))) ;; check if ghost is is lined up along Y with any walls
                                            (if (and (>= x (- (first wall) OFFSET)) (<= x (+ (third wall) OFFSET))) ;; check if ghost is lined up along X with any walls
                                                #t
                                                #f))
                                           (else #f)))
                  #f
                  lst))
          (else #f))))

;;;;;;;;;;;;;;;;;;;;;;; 
;;;; CHECK PELLETS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;;; x -> Rack-Mans x pos
;;; y -> Rack-mans y pos
;;; check if rackmans position matches the position of any pellets,
;;; if it does, remove that pellet
(define (check-pel x y)
  (cond ((equal? LEFT #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (<= x (+ (posn-x pel) OFFSET)) (>= x (posn-x pel))) ;; check if rackman is lined up along X with any pellets
                                          (if (and (>= y (- (posn-y pel) OFFSET)) (<= y (+ (posn-y pel) OFFSET))) ;; check if rackman is is lined up along Y with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                (display SCORE)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? RIGHT #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ((and (>= x (- (posn-x pel) OFFSET)) (<= x (posn-x pel))) ;; check if rackman is lined up along X with any pellets
                                          (if (and (>= y (- (posn-y pel) OFFSET)) (<= y (+ (posn-y pel) OFFSET))) ;; check if rackman is is lined up along Y with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                (display SCORE)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? DOWN #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ;((>= y (- (second wall) OFFSET))
                                         ((and (>= y (- (posn-y pel) OFFSET)) (<= y (posn-y pel))) ;; check if rackman is is lined up along Y with any pellets
                                          (if (and (>= x (- (posn-x pel) OFFSET)) (<= x (+ (posn-x pel) OFFSET))) ;; check if rackman is lined up along X with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                (display SCORE)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        ((equal? UP #t) ;#f)
         (foldl (lambda (pel res) (cond ((equal? res #t) #t) ;; if the last result was #t then return #t again
                                         ;((<= y (+ (second wall) 12))
                                         ((and (<= y (+ (posn-y pel) OFFSET)) (>= y (posn-y pel))) ;; check if rackman is is lined up along Y with any pellets
                                          (if (and (>= x (- (posn-x pel) OFFSET)) (<= x (+ (posn-x pel) OFFSET))) ;; check if rackman is lined up along X with any pellets
                                              (begin
                                                (set! PEL-POS (remove pel PEL-POS))
                                                (set! PEL-IMG (remove PELLET PEL-IMG))
                                                (set! SCORE (+ SCORE 1))
                                                (display SCORE)
                                                #t)
                                              #f))
                                         (else #f)))
                #f
                PEL-POS))
        (else #f)))

; GHOST
(define (ghost d w)
  #|
  (if (equal? d "x")
      (if (< (third w) (first w))
          (+ (third w) GHOST-SPEED)
          (- (third w) GHOST-SPEED))
      (if (< (fourth w) (second w))
          (+ (fourth w) GHOST-SPEED)
          (- (fourth w) GHOST-SPEED))))
  |#
  (begin
    
    (cond ((= GHOST-DIR 1);LEFT
           (if (equal? d "x")
               (if (equal? (ghost-maze-check (third w) (fourth w) L-DIR-WALLS) #t)
                   (begin
                     (set! GHOST-DIR (random 2 5 (current-pseudo-random-generator)))
                     (third w))
                   (- (third w) GHOST-SPEED))
               (fourth w)))
          ((= GHOST-DIR 2);RIGHT
           (if (equal? d "x")
               (if (equal? (ghost-maze-check (third w) (fourth w) R-DIR-WALLS) #t)
                   (begin
                     (set! GHOST-DIR (random 1 5 (current-pseudo-random-generator)))
                     (third w))
                   (+ (third w) GHOST-SPEED))
               (fourth w)))
          ((= GHOST-DIR 3);DOWN
           (if (equal? d "x")
               (third w)
               (if (equal? (ghost-maze-check (third w) (fourth w) D-DIR-WALLS) #t)
                   (begin
                     (set! GHOST-DIR (random 1 5 (current-pseudo-random-generator)))
                     (fourth w))
                   (+ (fourth w) GHOST-SPEED))))
          ((= GHOST-DIR 4);UP
           (if (equal? d "x")
               (third w)
               (if (equal? (ghost-maze-check (third w) (fourth w) U-DIR-WALLS) #t)
                   (begin
                     (set! GHOST-DIR (random 1 5 (current-pseudo-random-generator)))
                     (fourth w))
                   (- (fourth w) GHOST-SPEED)))))))
          ;(else 0))))

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
          (name "Rack-Man v3.0")
          (stop-when game-over high-score))




