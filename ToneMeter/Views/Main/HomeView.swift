//
//  HomeView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24) {
          // 1. 환영 헤더
          welcomeHeader
          
          // 2. 오늘의 감정 미터기
          toneMeterSection
          
          // 3. 통계 카드
          statisticsSection
          
          // 4. 빠른 액션
          quickActionsSection
          
          // 5. 최근 분석 기록
          if !viewModel.recentRecords.isEmpty {
            recentRecordsSection
          }
        }
        .padding()
      }
      .navigationTitle("ToneMeter")
      .refreshable {
        await viewModel.refresh()
      }
      .task {
        await viewModel.loadData()
      }
    }
  }
  
  // MARK: - View Components
  
  /// 환영 헤더
  private var welcomeHeader: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(L10n.Home.welcome)
        .font(.title2)
        .bold()
      
      Text(L10n.Home.subtitle)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  /// 미터기 섹션
  private var toneMeterSection: some View {
    VStack(spacing: 16) {
      Text(L10n.Home.todayTone)
        .font(.headline)
      
      // 미터기 컴포넌트
      ToneMeterGauge(score: viewModel.todayAverageScore)
      
      // 레이블
      if !viewModel.recentRecords.isEmpty {
        Text(scoreLabel(viewModel.todayAverageScore))
          .font(.title3)
          .bold()
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(Color.emotionColor(for: viewModel.todayAverageScore).opacity(0.2))
          .foregroundColor(Color.emotionColor(for: viewModel.todayAverageScore))
          .cornerRadius(20)
      }
    }
    .padding()
  }
  
  /// 통계 카드
  private var statisticsSection: some View {
    HStack(spacing: 16) {
      // 전체 분석 횟수
      StatCard(
        icon: "chart.bar.fill",
        title: L10n.History.totalAnalysis,
        value: "\(viewModel.totalAnalysisCount)\(L10n.History.countSuffix)",
        color: Color.primaryColor
      )
      
      // 오늘 평균
      StatCard(
        icon: "calendar",
        title: L10n.History.todayAverage,
        value: "\(Int(viewModel.todayAverageScore))\(L10n.History.scoreSuffix)",
        color: Color.emotionColor(for: viewModel.todayAverageScore)
      )
    }
  }
  
  /// 빠른 액션
  private var quickActionsSection: some View {
    VStack(spacing: 12) {
      Text(L10n.Home.quickStart)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      NavigationLink(destination: AnalysisView()) {
        HStack {
          Image(systemName: "sparkles")
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(Color.gradientPrimary)
            .cornerRadius(12)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(L10n.Home.startAnalysis)
              .font(.headline)
              .foregroundColor(Color.primaryColor)
            
            Text(L10n.Home.analysisDescription)
              .font(.caption)
              .foregroundColor(Color.textSecondary)
          }
          
          Spacer()
          
          Image(systemName: "chevron.right")
            .foregroundColor(Color.textSecondary)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .cardShadow()
      }
      .buttonStyle(PlainButtonStyle())
    }
  }
  
  /// 최근 분석 기록
  private var recentRecordsSection: some View {
    VStack(spacing: 12) {
      HStack {
        Text(L10n.Home.recentAnalysis)
          .font(.headline)
        
        Spacer()
        
        NavigationLink(L10n.Common.viewAll, destination: HistoryView())
          .font(.subheadline)
          .foregroundColor(Color.primaryColor)
      }
      
      VStack(spacing: 12) {
        ForEach(viewModel.recentRecords) { record in
          RecentRecordRow(record: record)
        }
      }
    }
  }
  
  // MARK: - Helper Functions
  
  private func scoreLabel(_ score: Double) -> String {
    switch score {
    case 70...100: return L10n.Analysis.positiveLabel
    case 40..<70: return L10n.Analysis.neutralLabel
    default: return L10n.Analysis.negativeLabel
    }
  }
}
