//
//  Color+Theme.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

extension Color {
  
  // MARK: - Primary Colors
  
  /// 앱 메인 컬러 (파란색)
  static let primaryColor = Color.blue
  
  /// 앱 강조 컬러 (보라색)
  static let accentColor = Color.purple
  
  // MARK: - Emotion Colors (감정 톤 색상)
  
  /// 긍정적 감정 (70-100점)
  static let emotionPositive = Color.green
  
  /// 중립적 감정 (40-69점)
  static let emotionNeutral = Color.orange
  
  /// 부정적 감정 (0-39점)
  static let emotionNegative = Color.red
  
  // MARK: - Background Colors
  
  /// 카드 배경색
  static let cardBackground = Color(.secondarySystemBackground)
  
  /// 섹션 배경색
  static let sectionBackground = Color(.tertiarySystemBackground)
  
  // MARK: - Text Colors
  
  /// 비활성 텍스트 색상
  static let textTertiary = Color(.tertiaryLabel)
  
  // MARK: - Border Colors
  
  /// 기본 테두리 색상
  static let borderColor = Color(.separator)
  
  /// 강조 테두리 색상
  static let borderAccent = Color.blue.opacity(0.3)
  
  // MARK: - Gradient Colors
  
  /// 메인 그라데이션
  static let gradientPrimary = LinearGradient(
    colors: [Color.blue, Color.purple],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  /// 감정 톤 그라데이션 (0-100점)
  static func emotionGradient(score: Double) -> LinearGradient {
    let colors: [Color] = {
      switch score {
      case 70...100:
        return [Color.green.opacity(0.8), Color.green]
      case 40..<70:
        return [Color.orange.opacity(0.8), Color.orange]
      default:
        return [Color.red.opacity(0.8), Color.red]
      }
    }()
    
    return LinearGradient(
      colors: colors,
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  // MARK: - Helper Functions
  
  /// 점수에 따른 감정 색상 반환
  static func emotionColor(for score: Double) -> Color {
    switch score {
    case 70...100:
      return .emotionPositive
    case 40..<70:
      return .emotionNeutral
    default:
      return .emotionNegative
    }
  }
  
  /// 감정 레이블에 따른 색상 반환
  static func emotionColor(for label: String) -> Color {
    switch label.lowercased() {
    case "positive":
      return .emotionPositive
    case "neutral":
      return .emotionNeutral
    case "negative":
      return .emotionNegative
    default:
      return .textSecondary
    }
  }
}

// MARK: - Shadow Modifier

extension View {
  /// 카드 그림자 효과
  func cardShadow() -> some View {
    self.shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
  }
  
  /// 강조 그림자 효과
  func accentShadow() -> some View {
    self.shadow(color: Color.blue.opacity(0.3), radius: 12, x: 0, y: 4)
  }
}

