import Foundation
import HandyOperators

public struct Matrix<Element> {
	public let width, height: Int
	/// row-major list of elements in the matrix
	public var rows: [[Element]]
	
	@inlinable
	public var columns: some RandomAccessCollection<ColumnView> {
		(0..<width).lazy.map(column(at:))
	}
	
	@inlinable
	public var elements: some BidirectionalCollection<Element> {
		rows.joined()
	}
	
	@inlinable
	public var positions: some Collection<Vector2> {
		(0..<height).lazy.flatMap { y in
			(0..<width).lazy.map { x in Vector2(x, y) }
		}
	}
	
	@inlinable
	public init<Outer: Collection, Inner: Collection>(
		_ rows: Outer
	) where Outer.Element == Inner, Inner.Element == Element {
		let width = rows.first!.count
		self.width = width
		self.height = rows.count
		assert(rows.allSatisfy { $0.count == width })
		self.rows = Array(rows.map(Array.init))
	}
	
	// this conflicts with the computing init with trailing closure syntax
	@_disfavoredOverload
	@inlinable
	public init(width: Int, height: Int, repeating element: Element) {
		self.init(Array(
			repeating: Array(repeating: element, count: width),
			count: height
		))
	}
	
	@inlinable
	public init(width: Int, height: Int, computing element: (Vector2) throws -> Element) rethrows {
		self.init(
			try (0..<height).map { y in
				try (0..<width).map { x in
					try element(.init(x, y))
				}
			}
		)
	}
	
	@inlinable
	public init<S: Sequence>(
		positions: S,
		present: Element, absent: Element
	) where S.Element == Vector2 {
		self.init(
			width: (positions.map(\.x).max() ?? 0) + 1,
			height: (positions.map(\.y).max() ?? 0) + 1,
			repeating: absent
		)
		for position in positions {
			self[position] = present
		}
	}
	
	@inlinable
	public subscript(x: Int, y: Int) -> Element {
		_read { yield rows[y][x] }
		_modify { yield &rows[y][x] }
	}
	
	@inlinable
	public subscript(position: Vector2) -> Element {
		_read { yield self[position.x, position.y] }
		_modify { yield &self[position.x, position.y] }
	}
	
	@inlinable
	public func isInMatrix(_ position: Vector2) -> Bool {
		guard
			case 0..<width = position.x,
			case 0..<height = position.y
		else { return false }
		return true
	}
	
	@inlinable
	public func wrap(_ position: Vector2) -> Vector2 {
		.init(position.x %% width, position.y %% height)
	}
	
	@inlinable
	public func element(at position: Vector2) -> Element? {
		guard isInMatrix(position) else { return nil }
		return self[position]
	}
	
	@inlinable
	public func indexedElement(at position: Vector2) -> (position: Vector2, element: Element)? {
		guard isInMatrix(position) else { return nil }
		return (position, self[position])
	}
	
	@inlinable
	public func neighbors(of position: Vector2) -> some Collection<Element> {
		position.neighbors.lazy.compactMap(element(at:))
	}
	
	@inlinable
	public func neighborsWithDiagonals(of position: Vector2) -> some Collection<Element> {
		position.neighborsWithDiagonals.lazy.compactMap(element(at:))
	}
	
	@inlinable
	public func row(at y: Int) -> [Element] {
		rows[y]
	}
	
	@inlinable
	public func column(at x: Int) -> ColumnView {
		.init(base: self, x: x)
	}
	
	@inlinable
	public mutating func swapRowsAt(_ i: Int, _ j: Int) {
		rows.swapAt(i, j)
	}
	
	@inlinable
	public func positionMatrix() -> Matrix<Vector2> {
		.init(width: width, height: height) { $0 }
	}
	
	@inlinable
	public var indexed: some Collection<(position: Vector2, element: Element)> {
		zip(positions, elements).lazy.map { $0 } // rename tuple
	}
	
