#lang racket

(require lang/posn) 
(provide (all-defined-out))
;;; MAZE WALL COORDINATES ;;;
(define R-DIR-WALLS
  (list (list 44 47 44 77) (list 133 47 133 77) (list 240 15 240 77) (list 294 47 294 77)
        (list 401 47 401 77) (list 489 15 489 155) (list 44 109 44 124) (list 98 109 96 124)
        (list 133 109 133 218) (list 187 203 187 264) (list 240 125 240 171) (list 294 156 294 171)
        (list 347 109 347 218) (list 401 156 401 218) (list 401 109 401 124) (list 133 250 133 311)
        (list 187 297 187 311) (list 240 311 240 358) (list 347 250 347 311) (list 401 250 401 311)
        (list 44 344 44 358) (list 79 358 79 405) (list 133 344 133 358) (list 294 344 294 358)
        (list 401 344 401 405) (list 8 390 8 405) (list 44 437 44 452) (list 133 390 133 437)
        (list 187 390 187 405) (list 240 405 240 452) (list 294 437 294 452) (list 347 390 347 437)
        (list 455 390 455 405) (list 187 109 187 124) (list 6 250 6 311) (list 489 312 489 483)))
(define L-DIR-WALLS
  (list (list 96 47 96 77) (list 203 47 203 77) (list 257 15 257 77) (list 364 47 364 77)
        (list 453 47 453 77) (list 96 156 96 218) (list 96 109 96 124) (list 150 109 150 218)
        (list 203 156 203 171) (list 257 125 257 171) (list 364 109 364 218) (list 453 109 453 124)
        (list 310 203 310 264) (list 310 109 310 124) (list 8 16 8 155) (list 150 250 150 311)
        (list 310 297 310 311) (list 257 311 257 358) (list 364 250 364 311) (list 488 250 488 311)
        (list 96 344 96 405) (list 203 344 203 358) (list 364 344 364 358) (list 418 358 418 405)
        (list 453 344 453 358) (list 42 390 42 405) (list 203 437 203 452) (list 150 390 150 437)
        (list 310 390 310 405) (list 257 405 257 452) (list 453 437 453 452) (list 364 390 364 437)
        (list 490 390 490 405) (list 96 250 96 311) (list 8 312 8 483)))
(define D-DIR-WALLS
  (list (list 44 47 96 47) (list 133 47 203 47) (list 294 47 354 47) (list 401 47 453 47)
        (list 44 109 96 109) (list 133 109 150 109) (list 187 109 310 109) (list 347 109 364 109)
        (list 401 109 453 109) (list 8 156 96 156) (list 151 156 203 156) (list 294 156 346 156)
        (list 401 156 489 156) (list 187 203 310 203) (list 133 250 145 250) (list 187 297 310 297)
        (list 347 250 364 250) (list 401 250 488 250) (list 44 344 96 344) (list 133 344 203 344)
        (list 294 344 364 344) (list 401 344 453 344) (list 8 390 42 390) (list 44 437 203 437)
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