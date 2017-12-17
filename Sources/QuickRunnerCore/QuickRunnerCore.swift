import Foundation

import Helper

public final class QuickRunner {

    let directory: String

    // Todo: extract absolute path from "inDir"
    public init(inDir: String) {
        directory = inDir
    }


    public func execute() -> [TestModule] {
        
        FileManager.default.changeCurrentDirectoryPath(directory)
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

        return tests
    }

}