//
//  EmotionRecordRow.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 기록 행
struct EmotionRecordRow: View {
  let record: EmotionRecord
  
  var body: some View {
    HStack(spacing: 12) {
      // 점수 원형
      ZStack {
        Circle()
          .fill(scoreColor.opacity(0.2))
          .frame(width: 60, height: 60)
        
        VStack(spacing: 2) {
          Text("\(Int(record.toneScore))")
            .font(.title3)
            .bold()
            .foregroundColor(scoreColor)
          
          Text(record.toneLabel)
            .font(.caption2)
            .foregroundColor(scoreColor)
        }
      }
      
      // 정보
      VStack(alignment: .leading, spacing: 6) {
        // OCR 텍스트 미리보기
        Text(record.ocrText.prefix(50))
          .font(.subheadline)
          .foregroundStyle(Color.textBlack)
          .lineLimit(2)
        
        // 날짜
        Text(formattedDate)
          .font(.caption)
          .foregroundColor(Color.textSecondary)
      }
      
      Spacer()
    }
    .padding(.vertical, 8)
  }
  
  private var scoreColor: Color {
    switch record.toneScore {
    case 0..<46: return .red
    case 46..<56: return .orange
    default: return .green
    }
  }
  
  private var formattedDate: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.unitsStyle = .abbreviated
    return formatter.localizedString(for: record.createdAt, relativeTo: Date())
  }
}
