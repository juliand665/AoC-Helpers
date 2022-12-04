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
