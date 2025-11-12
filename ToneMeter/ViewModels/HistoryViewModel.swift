//
//  HistoryViewModel.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI
import Combine

/// 기록 화면을 관리하는 ViewModel
@MainActor
class HistoryViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  /// 전체 기록
  @Published var records: [EmotionRecord] = []
  
  /// 필터링된 기록
  @Published var filteredRecords: [EmotionRecord] = []
  
  /// 현재 필터
  @Published var currentFilter: FilterOption = .all
  
  /// 현재 정렬
  @Published var currentSort: SortOption = .dateDescending
  
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
  func loadRecords() async {
    isLoading = true
    errorMessage = nil
    
    do {
      records = try repository.fetchAll()
      applyFilterAndSort()
    } catch {
      errorMessage = "기록을 불러오는데 실패했습니다: \(error.localizedDescription)"
      print("❌ HistoryViewModel 에러: \(error)")
    }
    
    isLoading = false
  }
  
  /// 필터 변경
  func changeFilter(_ filter: FilterOption) {
    currentFilter = filter
    applyFilterAndSort()
  }
  
  /// 정렬 변경
  func changeSort(_ sort: SortOption) {
    currentSort = sort
    applyFilterAndSort()
  }
  
  /// 기록 삭제
  func deleteRecord(_ record: EmotionRecord) async {
    do {
      try repository.delete(record.id.uuidString)
      await loadRecords()
      print("✅ 기록 삭제 완료: \(record.id)")
    } catch {
      errorMessage = "삭제에 실패했습니다: \(error.localizedDescription)"
      print("❌ 삭제 에러: \(error)")
    }
  }
  
  /// 전체 삭제
  func deleteAllRecords() async {
    do {
      try repository.deleteAll()
      await loadRecords()
      print("✅ 전체 기록 삭제 완료")
    } catch {
      errorMessage = "삭제에 실패했습니다: \(error.localizedDescription)"
      print("❌ 삭제 에러: \(error)")
    }
  }
  
  // MARK: - Private Methods
  
  /// 필터 및 정렬 적용
  private func applyFilterAndSort() {
    // 1. 필터링
    var filtered = records
    
    switch currentFilter {
    case .all:
      break // 모든 기록
    case .positive:
      filtered = records.filter { $0.toneLabel == "Positive" }
    case .neutral:
      filtered = records.filter { $0.toneLabel == "Neutral" }
    case .negative:
      filtered = records.filter { $0.toneLabel == "Negative" }
    case .today:
      let today = Calendar.current.startOfDay(for: Date())
      filtered = records.filter { $0.createdAt >= today }
    case .thisWeek:
      let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
      filtered = records.filter { $0.createdAt >= weekAgo }
    }
    
    // 2. 정렬
    switch currentSort {
    case .dateDescending:
      filtered.sort { $0.createdAt > $1.createdAt }
    case .dateAscending:
      filtered.sort { $0.createdAt < $1.createdAt }
    case .scoreDescending:
      filtered.sort { $0.toneScore > $1.toneScore }
    case .scoreAscending:
      filtered.sort { $0.toneScore < $1.toneScore }
    }
    
    filteredRecords = filtered
  }
}
