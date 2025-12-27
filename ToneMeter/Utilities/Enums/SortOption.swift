//
//  SortOption.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation

/// 정렬 옵션
enum SortOption: String, CaseIterable {
  case dateDescending = "최신순"
  case dateAscending = "오래된순"
  case scoreDescending = "점수 높은순"
  case scoreAscending = "점수 낮은순"
  
  var displayName: String {
    switch self {
    case .dateDescending: return L10n.Sort.latest
    case .dateAscending: return L10n.Sort.oldest
    case .scoreDescending: return L10n.Sort.highestScore
    case .scoreAscending: return L10n.Sort.lowestScore
    }
  }
}
