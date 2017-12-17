import Foundation
import QuickRunnerCore
import Rainbow

private func tab(_ times: Int) -> String {
    return String(repeating: "  ", count: times)
}

private func printTestCase(_ test: TestCase) {
    if (test.success) {
        print("\(tab(2))\u{2714} \(test.description)".green)
    } else {
        print("""
        \(tab(2))\u{2717} \(test.description)
        \(tab(2))Error: \(test.error!)
        """.red)
    }
}

let qr = QuickRunner(inDir: ".")

let modules = qr.execute()

for module in modules {
    print(module.name.blue)
    for testClass in module.testClasses {
        print("\(tab(1))\(testClass.name)".cyan)

        for testCase in testClass.testCases {
            printTestCase(testCase)
        }

    }
}
