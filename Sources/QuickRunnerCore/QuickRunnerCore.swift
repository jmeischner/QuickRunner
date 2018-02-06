import Foundation
import Rainbow

import Helper

public final class QuickRunner {

    let directory: String

    // Todo: extract absolute path from "inDir"
    public init(inDir: String) {
        directory = inDir
    }

    public func execute() -> [TestModule]? {

        let directoryChanged = FileManager.default.changeCurrentDirectoryPath(directory)

        if directoryChanged {

            let testOutput = executeScriptInPath(script: "swift", arguments: ["test"])

            var testResult = ""

            if let testOut = testOutput {
                if !testOut.error!.isEqual("") {
                    testResult = testOut.error!
                } else {
                    testResult = testOut.output!
                }
            }

            let tests = extractTestsFrom(testOutput: testResult)

            if tests.count > 0 {
                return tests
            } else {
                print(testOutput!.output!)
                print(testOutput!.error!)
                return nil
            }
        } else {
            print("\"\(directory)\" is no valid directory".red)
            return nil
        }

    }

}
