//
//  MockDateProvider.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/11.
//

import Foundation
@testable import quick_reminder

struct MockDateProvider: DateProviderProtocol {
    var now: Date
}
