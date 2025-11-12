//
//  AnalyticsLogger.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

/// Firebase Analytics & Crashlytics를 중앙에서 관리하는 Logger
class AnalyticsLogger {
  
  static let shared = AnalyticsLogger()
  
  private init() {}
  
  // MARK: - Crashlytics
  
  /// Crashlytics에 커스텀 로그 기록
  func logCrashlytics(_ message: String) {
    Crashlytics.crashlytics().log(message)
  }
  
  /// Crashlytics에 에러 기록
  func recordError(_ error: Error, userInfo: [String: Any]? = nil) {
    Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
  }
  
  /// Crashlytics에 사용자 ID 설정
  func setCrashlyticsUserID(_ userID: String) {
    Crashlytics.crashlytics().setUserID(userID)
  }
  
  /// Crashlytics에 커스텀 키-값 설정
  func setCrashlyticsValue(_ value: String, forKey key: String) {
    Crashlytics.crashlytics().setCustomValue(value, forKey: key)
  }
  
  // MARK: - 앱 생명주기
  
  func logAppLaunch() {
    Analytics.logEvent("app_launch", parameters: [
      "launch_time": Date().timeIntervalSince1970
    ])
  }
  
  func logAppBackground() {
    Analytics.logEvent("app_background", parameters: nil)
  }
  
  func logAppForeground() {
    Analytics.logEvent("app_foreground", parameters: nil)
  }
  
  // MARK: - 온보딩
  
  func logOnboardingCompleted(photoPermission: Bool) {
    Analytics.logEvent("onboarding_completed", parameters: [
      "photo_permission": photoPermission
    ])
  }
  
  func logOnboardingSkipped(currentPage: Int) {
    Analytics.logEvent("onboarding_skipped", parameters: [
      "current_page": currentPage
    ])
  }
  
  // MARK: - 권한
  
  func logPhotoLibraryPermission(granted: Bool, authorizationStatus: String) {
    Analytics.logEvent("permission_photo_library", parameters: [
      "status": granted ? "granted" : "denied",
      "authorization_status": authorizationStatus
    ])
  }
  
  func logCameraPermission(granted: Bool) {
    Analytics.logEvent("permission_camera", parameters: [
      "status": granted ? "granted" : "denied"
    ])
  }
  
  // MARK: - OCR
  
  func logOCRStart() {
    Analytics.logEvent("ocr_start", parameters: nil)
  }
  
  func logOCRSuccess(textLength: Int) {
    Analytics.logEvent("ocr_success", parameters: [
      "text_length": textLength
    ])
  }
  
  func logOCRFailed(error: String) {
    Analytics.logEvent("ocr_failed", parameters: [
      "error": error
    ])
  }
  
  // MARK: - 감정 분석
  
  func logAnalysisStart() {
    Analytics.logEvent("analysis_start", parameters: nil)
  }
  
  func logAnalysisSuccess(toneScore: Double, toneLabel: String, keywordCount: Int) {
    Analytics.logEvent("analysis_success", parameters: [
      "tone_score": toneScore,
      "tone_label": toneLabel,
      "keyword_count": keywordCount
    ])
  }
  
  func logAnalysisFailed(error: String) {
    Analytics.logEvent("analysis_failed", parameters: [
      "error": error
    ])
  }
  
  func logAnalysisError(errorType: String, errorDescription: String) {
    Analytics.logEvent("analysis_error", parameters: [
      "error_type": errorType,
      "error_description": errorDescription
    ])
    
    // Crashlytics에도 에러 로그 기록
    logCrashlytics("Analysis Error - \(errorType): \(errorDescription)")
  }
  
  // MARK: - 기록 관리
  
  func logRecordSaved(toneScore: Double, toneLabel: String) {
    Analytics.logEvent("record_saved", parameters: [
      "tone_score": toneScore,
      "tone_label": toneLabel
    ])
  }
  
  func logRecordDeleted(toneLabel: String, toneScore: Double) {
    Analytics.logEvent("record_deleted", parameters: [
      "tone_label": toneLabel,
      "tone_score": toneScore
    ])
  }
  
  func logAllRecordsDeleted(recordCount: Int) {
    Analytics.logEvent("all_records_deleted", parameters: [
      "record_count": recordCount
    ])
  }
  
  // MARK: - 히스토리
  
  func logHistoryFilterChanged(filter: String) {
    Analytics.logEvent("history_filter_changed", parameters: [
      "filter": filter
    ])
  }
  
  func logHistorySortChanged(sort: String) {
    Analytics.logEvent("history_sort_changed", parameters: [
      "sort": sort
    ])
  }
}

