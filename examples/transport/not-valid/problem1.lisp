(defproblem problem transport
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

(:unordered
   (get-to truck-0 city-loc-1)
   (get-to truck-0 city-loc-0)
)

)
