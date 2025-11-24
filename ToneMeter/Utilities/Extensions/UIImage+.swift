//
//  UIImage+.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import UIKit
import CryptoKit

// MARK: - UIImage Extension

extension UIImage.Orientation {
  /// UIImage.Orientation을 CGImagePropertyOrientation으로 변환
  func toCGImageOrientation() -> CGImagePropertyOrientation {
    switch self {
    case .up: return .up
    case .down: return .down
    case .left: return .left
    case .right: return .right
    case .upMirrored: return .upMirrored
    case .downMirrored: return .downMirrored
    case .leftMirrored: return .leftMirrored
    case .rightMirrored: return .rightMirrored
    @unknown default: return .up
    }
  }
}

extension UIImage {
  /// 이미지의 SHA256 해시 값을 생성합니다.
  /// 중복 이미지 감지를 위해 사용됩니다.
  /// - Returns: 이미지 데이터의 SHA256 해시 문자열 (64자리 16진수)
  func sha256Hash() -> String {
    guard let imageData = self.jpegData(compressionQuality: 0.8) else {
      // JPEG 변환 실패 시 빈 문자열 반환
      return ""
    }
    
    let hash = SHA256.hash(data: imageData)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
  }
}
