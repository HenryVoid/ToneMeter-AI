//
//  SettingsViewModel.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI
import Combine
import FirebaseCrashlytics

/// 설정 화면을 관리하는 ViewModel
@MainActor
class SettingsViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  /// 전체 분석 횟수
  @Published var totalAnalysisCount: Int = 0
  
  /// 평균 점수
  @Published var averageScore: Double = 0.0
  
  /// 가장 많이 나온 감정
  @Published var mostFrequentEmotion: String = "없음"
  
  /// 로딩 상태
  @Published var isLoading: Bool = false
  
  /// 에러 메시지
  @Published var errorMessage: String?
  
  /// 성공 메시지
  @Published var successMessage: String?
  
  // MARK: - Services
  
  private let repository: EmotionRecordRepository
  
  // MARK: - Initialization
  
  init(repository: EmotionRecordRepository = EmotionRecordRepository()) {
    self.repository = repository
  }
  
  // MARK: - Public Methods
  
  /// 통계 로드
  func loadStatistics() async {
    isLoading = true
    errorMessage = nil
    
    do {
      let records = try repository.fetchAll()
      
      // 전체 분석 횟수
      totalAnalysisCount = records.count
      
      // 평균 점수
      if !records.isEmpty {
        let totalScore = records.reduce(0.0) { $0 + $1.toneScore }
        averageScore = totalScore / Double(records.count)
      } else {
        averageScore = 0.0
      }
      
      // 가장 많이 나온 감정
      let emotions = records.map { $0.toneLabel }
      let emotionCounts = Dictionary(grouping: emotions, by: { $0 }).mapValues { $0.count }
      mostFrequentEmotion = emotionCounts.max(by: { $0.value < $1.value })?.key ?? "없음"
      
    } catch {
      errorMessage = "통계를 불러오는데 실패했습니다"
      print("❌ 통계 로드 에러: \(error)")
    }
    
    isLoading = false
  }
  
  /// 전체 데이터 삭제
  func deleteAllData() async {
    do {
      try repository.deleteAll()
      
      // 통계 초기화
      totalAnalysisCount = 0
      averageScore = 0.0
      mostFrequentEmotion = "없음"
      
      successMessage = "모든 데이터가 삭제되었습니다"
      print("✅ 전체 데이터 삭제 완료")
      
      // 3초 후 메시지 제거
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.successMessage = nil
      }
      
    } catch {
      errorMessage = "데이터 삭제에 실패했습니다"
      print("❌ 데이터 삭제 에러: \(error)")
    }
  }
  
  /// 캐시 정리 (저장된 이미지 삭제)
  func clearCache() async {
    do {
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let fileURLs = try FileManager.default.contentsOfDirectory(
        at: documentsURL,
        includingPropertiesForKeys: nil
      )
      
      // conversation_ 로 시작하는 이미지 파일 삭제
      let imageFiles = fileURLs.filter { $0.lastPathComponent.hasPrefix("conversation_") }
      
      for fileURL in imageFiles {
        try FileManager.default.removeItem(at: fileURL)
      }
      
      successMessage = "\(imageFiles.count)개의 이미지가 삭제되었습니다"
      print("✅ 캐시 정리 완료: \(imageFiles.count)개")
      
      // 3초 후 메시지 제거
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.successMessage = nil
      }
      
    } catch {
      errorMessage = "캐시 정리에 실패했습니다"
      print("❌ 캐시 정리 에러: \(error)")
    }
  }
  
  // MARK: - Crashlytics (Debug Only)
  
  #if DEBUG
  /// 테스트 크래시 발생 (Debug 모드 전용)
  func triggerTestCrash() {
    print("🔥 테스트 크래시 발생!")
    Crashlytics.crashlytics().log("User triggered test crash from Settings")
    fatalError("Test Crash - This is intentional for testing Crashlytics")
  }
  
  /// 테스트 에러 로그 전송
  func sendTestError() {
    let error = NSError(
      domain: "com.tonemeter.test",
      code: 9999,
      userInfo: [
        NSLocalizedDescriptionKey: "This is a test error for Crashlytics"
      ]
    )
    
    Crashlytics.crashlytics().record(error: error)
    successMessage = "테스트 에러가 Crashlytics로 전송되었습니다"
    print("✅ 테스트 에러 전송 완료")
    
    // 3초 후 메시지 제거
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.successMessage = nil
    }
  }
  
  /// 커스텀 로그 전송
  func sendCustomLog() {
    Crashlytics.crashlytics().log("User ID: test_user_123")
    Crashlytics.crashlytics().setCustomValue("Debug", forKey: "build_type")
    Crashlytics.crashlytics().setCustomValue(AppConstants.appVersion, forKey: "app_version")
    
    successMessage = "커스텀 로그가 Crashlytics로 전송되었습니다"
    print("✅ 커스텀 로그 전송 완료")
    
    // 3초 후 메시지 제거
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.successMessage = nil
    }
  }
  #endif
}
