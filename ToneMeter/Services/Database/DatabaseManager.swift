//
//  DatabaseManager.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation
import GRDB

class DatabaseManager {
  // 싱글톤 패턴
  static let shared = DatabaseManager()
  
  // 데이터베이스 큐
  private let dbQueue: DatabaseQueue
  
  private init() {
    // 1. 데이터베이스 파일 경로 설정 (Documents 디렉토리)
    let fileManager = FileManager.default
    let appSupportURL = try! fileManager
      .url(for: .documentDirectory,
           in: .userDomainMask,
           appropriateFor: nil,
           create: true)
    let databaseURL = appSupportURL.appendingPathComponent("tonemeter.db")
    
    // 2. 데이터베이스 큐 생성
    dbQueue = try! DatabaseQueue(path: databaseURL.path)
    
    // 3. 마이그레이션 실행
    try! migrator.migrate(dbQueue)
  }
  
  // 마이그레이션 정의
  private var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    
    // v1: emotionRecords 테이블 생성
    migrator.registerMigration("createEmotionRecords") { db in
      try db.create(table: "emotionRecords") { t in
        t.column("id", .text).primaryKey()
        t.column("createdAt", .datetime).notNull()
        t.column("imagePath", .text).notNull()
        t.column("ocrText", .text).notNull()
        t.column("toneScore", .double).notNull()
        t.column("toneLabel", .text).notNull()
        t.column("toneKeywords", .text).notNull()
        t.column("modelVersion", .text).notNull()
      }
    }
    
    // v2: imageHash 컬럼 추가 (중복 감지용)
    migrator.registerMigration("addImageHash") { db in
      try db.alter(table: "emotionRecords") { t in
        t.add(column: "imageHash", .text)
      }
      // 기존 레코드의 imageHash를 빈 문자열로 초기화
      try db.execute(sql: "UPDATE emotionRecords SET imageHash = '' WHERE imageHash IS NULL")
    }
    
    return migrator
  }
  
  // 데이터베이스 큐 접근 메서드
  func getDatabase() -> DatabaseQueue {
    return dbQueue
  }
}
