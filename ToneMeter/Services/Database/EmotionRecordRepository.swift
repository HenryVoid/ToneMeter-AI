//
//  EmotionRecordRepository.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation
import GRDB

class EmotionRecordRepository {
  private let dbQueue: DatabaseQueue
  
  init() {
    self.dbQueue = DatabaseManager.shared.getDatabase()
  }
  
  // CREATE: 새 레코드 저장
  func insert(_ record: EmotionRecord) throws {
    _ = try dbQueue.write { db in
      try record.insert(db)
    }
  }
  
  // READ: 모든 레코드 가져오기 (최신순)
  func fetchAll() throws -> [EmotionRecord] {
    try dbQueue.read { db in
      try EmotionRecord
        .order(Column("createdAt").desc)
        .fetchAll(db)
    }
  }
  
  // READ: 특정 날짜 범위 레코드 가져오기
  func fetchByDateRange(from: Date, to: Date) throws -> [EmotionRecord] {
    try dbQueue.read { db in
      try EmotionRecord
        .filter(Column("createdAt") >= from && Column("createdAt") <= to)
        .order(Column("createdAt").desc)
        .fetchAll(db)
    }
  }
  
  // READ: ID로 특정 레코드 가져오기
  func fetchByID(_ id: String) throws -> EmotionRecord? {
    try dbQueue.read { db in
      try EmotionRecord.fetchOne(db, key: id)
    }
  }
  
  // READ: imageHash로 레코드 조회 (중복 감지용)
  func findByImageHash(_ hash: String) throws -> EmotionRecord? {
    try dbQueue.read { db in
      try EmotionRecord
        .filter(Column("imageHash") == hash)
        .order(Column("createdAt").desc)
        .fetchOne(db)
    }
  }
  
  // UPDATE: 레코드 수정
  func update(_ record: EmotionRecord) throws {
    _ = try dbQueue.write { db in
      try record.update(db)
    }
  }
  
  // DELETE: 레코드 삭제
  func delete(_ id: String) throws {
    _ = try dbQueue.write { db in
      try EmotionRecord.deleteOne(db, key: id)
    }
  }
  
  // DELETE ALL: 모든 레코드 삭제 (설정 화면용)
  func deleteAll() throws {
    _ = try dbQueue.write { db in
      try EmotionRecord.deleteAll(db)
    }
  }
  
  // 통계: 평균 감정 점수 계산
  func fetchAverageScore(since: Date) throws -> Double? {
    try dbQueue.read { db in
      try EmotionRecord
        .filter(Column("createdAt") >= since)
        .select(average(Column("toneScore")))
        .fetchOne(db)
    }
  }
}
