//
//  InfoRow.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 정보 행
struct InfoRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
        .foregroundColor(Color.textSecondary)
      
      Spacer()
      
      Text(value)
        .font(.subheadline)
        .foregroundStyle(Color.textHint)
    }
  }
}
