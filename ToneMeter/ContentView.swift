//
//  ContentView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

struct ContentView: View {
  @State private var testResult: String = ""
  @State private var isAnalyzing: Bool = false
  
  var body: some View {
    VStack(spacing: 20) {
      // 감정 분석 테스트 버튼
      Button("감정 분석 테스트") {
        testEmotionAnalysis()
      }
      .disabled(isAnalyzing)
      
      if isAnalyzing {
        ProgressView("분석 중...")
      }
      
      // 결과 표시
      if !testResult.isEmpty {
        ScrollView {
          Text(testResult)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
      }
    }
    .padding()
  }
  
  func testEmotionAnalysis() {
    isAnalyzing = true
    
    // 테스트 텍스트 (OCR 결과 예시)
    let testText = """
        오빠 집이에요?
        저 오빠집 앞인데 잠깐 볼수 잇을까요?
        아돼지어딘데
        돼지라뇨 말이 심하시네요
        된다고돼지가아니라
        아 괜히 찔려가지고
        """
    
    Task {
      do {
        let apiService = OpenAIService()
        let result = try await apiService.analyzeTone(text: testText)
        
        await MainActor.run {
          testResult = """
                    ✅ 감정 분석 완료
                    
                    📊 점수: \(result.toneScore)/100
                    🏷️ 레이블: \(result.toneLabel)
                    🔑 키워드: \(result.toneKeywords.joined(separator: ", "))
                    💡 분석: \(result.reasoning ?? "없음")
                    """
          isAnalyzing = false
          print("✅ 분석 성공: \(result)")
        }
        
      } catch let error as APIError {
        await MainActor.run {
          testResult = "❌ API 에러: \(error.errorDescription ?? "알 수 없는 오류")"
          isAnalyzing = false
        }
        print("❌ API 에러: \(error)")
      } catch {
        await MainActor.run {
          testResult = "❌ 에러: \(error.localizedDescription)"
          isAnalyzing = false
        }
        print("❌ 에러: \(error)")
      }
    }
  }
}
