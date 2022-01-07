import SimpleParser

public struct Cuboid: Hashable {
	public var x, y, z: Range<Int>
	
	@inlinable
	public init(x: Range<Int>, y: Range<Int>, z: Range<Int>) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	@inlinable
	public init(center: Vector3, radius: Int) {
		self.x = center.x - radius ..< center.x + radius + 1
		self.y = center.y - radius ..< center.y + radius + 1
		self.z = center.z - radius ..< center.z + radius + 1
	}
	
	@inlinable
	public var volume: Int {
		x.count * y.count * z.count
	}
	
	@inlinable
	public func intersection(with other: Self) -> Self? {
		guard
			let x = x.intersection(with: other.x),
			let y = y.intersection(with: other.y),
			let z = z.intersection(with: other.z)
		else { return nil }
		return .init(x: x, y: y, z: z)
	}
	
	public var corners: [Vector3] {
		[
			.init(x.lowerBound, y.lowerBound, z.lowerBound),
			.init(x.lowerBound, y.lowerBound, z.upperBound),
			.init(x.lowerBound, y.upperBound, z.lowerBound),
			.init(x.lowerBound, y.upperBound, z.upperBound),
			.init(x.upperBound, y.lowerBound, z.lowerBound),
			.init(x.upperBound, y.lowerBound, z.upperBound),
			.init(x.upperBound, y.upperBound, z.lowerBound),
			.init(x.upperBound, y.upperBound, z.upperBound),
		]
	}
}

extension Cuboid: Parseable {
	public init(from parser: inout Parser) {
		parser.consume("x=")
		x = parser.readValue()
		parser.consume(",y=")
		y = parser.readValue()
		parser.consume(",z=")
		z = parser.readValue()
	}
}

extension Cuboid: CustomStringConvertible {
	public var description: String {
		"Cuboid(x: \(x.lowerBound)..\(x.upperBound - 1), y: \(y.lowerBound)..\(y.upperBound - 1), z: \(z.lowerBound)..\(z.upperBound - 1))"
	}
}

extension Range {
	@inlinable
	public func intersection(with other: Self) -> Self? {
		let lower = Swift.max(lowerBound, other.lowerBound)
		let upper = Swift.min(upperBound, other.upperBound)
		return lower < upper ? lower..<upper : nil
	}
}

extension Range: Parseable where Bound == Int{
	public init(from parser: inout Parser) {
		let lower = parser.readInt()
		parser.consume("..")
		let upper = parser.readInt()
		self = lower..<upper + 1
	}
}
