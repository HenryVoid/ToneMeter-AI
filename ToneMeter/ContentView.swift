//
//  ContentView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedImage: UIImage?
  @State private var isProcessing = false
  @State private var resultText = ""
  @State private var showImagePicker = false
  
  var body: some View {
    VStack(spacing: 30) {
      // 제목
      Text("ToneMeter 테스트")
        .font(.largeTitle)
        .bold()
      
      // 이미지 선택 버튼
      Button("📷 이미지 선택") {
        showImagePicker = true
      }
      .buttonStyle(.borderedProminent)
      
      // 선택된 이미지 미리보기
      if let image = selectedImage {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(height: 200)
          .cornerRadius(12)
      }
      
      // 전체 플로우 실행 버튼
      if selectedImage != nil {
        Button("🚀 전체 플로우 실행") {
          runFullFlow()
        }
        .buttonStyle(.borderedProminent)
        .disabled(isProcessing)
      }
      
      // 진행 상태
      if isProcessing {
        ProgressView("처리 중...")
      }
      
      // 결과 표시
      if !resultText.isEmpty {
        ScrollView {
          Text(resultText)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
        }
      }
    }
    .padding()
    .sheet(isPresented: $showImagePicker) {
      ImagePicker(image: $selectedImage)
    }
  }
  
  // MARK: - 전체 플로우
  
  func runFullFlow() {
    guard let image = selectedImage else { return }
    
    isProcessing = true
    resultText = ""
    
    Task {
      do {
        // 1단계: OCR
        print("1️⃣ OCR 시작...")
        let ocrService = VisionOCRService()
        let ocrText = try await ocrService.recognizeText(from: image)
        print("✅ OCR 완료: \(ocrText.prefix(50))...")
        
        await updateResult("1️⃣ OCR 완료\n\(ocrText)\n\n")
        
        // 2단계: 감정 분석
        print("2️⃣ 감정 분석 시작...")
        let apiService = OpenAIService()
        let analysis = try await apiService.analyzeTone(text: ocrText)
        print("✅ 감정 분석 완료")
        
        await updateResult("2️⃣ 감정 분석 완료\n점수: \(analysis.toneScore)\n레이블: \(analysis.toneLabel)\n키워드: \(analysis.toneKeywords.joined(separator: ", "))\n\n")
        
        // 3단계: DB 저장
        print("3️⃣ DB 저장 시작...")
        let record = EmotionRecord(
          id: UUID(),
          createdAt: Date(),
          imagePath: saveImageLocally(image), // 이미지 로컬 저장
          ocrText: ocrText,
          toneScore: analysis.toneScore,
          toneLabel: analysis.toneLabel,
          toneKeywords: analysis.toneKeywords.joined(separator: ", "),
          modelVersion: "gpt-4o-mini"
        )
        
        try EmotionRecordRepository().insert(record)
        print("✅ DB 저장 완료")
        
        await updateResult("3️⃣ DB 저장 완료\n\n🎉 전체 플로우 성공!")
        
      } catch {
        await updateResult("❌ 에러 발생: \(error.localizedDescription)")
        print("❌ 에러: \(error)")
      }
      
      await MainActor.run {
        isProcessing = false
      }
    }
  }
  
  @MainActor
  func updateResult(_ text: String) {
    resultText += text
  }
  
  func saveImageLocally(_ image: UIImage) -> String {
    // 이미지를 Documents 디렉토리에 저장
    guard let data = image.jpegData(compressionQuality: 0.8) else {
      return ""
    }
    
    let filename = "conversation_\(Date().timeIntervalSince1970).jpg"
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(filename)
    
    do {
      try data.write(to: fileURL)
      return fileURL.path
    } catch {
      print("❌ 이미지 저장 실패: \(error)")
      return ""
    }
  }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  @Environment(\.dismiss) private var dismiss
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.sourceType = .photoLibrary
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
        parent.image = image
      }
      parent.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.dismiss()
    }
  }
}
