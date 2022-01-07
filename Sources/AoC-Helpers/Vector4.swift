import SimpleParser
import HandyOperators

public struct Vector4: Hashable {
	public static let zero = Vector4(0, 0, 0, 0)
	
	public var x, y, z, w: Int
	
	public init(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}
	
	public var absolute: Int {
		abs(x) + abs(y) + abs(z) + abs(w)
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 += rhs }
	}
	
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.x += rhs.x
		lhs.y += rhs.y
		lhs.z += rhs.z
		lhs.w += rhs.w
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 -= rhs }
	}
	
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.x -= rhs.x
		lhs.y -= rhs.y
		lhs.z -= rhs.z
		lhs.w -= rhs.w
	}
	
	public static func * (vec: Self, scale: Int) -> Self {
		vec <- { $0 *= scale }
	}
	
	public static func * (scale: Int, vec: Self) -> Self {
		vec <- { $0 *= scale }
	}
	
	public static func *= (vec: inout Self, scale: Int) {
		vec.x *= scale
		vec.y *= scale
		vec.z *= scale
		vec.w *= scale
	}
	
	public func distance(to other: Self) -> Int {
		(self - other).absolute
	}
}

extension Vector4: Parseable {
	public init(from parser: inout Parser) {
		x = parser.readInt()
		parser.consume(",")
		y = parser.readInt()
		parser.consume(",")
		z = parser.readInt()
		parser.consume(",")
		w = parser.readInt()
	}
}
