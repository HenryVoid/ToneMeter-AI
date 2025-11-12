//
//  DetailView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct DetailView: View {
  let record: EmotionRecord
  @Environment(\.dismiss) private var dismiss
  @State private var showDeleteAlert = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // 1. 이미지
//        imageSection
        
        // 2. 점수 카드
        scoreCard
        
        // 3. OCR 텍스트
        ocrTextSection
        
        // 4. 감정 키워드
        keywordsSection
        
        // 5. 분석 정보
        #if DEBUG
        analysisInfoSection
        #endif
        // 6. 삭제 버튼
        deleteButton
      }
      .padding()
    }
    .navigationTitle("분석 상세")
    .navigationBarTitleDisplayMode(.inline)
    .alert("기록 삭제", isPresented: $showDeleteAlert) {
      Button("취소", role: .cancel) {}
      Button("삭제", role: .destructive) {
        deleteRecord()
      }
    } message: {
      Text("이 분석 기록을 삭제하시겠습니까?")
    }
  }
  
  // MARK: - View Components
  
  /// 이미지 섹션
  private var imageSection: some View {
    Group {
      if let image = loadImage() {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .cornerRadius(16)
          .cardShadow()
      } else {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.sectionBackground)
          .frame(height: 200)
          .overlay {
            VStack {
              Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(Color.textSecondary)
              Text("이미지 없음")
                .foregroundColor(Color.textSecondary)
            }
          }
      }
    }
  }
  
  /// 점수 카드
  private var scoreCard: some View {
    VStack(spacing: 20) {
      // 미터기
      ToneMeterGauge(score: record.toneScore, size: 180)
      
      // 레이블
      Text(emotionLabel)
        .font(.title2)
        .bold()
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .background(Color.emotionColor(for: record.toneScore).opacity(0.2))
        .foregroundColor(Color.emotionColor(for: record.toneScore))
        .cornerRadius(25)
      
      // 날짜
      Text(formattedFullDate)
        .font(.subheadline)
        .foregroundColor(Color.textSecondary)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(16)
    .cardShadow()
  }
  
  /// OCR 텍스트
  private var ocrTextSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("인식된 텍스트", systemImage: "doc.text")
        .font(.headline)
      
      Text(record.ocrText)
        .font(.body)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.sectionBackground)
        .cornerRadius(12)
    }
  }
  
  /// 키워드
  private var keywordsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("감정 키워드", systemImage: "tag")
        .font(.headline)
      
      FlowLayout(spacing: 10) {
        ForEach(keywords, id: \.self) { keyword in
          Text(keyword)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.emotionColor(for: record.toneScore).opacity(0.15))
            .foregroundColor(Color.emotionColor(for: record.toneScore))
            .cornerRadius(20)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  /// 분석 정보
  private var analysisInfoSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("분석 정보", systemImage: "info.circle")
        .font(.headline)
      
      VStack(spacing: 8) {
        InfoRow(title: "모델", value: record.modelVersion)
        InfoRow(title: "분석 일시", value: formattedFullDate)
        InfoRow(title: "ID", value: record.id.uuidString.prefix(8) + "...")
      }
      .padding()
      .background(Color.sectionBackground)
      .cornerRadius(12)
    }
  }
  
  /// 삭제 버튼
  private var deleteButton: some View {
    Button {
      showDeleteAlert = true
    } label: {
      Label("기록 삭제", systemImage: "trash")
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.emotionNegative.opacity(0.1))
        .foregroundColor(Color.emotionNegative)
        .cornerRadius(12)
    }
  }
  
  // MARK: - Helper Functions
  
  private var emotionLabel: String {
    switch record.toneScore {
    case 70...100: return "긍정적 😊"
    case 40..<70: return "중립적 😐"
    default: return "부정적 😢"
    }
  }
  
  private var keywords: [String] {
    record.toneKeywords.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
  }
  
  private var formattedFullDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일 a h:mm"
    return formatter.string(from: record.createdAt)
  }
  
  private func loadImage() -> UIImage? {
    guard FileManager.default.fileExists(atPath: record.imagePath) else {
      return nil
    }
    return UIImage(contentsOfFile: record.imagePath)
  }
  
  private func deleteRecord() {
    Task {
      let repository = EmotionRecordRepository()
      do {
        try repository.delete(record.id.uuidString)
        dismiss()
      } catch {
        print("❌ 삭제 에러: \(error)")
      }
    }
  }
}
