import Foundation
import Rainbow

public func executeScript(path: String, arguments: [String] = []) -> String {

    let task = Process()
    let pipe = Pipe()
    print("Pfad: \(path)")
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
        return "Another MacOS Version"
    }

}

public func executeScriptInPath(script: String, arguments: [String] = []) -> String {

    let pathToScript = executeScript(path: "/usr/bin/which", arguments: [script])
    return executeScript(path: pathToScript, arguments: arguments)

}

enum ScriptExecutionError: Error {
    case errorDuringExecution
}