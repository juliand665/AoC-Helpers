import SimpleParser
import HandyOperators

public struct Vector3: Hashable {
	public static let zero = Vector3(0, 0, 0)
	
	public var x, y, z: Int
	
	@inlinable
	public init(_ x: Int, _ y: Int, _ z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	@inlinable
	public var components: [Int] {
		[x, y, z]
	}
	
	@inlinable
	public var absolute: Int {
		abs(x) + abs(y) + abs(z)
	}
	
	@inlinable
	public var normalized: Self {
		let scale = absolute
		return scale == 0 ? self : self / scale
	}
	
	@inlinable public var xy: Vector2 { .init(x, y) }
	@inlinable public var yz: Vector2 { .init(y, z) }
	@inlinable public var xz: Vector2 { .init(x, z) }
	
	@inlinable
	public func with(x: Int? = nil, y: Int? = nil, z: Int? = nil) -> Self {
		.init(x ?? self.x, y ?? self.y, z ?? self.z)
	}
	
	@inlinable
	public static func + (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 += rhs }
	}
	
	@inlinable
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.x += rhs.x
		lhs.y += rhs.y
		lhs.z += rhs.z
	}
	
	@inlinable
	public static func - (lhs: Self, rhs: Self) -> Self {
		lhs <- { $0 -= rhs }
	}
	
	@inlinable
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.x -= rhs.x
		lhs.y -= rhs.y
		lhs.z -= rhs.z
	}
	
	@inlinable
	public static func * (vec: Self, scale: Int) -> Self {
		vec <- { $0 *= scale }
	}
	
	@inlinable
	public static func * (scale: Int, vec: Self) -> Self {
		vec <- { $0 *= scale }
	}
	
	@inlinable
	public static func *= (vec: inout Self, scale: Int) {
		vec.x *= scale
		vec.y *= scale
		vec.z *= scale
	}
	
	@inlinable
	public static func / (vec: Self, scale: Int) -> Self {
		vec <- { $0 /= scale }
	}
	
	@inlinable
	public static func /= (vec: inout Self, scale: Int) {
		vec.x /= scale
		vec.y /= scale
		vec.z /= scale
	}
	
	@inlinable
	public func distance(to other: Self) -> Int {
		(self - other).absolute
	}
}

extension Vector3: Parseable {
	@inlinable
	public init(from parser: inout Parser) {
		x = parser.readInt()
		parser.consume(",")
		y = parser.readInt()
		parser.consume(",")
		z = parser.readInt()
	}
}

extension Vector3 {
	@inlinable
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

extension Array where Element == Vector3 {
	public static let distance1: [Vector3] = [
		Vector3(+1, 00, 00),
		Vector3(-1, 00, 00),
		Vector3(00, +1, 00),
		Vector3(00, -1, 00),
		Vector3(00, 00, +1),
		Vector3(00, 00, -1),
	]
}

extension Vector3 {
	@inlinable
	public var neighbors: [Self] {
		applyingOffsets(.distance1)
	}
	
	@inlinable
	public func applyingOffsets(_ offsets: [Self]) -> [Self] {
		offsets.map { $0 + self }
	}
}
