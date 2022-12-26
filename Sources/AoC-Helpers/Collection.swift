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
	public func onlyIndex(where condition: (Element) throws -> Bool) rethrows -> Index? {
		try indexed().filter { try condition($1) }.onlyElement()?.index
	}
	
	@inlinable
	public func onlyIndex(of element: Element) -> Index? where Element: Equatable {
		onlyIndex { $0 == element }
	}
	
	@inlinable
	public func asOptional() -> Element? {
		assert(count <= 1)
		return first
	}
	
	@inlinable
	public subscript(wrapping index: Index) -> Element where Index: BinaryInteger {
		self[index %% Index(count)]
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

public extension Dictionary {
	@inlinable
	init(values: some Sequence<Value>, keyedBy key: (Value) -> Key) {
		self.init(uniqueKeysWithValues: values.map { (key($0), $0) })
	}
	
	@inlinable
	init(values: some Sequence<Value>) where Value: Identifiable, Key == Value.ID {
		self.init(values: values, keyedBy: \.id)
	}
}

public extension Sequence {
	@inlinable
	func identified<Key>(by key: (Element) -> Key) -> [Key: Element] {
		.init(values: self, keyedBy: key)
	}
	
	@inlinable
	func asDictionary<K, V>() -> [K: V] where Element == (K, V) {
		.init(uniqueKeysWithValues: self)
	}
	
	@inlinable
	func asArray() -> [Element] {
		.init(self)
	}
	
	@inlinable
	func asSet() -> Set<Element> where Element: Hashable {
		.init(self)
	}
	
	@inlinable
	func asString() -> String where Element == Character {
		.init(self)
	}
}

public extension RangeReplaceableCollection {
	@inlinable
	mutating func popFirst(_ n: Int) -> [Element]? {
		guard count >= n else { return nil }
		defer { removeFirst(n) }
		return .init(prefix(n))
	}
	
	@inlinable
	mutating func popLast(_ n: Int) -> [Element]? where Self: BidirectionalCollection {
		guard count >= n else { return nil }
		defer { removeLast(n) }
		return .init(suffix(n))
	}
}

public extension BidirectionalCollection {
	@inlinable
	func ends(with suffix: some Collection<Element>) -> Bool where Element: Equatable {
		self.suffix(suffix.count).elementsEqual(suffix)
	}
}
