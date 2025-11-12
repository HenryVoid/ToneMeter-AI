//
//  HistoryView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct HistoryView: View {
  var body: some View {
    NavigationView {
      VStack {
        Image(systemName: "clock.fill")
          .font(.system(size: 60))
          .foregroundColor(.gray)
        
        Text("기록")
          .font(.title2)
          .bold()
          .padding(.top)
        
        Text("분석 기록이 여기에 표시됩니다")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .navigationTitle("기록")
    }
  }
}
