//
//  SettingsView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationView {
      List {
        Section("앱 정보") {
          HStack {
            Text("버전")
            Spacer()
            Text("1.0.0")
              .foregroundColor(.secondary)
          }
        }
        
        Section("데이터") {
          Button("데이터 초기화") {
            // TODO
          }
          .foregroundColor(.red)
        }
      }
      .navigationTitle("설정")
    }
  }
}
