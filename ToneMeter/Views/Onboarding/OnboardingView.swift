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
  
  @StateObject private var permissionManager = PermissionManager.shared
  @State private var currentPage = 0
  @State private var isRequestingPermissions = false
  
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
            // 마지막 페이지: 권한 허용 버튼
            Button {
              requestPermissionsAndComplete()
            } label: {
              HStack {
                if isRequestingPermissions {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                  Text(L10n.Onboarding.startWithPermissions)
                    .font(.headline)
                }
              }
              .frame(maxWidth: .infinity)
              .frame(height: 56)
              .foregroundColor(.white)
              .background(Color.primaryColor)
              .cornerRadius(16)
            }
            .disabled(isRequestingPermissions)
            .transition(.scale.combined(with: .opacity))
          } else {
            // 다음 페이지 버튼
            Button {
              withAnimation {
                currentPage += 1
              }
            } label: {
              Text(L10n.Onboarding.next)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.primaryColor)
                .cornerRadius(16)
            }
            
            // 건너뛰기 버튼
            Button {
              // Analytics: 온보딩 건너뛰기
              AnalyticsLogger.shared.logOnboardingSkipped(currentPage: currentPage)
              completeOnboarding()
            } label: {
              Text(L10n.Onboarding.skip)
                .font(.subheadline)
                .foregroundColor(Color.textSecondary)
            }
          }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
      }
    }
  }
  
  // MARK: - Helper Functions
  
  private func requestPermissionsAndComplete() {
    Task {
      isRequestingPermissions = true
      
      // 사진 라이브러리 권한 요청
      _ = await permissionManager.requestPhotoLibraryPermission()
      
      // 카메라 권한 요청 (선택사항)
      // _ = await permissionManager.requestCameraPermission()
      
      isRequestingPermissions = false
      
      // 권한 요청 완료 후 온보딩 종료
      completeOnboarding()
    }
  }
  
  private func completeOnboarding() {
    withAnimation {
      hasCompletedOnboarding = true
    }
    
    // Analytics: 온보딩 완료
    AnalyticsLogger.shared.logOnboardingCompleted(
      photoPermission: permissionManager.isPhotoLibraryAuthorized
    )
  }
  
  // MARK: - Data
  
  private let pages: [OnboardingPage] = [
    OnboardingPage(
      image: "photo.on.rectangle.angled",
      title: L10n.Onboarding.Page1.title,
      description: L10n.Onboarding.Page1.description
    ),
    OnboardingPage(
      image: "text.viewfinder",
      title: L10n.Onboarding.Page2.title,
      description: L10n.Onboarding.Page2.description
    ),
    OnboardingPage(
      image: "brain.head.profile",
      title: L10n.Onboarding.Page3.title,
      description: L10n.Onboarding.Page3.description
    ),
    OnboardingPage(
      image: "chart.xyaxis.line",
      title: L10n.Onboarding.Page4.title,
      description: L10n.Onboarding.Page4.description
    ),
    OnboardingPage(
      image: "photo.badge.checkmark",
      title: L10n.Onboarding.Page5.title,
      description: L10n.Onboarding.Page5.description
    )
  ]
}
