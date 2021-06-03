//
//  RosterBusterDashboardTests.swift
//  RosterBusterDashboardTests
//
//  Created by Mayur Susare on 30/05/21.
//

import XCTest
@testable import RosterBusterDashboard

class RosterBusterDashboardTests: XCTestCase {
    
    var groupedStories : [[String? : [Story]]]!
    var rosterBusterListViewController : RosterListViewController!
    var viewModel : RosterStoryTableViewModel!

    override func setUpWithError() throws {
        rosterBusterListViewController = RosterListViewController()
        viewModel = RosterStoryTableViewModel(context: rosterBusterListViewController)
    }

    override func tearDownWithError() throws {
        groupedStories = nil
        rosterBusterListViewController = nil
        viewModel = nil
    }
    
    func test001Positive() {
        
        let expectation = self.expectation(description: "API fetch data successfully")
        viewModel.retriveRosterData(completionHandler: { (response, error) in
            XCTAssertTrue((response != nil), "Test case call successful")
            XCTAssertTrue(error == nil ? true : false, "Error Occurred")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 60.0)
    }
    
    func test002Negative() {
        let expectation = self.expectation(description: "API fetch data failure")
        let rosterBusterListViewController = RosterListViewController()
        let viewModel = RosterStoryTableViewModel(context: rosterBusterListViewController)
        viewModel.retriveRosterData(completionHandler: { (response, error) in
            if let error = error {
              XCTFail("Error: \(error.localizedDescription)")
              return
            }
            XCTAssertFalse(response == nil ? true : false, "Test case call failed")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testPerformance() {
        measure(
            metrics: [
                XCTClockMetric(),
                //TO DO: Uncomment to measure CPU Usage.
                //XCTCPUMetric(),
                XCTStorageMetric(),
                XCTMemoryMetric()
            ]
          ) {
            viewModel.fetchDataFromDB(completionHandler:{ (response, error) in
                XCTAssertTrue((response != nil), "Test case call successful")
                XCTAssertTrue(error == nil ? true : false, "Error Occurred")
            })
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
