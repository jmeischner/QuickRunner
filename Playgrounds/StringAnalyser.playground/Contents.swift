import Foundation

let testString = """
Compile Swift Module 'HelperTests' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/QuickRunnerPackageTests.xctest/Contents/MacOS/QuickRunnerPackageTests
2017-12-06 11:07:24.707 xctest[10761:1224256] Exception NSInvalidArgumentException thrown while decoding IOBluetoothSDPServiceRecord
2017-12-06 11:07:24.708 xctest[10761:1224256] Exception NSInvalidArgumentException thrown while decoding IOBluetoothSDPServiceRecord
Test Suite 'All tests' started at 2017-12-06 11:07:24.719
Test Suite 'QuickRunnerPackageTests.xctest' started at 2017-12-06 11:07:24.719
Test Suite 'ExecuteTestsSpec' started at 2017-12-06 11:07:24.719
Test Case '-[QuickRunnerCoreTests.ExecuteTestsSpec The swift tests Process, should get executed if it's a swift module directory]' started.
Test Case '-[QuickRunnerCoreTests.ExecuteTestsSpec The swift tests Process, should get executed if it's a swift module directory]' passed (0.091 seconds).
Test Suite 'ExecuteTestsSpec' passed at 2017-12-06 11:07:24.810.
Executed 1 test, with 0 failures (0 unexpected) in 0.091 (0.091) seconds
Test Suite 'ScriptHelperClass' started at 2017-12-06 11:07:24.810
Test Case '-[HelperTests.ScriptHelperClass The swift script helper, should execute a script]' started.
Test Case '-[HelperTests.ScriptHelperClass The swift script helper, should execute a script]' passed (0.000 seconds).
Test Case '-[HelperTests.ScriptHelperClass The swift script helper, Hier ist ein Kontext, is false script]' started.
/Users/janmeischner/Projects/QuickRunner/Tests/HelperTests/ScriptHelperTests.swift:15: error: -[HelperTests.ScriptHelperClass The swift script helper, Hier ist ein Kontext, is false script] : failed - expected to be falsy, got <true>
Test Case '-[HelperTests.ScriptHelperClass The swift script helper, Hier ist ein Kontext, is false script]' failed (0.001 seconds).
Test Suite 'ScriptHelperClass' failed at 2017-12-06 11:07:24.811.
Executed 2 tests, with 1 failure (0 unexpected) in 0.001 (0.001) seconds
Test Suite 'QuickRunnerPackageTests.xctest' failed at 2017-12-06 11:07:24.811.
Executed 3 tests, with 1 failure (0 unexpected) in 0.092 (0.093) seconds
Test Suite 'All tests' failed at 2017-12-06 11:07:24.811.
Executed 3 tests, with 1 failure (0 unexpected) in 0.092 (0.093) seconds
"""

func extractTestCases(from: String) -> [String] {
    let pat = "\\[(.*\\..*)\\]"
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    let matches = regex.matches(in: from, options: [], range: NSRange(location: 0, length: from.count))
    let casesWithDuplicates = matches.map {
        String(from[Range($0.range, in: from)!])
    }
   
    return Array(Set(casesWithDuplicates))
}

class TestCase {
    let module: String
    let testClass: String
    let description: String
    var lines: [String] = []
    var success: Bool = true
    var error: String? = nil
    
    init(module: String, testClass: String, description: String) {
        self.module = module
        self.testClass = testClass
        self.description = description
    }
    
    func desc() -> String {
        var result = "Test: \(description)"
        result += success ? " passed" : " failed"
        result += success ? "" : " because: \(error!)"
        
        return result
    }
}

var tests: [TestCase] = []

let cases = extractTestCases(from: testString)
for testcase in cases {
    var subs = testcase.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
    
    subs[0].removeFirst()
    subs[1].removeLast()
    
    let desc = String(subs[1])
    let moduleAndClass = subs[0].split(separator: ".")
    
    tests.append(TestCase(module: String(moduleAndClass[0]), testClass: String(moduleAndClass[1]), description: desc))
}

print(tests)

func getTestCaseFor(line: String, in tests: [TestCase]) -> TestCase? {
    return tests.first(where: { line.contains($0.description) })
}


testString.enumerateLines(invoking: {(line, stop) in
    let currentLineTest = getTestCaseFor(line: line, in: tests)
    if let test = currentLineTest {
        test.lines.append(line)
    }
})

for test in tests {
    if (test.lines.count > 2) {
        test.success = false
        test.error = test.lines[1].components(separatedBy: " failed - ").last!
    }
}

for test in tests {
    print(test.desc())
}
