//
//  ChatCompletionRequest.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

// MARK: - Request Models

/// OpenAI Chat Completion API 요청 구조
struct ChatCompletionRequest: Codable {
  let model: String
  let messages: [Message]
  let temperature: Double
  let maxTokens: Int
  let responseFormat: ResponseFormat?
  
  struct Message: Codable {
    let role: String      // "system", "user", "assistant"
    let content: String   // 실제 메시지 내용
  }
  
  struct ResponseFormat: Codable {
    let type: String  // "json_object" for JSON mode
  }
  
  enum CodingKeys: String, CodingKey {
    case model, messages, temperature
    case maxTokens = "max_tokens"
    case responseFormat = "response_format"
  }
}
