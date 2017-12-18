import Foundation
import QuickRunnerCore
import Rainbow
import Commander

var numberOfTests = 0
var slowTests = 0
var failedTests = 0

// Idea: Use themes for color sets
func tab(_ times: Int) -> String {
    return String(repeating: "  ", count: times)
}

func printTestCase(_ test: TestCase) {
    numberOfTests += 1
    if (test.success) {
        if (test.time > 0.5) {
            slowTests += 1
            print("\(tab(3))\u{2714} \(test.description)".green + " (slow: \(test.time) sec)".yellow)    
        } else {
            print("\(tab(3))\u{2714} \(test.description)".green)
        }
        
    } else {
        failedTests += 1
        print("""
        \(tab(3))\u{2717} \(test.description)
        \(tab(4))Error: \(test.error!)
        """.red)
    }
}

// Todo: What if "swift test" is not possible in the given directory
func executeTestsIn(directory: String) {
    let qr = QuickRunner(inDir: directory)

    let modulesOpt = qr.execute()

    if let modules = modulesOpt {
        print("Start".underline.bold)

        for module in modules {
            print("\u{25B8} \(module.name):".bold)
            for testClass in module.testClasses {
                print("\(tab(2))\(testClass.name)")

                for testCase in testClass.testCases {
                    printTestCase(testCase)
                }
            }
        }

        printSummary()
        
    }
}

func printSummary() {
    
    let completedTests = numberOfTests - failedTests

    print()
    print("Summary".underline.bold)

    if (completedTests > 0) {
        print("\u{2714} \(completedTests) completed".green)    
    }

    if (slowTests > 0) {
        print("\u{26A0} \(slowTests) slow".yellow)   
    }

    if (failedTests > 0) {
        print("\u{2717} \(failedTests) failed".red)    
    }
}

// Main Function
command(
    Option("path", default: ".", description: "Path to the swift project")
) { path in 
    executeTestsIn(directory: path)    
}.run()