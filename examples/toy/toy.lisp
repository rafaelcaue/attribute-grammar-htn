;;; TOY DOMAIN

(defdomain basic-example (
  (:operator (!pickup ?a) () () ((have ?a)))
  (:operator (!drop ?a) ((have ?a)) ((have ?a)) ())

  (:method (swap ?x ?y)
    ((have ?x))
    ((!drop ?x) (!pickup ?y))
    ((have ?y))
    ((!drop ?y) (!pickup ?x)))))

;;; TOY PROBLEM

(defproblem problem1 basic-example
  ((have banjo) (not (have kiwi))) ((swap banjo kiwi)))

;;; TOY SOLUTION PLAN

(((DROP BANJO) (PICKUP KIWI)))
