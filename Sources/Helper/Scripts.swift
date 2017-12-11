import Foundation
import Rainbow

public func executeScript(path: String, arguments: [String] = []) -> String {

    let task = Process()
    let pipe = Pipe()
    
    task.arguments = arguments
    task.standardOutput = pipe

    if #available(OSX 10.13, *) {
        task.executableURL = URL(fileURLWithPath: path)

        do {
            try task.run()    
        } catch {
            print("Error during Script Execution:\n".red + "\(error)")
        }
        
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output!
    } else {
        // Todo: How to write a Unit Test for the #available condition
        return "A OSX Version smaller than 10.13"
    }

}

public func executeScriptInPath(script: String, arguments: [String] = []) -> String {

    let pathToScriptUnescaped = executeScript(path: "/usr/bin/which", arguments: [script])
    let pathToScript = pathToScriptUnescaped.trimmingCharacters(in: ["\n"])
    let testResult = executeScript(path: pathToScript, arguments: arguments)

    return testResult

}

// Todo: Use appropriate Error cases
enum ScriptExecutionError: Error {
    case errorDuringExecution
}