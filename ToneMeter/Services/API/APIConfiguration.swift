//
//  APIConfiguration.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

/// OpenAI API 설정 관리
struct APIConfiguration {
  
  // MARK: - API Keys
  
  /// OpenAI API 키 (xcconfig에서 로드)
  static var openAIAPIKey: String {
    // Info.plist에서 OPENAI_API_KEY 읽기
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else {
      fatalError("❌ Info.plist에 OPENAI_API_KEY가 설정되지 않았습니다.")
    }
    
    // 기본값 체크 (실제 키가 설정되었는지 확인)
    guard !apiKey.isEmpty && apiKey != "your_openai_api_key_here" else {
      fatalError("❌ Debug.xcconfig 또는 Release.xcconfig에 올바른 OPENAI_API_KEY를 설정해주세요.")
    }
    
    return apiKey
  }
  
  // MARK: - Endpoints
  
  /// OpenAI API Base URL
  static let openAIBaseURL = "https://api.openai.com/v1"
  
  /// Chat Completions 엔드포인트
  static let chatCompletionEndpoint = "\(openAIBaseURL)/chat/completions"
  
  // MARK: - Model Settings
  
  /// 기본 사용 모델
  static let defaultModel = "gpt-4o-mini"
  
  /// Temperature (창의성 vs 일관성)
  /// 0.0 = 매우 일관적, 1.0 = 매우 창의적
  static let defaultTemperature: Double = 0.3
  
  /// 최대 토큰 수
  static let defaultMaxTokens: Int = 500
  
  // MARK: - Network Settings
  
  /// 요청 타임아웃 (초)
  static let requestTimeout: TimeInterval = 30.0
  
  /// 재시도 횟수
  static let maxRetries: Int = 3
  
  // MARK: - Helper Methods
  
  /// API 키가 유효한지 확인
  static func validateAPIKey() -> Bool {
    let key = openAIAPIKey
    return key.hasPrefix("sk-") && key.count > 20
  }
}
