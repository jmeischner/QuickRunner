public class TestCase {
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
}