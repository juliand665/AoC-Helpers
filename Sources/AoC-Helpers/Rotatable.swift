public protocol Rotatable {
	func rotated() -> Self
	func rotated(by diff: Int) -> Self
	
	mutating func rotate()
	mutating func rotate(by diff: Int)
}

public extension Rotatable {
	@inlinable
	func rotated() -> Self {
		rotated(by: 1)
	}
	
	@inlinable
	mutating func rotate() {
		self = rotated(by: 1)
	}
	
	@inlinable
	mutating func rotate(by diff: Int) {
		self = rotated(by: diff)
	}
}

extension Rotatable where Self: CaseIterable, Self: Equatable, Self.AllCases.Index == Int {
	@inlinable
	public var rotationIndex: Int { Self.allCases.firstIndex(of: self)! }
	
	@inlinable
	public func rotated(by diff: Int = 1) -> Self {
		let cases = Self.allCases
		return cases[(cases.firstIndex(of: self)! + diff + cases.count) % cases.count]
	}
}
