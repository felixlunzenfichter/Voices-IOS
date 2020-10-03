//
//  Voices_IOSUITests.swift
//  Voices IOSUITests
//
//  Created by Felix Lunzenfichter on 02.10.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import XCTest

class Voices_IOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecording() throws {
        
        

        let app = XCUIApplication()
        app.launch()

        

        app.navigationBars["Voices"].buttons["Record new Voice"].tap()
        app.buttons["Record"].tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Stop Recording"]/*[[".buttons[\"Stop Recording\"].staticTexts[\"Stop Recording\"]",".staticTexts[\"Stop Recording\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Recording"].buttons["Voices"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["2020-10-02 20:54:40.m4a"]/*[[".cells.staticTexts[\"2020-10-02 20:54:40.m4a\"]",".staticTexts[\"2020-10-02 20:54:40.m4a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let playButton = app.buttons["play"]
        playButton.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["transcribe"]/*[[".buttons[\"transcribe\"].staticTexts[\"transcribe\"]",".staticTexts[\"transcribe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        playButton.tap()
        playButton.tap()
        app.navigationBars["Listening"].buttons["Voices"].tap()
        app.tables.cells.containing(.staticText, identifier:"2020-10-02 20:54:40.m4a").element.tap()
    
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
