//
//  EmotionChart.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 감정 톤 차트 데이터
struct EmotionChartData: Identifiable {
  let id = UUID()
  let label: String
  let value: Double
  let color: Color
}

/// 간단한 막대 차트 컴포넌트
struct EmotionChart: View {
  let data: [EmotionChartData]
  let maxValue: Double
  
  init(data: [EmotionChartData]) {
    self.data = data
    self.maxValue = data.map { $0.value }.max() ?? 100
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      ForEach(data) { item in
        VStack(alignment: .leading, spacing: 8) {
          // 레이블 + 값
          HStack {
            Text(item.label)
              .font(.subheadline)
              .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            Text("\(Int(item.value))")
              .font(.subheadline)
              .bold()
              .foregroundColor(item.color)
          }
          
          // 막대
          GeometryReader { geometry in
            ZStack(alignment: .leading) {
              // 배경
              RoundedRectangle(cornerRadius: 4)
                .fill(Color.borderColor.opacity(0.2))
                .frame(height: 8)
              
              // 진행
              RoundedRectangle(cornerRadius: 4)
                .fill(item.color)
                .frame(
                  width: geometry.size.width * (item.value / maxValue),
                  height: 8
                )
                .animation(.easeOut(duration: 0.6), value: item.value)
            }
          }
          .frame(height: 8)
        }
      }
    }
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(16)
    .cardShadow()
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 20) {
    EmotionChart(data: [
      EmotionChartData(label: "긍정적", value: 45, color: .emotionPositive),
      EmotionChartData(label: "중립적", value: 30, color: .emotionNeutral),
      EmotionChartData(label: "부정적", value: 15, color: .emotionNegative)
    ])
    
    EmotionChart(data: [
      EmotionChartData(label: "이번 주", value: 72, color: .blue),
      EmotionChartData(label: "지난 주", value: 68, color: .purple),
      EmotionChartData(label: "2주 전", value: 55, color: .orange)
    ])
  }
  .padding()
}

