//
//  HistoryView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct HistoryView: View {
  @StateObject private var viewModel = HistoryViewModel()
  @State private var showFilterSheet = false
  @State private var showDeleteAlert = false
  
  var body: some View {
    NavigationView {
      ZStack {
        if viewModel.filteredRecords.isEmpty {
          emptyStateView
        } else {
          recordsList
        }
      }
      .navigationTitle("분석 기록")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            filterMenu
            Divider()
            sortMenu
          } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
        }
      }
      .task {
        await viewModel.loadRecords()
      }
      .refreshable {
        await viewModel.loadRecords()
      }
    }
  }
  
  // MARK: - View Components
  
  /// 빈 상태
  private var emptyStateView: some View {
    VStack(spacing: 16) {
      Image(systemName: "tray")
        .font(.system(size: 60))
        .foregroundColor(Color.primaryy.opacity(0.6))
      
      Text("분석 기록이 없습니다")
        .font(.title3)
        .bold()
      
      Text("첫 번째 대화를 분석해보세요")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
  
  /// 기록 리스트
  private var recordsList: some View {
    List {
      // 통계 섹션
      Section {
        statsHeader
      }
      
      // 기록 리스트
      Section {
        ForEach(viewModel.filteredRecords) { record in
          NavigationLink(destination: DetailView(record: record)) {
            EmotionRecordRow(record: record)
          }
        }
        .onDelete(perform: deleteRecords)
      } header: {
        HStack {
          Text(viewModel.currentFilter.rawValue)
            .font(.headline)
            .foregroundColor(Color.textBlack)
          Spacer()
          Text("\(viewModel.filteredRecords.count)개의 기록")
            .font(.subheadline)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
      }
    }
  }
  
  /// 통계 헤더
  private var statsHeader: some View {
    HStack(spacing: 20) {
      VStack(alignment: .center, spacing: 4) {
        Text("전체 분석")
          .font(.caption)
          .foregroundColor(Color.textSecondary)
        
        Text("\(viewModel.records.count)회")
          .font(.title2)
          .bold()
      }
      
      Divider()
        .frame(height: 40)
      
      VStack(alignment: .center, spacing: 4) {
        Text("평균 점수")
          .font(.caption)
          .foregroundColor(Color.textSecondary)
        
        Text("\(averageScore)점")
          .font(.title2)
          .bold()
      }
    }
    .padding(.vertical, 8)
  }
  
  /// 필터 메뉴
  private var filterMenu: some View {
    Menu("필터") {
      ForEach(FilterOption.allCases, id: \.self) { filter in
        Button {
          viewModel.changeFilter(filter)
        } label: {
          HStack {
            Text(filter.rawValue)
            if viewModel.currentFilter == filter {
              Image(systemName: "checkmark")
            }
          }
        }
      }
    }
  }
  
  /// 정렬 메뉴
  private var sortMenu: some View {
    Menu("정렬") {
      ForEach(SortOption.allCases, id: \.self) { sort in
        Button {
          viewModel.changeSort(sort)
        } label: {
          HStack {
            Text(sort.rawValue)
            if viewModel.currentSort == sort {
              Image(systemName: "checkmark")
            }
          }
        }
      }
    }
  }
  
  // MARK: - Helper Functions
  
  private var averageScore: Int {
    guard !viewModel.records.isEmpty else { return 0 }
    let total = viewModel.records.reduce(0.0) { $0 + $1.toneScore }
    return Int(total / Double(viewModel.records.count))
  }
  
  private func deleteRecords(at offsets: IndexSet) {
    for index in offsets {
      let record = viewModel.filteredRecords[index]
      Task {
        await viewModel.deleteRecord(record)
      }
    }
  }
}
