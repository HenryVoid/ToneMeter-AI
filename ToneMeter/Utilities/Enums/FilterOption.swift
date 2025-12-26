//
//  FilterOption.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation

/// 필터 옵션
enum FilterOption: String, CaseIterable {
  case all = "전체"
  case positive = "긍정"
  case neutral = "중립"
  case negative = "부정"
  case today = "오늘"
  case thisWeek = "이번 주"
  
  var displayName: String {
    switch self {
    case .all: return L10n.Filter.all
    case .positive: return L10n.Filter.positive
    case .neutral: return L10n.Filter.neutral
    case .negative: return L10n.Filter.negative
    case .today: return L10n.Filter.today
    case .thisWeek: return L10n.Filter.thisWeek
    }
  }
}
