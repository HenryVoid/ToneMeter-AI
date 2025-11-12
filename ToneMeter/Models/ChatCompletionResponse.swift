//
//  ChatCompletionResponse.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

// MARK: - Response Models

/// OpenAI Chat Completion API 응답 구조
struct ChatCompletionResponse: Codable {
  let id: String
  let object: String
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage?
  
  struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String?
    
    struct Message: Codable {
      let role: String
      let content: String
    }
    
    enum CodingKeys: String, CodingKey {
      case index, message
      case finishReason = "finish_reason"
    }
  }
  
  struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
      case promptTokens = "prompt_tokens"
      case completionTokens = "completion_tokens"
      case totalTokens = "total_tokens"
    }
  }
}
