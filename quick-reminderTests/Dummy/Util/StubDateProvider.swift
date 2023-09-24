//
//  StubDateProvider.swift
//  quick-reminderTests
//
//  Created by Seigetsu on 2023/09/11.
//

import Foundation
@testable import quick_reminder

struct StubDateProvider: DateProviderProtocol {
    var now: Date
}
