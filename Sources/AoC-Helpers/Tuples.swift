import Foundation
import HandyOperators
import SimpleParser

// no gyb here, just copilot

public extension Collection {
	@inlinable
	func extract() -> (Element, Element) {
		assert(count == 2)
		let a = Array(self)
		return (a[0], a[1])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element) {
		assert(count == 3)
		let a = Array(self)
		return (a[0], a[1], a[2])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element, Element) {
		assert(count == 4)
		let a = Array(self)
		return (a[0], a[1], a[2], a[3])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element, Element, Element) {
		assert(count == 5)
		let a = Array(self)
		return (a[0], a[1], a[2], a[3], a[4])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element, Element, Element, Element) {
		assert(count == 6)
		let a = Array(self)
		return (a[0], a[1], a[2], a[3], a[4], a[5])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element, Element, Element, Element, Element) {
		assert(count == 7)
		let a = Array(self)
		return (a[0], a[1], a[2], a[3], a[4], a[5], a[6])
	}
	
	@inlinable
	func extract() -> (Element, Element, Element, Element, Element, Element, Element, Element) {
		assert(count == 8)
		let a = Array(self)
		return (a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7])
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element, Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element, Element, Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
	
	@inlinable
	func splat<T>(_ take: (Element, Element, Element, Element, Element, Element, Element, Element) throws -> T) rethrows -> T {
		try pipe(extract(), into: take)
	}
}

@inlinable
public func pipe<Input, Output>(_ input: Input, into transform: (Input) throws -> Output) rethrows -> Output {
	try transform(input)
}

public extension Parser {
	@inlinable
	mutating func readArray<Element: Parseable>(
		of _: Element.Type = Element.self,
		separatedBy separator: String = ","
	) -> [Element] {
		[] <- {
			$0.append(readValue())
			while tryConsume(separator) {
				consumeWhitespace()
				$0.append(readValue())
			}
		}
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T, T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T, T, T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T, T, T, T, T) {
		readArray(separatedBy: separator).extract()
	}
	
	@inlinable
	mutating func readValues<T: Parseable>(
		of _: T.Type = T.self,
		separatedBy separator: String = ","
	) -> (T, T, T, T, T, T, T, T) {
		readArray(separatedBy: separator).extract()
	}
}
