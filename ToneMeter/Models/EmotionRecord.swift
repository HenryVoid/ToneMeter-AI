//
//  EmotionRecord.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation
import GRDB

struct EmotionRecord: Codable, Identifiable {
  var id: UUID
  var createdAt: Date
  var imagePath: String        // 로컬 이미지 저장 경로
  var imageHash: String         // 이미지 해시 (SHA256) - 중복 감지용
  var ocrText: String           // OCR로 인식된 텍스트
  var toneScore: Double         // 0~100 감정 점수
  var toneLabel: String         // "Positive", "Neutral", "Negative"
  var toneKeywords: String      // JSON 배열 문자열 ["공감", "기쁨"]
  var modelVersion: String      // "gpt-4o-mini"
}

// GRDB 프로토콜 채택
extension EmotionRecord: FetchableRecord, PersistableRecord {
  static let databaseTableName = "emotionRecords"
  
  // 👇 추가: 컬럼 정의
  enum Columns: String, ColumnExpression {
    case id, createdAt, imagePath, imageHash, ocrText, toneScore, toneLabel, toneKeywords, modelVersion
  }
  
  // 👇 추가: UUID를 문자열로 명시적 인코딩
  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id.uuidString  // UUID → String 변환
    container[Columns.createdAt] = createdAt
    container[Columns.imagePath] = imagePath
    container[Columns.imageHash] = imageHash
    container[Columns.ocrText] = ocrText
    container[Columns.toneScore] = toneScore
    container[Columns.toneLabel] = toneLabel
    container[Columns.toneKeywords] = toneKeywords
    container[Columns.modelVersion] = modelVersion
  }
}
