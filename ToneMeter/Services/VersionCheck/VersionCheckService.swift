//
//  VersionCheckService.swift
//  ToneMeter
//
//  Created by 송형욱 on 12/6/25.
//

import Foundation
import FirebaseRemoteConfig

class VersionCheckService: ObservableObject {
  static let shared = VersionCheckService()
  @Published var needsUpdate: Bool = false
  
  // 앱스토어 URL
  var appStoreURL: URL {
    return URL(string: AppConstants.appStoreURL)!
  }
  
  private init() {}
  
  func checkVersion() {
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    // 개발 중에는 0, 배포 시에는 적절히 조절 (예: 3600)
#if DEBUG
    settings.minimumFetchInterval = 0
#else
    settings.minimumFetchInterval = 3600
#endif
    
    remoteConfig.configSettings = settings
    
    // 기본값 설정 (혹시 인터넷이 안 될 경우)
    remoteConfig.setDefaults(["min_required_version": AppConstants.appVersion as NSObject])
    
    remoteConfig.fetch { [weak self] (status, error) in
      if status == .success {
        remoteConfig.activate { _, _ in
          let minVersion = remoteConfig["min_required_version"].stringValue
          let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
          
          let updateRequired = self?.isUpdateRequired(current: currentVersion, min: minVersion) ?? false
          
          print("📊 Version Check - Current: \(currentVersion), Min: \(minVersion)")
          
          // Analytics 로그 기록
          AnalyticsLogger.shared.logVersionCheck(
            currentVersion: currentVersion,
            minRequiredVersion: minVersion,
            needsUpdate: updateRequired
          )
          
          DispatchQueue.main.async {
            self?.needsUpdate = updateRequired
          }
        }
      } else {
        let errorMessage = error?.localizedDescription ?? "No error available."
        print("Error fetching remote config: \(errorMessage)")
        AnalyticsLogger.shared.logVersionCheckFailed(error: errorMessage)
      }
    }
  }
  
  // 버전 비교 로직
  private func isUpdateRequired(current: String, min: String) -> Bool {
    let currentComponents = current.split(separator: ".").compactMap { Int($0) }
    let minComponents = min.split(separator: ".").compactMap { Int($0) }
    
    let count = max(currentComponents.count, minComponents.count)
    
    for i in 0..<count {
      let currentVal = i < currentComponents.count ? currentComponents[i] : 0
      let minVal = i < minComponents.count ? minComponents[i] : 0
      
      if currentVal < minVal {
        return true
      } else if currentVal > minVal {
        return false
      }
    }
    
    return false
  }
}

