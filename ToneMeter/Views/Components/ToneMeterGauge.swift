//
//  ToneMeterGauge.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 감정 톤 미터기 컴포넌트
struct ToneMeterGauge: View {
  /// 점수 (0-100)
  let score: Double
  
  /// 미터기 크기
  let size: CGFloat
  
  /// 선 두께
  let lineWidth: CGFloat
  
  /// 애니메이션 여부
  let animated: Bool
  
  init(
    score: Double,
    size: CGFloat = 200,
    lineWidth: CGFloat = 20,
    animated: Bool = true
  ) {
    self.score = score
    self.size = size
    self.lineWidth = lineWidth
    self.animated = animated
  }
  
  var body: some View {
    ZStack {
      // 배경 원
      Circle()
        .stroke(Color.borderColor.opacity(0.3), lineWidth: lineWidth)
        .frame(width: size, height: size)
      
      // 진행 원
      Circle()
        .trim(from: 0, to: score / 100)
        .stroke(
          Color.emotionColor(for: score),
          style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
        .frame(width: size, height: size)
        .rotationEffect(.degrees(-90))
        .animation(animated ? .easeInOut(duration: 1.0) : .none, value: score)
      
      // 중앙 점수
      VStack(spacing: 4) {
        Text("\(Int(score))")
          .font(.system(size: size * 0.28, weight: .bold, design: .rounded))
          .foregroundColor(Color.emotionColor(for: score))
        
        Text("/ 100")
          .font(.system(size: size * 0.1))
          .foregroundColor(Color.textSecondary)
      }
    }
  }
}

// MARK: - Preview

#Preview("긍정적") {
  VStack(spacing: 40) {
    ToneMeterGauge(score: 85)
    Text("긍정적 (85점)")
  }
  .padding()
}

#Preview("중립적") {
  VStack(spacing: 40) {
    ToneMeterGauge(score: 55)
    Text("중립적 (55점)")
  }
  .padding()
}

#Preview("부정적") {
  VStack(spacing: 40) {
    ToneMeterGauge(score: 25)
    Text("부정적 (25점)")
  }
  .padding()
}

#Preview("다양한 크기") {
  VStack(spacing: 40) {
    ToneMeterGauge(score: 75, size: 150, lineWidth: 15)
    ToneMeterGauge(score: 75, size: 100, lineWidth: 10)
    ToneMeterGauge(score: 75, size: 60, lineWidth: 6)
  }
  .padding()
}

