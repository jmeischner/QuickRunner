public class TestCase {
    let module: String
    let testClass: String
    var lines: [String] = []

    public let description: String
    public var success: Bool = true
    public var error: String? = nil
    
    init(module: String, testClass: String, description: String) {
        self.module = module
        self.testClass = testClass
        self.description = description
    }
}

public class TestClass {
    public let name: String
    public var testCases: [TestCase] = []

    init(_ name: String) {
        self.name = name
    }
}

public class TestModule {
    public let name: String
    var testCases: [TestCase] = []
    public var testClasses: [TestClass] = []

    init(_ name: String) {
        self.name = name
    }
}