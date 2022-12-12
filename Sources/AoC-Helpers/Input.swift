import Foundation
import SimpleParser

public func input(filename: String = "input") -> Substring {
	let url = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "txt")!)
	let rawInput = try! Data(contentsOf: url)
	return String(data: rawInput, encoding: .utf8)!.dropLast() // trailing newline
}

extension StringProtocol {
	@inlinable
	public func lines() -> [SubSequence] {
		split(separator: "\n", omittingEmptySubsequences: false)
	}
	
	@inlinable
	public func lineGroups() -> [ArraySlice<SubSequence>] {
		split(separator: "\n", omittingEmptySubsequences: false)
			.split(whereSeparator: \.isEmpty)
	}
	
	@_disfavoredOverload
	@available(macOS 13.0, *)
	@inlinable
	public func lineGroups() -> [SubSequence] {
		split(separator: "\n\n")
	}
	
	@inlinable
	public func words() -> [SubSequence] {
		split(separator: " ")
	}
}

extension Sequence where Element: StringProtocol {
	@inlinable
	public func asInts() -> [Int] {
		map { Int($0)! }
	}
}

extension Character {
	@inlinable
	public static func - (query: Self, base: Self) -> Int {
		Int(query.asciiValue! - base.asciiValue!)
	}
	
	@inlinable
	public static func + (base: Self, offset: Int) -> Self {
		.init(.init(base.asciiValue! + .init(offset)))
	}
}

extension Parser {
	@usableFromInline
	static let digits = Set("0123456789")
	@usableFromInline
	static let digitsOrSigns = Set("+-0123456789")
	@inlinable
	public func ints(allowSigns: Bool = false) -> [Int] {
		let triggers = allowSigns ? Self.digitsOrSigns : Self.digits
		return Array(sequence(state: self) {
			$0.consume { !triggers.contains($0) }
			if $0.isDone { return nil }
			return $0.readInt()
		})
	}
	
	@inlinable
	public func int(allowSigns: Bool = false) -> Int {
		ints(allowSigns: allowSigns).onlyElement()!
	}
	
	@inlinable
	@discardableResult
	public mutating func consumeLine() -> Substring {
		consume(through: "\n") ?? consumeRest()
	}
	
	@inlinable
	public mutating func line() -> Self {
		.init(reading: consumeLine())
	}
	
	public func auto() -> String {
		.init(input)
	}
	
	public func auto() -> [Int] {
		ints()
	}
	
	public func auto() -> Int {
		ints().onlyElement()!
	}
	
	public func auto() -> (Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int, Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int, Int, Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int, Int, Int, Int, Int) {
		ints().extract()
	}
	
	public func auto() -> (Int, Int, Int, Int, Int, Int, Int, Int) {
		ints().extract()
	}
}

extension StringProtocol {
	@inlinable
	public func ints(allowSigns: Bool = false) -> [Int] {
		Parser(reading: self).ints(allowSigns: allowSigns)
	}
}
