(defdomain transport (

  (:operator (!drive ?v ?l1 ?l2)
	( (vehicle ?v) (location ?l1) (location ?l2) (at ?v ?l1) (road ?l1 ?l2) )
	( (at ?v ?l1) )
	( (at ?v ?l2) )
  )

 (:operator (!pick-up ?v ?l ?p)
	( (vehicle ?v) (location ?l) (package ?p) (at ?v ?l) (at ?p ?l) )
	( (at ?p ?l) )
	( (in ?p ?v) )
 )

  (:operator (!drop ?v ?l ?p)
	( (vehicle ?v) (location ?l) (package ?p) (at ?v ?l) (in ?p ?v) )
	( (in ?p ?v) )
	( (at ?p ?l) )
  )
  
  (:method (deliver ?p ?l2)
	( (vehicle ?v) (at ?p ?l1) )
	( (get-to ?v ?l1) (!pick-up ?v ?l1 ?p) (get-to ?v ?l2) (!drop ?v ?l2 ?p))
  )
  
  (:method (get-to ?v ?to)
	( (at ?v ?to) )
	( )
	
	( (at ?v ?from ) (road ?from ?to) )
	( (!drive ?v ?from ?to) )
  )
  
   (:method (root)
	 ( )
	 ( (deliver ?p1 ?l1) (deliver ?p2 ?l2) (get-to ?v1 ?l3) (get-to ?v1 ?l4) )
   )

))

