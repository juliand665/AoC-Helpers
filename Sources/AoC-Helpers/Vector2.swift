import Foundation
import SimpleParser
import HandyOperators

public struct Vector2: Hashable {
	public static let zero = Vector2(0, 0)
	public static let unitX = Vector2(1, 0)
	public static let unitY = Vector2(0, 1)
	
	public var x, y: Int
	
	@inlinable
	public init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
	
	@inlinable
	public var absolute: Int {
		abs(x) + abs(y)
	}
	
	@inlinable
	public var neighbors: [Vector2] {
		applyingOffsets(.distance1)
	}
	
	@inlinable
	public var neighborsWithDiagonals: [Vector2] {
		applyingOffsets(.distance1orDiagonal)
	}
	
	@inlinable
	public var angle: Double {
		atan2(Double(y), Double(x))
	}
	
	@inlinable
	public static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
		lhs <- { $0 += rhs }
	}
	
	@inlinable
	public static func += (lhs: inout Vector2, rhs: Vector2) {
		lhs.x += rhs.x
		lhs.y += rhs.y
	}
	
	@inlinable
	public static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
		lhs <- { $0 -= rhs }
	}
	
	@inlinable
	public static func -= (lhs: inout Vector2, rhs: Vector2) {
		lhs.x -= rhs.x
		lhs.y -= rhs.y
	}
	
	@inlinable
	public static func * (vec: Vector2, scale: Int) -> Vector2 {
		vec <- { $0 *= scale }
	}
	
	@inlinable
	public static func * (scale: Int, vec: Vector2) -> Vector2 {
		vec <- { $0 *= scale }
	}
	
	@inlinable
	public static func *= (vec: inout Vector2, scale: Int) {
		vec.x *= scale
		vec.y *= scale
	}
	
	@inlinable
	public func distance(to other: Vector2) -> Int {
		(self - other).absolute
	}
	
	@inlinable
	public func with(x: Int? = nil, y: Int? = nil) -> Vector2 {
		.init(x ?? self.x, y ?? self.y)
	}
}

extension Vector2: Comparable {
	@inlinable
	public static func < (lhs: Vector2, rhs: Vector2) -> Bool {
		(lhs.y, lhs.x) < (rhs.y, rhs.x)
	}
}

extension Vector2: CustomStringConvertible {
	public var description: String {
		"(\(x), \(y))"
	}
}

extension Vector2: Parseable {
	public init(from parser: inout Parser) {
		parser.consumeWhitespace()
		x = parser.readInt()
		parser.consume(",")
		parser.consumeWhitespace()
		y = parser.readInt()
	}
}

public enum Direction: CaseIterable, Rotatable {
	case up
	case right
	case down
	case left
	
	@inlinable
	public var offset: Vector2 {
		switch self {
		case .up:
			return Vector2(00, -1)
		case .right:
			return Vector2(+1, 00)
		case .down:
			return Vector2(00, +1)
		case .left:
			return Vector2(-1, 00)
		}
	}
	
	@inlinable
	public var opposite: Self {
		switch self {
		case .up:
			return .down
		case .right:
			return .left
		case .down:
			return .up
		case .left:
			return .right
		}
	}
}

public struct DirectionSet: OptionSet {
	public static let up = Self(rawValue: 1 << 0)
	public static let right = Self(rawValue: 1 << 1)
	public static let down = Self(rawValue: 1 << 2)
	public static let left = Self(rawValue: 1 << 3)
	
	public var rawValue: UInt8
	
	@inlinable
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	
	@inlinable
	public init(_ direction: Direction) {
		switch direction {
		case .up:
			self = .up
		case .right:
			self = .right
		case .down:
			self = .down
		case .left:
			self = .left
		}
	}
}

extension Direction: CustomStringConvertible {
	public var description: String {
		switch self {
		case .up:
			return "↑"
		case .right:
			return "→"
		case .down:
			return "↓"
		case .left:
			return "←"
		}
	}
}

extension Array where Element == Vector2 {
	public static let distance1 = [
		Vector2(00, -1),
		Vector2(+1, 00),
		Vector2(00, +1),
		Vector2(-1, 00),
	]
	
	public static let distance1orDiagonal = [
		Vector2(00, -1),
		Vector2(+1, -1),
		Vector2(+1, 00),
		Vector2(+1, +1),
		Vector2(00, +1),
		Vector2(-1, +1),
		Vector2(-1, 00),
		Vector2(-1, -1),
	]
}

extension Vector2 {
	public func applyingOffsets(_ offsets: [Vector2]) -> [Vector2] {
		offsets.map { $0 + self }
	}
}
