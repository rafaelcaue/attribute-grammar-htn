a = [[1,2,3,4],[5,6],[7,8,9,10],[11,12]]
b = a[0].product(*a[1..-1])
puts b.to_s
puts b.size()
