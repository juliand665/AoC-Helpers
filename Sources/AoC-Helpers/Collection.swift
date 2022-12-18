extension Collection {
	@inlinable
	public func onlyElement() -> Element? {
		count == 1 ? first! : nil
	}
	
	@inlinable
	public func bothElements() -> (Element, Element)? {
		count == 2 ? (first!, dropFirst().first!) : nil
	}
	
	@inlinable
	public func asOptional() -> Element? {
		assert(count <= 1)
		return first
	}
	
	@inlinable
	public subscript(wrapping index: Index) -> Element where Index: BinaryInteger {
		let count = Index(count)
		let simple = index % count
		return self[simple >= 0 ? simple : simple + count]
	}
	
	@inlinable
	public subscript(orNil index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

extension Collection where Element: Collection {
	@inlinable
	public func transposed() -> [[Element.Element]] {
		first!.indices.map { i in map { $0[i] } }
	}
}

extension MutableCollection {
	@inlinable
	public mutating func forEachMutate(_ transform: (inout Element) -> Void) {
		// can't use self.indices because that might keep a reference to self, preventing copy-on-write!
		var index = startIndex
		while index != endIndex {
			transform(&self[index])
			index = self.index(after: index)
		}
	}
}

extension Dictionary where Key == Int {
	@inlinable
	public func asArray() -> [Value] {
		assert(keys.min() == 0)
		assert(keys.max() == count - 1)
		return sorted(on: \.key).map(\.value)
	}
}
