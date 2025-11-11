//
//  AnalysisViewModel.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI
import Combine

/// 감정 분석 플로우를 관리하는 ViewModel
@MainActor
class AnalysisViewModel: ObservableObject {
  
  // MARK: - Published Properties (View가 관찰)
  
  /// 선택된 이미지
  @Published var selectedImage: UIImage?
  
  /// OCR로 추출된 텍스트
  @Published var ocrText: String = ""
  
  /// 감정 분석 결과
  @Published var analysisResult: ToneAnalysisResult?
  
  /// 저장된 레코드 ID
  @Published var savedRecordId: UUID?
  
  /// 현재 진행 단계
  @Published var currentStep: AnalysisStep = .idle
  
  /// 에러 메시지
  @Published var errorMessage: String?
  
  /// 로딩 상태
  @Published var isProcessing: Bool = false
  
  // MARK: - Services (의존성)
  
  private let ocrService: VisionOCRService
  private let apiService: OpenAIService
  private let repository: EmotionRecordRepository
  
  // MARK: - Initialization (의존성 주입)
  
  init(
    ocrService: VisionOCRService = VisionOCRService(),
    apiService: OpenAIService = OpenAIService(),
    repository: EmotionRecordRepository = EmotionRecordRepository()
  ) {
    self.ocrService = ocrService
    self.apiService = apiService
    self.repository = repository
  }
  
  // MARK: - Public Methods (View가 호출)
  
  /// 전체 분석 플로우 실행
  func analyzeImage() async {
    guard let image = selectedImage else {
      errorMessage = "이미지를 선택해주세요"
      return
    }
    
    // 초기화
    isProcessing = true
    errorMessage = nil
    currentStep = .idle
    
    do {
      // 1단계: OCR
      currentStep = .performingOCR
      print("1️⃣ OCR 시작...")
      
      ocrText = try await ocrService.recognizeText(from: image)
      
      guard !ocrText.isEmpty else {
        throw AnalysisError.noTextFound
      }
      
      print("✅ OCR 완료: \(ocrText.prefix(50))...")
      
      // 2단계: 감정 분석
      currentStep = .analyzingTone
      print("2️⃣ 감정 분석 시작...")
      
      analysisResult = try await apiService.analyzeTone(text: ocrText)
      
      print("✅ 감정 분석 완료: 점수 \(analysisResult!.toneScore)")
      
      // 3단계: DB 저장
      currentStep = .savingToDatabase
      print("3️⃣ DB 저장 시작...")
      
      let imagePath = try saveImageLocally(image)
      
      let record = EmotionRecord(
        id: UUID(),
        createdAt: Date(),
        imagePath: imagePath,
        ocrText: ocrText,
        toneScore: analysisResult!.toneScore,
        toneLabel: analysisResult!.toneLabel,
        toneKeywords: analysisResult!.toneKeywords.joined(separator: ", "),
        modelVersion: "gpt-4o-mini"
      )
      
      try repository.insert(record)
      savedRecordId = record.id
      
      print("✅ DB 저장 완료")
      
      // 완료
      currentStep = .completed
      print("🎉 전체 플로우 완료!")
      
    } catch let error as OCRError {
      handleError(error)
    } catch let error as APIError {
      handleError(error)
    } catch let error as AnalysisError {
      handleError(error)
    } catch {
      handleError(error)
    }
    
    isProcessing = false
  }
  
  /// 초기화 (새로운 분석 시작)
  func reset() {
    selectedImage = nil
    ocrText = ""
    analysisResult = nil
    savedRecordId = nil
    currentStep = .idle
    errorMessage = nil
    isProcessing = false
  }
  
  /// 이미지 선택
  func selectImage(_ image: UIImage) {
    selectedImage = image
    // 이전 결과 초기화
    ocrText = ""
    analysisResult = nil
    savedRecordId = nil
    errorMessage = nil
    currentStep = .idle
  }
  
  // MARK: - Private Methods
  
  /// 이미지를 로컬에 저장
  private func saveImageLocally(_ image: UIImage) throws -> String {
    guard let data = image.jpegData(compressionQuality: 0.8) else {
      throw AnalysisError.imageCompressionFailed
    }
    
    let filename = "conversation_\(UUID().uuidString).jpg"
    let documentsURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    )[0]
    let fileURL = documentsURL.appendingPathComponent(filename)
    
    try data.write(to: fileURL)
    return fileURL.path
  }
  
  /// 에러 처리
  private func handleError(_ error: Error) {
    currentStep = .failed
    
    if let ocrError = error as? OCRError {
      errorMessage = ocrError.errorDescription
      print("❌ OCR 에러: \(ocrError.errorDescription ?? "")")
    } else if let apiError = error as? APIError {
      errorMessage = apiError.errorDescription
      print("❌ API 에러: \(apiError.errorDescription ?? "")")
    } else if let analysisError = error as? AnalysisError {
      errorMessage = analysisError.errorDescription
      print("❌ 분석 에러: \(analysisError.errorDescription ?? "")")
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
      print("❌ 알 수 없는 에러: \(error)")
    }
  }
}

// MARK: - Supporting Types

/// 분석 진행 단계
enum AnalysisStep: Int {
  case idle = 0              // 대기 중
  case performingOCR = 1     // OCR 진행 중
  case analyzingTone = 2     // 감정 분석 중
  case savingToDatabase = 3  // DB 저장 중
  case completed = 4         // 완료
  case failed = -1           // 실패
  
  var description: String {
    switch self {
    case .idle: return "대기 중"
    case .performingOCR: return "텍스트 인식 중..."
    case .analyzingTone: return "감정 분석 중..."
    case .savingToDatabase: return "저장 중..."
    case .completed: return "완료!"
    case .failed: return "실패"
    }
  }
  
  var icon: String {
    switch self {
    case .idle: return "circle"
    case .performingOCR: return "doc.text.viewfinder"
    case .analyzingTone: return "brain.head.profile"
    case .savingToDatabase: return "square.and.arrow.down"
    case .completed: return "checkmark.circle.fill"
    case .failed: return "xmark.circle.fill"
    }
  }
  
  var color: Color {
    switch self {
    case .idle: return .gray
    case .performingOCR, .analyzingTone, .savingToDatabase: return .blue
    case .completed: return .green
    case .failed: return .red
    }
  }
}

/// 분석 관련 에러
enum AnalysisError: LocalizedError {
  case noTextFound
  case imageCompressionFailed
  case imageNotSelected
  
  var errorDescription: String? {
    switch self {
    case .noTextFound:
      return "이미지에서 텍스트를 찾을 수 없습니다"
    case .imageCompressionFailed:
      return "이미지 압축에 실패했습니다"
    case .imageNotSelected:
      return "이미지를 선택해주세요"
    }
  }
}
