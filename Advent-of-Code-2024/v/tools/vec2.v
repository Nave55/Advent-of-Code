module tools

pub struct Vec2[T] {
pub mut:
	 x T
	 y T
}

pub fn (a Vec2[T]) + (b Vec2[T]) Vec2[T] {
	return Vec2[T]{a.x + b.x, a.y + b.y}
}

pub fn (a Vec2[T]) - (b Vec2[T]) Vec2[T] {
	return Vec2[T]{a.x - b.x, a.y - b.y}
}

pub fn (a Vec2[T]) * (b Vec2[T]) Vec2[T] {
	return Vec2[T]{a.x * b.x, a.y * b.y}
}

pub fn (a Vec2[T]) mul_by_scalar[T](val T) Vec2[T] {
	return Vec2[T]{a.x * val, a.y * val}
}

pub fn (a Vec2[T]) to_str[T]() string {
	return "${a.x},${a.y}"
}

pub fn str_to_vec2[T](s string) Vec2[T] {
	tmp := s.split(",").map(it.int())
	return Vec2[T]{tmp[0], tmp[1]}
}

// pub fn (a Vec2[T]) mul_by_scalar[T](val T) Vec2[T] {
// 	return Vec2[T]{a.x * val, a.y * val}
// }
