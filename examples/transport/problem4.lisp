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
	(location city-loc-8)
	(location city-loc-9)
	(vehicle truck-0)
	(vehicle truck-1)
	(vehicle truck-2)
	(vehicle truck-3)
	(package package-0)
	(package package-1)
	(package package-2)
	(package package-3)
	(package package-4)
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
	(road city-loc-9 city-loc-8)
	(road city-loc-8 city-loc-9)
	(at package-0 city-loc-1)
	(at package-1 city-loc-1)
	(at package-2 city-loc-3)
	(at package-3 city-loc-6)
	(at package-4 city-loc-8)
	(at truck-0 city-loc-2)
	(at truck-1 city-loc-4)
	(at truck-2 city-loc-7)
	(at truck-3 city-loc-8)
	(not in package-0 truck-0)
	(not in package-1 truck-0)
	(not in package-2 truck-0)
	(not in package-3 truck-0)
	(not in package-3 truck-0)
	(not in package-0 truck-1)
	(not in package-1 truck-1)
	(not in package-2 truck-1)
	(not in package-3 truck-1)
	(not in package-4 truck-1)
	(not in package-0 truck-2)
	(not in package-1 truck-2)
	(not in package-2 truck-2)
	(not in package-3 truck-2)
	(not in package-4 truck-2)
	(not in package-0 truck-3)
	(not in package-1 truck-3)
	(not in package-2 truck-3)
	(not in package-3 truck-3)
	(not in package-4 truck-3)
  )

(:unordered
   (deliver package-0 city-loc-0)
   (deliver package-1 city-loc-2)
   (deliver package-2 city-loc-4)
   (deliver package-3 city-loc-7)
   (deliver package-4 city-loc-9)
)

)