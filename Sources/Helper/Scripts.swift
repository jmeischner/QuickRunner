import Foundation
import Rainbow

public struct ScriptOutput {
    let output: String?
    let error: String?
}

public func executeScript(path: String, arguments: [String] = []) -> ScriptOutput {

    let task = Process()
    let pipeStdout = Pipe()
    let pipeStderr = Pipe()
    
    task.arguments = arguments
    task.standardOutput = pipeStdout
    task.standardError = pipeStderr

    if #available(OSX 10.13, *) {
        task.executableURL = URL(fileURLWithPath: path)

        do {
            try task.run()    
        } catch {
            print("Error during Script Execution:\n".red + "\(error)")
        }
        
        task.waitUntilExit()
        let dataOut = pipeStdout.fileHandleForReading.readDataToEndOfFile()
        let dataErr = pipeStderr.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: dataOut, encoding: String.Encoding.utf8)
        let error = String(data: dataErr, encoding: String.Encoding.utf8)

        return ScriptOutput(output: output, error: error)
    } else {
        // Todo: How to write a Unit Test for the #available condition
        return ScriptOutput(output: nil, error: "A OSX Version smaller than 10.13")
    }

}

public func executeScriptInPath(script: String, arguments: [String] = []) -> ScriptOutput? {

    let pathToScriptUnescaped = executeScript(path: "/usr/bin/which", arguments: [script])

    if !pathToScriptUnescaped.error!.isEqual("") {
        print("Script with name: \(script) can not be found with following message: \(pathToScriptUnescaped.error!)")
    } else {
        let pathToScript = pathToScriptUnescaped.output!.trimmingCharacters(in: ["\n"])
        let scriptResult = executeScript(path: pathToScript, arguments: arguments)
        return scriptResult
    }

    return nil

}

// Todo: Use appropriate Error cases
enum ScriptExecutionError: Error {
    case errorDuringExecution
}