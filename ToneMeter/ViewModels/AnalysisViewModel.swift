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
      
      // Analytics: OCR 시작
      AnalyticsLogger.shared.logOCRStart()
      
      ocrText = try await ocrService.recognizeText(from: image)
      
      guard !ocrText.isEmpty else {
        throw AnalysisError.noTextFound
      }
      
      print("✅ OCR 완료: \(ocrText.prefix(50))...")
      
      // Analytics: OCR 성공
      AnalyticsLogger.shared.logOCRSuccess(textLength: ocrText.count)
      
      // 2단계: 감정 분석
      currentStep = .analyzingTone
      print("2️⃣ 감정 분석 시작...")
      
      // Analytics: 감정 분석 시작
      AnalyticsLogger.shared.logAnalysisStart()
      
      analysisResult = try await apiService.analyzeTone(text: ocrText)
      
      print("✅ 감정 분석 완료: 점수 \(analysisResult!.toneScore)")
      
      // Analytics: 감정 분석 성공
      AnalyticsLogger.shared.logAnalysisSuccess(
        toneScore: analysisResult!.toneScore,
        toneLabel: analysisResult!.toneLabel,
        keywordCount: analysisResult!.toneKeywords.count
      )
      
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
      
      // Analytics: 기록 저장
      AnalyticsLogger.shared.logRecordSaved(
        toneScore: record.toneScore,
        toneLabel: record.toneLabel
      )
      
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
    
    // Analytics: 에러 기록
    var errorType = "unknown"
    var errorDescription = error.localizedDescription
    
    if let ocrError = error as? OCRError {
      errorType = "ocr_error"
      errorMessage = ocrError.errorDescription
      errorDescription = ocrError.errorDescription ?? ""
      print("❌ OCR 에러: \(errorDescription)")
      
      // Analytics: OCR 실패
      AnalyticsLogger.shared.logOCRFailed(error: errorDescription)
    } else if let apiError = error as? APIError {
      errorType = "api_error"
      errorMessage = apiError.errorDescription
      errorDescription = apiError.errorDescription ?? ""
      print("❌ API 에러: \(errorDescription)")
      
      // Analytics: 감정 분석 실패
      AnalyticsLogger.shared.logAnalysisFailed(error: errorDescription)
    } else if let analysisError = error as? AnalysisError {
      errorType = "analysis_error"
      errorMessage = analysisError.errorDescription
      errorDescription = analysisError.errorDescription ?? ""
      print("❌ 분석 에러: \(errorDescription)")
      
      // Analytics: 일반 분석 실패
      AnalyticsLogger.shared.logAnalysisFailed(error: errorDescription)
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
      print("❌ 알 수 없는 에러: \(error)")
    }
    
    // Analytics: 전체 에러 추적
    AnalyticsLogger.shared.logAnalysisError(
      errorType: errorType,
      errorDescription: errorDescription
    )
  }
}
