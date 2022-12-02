import Foundation

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
