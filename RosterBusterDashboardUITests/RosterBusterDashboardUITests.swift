//
//  RosterBusterDashboardUITests.swift
//  RosterBusterDashboardUITests
//
//  Created by Mayur Susare on 30/05/21.
//

import XCTest

class RosterBusterDashboardUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    //Test to check if navigation is working perfectly
    func testDataInCellSelection() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Layover").element/*[[".cells.containing(.staticText, identifier:\"08:00 hours\").element",".cells.containing(.staticText, identifier:\"BUD\").element",".cells.containing(.staticText, identifier:\"Layover\").element"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Roster Details"].buttons["Dashboard"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"DO(RTM)").element.tap()
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
