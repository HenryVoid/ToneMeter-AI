//
//  HomeViewModel.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI
import Combine

/// 홈 화면을 관리하는 ViewModel
@MainActor
class HomeViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  /// 오늘의 평균 감정 점수
  @Published var todayAverageScore: Double = 0.0
  
  /// 최근 분석 기록 (최대 5개)
  @Published var recentRecords: [EmotionRecord] = []
  
  /// 전체 분석 횟수
  @Published var totalAnalysisCount: Int = 0
  
  /// 로딩 상태
  @Published var isLoading: Bool = false
  
  /// 에러 메시지
  @Published var errorMessage: String?
  
  // MARK: - Services
  
  private let repository: EmotionRecordRepository
  
  // MARK: - Initialization
  
  init(repository: EmotionRecordRepository = EmotionRecordRepository()) {
    self.repository = repository
  }
  
  // MARK: - Public Methods
  
  /// 데이터 로드
  func loadData() async {
    isLoading = true
    errorMessage = nil
    
    do {
      // 1. 전체 기록 로드
      let allRecords = try repository.fetchAll()
      totalAnalysisCount = allRecords.count
      
      // 2. 최근 5개 기록
      recentRecords = Array(allRecords.prefix(5))
      
      // 3. 오늘의 평균 점수 계산
      let today = Calendar.current.startOfDay(for: Date())
      if let avgScore = try repository.fetchAverageScore(since: today) {
        todayAverageScore = avgScore
      } else {
        // 오늘 기록이 없으면 최근 기록의 평균
        if !recentRecords.isEmpty {
          todayAverageScore = recentRecords.reduce(0) { $0 + $1.toneScore } / Double(recentRecords.count)
        } else {
          todayAverageScore = 0
        }
      }
      
    } catch {
      errorMessage = "데이터를 불러오는데 실패했습니다: \(error.localizedDescription)"
      print("❌ HomeViewModel 에러: \(error)")
    }
    
    isLoading = false
  }
  
  /// 새로고침
  func refresh() async {
    await loadData()
  }
}
