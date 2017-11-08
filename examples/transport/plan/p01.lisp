(in-package :shop2-user)

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

))

(defproblem p01 transport
  (
	(location city-loc-0)
	(location city-loc-1)
	(location city-loc-2)
	(vehicle truck-0)
	(package package-0)
	(package package-1)
	(road city-loc-0 city-loc-1)
	(road city-loc-1 city-loc-0)
	(road city-loc-1 city-loc-2)
	(road city-loc-2 city-loc-1)
	(at package-0 city-loc-1)
	(at package-1 city-loc-1)
	(at truck-0 city-loc-2)
	(not in package-0 truck-0)
	(not in package-1 truck-0)
  )

(:ordered
   (deliver package-0 city-loc-0)
   (deliver package-1 city-loc-2)
)

)

(find-plans 'p01 :verbose :plans)
