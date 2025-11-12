//
//  RecentRecordRow.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 최근 기록 행
struct RecentRecordRow: View {
  let record: EmotionRecord
  
  var body: some View {
    HStack(spacing: 12) {
      // 점수 표시
      ZStack {
        Circle()
          .fill(scoreColor.opacity(0.2))
          .frame(width: 50, height: 50)
        
        Text("\(Int(record.toneScore))")
          .font(.headline)
          .bold()
          .foregroundColor(scoreColor)
      }
      
      // 정보
      VStack(alignment: .leading, spacing: 4) {
        Text(record.toneLabel)
          .font(.subheadline)
          .bold()
          .foregroundStyle(Color.textPrimary)
        
        Text(formattedDate)
          .font(.caption)
          .foregroundColor(Color.textSecondary)
      }
      
      Spacer()
      
      // 키워드 미리보기
      if let firstKeyword = record.toneKeywords.split(separator: ",").first {
        Text(String(firstKeyword))
          .font(.caption)
          .padding(.horizontal, 10)
          .padding(.vertical, 4)
          .background(Color.primaryy.opacity(0.1))
          .foregroundColor(Color.primaryy)
          .cornerRadius(8)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
    formatter.unitsStyle = .short
    return formatter.localizedString(for: record.createdAt, relativeTo: Date())
  }
}
