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
