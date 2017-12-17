import Foundation

public func extractTestsFrom(testOutput: String) -> [TestModule] {

    let testStrings = extractTestCaseStrings(from: testOutput)
    // print(testOutput)
    let testCases = buildTestCases(testStrings: testStrings)    
    let testCasesWithLines = getTestLines(forTests: testCases, from: testOutput)
    let cases = extendTestCasesWithResult(tests: testCasesWithLines)

    return group(testCases: cases)

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

private func group(testCases: [TestCase]) -> [TestModule] {
    
    let modules = groupModulesFrom(testCases: testCases)

    for module in modules.values {
        module.testClasses = Array(groupClassesFrom(module: module).values)
    }

    return Array(modules.values)
}

private func groupModulesFrom(testCases: [TestCase]) -> [String: TestModule] {
    let moduleNames = Set(testCases.map { $0.module })
    
    var modules: [String: TestModule] = [:]

    for moduleName in moduleNames {
        modules.updateValue(TestModule(moduleName), forKey: moduleName)
    }

    for test in testCases {
        modules[test.module]!.testCases.append(test)
    }

    return modules
}

private func groupClassesFrom(module: TestModule) -> [String: TestClass] {

    let classNames = Set(module.testCases.map { $0.testClass })
    
    var classes: [String: TestClass] = [:]

    for className in classNames {
        classes.updateValue(TestClass(className), forKey: className)
    }

    for test in module.testCases {
        classes[test.testClass]!.testCases.append(test)
    }

    return classes
}