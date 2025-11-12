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
      return "이미지에서 텍스트를 찾을 수 없습니다"
    case .imageCompressionFailed:
      return "이미지 압축에 실패했습니다"
    case .imageNotSelected:
      return "이미지를 선택해주세요"
    }
  }
}
