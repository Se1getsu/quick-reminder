//
//  MockOldReminderFinder.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/15
//  
//

import Foundation
@testable import quick_reminder

class MockOldReminderFinder: OldReminderFinderProtocol {
    var getOldReminderIndicesReturn: [Int]!
    private(set) var inputReminderList: ReminderListProtocol?
    
    func getOldReminderIndices(in reminderList: ReminderListProtocol) -> [Int] {
        inputReminderList = reminderList
        return getOldReminderIndicesReturn
    }
}
