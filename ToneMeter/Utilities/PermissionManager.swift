//
//  PermissionManager.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import UIKit
import Photos
import AVFoundation

/// 권한 관리 매니저
class PermissionManager: ObservableObject {
  
  static let shared = PermissionManager()
  
  // MARK: - Published Properties
  
  @Published var photoLibraryStatus: PHAuthorizationStatus = .notDetermined
  @Published var cameraStatus: CameraAuthorizationStatus = .notDetermined
  
  // MARK: - Initialization
  
  private init() {
    checkAllPermissions()
  }
  
  // MARK: - Check Permissions
  
  /// 모든 권한 상태 확인
  func checkAllPermissions() {
    checkPhotoLibraryPermission()
    checkCameraPermission()
  }
  
  /// 사진 라이브러리 권한 확인
  func checkPhotoLibraryPermission() {
    if #available(iOS 14, *) {
      photoLibraryStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    } else {
      photoLibraryStatus = PHPhotoLibrary.authorizationStatus()
    }
  }
  
  /// 카메라 권한 확인
  func checkCameraPermission() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      cameraStatus = .notDetermined
    case .restricted:
      cameraStatus = .restricted
    case .denied:
      cameraStatus = .denied
    case .authorized:
      cameraStatus = .authorized
    @unknown default:
      cameraStatus = .notDetermined
    }
  }
  
  // MARK: - Request Permissions
  
  /// 사진 라이브러리 권한 요청
  func requestPhotoLibraryPermission() async -> Bool {
    if #available(iOS 14, *) {
      let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
      await MainActor.run {
        self.photoLibraryStatus = status
      }
      return status == .authorized || status == .limited
    } else {
      return await withCheckedContinuation { continuation in
        PHPhotoLibrary.requestAuthorization { status in
          DispatchQueue.main.async {
            self.photoLibraryStatus = status
            continuation.resume(returning: status == .authorized)
          }
        }
      }
    }
  }
  
  /// 카메라 권한 요청
  func requestCameraPermission() async -> Bool {
    await withCheckedContinuation { continuation in
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          self.checkCameraPermission()
          continuation.resume(returning: granted)
        }
      }
    }
  }
  
  // MARK: - Helper Functions
  
  /// 사진 라이브러리 권한이 허용되었는지 확인
  var isPhotoLibraryAuthorized: Bool {
    photoLibraryStatus == .authorized || photoLibraryStatus == .limited
  }
  
  /// 카메라 권한이 허용되었는지 확인
  var isCameraAuthorized: Bool {
    cameraStatus == .authorized
  }
  
  /// 설정 앱 열기
  func openSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsURL) {
      UIApplication.shared.open(settingsURL)
    }
  }
}

// MARK: - Supporting Types

/// 카메라 권한 상태
enum CameraAuthorizationStatus {
  case notDetermined
  case restricted
  case denied
  case authorized
}

