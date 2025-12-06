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
  
  @StateObject private var versionCheck = VersionCheckService.shared
  
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
        versionCheck.checkVersion()
        
        // Launch Screen 표시 시간 (1.5초)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          withAnimation(.easeOut(duration: 0.3)) {
            showLaunchScreen = false
          }
        }
      }
      .alert("업데이트 알림", isPresented: $versionCheck.needsUpdate) {
        Button("업데이트 하러 가기", role: .none) {
          if UIApplication.shared.canOpenURL(versionCheck.appStoreURL) {
            UIApplication.shared.open(versionCheck.appStoreURL)
          }
          // 닫기 버튼을 눌러도 다시 팝업을 띄우거나 앱을 종료해야 함 (강제성을 위해)
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            versionCheck.needsUpdate = true
          }
        }
      } message: {
        Text("원활한 서비스 이용을 위해 최신 버전으로 업데이트가 필요합니다.")
      }
    }
  }
}
