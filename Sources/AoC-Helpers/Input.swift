import Foundation

public func input(filename: String = "input") -> Substring {
	let url = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "txt")!)
	let rawInput = try! Data(contentsOf: url)
	return String(data: rawInput, encoding: .utf8)!.dropLast() // trailing newline
}

extension StringProtocol {
	public func lines() -> [SubSequence] {
		split(separator: "\n", omittingEmptySubsequences: false)
	}
	
	public func words() -> [SubSequence] {
		split(separator: " ")
	}
}

extension Sequence where Element: StringProtocol {
	public func asInts() -> [Int] {
		map { Int($0)! }
	}
}
