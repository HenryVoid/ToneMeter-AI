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
}
