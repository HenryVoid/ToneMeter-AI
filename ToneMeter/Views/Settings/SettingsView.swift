//
//  SettingsView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct SettingsView: View {
  @StateObject private var viewModel = SettingsViewModel()
  @AppStorage(UserDefaultsKeys.appLanguage) private var appLanguage = "ko"
  @State private var showDeleteAlert = false
  @State private var showClearCacheAlert = false
  @State private var showCrashAlert = false
  
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
        
        #if DEBUG
        // 5. Crashlytics 테스트 (Debug 모드만)
        crashlyticsSection
        // 6. 테스트 섹션
        testSection
        #endif
                
        // 7. 개발자 정보
        developerSection
      }
      .navigationTitle(L10n.Settings.title)
      .task {
        await viewModel.loadStatistics()
      }
      .refreshable {
        await viewModel.loadStatistics()
      }
      .alert(L10n.Settings.deleteDataTitle, isPresented: $showDeleteAlert) {
        Button(L10n.Common.cancel, role: .cancel) {}
        Button(L10n.Common.delete, role: .destructive) {
          Task {
            await viewModel.deleteAllData()
          }
        }
      } message: {
        Text(L10n.Settings.deleteDataConfirm)
      }
      .alert(L10n.Settings.clearCache, isPresented: $showClearCacheAlert) {
        Button(L10n.Common.cancel, role: .cancel) {}
        Button(L10n.Settings.clearCacheConfirm, role: .destructive) {
          Task {
            await viewModel.clearCache()
          }
        }
      } message: {
        Text(L10n.Settings.clearCacheDescription)
      }
      #if DEBUG
      .alert("테스트 크래시", isPresented: $showCrashAlert) {
        Button("취소", role: .cancel) {}
        Button("크래시 발생", role: .destructive) {
          viewModel.triggerTestCrash()
        }
      } message: {
        Text("앱이 강제 종료됩니다. Firebase Console에서 크래시 리포트를 확인할 수 있습니다.")
      }
      #endif
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
      VStack(spacing: 16) {
        HStack(spacing: 16) {
          // 전체 분석
          EmotionCard(
            title: L10n.History.totalAnalysis,
            value: "\(viewModel.totalAnalysisCount)\(L10n.History.countSuffix)",
            icon: "chart.bar.fill",
            accentColor: Color.primaryColor
          )
          
          // 평균 점수
          EmotionCard(
            title: L10n.History.averageScore,
            value: "\(Int(viewModel.averageScore))\(L10n.History.scoreSuffix)",
            icon: "star.fill",
            accentColor: Color.emotionColor(for: viewModel.averageScore)
          )
        }
        
        // 가장 많은 감정
        EmotionCard(
          title: L10n.Settings.mostFrequentEmotion,
          value: emotionLabel(viewModel.mostFrequentEmotion),
          icon: "face.smiling.fill",
          accentColor: emotionColor(viewModel.mostFrequentEmotion)
        )
      }
      .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
      .listRowBackground(Color.clear)
    } header: {
      Text(L10n.Settings.statistics)
    }
  }
  
  /// 앱 정보 섹션
  private var appInfoSection: some View {
    Section {
      HStack {
        Label(L10n.Settings.version, systemImage: "info.circle")
        Spacer()
        Text(AppConstants.appVersion)
          .foregroundColor(Color.textSecondary)
      }
      
      HStack {
        Label(L10n.Settings.appNameLabel, systemImage: "app.badge")
        Spacer()
        Text(AppConstants.appName)
          .foregroundColor(Color.textSecondary)
      }
    } header: {
      Text(L10n.Settings.appInfo)
    }
  }
  
  /// 데이터 관리 섹션
  private var dataManagementSection: some View {
    Section {
      // 캐시 정리
      Button {
        showClearCacheAlert = true
      } label: {
        Label(L10n.Settings.clearCache, systemImage: "arrow.clockwise")
      }
      
      // 전체 삭제
      Button(role: .destructive) {
        showDeleteAlert = true
      } label: {
        Label(L10n.Settings.deleteDataAction, systemImage: "trash")
      }
    } header: {
      Text(L10n.Settings.dataManagement)
    } footer: {
      Text(L10n.Settings.deleteDataDescription)
    }
  }
  
  /// 지원 섹션
  private var supportSection: some View {
    Section {
      // 문의하기
      Button {
        sendEmail()
      } label: {
        Label(L10n.Settings.contact, systemImage: "envelope")
      }
      
      // 개인정보 처리방침 (노션)
      if let privacyURL = URL(string: AppConstants.privacyPolicyURL) {
        Link(destination: privacyURL) {
          Label(L10n.Settings.privacyPolicy, systemImage: "hand.raised")
        }
      }
      
      // 오픈소스 라이선스
      NavigationLink {
        LicensesView()
      } label: {
        Label(L10n.Settings.openSource, systemImage: "doc.text")
      }
    } header: {
      Text(L10n.Settings.support)
    }
  }
  
  #if DEBUG
  /// Crashlytics 테스트 섹션 (Debug 모드만)
  private var crashlyticsSection: some View {
    Section {
      // 테스트 크래시
      Button(role: .destructive) {
        showCrashAlert = true
      } label: {
        Label("테스트 크래시 발생", systemImage: "exclamationmark.triangle")
      }
      
      // 테스트 에러 전송
      Button {
        viewModel.sendTestError()
      } label: {
        Label("테스트 에러 전송", systemImage: "xmark.circle")
      }
      
      // 커스텀 로그 전송
      Button {
        viewModel.sendCustomLog()
      } label: {
        Label("커스텀 로그 전송", systemImage: "square.and.arrow.up")
      }
    } header: {
      Text("Crashlytics 테스트 (Debug)")
    } footer: {
      Text("테스트 크래시는 앱을 강제 종료합니다. 크래시 리포트는 Firebase Console에서 확인할 수 있습니다.")
    }
  }
  
  /// 테스트 섹션
  private var testSection: some View {
    Section {
      HStack {
        Label("언어 설정 (Language)", systemImage: "globe")
        Spacer()
        Picker("언어 선택", selection: $appLanguage) {
          Text("한국어 (KR)").tag("ko")
          Text("English (EN)").tag("en")
        }
        .pickerStyle(.menu)
      }
    } header: {
      Text("Test (테스트)")
    } footer: {
      Text("테스트를 위한 언어 변경 옵션입니다.")
    }
  }
#endif
  
  /// 개발자 정보
  private var developerSection: some View {
    Section {
      HStack {
        Label(L10n.Settings.developer, systemImage: "person.circle")
        Spacer()
        Text(AppConstants.developerName)
          .foregroundColor(Color.textSecondary)
      }
    } header: {
      Text(L10n.Settings.developer)
    } footer: {
      VStack(spacing: 8) {
        Text("ToneMeter AI v\(AppConstants.appVersion)")
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
    case "Positive": return L10n.Analysis.positiveLabel
    case "Neutral": return L10n.Analysis.neutralLabel
    case "Negative": return L10n.Analysis.negativeLabel
    default: return emotion
    }
  }
  
  private func emotionColor(_ emotion: String) -> Color {
    Color.emotionColor(for: emotion)
  }
  
  private func sendEmail() {
    let email = AppConstants.supportEmail
    let subject = L10n.Settings.contactEmailSubject
    let body = L10n.Settings.contactEmailBody(
        version: AppConstants.appVersion,
        device: UIDevice.current.model,
        os: UIDevice.current.systemVersion
    )
    
    let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    if let url = URL(string: urlString) {
      UIApplication.shared.open(url)
    }
  }
}
