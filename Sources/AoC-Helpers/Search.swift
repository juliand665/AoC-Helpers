import Algorithms

extension Collection {
    @inlinable
    public func partitioningElement(where belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Element {
        self[try partitioningIndex(where: belongsInSecondPartition)]
    }
}

@inlinable
public func binarySearch<Bound: SignedInteger, Output: Comparable>(
	in bounds: ClosedRange<Bound>,
	for target: Output,
	computing output: (Bound) throws -> Output
) rethrows -> SearchOutput<Bound> {
	var lower = bounds.lowerBound
	var upper = bounds.upperBound
	while lower < upper - 1 {
		let middle = (lower + upper) / 2
		let result = try output(middle)
		if result == target {
			return .exact(middle)
		} else if result < target {
			lower = middle
		} else {
			upper = middle
		}
	}
	return .notFound(below: lower, above: upper)
}

@inlinable
public func exponentialSearch<Bound: SignedInteger, Output: Comparable>(
	for target: Output,
	from lowerBound: Bound = 1,
	computing output: (Bound) throws -> Output
) rethrows -> SearchOutput<Bound> {
	var lowerBound = lowerBound
	while true {
		let next = lowerBound << 1
		let result = try output(next)
		if result == target {
			return .exact(next)
		} else if result > target {
			return try binarySearch(in: lowerBound...next, for: target, computing: output)
		} else {
			lowerBound = next
		}
	}
}

public enum SearchOutput<Bound> {
	case exact(Bound)
	case notFound(below: Bound, above: Bound)
}

public extension SearchOutput {
	@inlinable
	var exactBound: Bound? {
		switch self {
		case .exact(let bound):
			return bound
		case .notFound:
			return nil
		}
	}
	
	@inlinable
	var exactOrNextBelow: Bound {
		switch self {
		case .exact(let bound):
			return bound
		case .notFound(let below, _):
			return below
		}
	}
	
	@inlinable
	var exactOrNextAbove: Bound {
		switch self {
		case .exact(let bound):
			return bound
		case .notFound(_, let above):
			return above
		}
	}
}
