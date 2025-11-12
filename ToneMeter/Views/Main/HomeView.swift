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
      
      // 미터기 (Gauge)
      ZStack {
        // 배경 원
        Circle()
          .stroke(Color.gray.opacity(0.2), lineWidth: 20)
          .frame(width: 200, height: 200)
        
        // 진행 원
        Circle()
          .trim(from: 0, to: viewModel.todayAverageScore / 100)
          .stroke(
            gaugeColor(viewModel.todayAverageScore),
            style: StrokeStyle(lineWidth: 20, lineCap: .round)
          )
          .frame(width: 200, height: 200)
          .rotationEffect(.degrees(-90))
          .animation(.easeInOut(duration: 1.0), value: viewModel.todayAverageScore)
        
        // 중앙 점수
        VStack(spacing: 4) {
          Text("\(Int(viewModel.todayAverageScore))")
            .font(.system(size: 56, weight: .bold, design: .rounded))
            .foregroundColor(gaugeColor(viewModel.todayAverageScore))
          
          Text("/ 100")
            .font(.title3)
            .foregroundColor(.secondary)
        }
      }
      
      // 레이블
      Text(scoreLabel(viewModel.todayAverageScore))
        .font(.title3)
        .bold()
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(gaugeColor(viewModel.todayAverageScore).opacity(0.2))
        .foregroundColor(gaugeColor(viewModel.todayAverageScore))
        .cornerRadius(20)
    }
    .padding()
    .background(Color.blue.opacity(0.05))
    .cornerRadius(20)
  }
  
  /// 통계 카드
  private var statisticsSection: some View {
    HStack(spacing: 16) {
      // 전체 분석 횟수
      StatCard(
        icon: "chart.bar.fill",
        title: "전체 분석",
        value: "\(viewModel.totalAnalysisCount)회",
        color: .blue
      )
      
      // 오늘 평균
      StatCard(
        icon: "calendar",
        title: "오늘 평균",
        value: "\(Int(viewModel.todayAverageScore))점",
        color: .green
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
            .background(
              LinearGradient(
                colors: [.blue, .blue.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .cornerRadius(12)
          
          VStack(alignment: .leading, spacing: 4) {
            Text("새로운 분석 시작")
              .font(.headline)
              .foregroundStyle(Color.primaryy)
            
            Text("대화 이미지를 분석해보세요")
              .font(.caption)
              .foregroundColor(Color.textSecondary)
          }
          
          Spacer()
          
          Image(systemName: "chevron.right")
            .foregroundColor(Color.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
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
          .foregroundColor(.blue)
      }
      
      VStack(spacing: 12) {
        ForEach(viewModel.recentRecords) { record in
          RecentRecordRow(record: record)
        }
      }
    }
  }
  
  // MARK: - Helper Functions
  
  private func gaugeColor(_ score: Double) -> Color {
    switch score {
    case 0..<46: return .red
    case 46..<56: return .orange
    default: return .green
    }
  }
  
  private func scoreLabel(_ score: Double) -> String {
    switch score {
    case 0..<46: return "부정적"
    case 46..<56: return "중립적"
    default: return "긍정적"
    }
  }
}

// MARK: - Supporting Views

/// 통계 카드
struct StatCard: View {
  let icon: String
  let title: String
  let value: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(color)
      
      Text(title)
        .font(.caption)
        .foregroundColor(Color.textSecondary)
      
      Text(value)
        .font(.headline)
        .bold()
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(12)
  }
}

/// 최근 기록 행
struct RecentRecordRow: View {
  let record: EmotionRecord
  
  var body: some View {
    HStack(spacing: 12) {
      // 점수 표시
      ZStack {
        Circle()
          .fill(scoreColor.opacity(0.2))
          .frame(width: 50, height: 50)
        
        Text("\(Int(record.toneScore))")
          .font(.headline)
          .bold()
          .foregroundColor(scoreColor)
      }
      
      // 정보
      VStack(alignment: .leading, spacing: 4) {
        Text(record.toneLabel)
          .font(.subheadline)
          .bold()
          .foregroundStyle(Color.textPrimary)
        
        Text(formattedDate)
          .font(.caption)
          .foregroundColor(Color.textSecondary)
      }
      
      Spacer()
      
      // 키워드 미리보기
      if let firstKeyword = record.toneKeywords.split(separator: ",").first {
        Text(String(firstKeyword))
          .font(.caption)
          .padding(.horizontal, 10)
          .padding(.vertical, 4)
          .background(Color.blue.opacity(0.1))
          .foregroundColor(.blue)
          .cornerRadius(8)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
  }
  
  private var scoreColor: Color {
    switch record.toneScore {
    case 0..<46: return .red
    case 46..<56: return .orange
    default: return .green
    }
  }
  
  private var formattedDate: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.unitsStyle = .short
    return formatter.localizedString(for: record.createdAt, relativeTo: Date())
  }
}
