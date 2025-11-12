//
//  ToneMeterTabView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct ToneMeterTabView: View {
  @State private var selectedTab: TMTab = .home
  
  var body: some View {
    TabView(selection: $selectedTab) {
      // 1. Home 탭
      HomeView()
        .tabItem {
          Label("홈", systemImage: "house.fill")
        }
        .tag(TMTab.home)
      
      // 2. Analysis 탭
      AnalysisView()
        .tabItem {
          Label("분석", systemImage: "sparkles")
        }
        .tag(TMTab.analysis)
      
      // 3. History 탭
      HistoryView()
        .tabItem {
          Label("기록", systemImage: "clock.fill")
        }
        .tag(TMTab.history)
      
      // 4. Settings 탭
      SettingsView()
        .tabItem {
          Label("설정", systemImage: "gearshape.fill")
        }
        .tag(TMTab.settings)
    }
    .tint(Color.primaryy) // 탭 선택 색상
  }
}
