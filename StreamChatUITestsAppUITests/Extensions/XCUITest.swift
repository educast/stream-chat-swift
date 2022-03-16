//
//  XCUITest.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/4/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

// MARK: XCUIElement

extension XCUIElement {

    static var waitTimeout: Double { 5.0 }

    var centralCoordinates: CGPoint {
        CGPoint(x: self.frame.midX, y: self.frame.midY)
    }

    var height: Double {
        Double(self.frame.size.height)
    }

    var width: Double {
        Double(self.frame.size.width)
    }

    var hasKeyboardFocus: Bool {
        (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }

    var text: String {
        var labelText = label as String
        labelText = label.contains("AX error") ? "" : labelText
        let valueText = value as? String
        let text = labelText.isEmpty ? valueText : labelText
        return text ?? ""
    }

    func clearAndEnterText(text: String) {
        clear()
        typeText(text)
    }

    func dragAndDrop(dropElement: XCUIElement, duration: Double = 2) {
        self.press(forDuration: duration, thenDragTo: dropElement)
    }

    func safeTap() {
        if !self.isHittable {
            let coordinate: XCUICoordinate =
                self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        } else { self.tap() }
    }

    @discardableResult
    func waitForLoss(timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        while elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
        }
        return !elementPresent
    }

    func waitForText(_ expectedText: String, timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        var textPresent = false
        while !textPresent && elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
            textPresent = (self.text == expectedText)
        }
        return textPresent
    }

    func clear() {
        guard let oldValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        tapIfExists()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: oldValue.count)
        typeText(deleteString)
    }

    func tapIfExists() {
        if self.wait(timeout: 1.0) {
            self.tap()
        }
    }
    
    @discardableResult
    func tapAndWaitForKeyboardToAppear() -> Self {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            self.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
        return self
    }

    @discardableResult
    func wait(timeout: Double = XCUIElement.waitTimeout) -> Bool {
        waitForExistence(timeout: timeout)
    }

    func tapFrameCenter() {
        let frameCenterCoordinate = self.frameCenter()
        frameCenterCoordinate.tap()
    }

    private func frameCenter() -> XCUICoordinate {
        let centerX = self.frame.midX
        let centerY = self.frame.midY

        let normalizedCoordinate = XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let frameCenterCoordinate = normalizedCoordinate.withOffset(CGVector(dx: centerX, dy: centerY))

        return frameCenterCoordinate
    }
}

// MARK: XCUIElementQuery

extension XCUIElementQuery {

    @discardableResult
    func waitCount(_ expectedCount: Int, timeout: Double) -> Int {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var actualCount = count
        while actualCount < expectedCount && endTime > Date().timeIntervalSince1970 * 1000 {
            actualCount = count
        }
        return actualCount
    }

    var lastMatch: XCUIElement? {
        allElementsBoundByIndex.last
    }
}

// MARK: XCUIApplication
extension XCUIApplication {
    
    func setLaunchArguments(_ args: LaunchArgument...) {
        launchArguments.append(contentsOf: args.map { $0.rawValue })
    }

    func setEnvironmentVariables(_ envVars: [EnvironmentVariable: String]) {
        envVars.forEach { envVar in
            launchEnvironment[envVar.key.rawValue] = envVar.value
        }
    }

    func saveToBuffer(text: String) {
        UIPasteboard.general.string = text
    }

    func tap(x: CGFloat, y: CGFloat) {
        let normalized = self.coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.tap()
    }

    func doubleTap(x: CGFloat, y: CGFloat) {
        let normalized = self.coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.doubleTap()
    }

    func waitForChangingState(from previousState: State, timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var isChanged = (previousState != self.state)
        while !isChanged && endTime > Date().timeIntervalSince1970 * 1000 {
            isChanged = (previousState != self.state)
        }
        return isChanged
    }

    func waitForLosingFocus(timeout: Double) -> Bool {
        sleep(UInt32(timeout))
        return !self.debugDescription.contains("subtree")
    }

    func landscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
    }

    func portrait() {
        XCUIDevice.shared.orientation = .portrait
    }

    func openNotificationCenter() {
        let up = self.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.001))
        let down = self.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.8))
        up.press(forDuration: 0.1, thenDragTo: down)
    }

    func openControlCenter() {
        let down = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.999))
        let up = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        down.press(forDuration: 0.1, thenDragTo: up)
    }

    func back() {
        navigationBars.buttons.element(boundBy: 0).tapIfExists()
    }

    func rollUp() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }

    func rollUp(sec: Int, withDelay: Bool = false) {
        if withDelay { sleep(1) }
        rollUp()
        sleep(UInt32(sec))
        activate()
        if withDelay { sleep(1) }
    }

    func restart() {
        terminate()
        activate()
    }

    func bundleId() -> String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
