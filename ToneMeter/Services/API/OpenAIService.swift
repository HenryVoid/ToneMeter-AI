//
//  OpenAIService.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

/// OpenAI API를 통한 감정 분석 서비스
class OpenAIService {
  
  // MARK: - Properties
  
  private let urlSession: URLSession
  
  // MARK: - Initialization
  
  init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = APIConfiguration.requestTimeout
    configuration.timeoutIntervalForResource = APIConfiguration.requestTimeout * 2
    self.urlSession = URLSession(configuration: configuration)
  }
  
  // MARK: - Public Methods
  
  /// 텍스트의 감정 톤을 분석합니다
  /// - Parameter text: 분석할 텍스트
  /// - Returns: 감정 분석 결과
  /// - Throws: APIError
  func analyzeTone(text: String) async throws -> ToneAnalysisResult {
    // 1. 입력 검증
    guard !text.isEmpty else {
      throw APIError.emptyInput
    }
    
    // 2. 요청 생성
    let request = try createRequest(text: text)
    
    // 3. API 호출
    let (data, response) = try await urlSession.data(for: request)
    
    // 4. 응답 검증
    try validateResponse(response, data: data)
    
    // 5. 응답 파싱
    let chatResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
    
    // 6. 결과 추출
    guard let content = chatResponse.choices.first?.message.content else {
      throw APIError.emptyResponse
    }
    
    // 7. JSON 파싱
    let result = try parseAnalysisResult(from: content)
    
    return result
  }
  
  // MARK: - Private Methods
  
  /// API 요청 생성
  private func createRequest(text: String) throws -> URLRequest {
    guard let url = URL(string: APIConfiguration.chatCompletionEndpoint) else {
      throw APIError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.timeoutInterval = APIConfiguration.requestTimeout
    
    // 헤더 설정
    request.setValue("Bearer \(APIConfiguration.openAIAPIKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 요청 바디 생성
    let requestBody = ChatCompletionRequest(
      model: APIConfiguration.defaultModel,
      messages: [
        .init(role: "system", content: systemPrompt),
        .init(role: "user", content: createAnalysisPrompt(text: text))
      ],
      temperature: APIConfiguration.defaultTemperature,
      maxTokens: APIConfiguration.defaultMaxTokens,
      responseFormat: .init(type: "json_object")  // JSON 모드 활성화
    )
    
    request.httpBody = try JSONEncoder().encode(requestBody)
    
    return request
  }
  
  /// 응답 검증
  private func validateResponse(_ response: URLResponse, data: Data) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    // 성공 코드 확인 (200~299)
    guard (200...299).contains(httpResponse.statusCode) else {
      // 에러 응답 파싱 시도
      if let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
        throw APIError.openAIError(message: errorResponse.error.message, code: errorResponse.error.code)
      }
      throw APIError.httpError(statusCode: httpResponse.statusCode)
    }
  }
  
  /// 분석 결과 파싱
  private func parseAnalysisResult(from content: String) throws -> ToneAnalysisResult {
    guard let contentData = content.data(using: .utf8) else {
      throw APIError.parsingFailed
    }
    
    do {
      let result = try JSONDecoder().decode(ToneAnalysisResult.self, from: contentData)
      
      // 결과 검증
      guard (0...100).contains(result.toneScore) else {
        throw APIError.invalidResult("toneScore는 0~100 사이여야 합니다")
      }
      
      guard ["Positive", "Neutral", "Negative"].contains(result.toneLabel) else {
        throw APIError.invalidResult("toneLabel이 올바르지 않습니다")
      }
      
      return result
      
    } catch {
      throw APIError.parsingFailed
    }
  }
}

// MARK: - Error Types

enum APIError: LocalizedError {
  case invalidURL
  case invalidResponse
  case emptyInput
  case emptyResponse
  case httpError(statusCode: Int)
  case openAIError(message: String, code: String?)
  case parsingFailed
  case invalidResult(String)
  case networkError(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "잘못된 API URL입니다."
    case .invalidResponse:
      return "서버 응답이 올바르지 않습니다."
    case .emptyInput:
      return "분석할 텍스트가 비어있습니다."
    case .emptyResponse:
      return "API 응답이 비어있습니다."
    case .httpError(let code):
      return "HTTP 오류 발생 (코드: \(code))"
    case .openAIError(let message, let code):
      if let code = code {
        return "OpenAI API 오류 [\(code)]: \(message)"
      }
      return "OpenAI API 오류: \(message)"
    case .parsingFailed:
      return "응답 파싱에 실패했습니다."
    case .invalidResult(let reason):
      return "분석 결과가 올바르지 않습니다: \(reason)"
    case .networkError(let error):
      return "네트워크 오류: \(error.localizedDescription)"
    }
  }
}

// OpenAI 에러 응답 구조
struct OpenAIErrorResponse: Codable {
  let error: ErrorDetail
  
  struct ErrorDetail: Codable {
    let message: String
    let type: String
    let code: String?
  }
}
