//
//  AppDelegate.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    // Firebase 초기화
    FirebaseApp.configure()
    
    // AdMob 초기화
    MobileAds.shared.start()
    
    // 첫 광고 미리 로드 (Pre-load)
    AdMobService.shared.loadAd()
    
#if DEBUG
    print("✅ Firebase 초기화 완료 (Debug 모드)")
    // Debug 모드에서는 Analytics 비활성화 (선택사항)
    Analytics.setAnalyticsCollectionEnabled(false)
#else
    print("✅ Firebase 초기화 완료 (Release 모드)")
    // 앱 시작 이벤트 기록
    AnalyticsLogger.shared.logAppLaunch()
#endif
    
    return true
  }
  
  // 앱이 백그라운드로 전환될 때
  func applicationDidEnterBackground(_ application: UIApplication) {
    AnalyticsLogger.shared.logAppBackground()
  }
  
  // 앱이 포그라운드로 전환될 때
  func applicationWillEnterForeground(_ application: UIApplication) {
    AnalyticsLogger.shared.logAppForeground()
  }
}
