(defproblem problem transport
  (
	(location city-loc-0)
	(location city-loc-1)
	(location city-loc-2)
	(location city-loc-3)
	(location city-loc-4)
	(location city-loc-5)
	(location city-loc-6)
	(location city-loc-7)
	(vehicle truck-0)
	(vehicle truck-1)
	(vehicle truck-2)
	(package package-0)
	(package package-1)
	(package package-2)
	(package package-3)
	(road city-loc-0 city-loc-1)
	(road city-loc-1 city-loc-0)
	(road city-loc-1 city-loc-2)
	(road city-loc-2 city-loc-1)
	(road city-loc-2 city-loc-4)
	(road city-loc-4 city-loc-2)
	(road city-loc-3 city-loc-4)
	(road city-loc-4 city-loc-3)
	(road city-loc-7 city-loc-6)
	(road city-loc-6 city-loc-7)
	(at package-0 city-loc-1)
	(at package-1 city-loc-1)
	(at package-2 city-loc-3)
	(at package-3 city-loc-6)
	(at truck-0 city-loc-2)
	(at truck-1 city-loc-4)
	(at truck-2 city-loc-7)
	(not in package-0 truck-0)
	(not in package-1 truck-0)
	(not in package-2 truck-0)
	(not in package-3 truck-0)
	(not in package-0 truck-1)
	(not in package-1 truck-1)
	(not in package-2 truck-1)
	(not in package-3 truck-1)
	(not in package-0 truck-2)
	(not in package-1 truck-2)
	(not in package-2 truck-2)
	(not in package-3 truck-2)
  )

(:unordered
   (deliver package-0 city-loc-0)
   (deliver package-1 city-loc-2)
)

)
