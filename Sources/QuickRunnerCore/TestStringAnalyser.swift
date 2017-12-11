import Foundation

public func extractTestsFrom(testOutput: String) -> [TestCase] {

    let testStrings = extractTestCaseStrings(from: testOutput)
    // print(testOutput)
    let testCases = buildTestCases(testStrings: testStrings)    
    let testCasesWithLines = getTestLines(forTests: testCases, from: testOutput)
    return extendTestCasesWithResult(tests: testCasesWithLines)

}

private func getTestLines(forTests: [TestCase], from: String) -> [TestCase] {
    from.enumerateLines(invoking: {(line, stop) in
        let currentLineTest = getTestCaseFor(line: line, in: forTests)
        if let test = currentLineTest {
            test.lines.append(line)
        }
    })

    return forTests
}

private func extendTestCasesWithResult(tests: [TestCase]) -> [TestCase] {
    for test in tests {
        if (test.lines.count > 2) {
            test.success = false
            test.error = test.lines[1].components(separatedBy: " failed - ").last!
        }
    }

    return tests
}

private func buildTestCases(testStrings: [String]) -> [TestCase] {
    var result: [TestCase] = []

    for testcase in testStrings {
        var subs = testcase.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        
        subs[0].removeFirst()
        subs[1].removeLast()
        
        let desc = String(subs[1])
        let moduleAndClass = subs[0].split(separator: ".")
        
        result.append(TestCase(module: String(moduleAndClass[0]), testClass: String(moduleAndClass[1]), description: desc))
    }

    return result
}

private func extractTestCaseStrings(from: String) -> [String] {
    let pat = "\\[(.*\\..*)\\]"
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    let matches = regex.matches(in: from, options: [], range: NSRange(location: 0, length: from.count))
    let casesWithDuplicates = matches.map {
        String(from[Range($0.range, in: from)!])
    }
   
    return Array(Set(casesWithDuplicates))
}

private func getTestCaseFor(line: String, in tests: [TestCase]) -> TestCase? {
    return tests.first(where: { line.contains($0.description) })
}
