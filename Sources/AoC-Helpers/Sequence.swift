extension Sequence {
	@inlinable
	public func count(where isIncluded: (Element) throws -> Bool) rethrows -> Int {
		try lazy.filter(isIncluded).count
	}
	
	@inlinable
	public func sorted<C>(on accessor: (Element) -> C) -> [Element] where C: Comparable {
		self
			.map { ($0, accessor($0)) }
			.sorted { $0.1 < $1.1 }
			.map { $0.0 }
	}
	
	@inlinable
	public func onlyElement(where isIncluded: (Element) throws -> Bool) rethrows -> Element? {
		try filter(isIncluded).onlyElement()
	}
	
	@inlinable
	public func onlyElement() -> Element? {
		Array(prefix(2)).onlyElement()
	}
	
	@inlinable
	public func pairwiseCombinations() -> AnySequence<(Element, Element)> {
		.init(enumerated().lazy.flatMap { i, lhs in
			enumerated()
				.lazy
				.filter { $0.offset != i }
				.map { (lhs, $0.element) }
		})
	}
	
	@inlinable
	public func allNil<T>() -> Bool where Element == T? {
		allSatisfy { $0 == nil }
	}
}

extension Sequence where Element: AdditiveArithmetic {
	@inlinable
	public func sum() -> Element {
		reduce(.zero, +)
	}
}

extension Sequence where Element == Int {
	@inlinable
	public func product() -> Element {
		reduce(1, *)
	}
}

extension Sequence where Element: Equatable {
	@inlinable
	public func count(of element: Element) -> Int {
		count { $0 == element }
	}
}

extension Sequence where Element: Hashable {
	@inlinable
	public func occurrenceCounts() -> [Element: Int] {
		Dictionary(lazy.map { ($0, 1) }, uniquingKeysWith: +)
	}
	
	@inlinable
	public func mostCommonElement() -> Element? {
		let counts = occurrenceCounts()
		let descending = counts.sorted { -$0.value }
		guard descending.count > 1 else { return descending.first?.key }
		guard descending[0].value > descending[1].value else { return nil }
		return descending.first!.key
	}
}

extension Sequence where Element: Sequence {
	@inlinable
	public func nestedMap<T>(_ transform: (Element.Element) throws -> T) rethrows -> [[T]] {
		try map { try $0.map(transform) }
	}
}

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
}

extension Collection where Element: Collection, Index == Element.Index {
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
