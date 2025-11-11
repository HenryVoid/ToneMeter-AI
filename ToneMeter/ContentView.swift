//
//  ContentView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

struct ContentView: View {
  @State private var id: UUID? = nil
  
  
  var body: some View {
    VStack(spacing: 30) {
      Button("DB 저장 테스트") {
        saveTestDatabase()
      }
      
      Button("DB 삭제 테스트") {
        if let id {
          deleteTestDatabase(id)
        } else {
          print("⚠️ 먼저 저장해주세요")
        }
      }
      
      Button("모든 DB 조회") {
        fetchAllRecords()
      }
      
      Button("모든 DB 제거") {
        deleteAllRecords()
      }
    }
  }
  
  func saveTestDatabase() {
    let repo = EmotionRecordRepository()
    let newID = UUID()
    
    // 테스트 데이터 생성
    let testRecord = EmotionRecord(
      id: newID,
      createdAt: Date(),
      imagePath: "/test/path.jpg",
      ocrText: "안녕하세요 좋은 하루입니다",
      toneScore: 85.5,
      toneLabel: "Positive",
      toneKeywords: "[\"기쁨\", \"밝음\"]",
      modelVersion: "gpt-4o-mini"
    )
    
    do {
      // 저장
      try repo.insert(testRecord)
      id = newID
      print("✅ 저장 성공 - id: \(newID)")
      
      // 조회
      let records = try repo.fetchAll()
      print("✅ 조회 성공: \(records.count)개")
    } catch {
      print("❌ 에러: \(error)")
    }
  }
  
  func deleteTestDatabase(_ id: UUID) {
    let repo = EmotionRecordRepository()
    
    do {
      // 저장
      print("🗑️ 삭제 시도 - ID: \(id)")
      try repo.delete(id.uuidString)
      print("✅ 삭제 성공")
      
      // 조회
      let records = try repo.fetchAll()
      print("✅ 조회 성공: \(records.count)개")
    } catch {
      print("❌ 에러: \(error)")
    }
  }
  
  func fetchAllRecords() {
    let repo = EmotionRecordRepository()
    do {
      let records = try repo.fetchAll()
      print("📊 전체 레코드: \(records.count)개")
      records.forEach { record in
        print("  - ID: \(record.id)")
        print("    Text: \(record.ocrText)")
        print("    Score: \(record.toneScore)")
      }
    } catch {
      print("❌ 에러: \(error)")
    }
  }
  
  func deleteAllRecords() {
    let repo = EmotionRecordRepository()
    do {
      try repo.deleteAll()
      let records = try repo.fetchAll()
      print("📊 전체 레코드: \(records.count)개")
    } catch {
      print("❌ 에러: \(error)")
    }
  }
}

//#Preview {
//  ContentView()
//}
