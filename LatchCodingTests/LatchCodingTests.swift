//
//  LatchCodingTests.swift
//  LatchCodingTests
//
//  Created by Utsha Guha on 9-7-18.
//  Copyright © 2018 Utsha Guha. All rights reserved.
//

import XCTest
@testable import LatchCoding

class LatchCodingTests: XCTestCase {
    var latchCodingTest:ViewController!
    var latchCodingTest2:AlbumDetailsViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        latchCodingTest = ViewController()
        latchCodingTest2 = AlbumDetailsViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchAlbum() {
        latchCodingTest.fetchTopAlbums()
        XCTAssert(latchCodingTest.albumArray.count > 0, "Album details have not loaded!")
    }
    
    func testAlbumTableSectionCount() {
        let myTableView = UITableView()
        let numberOfSection = latchCodingTest.numberOfSections(in: myTableView)
        XCTAssert(numberOfSection == 1, "Number of section in Album table view is not 1")
    }
    
    func testAlbumTableRowCount() {
        let myTableView = UITableView()
        let numberOfRow = latchCodingTest.tableView(myTableView, numberOfRowsInSection: 1)
        XCTAssert(numberOfRow == latchCodingTest.albumArray.count, "The album count is not correct.")
    }
    
    func testFetchOnlineRecord() {
        latchCodingTest.fetchOnlineRecord(offlineArray: latchCodingTest.albumArray)
        XCTAssert(latchCodingTest.sortOnline.count == latchCodingTest.sortOffline.count, "Online and Offline array count is not same")
    }
}
