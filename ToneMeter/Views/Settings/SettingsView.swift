//
//  SettingsView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct SettingsView: View {
  @StateObject private var viewModel = SettingsViewModel()
  @State private var showDeleteAlert = false
  @State private var showClearCacheAlert = false
  
  var body: some View {
    NavigationView {
      List {
        // 1. 통계 섹션
        statisticsSection
        
        // 2. 앱 정보 섹션
        appInfoSection
        
        // 3. 데이터 관리 섹션
        dataManagementSection
        
        // 4. 지원 섹션
        supportSection
        
        // 5. 개발자 정보
        developerSection
      }
      .navigationTitle("설정")
      .task {
        await viewModel.loadStatistics()
      }
      .refreshable {
        await viewModel.loadStatistics()
      }
      .alert("전체 데이터 삭제", isPresented: $showDeleteAlert) {
        Button("취소", role: .cancel) {}
        Button("삭제", role: .destructive) {
          Task {
            await viewModel.deleteAllData()
          }
        }
      } message: {
        Text("모든 분석 기록과 이미지가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
      }
      .alert("캐시 정리", isPresented: $showClearCacheAlert) {
        Button("취소", role: .cancel) {}
        Button("정리", role: .destructive) {
          Task {
            await viewModel.clearCache()
          }
        }
      } message: {
        Text("저장된 이미지 파일을 삭제합니다. 분석 기록은 유지됩니다.")
      }
      .overlay {
        if let message = viewModel.successMessage {
          successToast(message)
        }
      }
    }
  }
  
  // MARK: - View Components
  
  /// 통계 섹션
  private var statisticsSection: some View {
    Section {
      // 전체 분석 횟수
      HStack {
        Label("전체 분석", systemImage: "chart.bar.fill")
        Spacer()
        Text("\(viewModel.totalAnalysisCount)회")
          .foregroundColor(Color.textSecondary)
      }
      
      // 평균 점수
      HStack {
        Label("평균 점수", systemImage: "star.fill")
        Spacer()
        Text("\(Int(viewModel.averageScore))점")
          .foregroundColor(Color.textSecondary)
      }
      
      // 가장 많은 감정
      HStack {
        Label("가장 많은 감정", systemImage: "face.smiling")
        Spacer()
        Text(emotionLabel(viewModel.mostFrequentEmotion))
          .foregroundColor(emotionColor(viewModel.mostFrequentEmotion))
      }
    } header: {
      Text("통계")
    }
  }
  
  /// 앱 정보 섹션
  private var appInfoSection: some View {
    Section {
      HStack {
        Label("버전", systemImage: "info.circle")
        Spacer()
        Text(viewModel.appVersion)
          .foregroundColor(Color.textSecondary)
      }
      
      HStack {
        Label("앱 이름", systemImage: "app.badge")
        Spacer()
        Text(AppConstants.appName)
          .foregroundColor(Color.textSecondary)
      }
    } header: {
      Text("앱 정보")
    }
  }
  
  /// 데이터 관리 섹션
  private var dataManagementSection: some View {
    Section {
      // 캐시 정리
      Button {
        showClearCacheAlert = true
      } label: {
        Label("캐시 정리", systemImage: "arrow.clockwise")
      }
      
      // 전체 삭제
      Button(role: .destructive) {
        showDeleteAlert = true
      } label: {
        Label("전체 데이터 삭제", systemImage: "trash")
      }
    } header: {
      Text("데이터 관리")
    } footer: {
      Text("전체 데이터 삭제 시 모든 분석 기록과 이미지가 영구적으로 삭제됩니다.")
    }
  }
  
  /// 지원 섹션
  private var supportSection: some View {
    Section {
      // 문의하기
      Button {
        sendEmail()
      } label: {
        Label("문의하기", systemImage: "envelope")
      }
      
      // 개인정보 처리방침 (노션)
      if let privacyURL = URL(string: AppConstants.privacyPolicyURL) {
        Link(destination: privacyURL) {
          Label("개인정보 처리방침", systemImage: "hand.raised")
        }
      }
      
      // 오픈소스 라이선스
      NavigationLink {
        LicensesView()
      } label: {
        Label("오픈소스 라이선스", systemImage: "doc.text")
      }
    } header: {
      Text("지원")
    }
  }
  
  /// 개발자 정보
  private var developerSection: some View {
    Section {
      HStack {
        Label("개발자", systemImage: "person.circle")
        Spacer()
        Text(AppConstants.developerName)
          .foregroundColor(Color.textSecondary)
      }
    } header: {
      Text("개발자")
    } footer: {
      VStack(spacing: 8) {
        Text("ToneMeter AI v\(viewModel.appVersion)")
          .font(.caption)
          .foregroundColor(Color.textSecondary)
      }
      .frame(maxWidth: .infinity)
      .padding(.top, 20)
    }
  }
  
  /// 성공 토스트
  private func successToast(_ message: String) -> some View {
    VStack {
      Spacer()
      
      HStack {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
        
        Text(message)
          .font(.subheadline)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(.systemBackground))
          .shadow(color: .black.opacity(0.2), radius: 10)
      )
      .padding(.bottom, 100)
    }
    .transition(.move(edge: .bottom).combined(with: .opacity))
    .animation(.spring(), value: viewModel.successMessage)
  }
  
  // MARK: - Helper Functions
  
  private func emotionLabel(_ emotion: String) -> String {
    switch emotion {
    case "Positive": return "긍정적"
    case "Neutral": return "중립적"
    case "Negative": return "부정적"
    default: return emotion
    }
  }
  
  private func emotionColor(_ emotion: String) -> Color {
    switch emotion {
    case "Positive": return .green
    case "Neutral": return .orange
    case "Negative": return .red
    default: return Color.textSecondary
    }
  }
  
  private func sendEmail() {
    let email = "chicazic@gmail.com"
    let subject = "[ToneMeter] 문의하기"
    let body = """
        
        ---
        앱 버전: \(viewModel.appVersion)
        디바이스: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        """
    
    let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    if let url = URL(string: urlString) {
      UIApplication.shared.open(url)
    }
  }
}
