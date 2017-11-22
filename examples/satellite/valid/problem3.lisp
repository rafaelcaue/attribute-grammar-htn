(defproblem p03 satellite
  (
	(instrument instrument0)
	(satellite satellite0)
	(mode thermograph0)
	(direction GroundStation2)
	(direction Phenomenon1)
	(direction Phenomenon3)
	(direction Phenomenon4)
	(direction Phenomenon6)
	(on_board instrument0 satellite0)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation2)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
  )

(:unordered
   (do_observation Phenomenon1 thermograph0)
)

)
