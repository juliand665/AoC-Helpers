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

/// stores the auto-incremented IDs for `getID`
public private(set) var rawIDs: [String] = []
/// provides auto-incremented IDs
@inlinable
public func getID(_ raw: String) -> Int {
	if let index = rawIDs.firstIndex(of: raw) {
		return index
	} else {
		rawIDs.append(raw)
		return rawIDs.count - 1
	}
}

/// provides auto-incremented IDs
@inlinable
public func getID(_ raw: some StringProtocol) -> Int {
	getID(String(raw))
}
