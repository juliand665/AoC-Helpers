extension Sequence {
	@inlinable
	public func count(where isIncluded: (Element) throws -> Bool) rethrows -> Int {
		try lazy.filter(isIncluded).reduce(0) { sum, _ in sum + 1 }
	}
	
	@inlinable
	public func sorted<C>(on accessor: (Element) -> C) -> [Element] where C: Comparable {
		self.sorted { accessor($0) < accessor($1) }
	}
	
	@inlinable
	public func max<C>(on accessor: (Element) -> C) -> Element? where C: Comparable {
		self.max { accessor($0) < accessor($1) }
	}
	
	@inlinable
	public func onlyElement(where isIncluded: (Element) throws -> Bool) rethrows -> Element? {
		try lazy.filter(isIncluded).onlyElement()
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
	
	@inlinable
	public func reduce(_ combine: (Element, Element) throws -> Element) rethrows -> Element? {
		guard let (first, rest) = chop() else { return nil }
		return try rest.reduce(first, combine)
	}
	
	@inlinable
	public func chop() -> (Element, some Sequence<Element>)? {
		var iterator = makeIterator()
		guard let first = iterator.next() else {
			return nil as (Element, IteratorSequence<Iterator>)? // ugh
		}
		return (first, IteratorSequence(iterator))
	}
}

extension Sequence where Element: Sequence, Element.Element: Hashable {
	public func intersectionOfElements() -> Set<Element.Element> {
		guard let (first, rest) = chop() else { return [] }
		return rest.reduce(into: Set(first)) { $0.formIntersection($1) }
	}
	
	public func unionOfElements() -> Set<Element.Element> {
		reduce(into: Set()) { $0.formUnion($1) }
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
	@_disfavoredOverload
	@inlinable
	public func nestedMap<T>(_ transform: (Element.Element) throws -> T) rethrows -> [[T]] {
		try map { try $0.map(transform) }
	}
	
	@_disfavoredOverload
	@inlinable
	public func nestedMap<T>(
		_ transform: @escaping (Element.Element) -> T
	) -> some Collection<LazyMapSequence<Element, T>> { // can't nest opaque return types as of Xcode 15.1
		self.lazy.map { $0.lazy.map(transform) }
	}
}
