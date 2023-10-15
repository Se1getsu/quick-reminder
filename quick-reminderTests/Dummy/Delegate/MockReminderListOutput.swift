//
//  MockReminderListOutput.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/15
//  
//

import Foundation
@testable import quick_reminder

class MockReminderListOutput: ReminderListPresenterOutput {
    var reminders = [Reminder]()
    
    private(set) var reloadedIndex = [Int]()
    
    /// updateReminderStyle(index:style:) の引数
    struct UpdateReminderStyleArgs: Equatable {
        var index: Int
        var style: ReminderPresentationStyle
    }
    private(set) var setStyles = [UpdateReminderStyleArgs]()
    
    /// moveToReminderEditVC(editMode:delegate:) の引数
    private(set) var reminderEditVCEditMode: ReminderEditPresenter.EditMode?
    
    func didAddReminder(_ reminder: Reminder, index: Int) {
        reminders.insert(reminder, at: index)
    }
    
    func didDeleteReminder(index: Int) {
        reminders.remove(at: index)
    }
    
    func didMoveReminder(at fromIndex: Int, to toIndex: Int) {
        let reminder = reminders.remove(at: fromIndex)
        reminders.insert(reminder, at: toIndex)
    }
    
    func reloadReminder(index: Int) {
        reloadedIndex.append(index)
    }
    
    func updateReminderStyle(index: Int, style: ReminderPresentationStyle) {
        setStyles.append(.init(index: index, style: style))
    }
    
    func moveToReminderEditVC(editMode: ReminderEditPresenter.EditMode, delegate: ReminderEditDelegate) {
        reminderEditVCEditMode = editMode
    }
}
