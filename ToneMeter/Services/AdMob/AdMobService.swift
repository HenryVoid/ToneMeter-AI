//
//  AdMobService.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/26/25.
//

import Foundation
import GoogleMobileAds
import UIKit

@MainActor
class AdMobService: NSObject {
  
  static let shared = AdMobService()
  
  private var interstitial: InterstitialAd?
  private var onAdDismissed: (() -> Void)?
  
  override private init() {
    super.init()
  }
  
  func loadAd() {
    let request = Request()
    let adUnitID = AppConstants.AdMob.adUnitID
    
    print("📡 AdMob: 전면광고 로드 요청 (ID: \(adUnitID))")
    
    InterstitialAd.load(
      with: adUnitID,
      request: request
    ) { [weak self] ad, error in
      if let error = error {
        print("❌ AdMob: 광고 로드 실패 - \(error.localizedDescription)")
        return
      }
      
      self?.interstitial = ad
      self?.interstitial?.fullScreenContentDelegate = self
      print("✅ AdMob: 전면광고 로드 완료")
    }
  }
  
  func showAd() async {
    return await withCheckedContinuation { continuation in
      guard let interstitial = interstitial else {
        print("⚠️ AdMob: 광고가 준비되지 않음. 즉시 작업 진행.")
        loadAd()
        continuation.resume()
        return
      }
      
      guard let rootViewController = UIApplication.shared.rootViewController else {
        print("⚠️ AdMob: RootViewController를 찾을 수 없음. 즉시 작업 진행.")
        continuation.resume()
        return
      }
      
      // 광고 닫힘 이벤트 핸들러 설정
      self.onAdDismissed = {
        continuation.resume()
      }
      
      print("📺 AdMob: 전면광고 표시")
      interstitial.present(from: rootViewController)
    }
  }
}

// MARK: - GADFullScreenContentDelegate
extension AdMobService: FullScreenContentDelegate {
  
  internal func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
    print("👀 AdMob: 광고 노출됨")
  }
  
  internal func adDidRecordClick(_ ad: FullScreenPresentingAd) {
    print("👆 AdMob: 광고 클릭됨")
  }
  
  internal func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("👋 AdMob: 광고 닫힘")
    
    onAdDismissed?()
    onAdDismissed = nil
    
    self.interstitial = nil
    
    loadAd()
  }
  
  internal func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("❌ AdMob: 광고 표시 실패 - \(error.localizedDescription)")
    
    onAdDismissed?()
    onAdDismissed = nil
    
    self.interstitial = nil
    loadAd()
  }
}
