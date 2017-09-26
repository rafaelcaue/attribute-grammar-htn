(defdomain basic-example (
  (:operator (!pickup ?a) () () ((have ?a)))
  (:operator (!drop ?a) ((have ?a)) ((have ?a)) ())

  (:method (swap ?x ?y)
    ((have ?x))
    ((!drop ?x) (!pickup ?y))
    ((have ?y))
    ((!drop ?y) (!pickup ?x)))))

