/// True Modulo
infix operator %%: MultiplicationPrecedence

public extension BinaryInteger {
	@inlinable
	static func %% (index: Self, count: Self) -> Self {
		let simple = index % count
		return simple >= 0 ? simple : simple + count
	}
}

public extension BinaryInteger {
	@inlinable
	func ceilOfDivision(by divisor: Self) -> Self {
		let (quotient, remainder) = quotientAndRemainder(dividingBy: divisor)
		return quotient + (remainder == 0 ? 0 : remainder.signum())
	}
}

/// greatest common divisor of two integers (Euclid's algorithm)
@inlinable
public func gcd<I: BinaryInteger>(_ a: I, _ b: I) -> I {
	let remainder = a % b
	guard remainder > 0 else { return b }
	return gcd(b, remainder)
}

/// lowest common multiple of two integers (via ``gcd``)
@inlinable
public func lcm<I: BinaryInteger>(_ a: I, _ b: I) -> I {
	a / gcd(a, b) * b
}

public extension Sequence where Element: BinaryInteger {
	@inlinable
	func greatestCommonDivisor() -> Element {
		reduce(1, gcd)
	}
	
	@inlinable
	func lowestCommonMultiple() -> Element {
		reduce(1, lcm)
	}
}
