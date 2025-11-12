//
//  LaunchView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct LaunchView: View {
  @State private var isAnimating = false
  @State private var showSlogan = false
  
  var body: some View {
    ZStack {
      // 배경 그라데이션
      LinearGradient(
        colors: [
          Color.blue.opacity(0.8),
          Color.purple.opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      VStack(spacing: 24) {
        // 앱 아이콘/로고
        Image(systemName: "waveform.circle.fill")
          .font(.system(size: 100))
          .foregroundColor(.white)
          .scaleEffect(isAnimating ? 1.0 : 0.5)
          .opacity(isAnimating ? 1.0 : 0.0)
          .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isAnimating)
        
        // 앱 이름
        Text(AppConstants.appName)
          .font(.system(size: 36, weight: .bold))
          .foregroundColor(.white)
          .opacity(isAnimating ? 1.0 : 0.0)
          .offset(y: isAnimating ? 0 : 20)
          .animation(.easeOut(duration: 0.6).delay(0.2), value: isAnimating)
        
        // 슬로건
        if showSlogan {
          Text(AppConstants.appDescription)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white.opacity(0.9))
            .transition(.opacity.combined(with: .scale))
        }
      }
    }
    .onAppear {
      // 애니메이션 시작
      isAnimating = true
      
      // 슬로건 표시 (0.5초 후)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.easeIn(duration: 0.4)) {
          showSlogan = true
        }
      }
    }
  }
}
