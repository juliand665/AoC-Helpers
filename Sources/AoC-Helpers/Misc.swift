extension Optional {
	@inlinable
	public mutating func take() -> Self {
		if let wrapped = self {
			self = nil
			return wrapped
		} else {
			return self
		}
	}
}

/// True Modulo
infix operator %%: MultiplicationPrecedence

public extension BinaryInteger {
	@inlinable
	static func %% (index: Self, count: Self) -> Self {
		let simple = index % count
		return simple >= 0 ? simple : simple + count
	}
}
