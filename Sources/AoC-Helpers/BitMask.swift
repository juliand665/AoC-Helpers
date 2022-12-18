import Algorithms

public struct BitMask<RawValue: BinaryInteger>: Hashable {
	public var raw: RawValue = 0
	
	@inlinable
	public init(raw: RawValue) {
		self.raw = raw
	}
	
	@inlinable
	public var isEmpty: Bool { raw == 0 }
	
	@inlinable
	public func contains(_ other: some BinaryInteger) -> Bool {
		raw & (1 << other) != 0
	}
	
	@inlinable
	public mutating func insert(_ other: some BinaryInteger) {
		raw |= (1 << other)
	}
	
	@inlinable
	public mutating func insertNew(_ other: some BinaryInteger) {
		assert(!contains(other))
		insert(other)
	}
	
	@inlinable
	public func inserting(_ other: some BinaryInteger) -> Self {
		.init(raw: raw | (1 << other))
	}
	
	@inlinable
	public static func & (lhs: Self, rhs: Self) -> Self {
		.init(raw: lhs.raw & rhs.raw)
	}
	
	@inlinable
	public static func | (lhs: Self, rhs: Self) -> Self {
		.init(raw: lhs.raw | rhs.raw)
	}
	
	@inlinable
	public static func ^ (lhs: Self, rhs: Self) -> Self {
		.init(raw: lhs.raw ^ rhs.raw)
	}
}

extension BitMask {
	@inlinable
	public init<I: BinaryInteger>(_ values: some Sequence<I>) {
		for value in values {
			insert(value)
		}
	}
}

extension BitMask: ExpressibleByArrayLiteral {
	// can't make this generic over the type unfortunately
	@inlinable
	public init(arrayLiteral elements: Int...) {
		self.init(elements)
	}
}

extension BitMask: CustomStringConvertible {
	public var description: String {
		"BitMask(\(String(String(raw, radix: 2).reversed().chunks(ofCount: 8).joined(separator: " ").reversed())))"
	}
}
