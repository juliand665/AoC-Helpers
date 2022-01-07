import SimpleParser
import HandyOperators

public struct Vector3: Hashable {
	public static let zero = Vector3(0, 0, 0)
	
	public var x, y, z: Int
	
	public init(x: Int, y: Int, z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	public init(_ x: Int, _ y: Int, _ z: Int) {
		self.init(x: x, y: y, z: z)
	}
	
	public var absolute: Int {
		abs(x) + abs(y) + abs(z)
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 += rhs }
	}
	
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.x += rhs.x
		lhs.y += rhs.y
		lhs.z += rhs.z
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 -= rhs }
	}
	
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.x -= rhs.x
		lhs.y -= rhs.y
		lhs.z -= rhs.z
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
	}
	
	public func distance(to other: Self) -> Int {
		(self - other).absolute
	}
}

extension Vector3: Parseable {
	public init(from parser: inout Parser) {
		x = parser.readInt()
		parser.consume(",")
		y = parser.readInt()
		parser.consume(",")
		z = parser.readInt()
	}
}

extension Vector3 {
	public var allOrientations: [Self] {
		[
			// original order (even sign flips)
			
			Self(+x, +y, +z),
			Self(+x, -y, -z),
			Self(-x, +y, -z),
			Self(-x, -y, +z),
			
			Self(+y, +z, +x),
			Self(+y, -z, -x),
			Self(-y, +z, -x),
			Self(-y, -z, +x),
			
			Self(+z, +x, +y),
			Self(+z, -x, -y),
			Self(-z, +x, -y),
			Self(-z, -x, +y),
			
			// reverse order (odd sign flips)
			
			Self(-z, +y, +x),
			Self(+z, -y, +x),
			Self(+z, +y, -x),
			Self(-z, -y, -x),
			
			Self(-y, +x, +z),
			Self(+y, -x, +z),
			Self(+y, +x, -z),
			Self(-y, -x, -z),
			
			Self(-x, +z, +y),
			Self(+x, -z, +y),
			Self(+x, +z, -y),
			Self(-x, -z, -y),
		]
	}
}
