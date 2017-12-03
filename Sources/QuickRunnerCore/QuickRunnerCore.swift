import Foundation

import Helper

public final class QuickRunner {

    let directory: String

    public init(inDir: String) {
        directory = inDir
    }


    public func execute() {
        FileManager.default.changeCurrentDirectoryPath(directory)
        
        let result = executeScriptInPath(script: "swift", arguments: ["test"])

        print(result)
    }

}