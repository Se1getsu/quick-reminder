//
//  DateProvider.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/11.
//

import Foundation

/// 現在時刻 `Date()` を計算するプロパティを提供する。
protocol DateProviderProtocol {
    /// 現在時刻 `Date()` を表す計算型プロパティ。
    var now: Date { get }
}

/// 現在時刻 `Date()` を計算するプロパティを提供する。
struct DateProvider: DateProviderProtocol {
    var now: Date {
        Date()
    }
}