	@inlinable
	public func transposed() -> Self {
		guard let first = self.element(at: .zero) else { return self }
		
		return Matrix(width: height, height: width, repeating: first) <- { copy in
			for (position, element) in indexed {
				copy[position.y, position.x] = element
			}
		}
	}
	
	@inlinable
	public func map<T>(_ transform: (Element) throws -> T) rethrows -> Matrix<T> {
		.init(try rows.nestedMap(transform))
	}
	
	@inlinable
	public func flattened<T>() -> Matrix<T> where Element == Matrix<T> {
		.init(rows.flatMap { matrices -> [[T]] in
			matrices
				.map { $0.rows }
				.transposed()
				.map { Array($0.joined()) }
		})
	}
	
	public struct ColumnView: RandomAccessCollection {
		@usableFromInline var base: Matrix
		@usableFromInline var x: Int
		public let startIndex: Int
		public let endIndex: Int
		
		@inlinable
		public subscript(y: Int) -> Element {
			base[x, y]
		}
		
		@usableFromInline
		init(base: Matrix, x: Int) {
			self.base = base
			self.x = x
			self.startIndex = 0
			self.endIndex = base.rows.count
		}
	}
}

extension Matrix: CustomStringConvertible {
	public var description: String {
		"""
		\(type(of: self))(
		\(contentLines.map { "\t\($0)" }.joined(separator: "\n"))
		)
		"""
	}
	
	public var contentLines: [String] {
		let descriptions = self.map(String.init(describing:))
		let maxLength = descriptions.map(\.count).max()!
		return descriptions.rows.map {
			$0
				.map { String(repeating: " ", count: maxLength - $0.count) + $0 }
				.joined(separator: " ")
		}
	}
}

extension Matrix where Element == Character {
	public var description: String {
		let indices = (0...).lazy.flatMap { _ in (0..<10) }
		let indexChars = indices.map { Character(String($0)) }
		let headerRow = " " + indexChars.prefix(width).flatMap { " \($0)" }
		let contentRows = zip(indexChars, contentLines).map { "\($0) \($1)" }
		return ([headerRow] + contentRows).joined(separator: "\n")
	}
}

extension Matrix: RandomAccessCollection {
	@inlinable
	public var startIndex: Vector2 { .zero }
	
	@inlinable
	public var endIndex: Vector2 { .init(0, height) }
	
	@inlinable
	public func index(before i: Vector2) -> Vector2 {
		if i.x - 1 >= 0 {
			return Vector2(i.x - 1, i.y)
		} else {
			return Vector2(width - 1, i.y - 1)
		}
	}
	
	@inlinable
	public func index(after i: Vector2) -> Vector2 {
		if i.x + 1 < width {
			return Vector2(i.x + 1, i.y)
		} else {
			return Vector2(0, i.y + 1)
		}
	}
}

extension Matrix where Element == Int {
	@inlinable
	public init(digitsOf lines: [Substring]) {
		self.init(lines.map { $0.map(String.init).asInts() })
	}
}

extension Matrix where Element == Character {
	@inlinable
	public init<S: Sequence>(positions: S) where S.Element == Vector2 {
		self.init(positions: positions, present: "█", absent: "·")
	}
}

extension Matrix where Element == Bool {
	public func binaryImage() -> String {
		map { $0 ? "██" : "··" }.rows.map { $0.joined() }.joined(separator: "\n")
	}
}

extension Matrix: Equatable where Element: Equatable {}
extension Matrix: Hashable where Element: Hashable {}

extension Matrix {
    @inlinable
    public func positions(where shouldInclude: (Element) throws -> Bool) rethrows -> [Vector2] {
        try positions.filter { try shouldInclude(self[$0]) }
    }
}

extension Matrix where Element: Equatable {
    @inlinable
    public func positions(of element: Element) -> [Vector2] {
        positions { $0 == element }
    }
}
