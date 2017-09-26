(defdomain floods-uav (
	;; basic operators

	(:operator (!navigate_uav_op ?v ?y ?z)
			   (	(uav ?v)  (area ?y)  (area ?z) (at ?v ?y)	)
			   (	(at ?v ?y)	)
	   (	(at ?v ?z)	)
	)

	(:operator (!take_picture ?v ?a ?d)
		   ( (area ?a) (disaster ?d) (visible_from ?d ?a) (at ?v ?a)	)
		   ()
		   (	(have_picture ?v ?d)	)
	)

	(:operator (!communicate_data ?v ?c ?d ?a1 ?a2)
		   ( (disaster ?d) (cdm ?c) (at ?v ?a1) (cdm_at ?c ?a2) (area ?a1) (area ?a2) (have_picture ?v ?d) (in_range ?a1 ?a2)	)
		   (	(have_picture ?v ?d)	)
		   (	(communicated_data ?d)	)
	)

;;;------------------------------------------------------------

;; actual AI planning methods

(:method (navigate ?robot ?to)
  (	(uav ?robot) (at ?robot ?from) 	)
  (	(navigate_uav ?robot ?from ?to)	)
)

(:method (navigate_uav ?uav ?from ?to)
(	(at ?uav ?to)	)
()

()
(	(!navigate_uav_op ?uav ?from ?to)	)
)

(:method (get_picture ?disaster)
(	(uav ?robot) (disaster ?disaster) (visible_from ?disaster ?area)	)
(	(navigate ?robot ?area) (!take_picture ?robot ?area ?disaster) (send_data ?robot ?disaster)	)
)

(:method (send_data ?robot ?disaster)
(	(uav ?robot) (disaster ?disaster) (have_picture ?v ?d) (at ?v ?a1) (cdm_at ?c ?a2) (area ?a1) (area ?a2) (in_range ?a1 ?a2)	)
(	(!communicate_data ?robot ?c ?disaster ?a1 ?a2)	)

(	(uav ?robot) (disaster ?disaster) (have_picture ?v ?d) (cdm_at ?c ?a2) (area ?a2) (in_range ?a1 ?a2)	)
(	(navigate ?robot ?a1) (!communicate_data ?robot ?c ?disaster ?a1 ?a2)	)
)

))
