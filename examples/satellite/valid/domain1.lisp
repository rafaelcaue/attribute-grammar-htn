(defdomain satellite (

  (:operator (!turn_to ?s ?d_new ?d_prev)
	( (satellite ?s) (direction ?d_new) (direction ?d_prev) (pointing ?s ?d_prev) )
	( (pointing ?s ?d_prev) )
	( (pointing ?s ?d_new) )
  )

 (:operator (!switch_on ?i ?s)
	( (instrument ?i) (satellite ?s) (on_board ?i ?s) (power_avail ?s) )
	( (calibrated ?i) (power_avail ?s) )
	( (power_on ?i) )
 )

 (:operator (!switch_off ?i ?s)
	( (instrument ?i) (satellite ?s) (on_board ?i ?s) (power_on ?i) )
	( (power_on ?i) )
	( (power_avail ?s) )
 )
 
 (:operator (!calibrate ?s ?i ?d)
	( (satellite ?s) (instrument ?i) (direction ?d) (on_board ?i ?s) (calibration_target ?i ?d) (pointing ?s ?d) (power_on ?i) )
	(  )
	( (calibrated ?i) )
 )
 
 (:operator (!take_image ?s ?d ?i ?m)
	( (satellite ?s) (direction ?d) (instrument ?i) (mode ?m) (calibrated ?i) (pointing ?s ?d) (on_board ?i ?s) (power_on ?i) (supports ?i ?m) )
	(  )
	( (have_image ?d ?m) )
 )
  
  (:method (do_observation ?d ?m)
	( (satellite ?s) (on_board ?i ?s) (supports ?i ?m) )
	( (activate_instrument ?i ?s) (reposition ?s ?d) (!take_image ?s ?d ?i ?m) )
  )
  
  (:method (reposition ?s ?d_new)
    ( (pointing ?s ?d_new) )
    ( )
  
	( (pointing ?s ?d_prev) )
	( (!turn_to ?s ?d_new ?d_prev) )
  )
  
  (:method (activate_instrument ?i ?s)
	( (power_avail ?s) )
	( (!switch_on ?i ?s) (auto_calibrate ?i ?s) )
	
	( )
	( (!switch_off ?i ?s) (!switch_on ?i ?s) (auto_calibrate ?i ?s) )
  )
  
  (:method (auto_calibrate ?i ?s)
	( (calibrated ?i) )
	( )
  
	( (calibration_target ?i ?d) )
	( (reposition ?s ?d) (!calibrate ?s ?i ?d) )
  )
  
   (:method (root)
	 ( )
	 ( (reposition ?s ?d1) (reposition ?s ?d2) )
   )

))

