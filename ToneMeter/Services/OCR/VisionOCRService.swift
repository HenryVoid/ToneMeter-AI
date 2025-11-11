import UIKit
import Vision

/// 이미지에서 텍스트를 인식하는 OCR 서비스
class VisionOCRService {
  
  // MARK: - Properties
  
  private let recognitionLevel: VNRequestTextRecognitionLevel
  private let supportedLanguages: [String]
  private let minimumConfidence: Float
  
  // MARK: - Initialization
  
  init(
    recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
    supportedLanguages: [String] = ["ko-KR", "en-US"],
    minimumConfidence: Float = 0.5
  ) {
    self.recognitionLevel = recognitionLevel
    self.supportedLanguages = supportedLanguages
    self.minimumConfidence = minimumConfidence
  }
  
  // MARK: - Public Methods
  
  /// 이미지에서 텍스트를 인식합니다
  func recognizeText(from image: UIImage) async throws -> String {
    guard let cgImage = image.cgImage else {
      throw OCRError.invalidImage
    }
    
    let handler = VNImageRequestHandler(
      cgImage: cgImage,
      orientation: image.imageOrientation.toCGImageOrientation(),
      options: [:]
    )
    
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = recognitionLevel
    request.recognitionLanguages = supportedLanguages
    request.usesLanguageCorrection = true
    request.minimumTextHeight = 0.0
    
    return try await withCheckedThrowingContinuation { continuation in
      do {
        try handler.perform([request])
        
        guard let observations = request.results else {
          continuation.resume(throwing: OCRError.noTextFound)
          return
        }
        
        let text = self.processObservations(observations)
        
        if text.isEmpty {
          continuation.resume(throwing: OCRError.noTextFound)
        } else {
          continuation.resume(returning: text)
        }
        
      } catch {
        continuation.resume(throwing: OCRError.processingFailed(error))
      }
    }
  }
  
  /// 텍스트와 위치 정보를 함께 반환
  func recognizeTextWithBounds(from image: UIImage) async throws -> [RecognizedTextWithBounds] {
    guard let cgImage = image.cgImage else {
      throw OCRError.invalidImage
    }
    
    let handler = VNImageRequestHandler(
      cgImage: cgImage,
      orientation: image.imageOrientation.toCGImageOrientation(),
      options: [:]
    )
    
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = recognitionLevel
    request.recognitionLanguages = supportedLanguages
    request.usesLanguageCorrection = true
    
    return try await withCheckedThrowingContinuation { continuation in
      do {
        try handler.perform([request])
        
        guard let observations = request.results else {
          continuation.resume(throwing: OCRError.noTextFound)
          return
        }
        
        let results = observations.compactMap { observation -> RecognizedTextWithBounds? in
          guard let candidate = observation.topCandidates(1).first else {
            return nil
          }
          
          // 신뢰도 필터링
          guard candidate.confidence >= minimumConfidence else {
            return nil
          }
          
          return RecognizedTextWithBounds(
            text: candidate.string,
            boundingBox: observation.boundingBox,
            confidence: candidate.confidence
          )
        }
        
        continuation.resume(returning: results)
        
      } catch {
        continuation.resume(throwing: OCRError.processingFailed(error))
      }
    }
  }
  
  // MARK: - Private Methods
  
  private func processObservations(_ observations: [VNRecognizedTextObservation]) -> String {
    let recognizedStrings = observations.compactMap { observation -> String? in
      guard let candidate = observation.topCandidates(1).first else {
        return nil
      }
      
      guard candidate.confidence >= minimumConfidence else {
        return nil
      }
      
      return candidate.string
    }
    
    return recognizedStrings.joined(separator: "\n")
  }
}

// MARK: - Supporting Types

struct RecognizedTextWithBounds {
  let text: String
  let boundingBox: CGRect
  let confidence: Float
}

enum OCRError: LocalizedError {
  case invalidImage
  case noTextFound
  case processingFailed(Error)
  case unsupportedFormat
  
  var errorDescription: String? {
    switch self {
    case .invalidImage:
      return "이미지를 처리할 수 없습니다."
    case .noTextFound:
      return "이미지에서 텍스트를 찾을 수 없습니다."
    case .processingFailed(let error):
      return "OCR 처리 중 오류가 발생했습니다: \(error.localizedDescription)"
    case .unsupportedFormat:
      return "지원하지 않는 이미지 형식입니다."
    }
  }
}
