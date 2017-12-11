import Quick
import Nimble

@testable import Helper

class ScriptHelperClass: QuickSpec {
    override func spec() {
        describe("The swift script helper") {
            it("should execute a script") {
                expect(true).to(beTruthy())
            }

            context("Hier ist ein Kontext") {
                it("is false script") {
                    expect(true).to(beFalsy())
                }    
            }

            
        }
    }
}