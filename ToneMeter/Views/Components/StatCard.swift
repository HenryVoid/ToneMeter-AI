//
//  StatCard.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 통계 카드
struct StatCard: View {
  let icon: String
  let title: String
  let value: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(color)
      
      Text(title)
        .font(.caption)
        .foregroundColor(Color.textSecondary)
      
      Text(value)
        .font(.headline)
        .bold()
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(12)
    .cardShadow()
  }
}
