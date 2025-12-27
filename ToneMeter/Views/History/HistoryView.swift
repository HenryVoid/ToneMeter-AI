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
      .navigationTitle(L10n.History.title)
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
      
      Text(L10n.History.noRecord)
        .font(.title3)
        .bold()
      
      Text(L10n.History.startFirstAnalysis)
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
          Text(viewModel.currentFilter.displayName)
            .font(.headline)
            .foregroundColor(Color.textBlack)
          Spacer()
          Text("\(viewModel.filteredRecords.count)\(L10n.History.countSuffix)")
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
        Text(L10n.History.totalAnalysis)
          .font(.caption)
          .foregroundColor(Color.textSecondary)
        
        Text("\(viewModel.records.count)\(L10n.History.countSuffix)")
          .font(.title2)
          .bold()
      }
      
      Divider()
        .frame(height: 40)
      
      VStack(alignment: .center, spacing: 4) {
        Text(L10n.History.averageScore)
          .font(.caption)
          .foregroundColor(Color.textSecondary)
        
        Text("\(averageScore)\(L10n.History.scoreSuffix)")
          .font(.title2)
          .bold()
      }
    }
    .padding(.vertical, 8)
  }
  
  /// 필터 메뉴
  private var filterMenu: some View {
    Menu(L10n.Common.filter) {
      ForEach(FilterOption.allCases, id: \.self) { filter in
        Button {
          viewModel.changeFilter(filter)
        } label: {
          HStack {
            Text(filter.displayName)
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
    Menu(L10n.Common.sort) {
      ForEach(SortOption.allCases, id: \.self) { sort in
        Button {
          viewModel.changeSort(sort)
        } label: {
          HStack {
            Text(sort.displayName)
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
