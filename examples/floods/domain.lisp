(defdomain floods (
	;; basic operators

	(:operator (!navigate_uav ?v ?y ?z)
			   (	(uav ?v)  (area ?y)  (area ?z) (at ?v ?y)	)
			   (	(at ?v ?y)	) 
	   (	(at ?v ?z)	)
	)
	
	(:operator (!navigate_ugv ?v ?y ?z)
			   (	(ugv ?v)  (area ?y)  (area ?z) (ground_path ?y ?z) (at ?v ?y)	)
			   (	(at ?v ?y)	) 
	   (	(at ?v ?z)	)
	)
	
	(:operator (!navigate_usv ?v ?y ?z)
			   (	(usv ?v)  (area ?y)  (area ?z) (water_path ?y ?z) (at ?v ?y)	)
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
	
	(:operator (!pickup_box ?v ?s ?c ?a ?b)
		   ( (ugv ?v) (store ?s) (store_of ?s ?v) (empty ?s) (cdm ?c) (box ?b) (area ?a) (box_at_cdm ?b ?c) (cdm_at ?c ?a) (at ?v ?a)	)
		   (	(empty ?s) (box_at_cdm ?b ?c)	)
		   (	(full ?s) (box_at ?b ?v)	)
	)

	(:operator (!drop_box ?v ?s ?a ?b)
		   ( (ugv ?v) (store ?s) (store_of ?s ?v) (box ?b) (area ?a) (box_at ?b ?v) (at ?v ?a)	)
		   (	(full ?s) (box_at ?b ?v)	)
		   (	(empty ?s) (box_at_area ?b ?a)	)
	)
	
	(:operator (!sample_water ?v ?s ?a)
		   ( (usv ?v) (store ?s) (store_of ?s ?v) (empty ?s) (area ?a) (at ?v ?a)	)
		   (	(empty ?s)	)
		   (	(full ?s) (have_water_sample ?v ?a)	)
	)

	(:operator (!drop_sample ?v ?s ?a1 ?a2 ?c)
		   ( (usv ?v) (store ?s) (store_of ?s ?v) (area ?a1) (area ?a2) (cdm ?c) (have_water_sample ?v ?a2) (cdm_at ?c ?a1) (at ?v ?a1)	)
		   (	(full ?s) (have_water_sample ?v ?a2)	)
		   (	(empty ?s) (have_water_sample_cdm ?c ?a2)	)
	)

(:operator (!!visit ?area)
  ()
  ()
  ((visited ?area))
)

(:operator (!!unvisit ?area)
  ()
  ((visited ?area))
  ()
)

;;;------------------------------------------------------------

;; actual AI planning methods

(:method (navigate ?robot ?to)
  (	(uav ?robot) (at ?robot ?from) 	)
  (	(navigate_uav ?robot ?from ?to)	)
  
  (	(ugv ?robot) (at ?robot ?from) 	)
  (	(!!visit ?from) (navigate_ugv ?robot ?from ?to) (!!unvisit ?from)	)  
  
  (	(usv ?robot) (at ?robot ?from) 	)
  (	(!!visit ?from) (navigate_usv ?robot ?from ?to) (!!unvisit ?from)	)
)

(:method (navigate_uav ?uav ?from ?to)
(	(at ?uav ?to)	)
()

()
(	(!navigate_uav ?uav ?from ?to)	)
)

(:method (navigate_ugv ?ugv ?from ?to)
(	(at ?ugv ?to)	)
()

(	(ground_path ?from ?to)	)
(	(!navigate_ugv ?ugv ?from ?to)	)

(	(ground_path ?from ?mid) (not (visited ?mid))	)
(	(!navigate_ugv ?ugv ?from ?mid) (!!visit ?mid) (navigate_ugv ?ugv ?mid ?to) (!!unvisit ?mid)	)
)

(:method (navigate_usv ?usv ?from ?to)
(	(at ?usv ?to)	)
()

(	(water_path ?from ?to)	)
(	(!navigate_usv ?usv ?from ?to)	)

(	(water_path ?from ?mid) (not (visited ?mid))	)
(	(!navigate_usv ?usv ?from ?mid) (!!visit ?mid) (navigate_usv ?usv ?mid ?to) (!!unvisit ?mid)	)
)

(:method (get_picture ?disaster)
(	(robot ?robot) (disaster ?disaster) (visible_from ?disaster ?area)	)
(	(navigate ?robot ?area) (!take_picture ?robot ?area ?disaster) (send_data ?robot ?disaster)	)
)

(:method (send_data ?robot ?disaster)
(	(robot ?robot) (disaster ?disaster) (have_picture ?v ?d) (at ?v ?a1) (cdm_at ?c ?a2) (area ?a1) (area ?a2) (in_range ?a1 ?a2)	)
(	(!communicate_data ?robot ?c ?disaster ?a1 ?a2)	)

(	(robot ?robot) (disaster ?disaster) (have_picture ?v ?d) (cdm_at ?c ?a2) (area ?a2) (in_range ?a1 ?a2)	)
(	(navigate ?robot ?a1) (!communicate_data ?robot ?c ?disaster ?a1 ?a2)	)
)

(:method (deliver_box ?box ?area)
(	(ugv ?robot) (box ?box) (area ?area) (store ?s) (store_of ?s ?v) (box_at_cdm ?box ?cdm) (cdm_at ?cdm ?area2)	)
(	(navigate ?robot ?area2) (!pickup_box ?robot ?s ?cdm ?area2 ?box) (navigate ?robot ?area) (!drop_box ?robot ?s ?area ?box)	)
)

(:method (deliver_sample ?cdm ?area2)
(	(usv ?robot) (cdm ?cdm) (area ?area2) (store ?s) (store_of ?s ?v) (cdm_at ?cdm ?area1)	)
(	(navigate ?robot ?area2) (!sample_water ?robot ?s ?area2) (navigate ?robot ?area1) (!drop_sample ?robot ?s ?area1 ?area2 ?cdm)	)
)

))
