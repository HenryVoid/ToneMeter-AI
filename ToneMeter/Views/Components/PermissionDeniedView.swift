//
//  PermissionDeniedView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

/// 권한 거부 시 표시되는 안내 화면
struct PermissionDeniedView: View {
  let permissionType: PermissionType
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      
      // 아이콘
      Image(systemName: iconName)
        .font(.system(size: 80))
        .foregroundColor(Color.primaryy.opacity(0.6))
      
      // 제목
      Text(title)
        .font(.title2)
        .bold()
      
      // 설명
      Text(message)
        .font(.body)
        .foregroundColor(Color.textSecondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      
      Spacer()
      
      // 버튼
      VStack(spacing: 12) {
        // 설정 열기
        Button {
          PermissionManager.shared.openSettings()
          dismiss()
        } label: {
          Label("설정으로 이동", systemImage: "gearshape")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primaryy)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        
        // 취소
        Button {
          dismiss()
        } label: {
          Text("취소")
            .font(.headline)
            .foregroundColor(Color.textSecondary)
        }
      }
      .padding(.horizontal)
    }
    .padding()
  }
  
  // MARK: - Helper Properties
  
  private var iconName: String {
    switch permissionType {
    case .photoLibrary: return "photo.on.rectangle.angled"
    case .camera: return "camera"
    }
  }
  
  private var title: String {
    switch permissionType {
    case .photoLibrary: return "사진 접근 권한 필요"
    case .camera: return "카메라 접근 권한 필요"
    }
  }
  
  private var message: String {
    switch permissionType {
    case .photoLibrary:
      return "대화 이미지를 선택하려면 사진 라이브러리 접근 권한이 필요합니다.\n\n설정 > ToneMeter > 사진에서 권한을 허용해주세요."
    case .camera:
      return "대화를 촬영하려면 카메라 접근 권한이 필요합니다.\n\n설정 > ToneMeter > 카메라에서 권한을 허용해주세요."
    }
  }
}

// MARK: - Supporting Types

enum PermissionType {
  case photoLibrary
  case camera
}

// MARK: - Preview

#Preview("사진 라이브러리") {
  PermissionDeniedView(permissionType: .photoLibrary)
}

#Preview("카메라") {
  PermissionDeniedView(permissionType: .camera)
}

