//
//  OnboardingPageView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct OnboardingPageView: View {
  let page: OnboardingPage
  
  var body: some View {
    VStack(spacing: 32) {
      Spacer()
      
      // 아이콘
      Image(systemName: page.image)
        .font(.system(size: 100))
        .foregroundStyle(
          LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .padding(.bottom, 20)
      
      // 제목
      Text(page.title)
        .font(.system(size: 28, weight: .bold))
        .multilineTextAlignment(.center)
      
      // 설명
      Text(page.description)
        .font(.system(size: 17))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .lineSpacing(4)
        .padding(.horizontal, 32)
      
      Spacer()
    }
    .padding()
  }
}
