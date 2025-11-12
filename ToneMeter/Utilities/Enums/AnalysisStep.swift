//
//  AnalysisStep.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation
import SwiftUI

/// 분석 진행 단계
enum AnalysisStep: Int {
  case idle = 0              // 대기 중
  case performingOCR = 1     // OCR 진행 중
  case analyzingTone = 2     // 감정 분석 중
  case savingToDatabase = 3  // DB 저장 중
  case completed = 4         // 완료
  case failed = -1           // 실패
  
  var description: String {
    switch self {
    case .idle: return "대기 중"
    case .performingOCR: return "텍스트 인식 중..."
    case .analyzingTone: return "감정 분석 중..."
    case .savingToDatabase: return "저장 중..."
    case .completed: return "완료!"
    case .failed: return "실패"
    }
  }
  
  var icon: String {
    switch self {
    case .idle: return "circle"
    case .performingOCR: return "doc.text.viewfinder"
    case .analyzingTone: return "brain.head.profile"
    case .savingToDatabase: return "square.and.arrow.down"
    case .completed: return "checkmark.circle.fill"
    case .failed: return "xmark.circle.fill"
    }
  }
  
  var color: Color {
    switch self {
    case .idle: return .gray
    case .performingOCR, .analyzingTone, .savingToDatabase: return .blue
    case .completed: return .green
    case .failed: return .red
    }
  }
}
