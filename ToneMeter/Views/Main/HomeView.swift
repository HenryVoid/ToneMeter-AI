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
      Text("안녕하세요! 👋")
        .font(.title2)
        .bold()
      
      Text("오늘의 대화 감정을 분석해보세요")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  /// 미터기 섹션
  private var toneMeterSection: some View {
    VStack(spacing: 16) {
      Text("오늘의 감정 톤")
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
        title: "전체 분석",
        value: "\(viewModel.totalAnalysisCount)회",
        color: Color.primaryColor
      )
      
      // 오늘 평균
      StatCard(
        icon: "calendar",
        title: "오늘 평균",
        value: "\(Int(viewModel.todayAverageScore))점",
        color: Color.emotionColor(for: viewModel.todayAverageScore)
      )
    }
  }
  
  /// 빠른 액션
  private var quickActionsSection: some View {
    VStack(spacing: 12) {
      Text("빠른 시작")
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
            Text("새로운 분석 시작")
              .font(.headline)
              .foregroundColor(Color.primaryColor)
            
            Text("대화 이미지를 분석해보세요")
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
        Text("최근 분석")
          .font(.headline)
        
        Spacer()
        
        NavigationLink("전체보기", destination: HistoryView())
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
    case 70...100: return "긍정적 😊"
    case 40..<70: return "중립적 😐"
    default: return "부정적 😢"
    }
  }
}
