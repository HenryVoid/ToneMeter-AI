//
//  ToneMeterApp.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

@main
struct ToneMeterApp: App {
  // Firebase 초기화를 위한 AppDelegate 연결
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @AppStorage(UserDefaultsKeys.hasCompletedOnboarding)
  private var hasCompletedOnboarding = false
  
  @State private var showLaunchScreen = true
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        // Launch Screen (앱 시작 시 짧게 표시)
        if showLaunchScreen {
          LaunchView()
            .transition(.opacity)
            .zIndex(1)
        } else if hasCompletedOnboarding {
          // 온보딩 완료 → 메인 앱
          ToneMeterTabView()
        } else {
          // 온보딩 미완료 → 온보딩 화면
          OnboardingView()
        }
      }
      .onAppear {
        // Launch Screen 표시 시간 (1.5초)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          withAnimation(.easeOut(duration: 0.3)) {
            showLaunchScreen = false
          }
        }
      }
    }
  }
}
