//
//  ContentView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

struct ContentView: View {
  @State private var ocrResult: String = ""
  @State private var isProcessing: Bool = false
  
  var body: some View {
    VStack(spacing: 20) {
      // OCR 테스트 버튼
      Button("OCR 테스트") {
        testOCR()
      }
      .disabled(isProcessing)
      
      if isProcessing {
        ProgressView("처리 중...")
      }
      
      // 결과 표시
      if !ocrResult.isEmpty {
        ScrollView {
          Text(ocrResult)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
      }
    }
    .padding()
  }
  
  func testOCR() {
    isProcessing = true
    
    Task {
      do {
        // 테스트 이미지 (Assets.xcassets에 추가한 이미지)
        guard let testImage = UIImage(named: "test_conversation") else {
          print("❌ 테스트 이미지를 찾을 수 없습니다")
          isProcessing = false
          return
        }
        
        let ocrService = VisionOCRService()
        let text = try await ocrService.recognizeText(from: testImage)
        
        await MainActor.run {
          ocrResult = text
          isProcessing = false
          print("✅ OCR 성공:\n\(text)")
        }
        
      } catch let error as OCRError {
        await MainActor.run {
          ocrResult = "에러: \(error.errorDescription ?? "알 수 없는 오류")"
          isProcessing = false
        }
        print("❌ OCR 에러: \(error)")
      } catch {
        await MainActor.run {
          ocrResult = "에러: \(error.localizedDescription)"
          isProcessing = false
        }
        print("❌ 에러: \(error)")
      }
    }
  }
}
