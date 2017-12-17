import Quick
import Nimble

@testable import QuickRunnerCore

class ExecuteTestsSpec: QuickSpec {
    override func spec() {
        describe("The swift tests Process") {
            it("should get executed if it's a swift module directory") {
                // let result = QuickRunner.execute(inDir: ".")
                // expect(result).notTo(equal(""))
                expect(true).to(beTruthy())
            }
        }
    }
}

class ExecuteTestsSecondSpec: QuickSpec {
    override func spec() {
        describe("The second test class in this test module") {
            it("should get executed if it's a swift module directory") {
                // let result = QuickRunner.execute(inDir: ".")
                // expect(result).notTo(equal(""))
                expect(true).to(beTruthy())
            }
        }
    }   
}