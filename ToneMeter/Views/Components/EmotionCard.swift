//
//  EmotionCard.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 감정 정보 카드 컴포넌트
struct EmotionCard: View {
  /// 제목
  let title: String
  
  /// 값 (숫자 또는 텍스트)
  let value: String
  
  /// 아이콘
  let icon: String
  
  /// 강조 색상
  let accentColor: Color
  
  init(
    title: String,
    value: String,
    icon: String,
    accentColor: Color = .blue
  ) {
    self.title = title
    self.value = value
    self.icon = icon
    self.accentColor = accentColor
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // 아이콘
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(accentColor)
      
      // 제목
      Text(title)
        .font(.subheadline)
        .foregroundColor(Color.textSecondary)
      
      // 값
      Text(value)
        .font(.title2)
        .bold()
        .foregroundColor(Color.textBlack)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(16)
    .cardShadow()
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 16) {
    EmotionCard(
      title: "전체 분석",
      value: "24회",
      icon: "chart.bar.fill",
      accentColor: .blue
    )
    
    EmotionCard(
      title: "평균 점수",
      value: "72점",
      icon: "star.fill",
      accentColor: .orange
    )
    
    EmotionCard(
      title: "가장 많은 감정",
      value: "긍정적",
      icon: "face.smiling.fill",
      accentColor: .green
    )
  }
  .padding()
}

