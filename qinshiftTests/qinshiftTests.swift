import XCTest
@testable import wald

final class qinshiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func test_SHAHash() {
        let testString = "password"
        let testHash = testString.sha1()
        assert(testHash == "5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_funcbase64ToImage() {
        let base64string = "iVBORw0KGgoAAAANSUhEUgAAAGAAAABmCAYAAAA0wZQlAAAAAXNSR0IArs4c6QAAAJZlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAACQAAAAAQAAAJAAAAABAASShgAHAAAAEgAAAISgAQADAAAAAQABAACgAgAEAAAAAQAAAGCgAwAEAAAAAQAAAGYAAAAAQVNDSUkAAABTY3JlZW5zaG90CWKaqQAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAAdVpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+MTAyPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjk2PC9leGlmOlBpeGVsWERpbWVuc2lvbj4KICAgICAgICAgPGV4aWY6VXNlckNvbW1lbnQ+U2NyZWVuc2hvdDwvZXhpZjpVc2VyQ29tbWVudD4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CgCFDAYAAAAcaURPVAAAAAIAAAAAAAAAMwAAACgAAAAzAAAAMwAAAuw70rWGAAACuElEQVR4Aeyav0scQRTH5+poaRCEgMTikkC0ia2xigQCCWJ71+esFAQVzh9FCsXyUntpQ0iaQFIYksImpkiKiIKif4N32irfhZV1d5zdzLy9NxPeNHc7szvz5vO5N7t3c5UHky8ulRQ2AhURwMY+GlgE8PJXIkAEMBNgHl4yQAQwE2AeXjJABDATYB5eMkAEMBNgHl4yQAQwE2AeXjJABDATYB5eMkAEMBNgHl4yQAS4ERgfe6S2t1Yynez92Vf1udVMvW8VwWeACGD+SIkACwH9fXdUp3tucWX2EhGQZWKsebPQUNX791R9fp1Egggw4r7ZCPgvn01ElQdHJyQSRMBNxrceJeHHJ1FIEAExTcOrDn58uqsEERCTNLyaBOAyFwkiwAA+2VSWBBGQpJzzvgwJIiAHerqZWkJZAvBdpTb9XLXa79NTID1m+SmCUkIZAgC/vdVU1ZFh9fHLd7W8+ZYUerIzFgEIgEoCtYAk/BhUmRLYBFBJoBSgg1+2BFYBFBKoBJjgxxKwFCEbKAu7AEzGZTmiEFAE/qevP9TSRouSfdSXFwJcJLgK4ISPeXsjoIiEb7t7ara5iVOvi4sAbviYhFcCEJBpOdJtM9oK8AG+lwJMEv5FgC5b0DeKL/ARi3cZgKBQdJlQVMDh8amqza1pN3x8go95eitAJ6GIgJDgey8gLSFPQGjwrQXgxvdk9CGuJys7u7+ifQFdh/FyZBIQInzM1WoJatRmVKM+o2NlXYd/SWCjHpszugIJQ4MDmT9b4cOw+LoezJqfnps3AhBYnoRXU08zPwVAyln3Iogbbho+jr0SgIDyJOCcIsW3p53bYvZOAAJ1lRAKfMzVSwEuEkKCby0gegp6TPsUhGDSpXN+od59+JyuNh7jnjA0eNd4zs/ff43tvWy0yoBeBvi/jyUCmA1fAQAA//8pxUnEAAADO0lEQVTt2k9IVEEcB/Cf4IalHgvBQ4ZRZtAfYjuUh8pLlw4d6qrXNoRMjbJwXaNazFbCyJAuG0G3hE4hBRFL1EpgQX8OQkFERcfqkLlWv+Ats883z/fn9/Y305u5vPmzM+N8P84KD2u27D/0G0xhS6DGALBl/29jVoDGhnpoa13vmsDsi9eu4/ZBXPPSqRQ01K+xD5G3s5O34O38u1DrsgFgUPkrQ9C2cYP0AGcvX4fp+4+k47IBXDOfS0NjxAjdfRkozr2S/Rie+lkAogzfOnU1ELQEqEb41ULQDiBs+IcP7nP8SjredQRu3L4LpVLJyr78jPImaAVAEf6FgRS0dx4th2tVpqdG4cOnL9CbGYfS0pLVXX5GhaANAFX4mKgMYHNrCzwoPJMiNDetheamdWUUisqb+ffw7fuPUEtF/keYMnw8qRsAjrsh4LhqJVIA6vAxvJUA8DM6IUQGEEX4XgF0QogEIGz4GGA+NwzJ7e1YrSheboA1QYebQA5AET4GSAGA66iOQApAFb5fgGsjA3BgbxKnOZaZx0/hRCbnOMbdSQZAGT6G4ucGrK6rg5uj52Dn1k3SPFW9CSQA1OH7BcDP64pAAtDZsRsmMv3S374gbzX93ABrYx0RSAAwAHxPg68K7CVI+LhGEACc5xWh7/xV+LW4iFNYCxkAnsKOEDR8XCsoAM71gvDk+Us4NphlRyAFwMNbCGHCx3XCAOB8RJgY6Yc9u7Zh07GogEAOgCfFF18fP391PLTXzrAAuE+ithYmL55WGiESAK8hu32OAkAHhP8eQHWEWACojBAbAFURYgWgIkLsAFRDiCWASgixBVAFIdYAKiDEHoAbQVmAM6nuv/+424L5VJSuk8MVbaoG12sLZQGogvWzDgeCAbAJVRvBANgArOZUdhA6kjus5rLnw0IRetJjy/r9dhgASWJuN+HnwgL0DI1BYXZOMtt7twFwycoJgTJ83NoAuADgkIhAHT6ubwAwhRXKqkQCxtO9cOfeDBSK4b92xO0MgJgGQ90AMIQubmkAxDQY6gaAIXRxSwMgpsFQNwAMoYtbGgAxDYa6AWAIXdzSAIhpMNQNAEPo4pYGQEyDof4HZZrJJ/QId6EAAAAASUVORK5CYII="
        
        assert(base64string.base64ToImage() == nil, "The base64 string could not be converted to an image")
    }
}
