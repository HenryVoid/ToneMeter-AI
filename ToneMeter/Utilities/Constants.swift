//
//  Constants.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

/// 앱 전역 상수
struct AppConstants {
    
    // MARK: - URLs
    
    /// 개인정보 처리방침 URL (노션)
    static let privacyPolicyURL = "https://deep-bassoon-e24.notion.site/2a9bffc137a180e5bba2c306c098deae?source=copy_link"
    
    // MARK: - Contact
    
    /// 문의 이메일
    static let supportEmail = "chicazic@gmail.com"
    
    // MARK: - App Info
    
    /// 앱 이름
    static let appName = "ToneMeter AI"
    
    /// 개발팀 이름
    static let developerName = "Hyungwook Song"
    
    /// 앱 설명
    static let appDescription = "대화의 분위기를 숫자로 읽다"
    
    // MARK: - AdMob
    
    struct AdMob {
        /// Info.plist에서 광고 단위 ID 로드
        static var adUnitID: String {
            return Bundle.main.object(forInfoDictionaryKey: "GADAdUnitID") as? String ?? ""
        }
        
        /// 테스트용 전면광고 ID (개발 시 Fallback)
        static let testInterstitialID = "ca-app-pub-3940256099942544/4411468910"
    }
}
