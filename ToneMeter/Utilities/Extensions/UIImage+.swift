//
//  UIImage+.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import UIKit

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
