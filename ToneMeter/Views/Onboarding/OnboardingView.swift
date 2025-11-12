//
//  OnboardingView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct OnboardingView: View {
  @AppStorage(UserDefaultsKeys.hasCompletedOnboarding)
  private var hasCompletedOnboarding = false
  
  @State private var currentPage = 0
  
  var body: some View {
    ZStack {
      // 배경
      Color(.systemBackground)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // 페이지 인디케이터
        HStack(spacing: 8) {
          ForEach(0..<pages.count, id: \.self) { index in
            Circle()
              .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
              .frame(width: 8, height: 8)
              .animation(.easeInOut, value: currentPage)
          }
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
        
        // 페이지 콘텐츠
        TabView(selection: $currentPage) {
          ForEach(0..<pages.count, id: \.self) { index in
            OnboardingPageView(page: pages[index])
              .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        // 하단 버튼
        VStack(spacing: 16) {
          if currentPage == pages.count - 1 {
            // 마지막 페이지: 시작하기 버튼
            Button {
              completeOnboarding()
            } label: {
              Text("시작하기")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.blue)
                .cornerRadius(16)
            }
            .transition(.scale.combined(with: .opacity))
          } else {
            // 다음 페이지 버튼
            Button {
              withAnimation {
                currentPage += 1
              }
            } label: {
              Text("다음")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.blue)
                .cornerRadius(16)
            }
            
            // 건너뛰기 버튼
            Button {
              completeOnboarding()
            } label: {
              Text("건너뛰기")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
          }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
      }
    }
  }
  
  // MARK: - Helper Functions
  
  private func completeOnboarding() {
    withAnimation {
      hasCompletedOnboarding = true
    }
    
    // Firebase Analytics 이벤트 (선택)
    // Analytics.logEvent("onboarding_completed", parameters: nil)
  }
  
  // MARK: - Data
  
  private let pages: [OnboardingPage] = [
    OnboardingPage(
      image: "photo.on.rectangle.angled",
      title: "대화 이미지 분석",
      description: "카카오톡, 메시지 등 대화 스크린샷을\n선택하거나 촬영하세요"
    ),
    OnboardingPage(
      image: "text.viewfinder",
      title: "자동 텍스트 인식",
      description: "최신 OCR 기술로 대화 내용을\n정확하게 추출합니다"
    ),
    OnboardingPage(
      image: "brain.head.profile",
      title: "AI 감정 분석",
      description: "OpenAI 기술로 대화의 감정 톤을\n0-100점으로 분석합니다"
    ),
    OnboardingPage(
      image: "chart.xyaxis.line",
      title: "기록 및 통계",
      description: "모든 데이터는 내 iPhone에만 안전하게 저장되며,\n통계로 확인할 수 있습니다"
    )
  ]
}
