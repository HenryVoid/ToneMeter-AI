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
  func analyze() async {
    guard let image = selectedImage else {
      errorMessage = "이미지를 선택해주세요"
      return
    }
    
    // 초기화
    isProcessing = true
    errorMessage = nil
    currentStep = .idle
    
    // 중복 이미지 체크
    if checkDuplicate(image: image) {
      isProcessing = false
      return
    }
    
    do {
      // 1단계: OCR 수행
      let text = try await performOCR(image: image)
      
      // 광고 표시 (OCR 성공 후, 감정 분석 전)
      await AdMobService.shared.showAd()
      
      // 2단계: 감정 분석 수행
      let result = try await analyzeTone(text: text)
      
      // 3단계: DB 저장 수행
      try await saveRecord(image: image, text: text, result: result)
      
      // 완료 처리
      currentStep = .completed
      print("🎉 전체 플로우 완료!")
      
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
  
  // MARK: - Private Methods (단계별 로직)
  
  /// 중복 이미지 체크
  /// - Returns: 중복 이미지가 있어서 로드에 성공하면 true, 아니면 false
  private func checkDuplicate(image: UIImage) -> Bool {
    let imageHash = image.sha256Hash()
    if imageHash.isEmpty { return false }
    
    do {
      if let existingRecord = try repository.findByImageHash(imageHash) {
        // 중복 이미지 발견: 저장된 결과 사용
        print("🔄 중복 이미지 발견: 저장된 결과 사용")
        
        let keywords = existingRecord.toneKeywords
          .split(separator: ",")
          .map { $0.trimmingCharacters(in: .whitespaces) }
        
        analysisResult = ToneAnalysisResult(
          toneScore: existingRecord.toneScore,
          toneLabel: existingRecord.toneLabel,
          toneKeywords: keywords,
          reasoning: nil
        )
        
        ocrText = existingRecord.ocrText
        savedRecordId = existingRecord.id
        currentStep = .completed
        
        print("✅ 저장된 결과 로드 완료: 점수 \(existingRecord.toneScore)")
        return true
      }
    } catch {
      print("⚠️ 중복 체크 실패: \(error.localizedDescription)")
    }
    
    return false
  }
  
  /// 1단계: OCR 수행
  private func performOCR(image: UIImage) async throws -> String {
    currentStep = .performingOCR
    print("1️⃣ OCR 시작...")
    
    AnalyticsLogger.shared.logOCRStart()
    
    let text = try await ocrService.recognizeText(from: image)
    
    guard !text.isEmpty else {
      throw AnalysisError.noTextFound
    }
    
    print("✅ OCR 완료: \(text.prefix(50))...")
    AnalyticsLogger.shared.logOCRSuccess(textLength: text.count)
    
    // 상태 업데이트
    self.ocrText = text
    return text
  }
  
  /// 2단계: 감정 분석 수행
  private func analyzeTone(text: String) async throws -> ToneAnalysisResult {
    currentStep = .analyzingTone
    print("2️⃣ 감정 분석 시작...")
    
    AnalyticsLogger.shared.logAnalysisStart()
    
    let result = try await apiService.analyzeTone(text: text)
    
    print("✅ 감정 분석 완료: 점수 \(result.toneScore)")
    
    AnalyticsLogger.shared.logAnalysisSuccess(
      toneScore: result.toneScore,
      toneLabel: result.toneLabel,
      keywordCount: result.toneKeywords.count
    )
    
    // 상태 업데이트
    self.analysisResult = result
    return result
  }
  
  /// 3단계: DB 저장 수행
  private func saveRecord(image: UIImage, text: String, result: ToneAnalysisResult) async throws {
    currentStep = .savingToDatabase
    print("3️⃣ DB 저장 시작...")
    
    let imagePath = try saveImageLocally(image)
    let imageHash = image.sha256Hash()
    
    let record = EmotionRecord(
      id: UUID(),
      createdAt: Date(),
      imagePath: imagePath,
      imageHash: imageHash,
      ocrText: text,
      toneScore: result.toneScore,
      toneLabel: result.toneLabel,
      toneKeywords: result.toneKeywords.joined(separator: ", "),
      modelVersion: "gpt-4o-mini"
    )
    
    try repository.insert(record)
    self.savedRecordId = record.id
    
    print("✅ DB 저장 완료")
    
    AnalyticsLogger.shared.logRecordSaved(
      toneScore: record.toneScore,
      toneLabel: record.toneLabel
    )
  }
  
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
    
    var errorType = "unknown"
    var errorDescription = error.localizedDescription
    
    if let ocrError = error as? OCRError {
      errorType = "ocr_error"
      errorMessage = ocrError.errorDescription
      errorDescription = ocrError.errorDescription ?? ""
      print("❌ OCR 에러: \(errorDescription)")
      AnalyticsLogger.shared.logOCRFailed(error: errorDescription)
    } else if let apiError = error as? APIError {
      errorType = "api_error"
      errorMessage = apiError.errorDescription
      errorDescription = apiError.errorDescription ?? ""
      print("❌ API 에러: \(errorDescription)")
      AnalyticsLogger.shared.logAnalysisFailed(error: errorDescription)
    } else if let analysisError = error as? AnalysisError {
      errorType = "analysis_error"
      errorMessage = analysisError.errorDescription
      errorDescription = analysisError.errorDescription ?? ""
      print("❌ 분석 에러: \(errorDescription)")
      AnalyticsLogger.shared.logAnalysisFailed(error: errorDescription)
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
      print("❌ 알 수 없는 에러: \(error)")
    }
    
    AnalyticsLogger.shared.logAnalysisError(
      errorType: errorType,
      errorDescription: errorDescription
    )
  }
}
