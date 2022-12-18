import SimpleParser

@inlinable
public func autoFlippedRange(_ a: Int, _ b: Int) -> [Int] {
	a <= b ? Array(a...b) : (b...a).reversed()
}

extension ClosedRange {
	@inlinable
	public func contains(_ other: Self) -> Bool {
		lowerBound <= other.lowerBound && upperBound >= other.upperBound
	}
	
	@inlinable
	public func expanded(by delta: Bound) -> Self where Bound: AdditiveArithmetic {
		lowerBound - delta ... upperBound + delta
	}
}

extension ClosedRange: Parseable where Bound == Int {
	@inlinable
	public init(from parser: inout Parser) {
		self = parser.readArray(of: Int.self, separatedBy: "-").splat(...)
	}
}

extension Int: Parseable {
	@inlinable
	public init(from parser: inout Parser) {
		self = parser.readInt()
	}
}

extension Int {
	@inlinable
	public func clamped(to range: ClosedRange<Self>) -> Self {
		Swift.min(range.upperBound, Swift.max(range.lowerBound, self))
	}
	
	@inlinable
	public func clamped(to range: Range<Self>) -> Self {
		Swift.min(range.upperBound - 1, Swift.max(range.lowerBound, self))
	}
}

extension ClosedRange {
	public func clamped(to other: PartialRangeFrom<Bound>) -> Self {
		Swift.max(lowerBound, other.lowerBound)...upperBound
	}
	
	public func clamped(to other: PartialRangeThrough<Bound>) -> Self {
		lowerBound...Swift.min(upperBound, other.upperBound)
	}
	
	public func clamped(to other: PartialRangeUpTo<Bound>) -> Self where Bound: BinaryInteger {
		lowerBound...Swift.min(upperBound, other.upperBound - 1)
	}
}
