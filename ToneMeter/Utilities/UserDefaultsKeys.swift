//
//  UserDefaultsKeys.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation

/// UserDefaults 키 상수
enum UserDefaultsKeys {
    /// 앱 첫 실행 여부
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    
    /// 온보딩 버전 (온보딩 내용 변경 시 재표시용)
    static let onboardingVersion = "onboardingVersion"
    
    /// 현재 온보딩 버전
    static let currentOnboardingVersion = "1.0.0"
}

