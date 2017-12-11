import Foundation

import Helper

public final class QuickRunner {

    let directory: String

    // Todo: extract absolute path from "inDir"
    public init(inDir: String) {
        directory = inDir
    }


    public func execute() {
        
        FileManager.default.changeCurrentDirectoryPath(directory)
        let testOutput = executeScriptInPath(script: "swift", arguments: ["test"])
        
        // let tests = extractTestsFrom(testOutput: testOutput)
    }

}