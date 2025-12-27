//
//  AnalysisError.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation

/// 분석 관련 에러
enum AnalysisError: LocalizedError {
  case noTextFound
  case imageCompressionFailed
  case imageNotSelected
  
  var errorDescription: String? {
    switch self {
    case .noTextFound:
      return L10n.Error.noTextFound
    case .imageCompressionFailed:
      return L10n.Error.imageCompressionFailed
    case .imageNotSelected:
      return L10n.Error.imageNotSelected
    }
  }
}
