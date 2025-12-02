module tools

pub struct Set[T] {
pub mut:
	 arr []T
}

pub fn (mut s Set[T]) push[T](val T) {
	if ! s.arr.contains(val) {
		s.arr << val
	} 
}

pub fn (a Set[T]) * (b Set[T]) []T {
	mut tmp := []T{}

	if a.arr.len >= b.arr.len {
		for i in a.arr {
			if b.arr.contains(i) && !tmp.contains(i) {
				tmp << i
			}
		} 
	} else {
		for i in b.arr {
			if a.arr.contains(i) && !tmp.contains(i) {
				tmp << i
			}
		}
	}
	return tmp
}

pub fn (a Set[T]) + (b Set[T]) []T {
	mut tmp := a.arr.clone()

	for i in b.arr {
		if !tmp.contains(i) {
			tmp << i
		}
	}
	return tmp
}