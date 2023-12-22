public struct Cycled<Info> {
	public var byRound: [Info]
	public var period: Int
	
	@inlinable
	public func info(at round: Int) -> Info {
		if round < byRound.count {
			return byRound[round]
		} else {
			let offset = byRound.count - period
			return byRound[offset + (round - offset) % period]
		}
	}
	
	public static func representation(
		of sequence: some Sequence<Info>
	) -> Self where Info: Equatable {
		var infos: [Info] = []
		var period = 0
		// floyd's algorithm: compare at distance 1 greater each time until match
		var iterator = sequence.makeIterator()
		repeat {
			infos.append(iterator.next()!)
			infos.append(iterator.next()!)
			period += 1
		} while infos.dropLast(period).last! != infos.last!
		return Self(byRound: infos, period: period)
	}
}
