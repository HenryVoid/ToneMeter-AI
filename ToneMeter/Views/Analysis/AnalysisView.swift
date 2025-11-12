//
//  AnalysisView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import SwiftUI

struct AnalysisView: View {
  // ViewModel 연결 (ObservableObject)
  @StateObject private var viewModel = AnalysisViewModel()
  @StateObject private var permissionManager = PermissionManager.shared
  
  // 이미지 피커 표시 여부
  @State private var showImagePicker = false
  @State private var showPermissionDenied = false
  @State private var deniedPermissionType: PermissionType?
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24) {
          // 1. 이미지 선택 영역
          imageSelectionSection
          
          // 2. 분석 버튼
          if viewModel.selectedImage != nil && !viewModel.isProcessing {
            analyzeButton
          }
          
          // 3. 진행 상태
          if viewModel.isProcessing {
            progressSection
          }
          
          // 4. 결과 표시
          if let result = viewModel.analysisResult, viewModel.currentStep == .completed {
            resultSection(result)
          }
          
          // 5. 에러 표시
          if let error = viewModel.errorMessage {
            errorSection(error)
          }
        }
        .padding()
      }
      .navigationTitle("감정 분석")
      .toolbar {
        if viewModel.selectedImage != nil {
          Button("초기화") {
            viewModel.reset()
          }
        }
      }
      .sheet(isPresented: $showImagePicker) {
        ImagePicker(image: $viewModel.selectedImage)
      }
      .sheet(isPresented: $showPermissionDenied) {
        PermissionDeniedView(permissionType: deniedPermissionType ?? .photoLibrary)
      }
    }
  }
  
  // MARK: - View Components
  
  /// 이미지 선택 영역
  private var imageSelectionSection: some View {
    VStack(spacing: 16) {
      if let image = viewModel.selectedImage {
        // 선택된 이미지 표시
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(maxHeight: 300)
          .cornerRadius(16)
          .cardShadow()
        
        Button {
          checkPhotoLibraryPermissionAndShowPicker()
        } label: {
          Label("다른 이미지 선택", systemImage: "photo")
        }
        .buttonStyle(.bordered)
      } else {
        // 이미지 선택 버튼
        Button {
          checkPhotoLibraryPermissionAndShowPicker()
        } label: {
          VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
              .font(.system(size: 60))
              .foregroundColor(Color.primaryy.opacity(0.6))
            
            Text("대화 이미지 선택")
              .font(.headline)
              .foregroundStyle(Color.textBlack)
            
            Text("갤러리에서 대화 스크린샷을 선택해주세요")
              .font(.caption)
              .foregroundColor(Color.textSecondary)
          }
          .frame(maxWidth: .infinity)
          .frame(height: 250)
          .background(Color.cardBackground)
          .cornerRadius(16)
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color.primaryy, style: StrokeStyle(lineWidth: 2, dash: [10]))
          )
        }
      }
    }
  }
  
  /// 분석 시작 버튼
  private var analyzeButton: some View {
    Button {
      Task {
        await viewModel.analyzeImage()
      }
    } label: {
      Label("감정 분석 시작", systemImage: "sparkles")
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gradientPrimary)
        .foregroundColor(.white)
        .cornerRadius(12)
        .accentShadow()
    }
  }
  
  /// 진행 상태 표시
  private var progressSection: some View {
    VStack(spacing: 20) {
      // 단계 표시
      stepIndicators
      
      // 현재 단계 설명
      currentStepDescription
    }
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(16)
    .cardShadow()
  }
  
  /// 단계 인디케이터
  private var stepIndicators: some View {
    HStack(spacing: 12) {
      ForEach([AnalysisStep.performingOCR, .analyzingTone, .savingToDatabase], id: \.self) { step in
        stepIndicatorView(for: step)
        
        if step != .savingToDatabase {
          stepConnector(for: step)
        }
      }
    }
    .padding(.horizontal)
  }
  
  /// 개별 단계 인디케이터 뷰
  private func stepIndicatorView(for step: AnalysisStep) -> some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(stepCircleColor(for: step))
          .frame(width: 50, height: 50)
        
        Image(systemName: step.icon)
          .font(.title3)
          .foregroundColor(.white)
      }
      
      Text(stepShortName(step))
        .font(.caption)
        .foregroundColor(viewModel.currentStep == step ? .primary : .secondary)
    }
  }
  
  /// 단계 간 연결선
  private func stepConnector(for step: AnalysisStep) -> some View {
    Rectangle()
      .fill(stepConnectorColor(for: step))
      .frame(height: 2)
  }
  
  /// 현재 단계 설명
  private var currentStepDescription: some View {
    VStack(spacing: 8) {
      ProgressView()
        .scaleEffect(1.2)
      
      Text(viewModel.currentStep.description)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .padding()
  }
  
  /// 단계 원 색상
  private func stepCircleColor(for step: AnalysisStep) -> Color {
    viewModel.currentStep.rawValue >= step.rawValue ? step.color : Color.gray.opacity(0.2)
  }
  
  /// 단계 연결선 색상
  private func stepConnectorColor(for step: AnalysisStep) -> Color {
    viewModel.currentStep.rawValue > step.rawValue ? Color.blue : Color.gray.opacity(0.2)
  }
  
  /// 결과 표시
  private func resultSection(_ result: ToneAnalysisResult) -> some View {
    VStack(alignment: .leading, spacing: 24) {
      // 헤더
      HStack {
        Image(systemName: "checkmark.circle.fill")
          .font(.title2)
          .foregroundColor(.green)
        
        Text("분석 완료")
          .font(.title2)
          .bold()
      }
      
      // 점수 (큰 숫자)
      VStack(alignment: .leading, spacing: 12) {
        Text("감정 점수")
          .font(.headline)
          .foregroundColor(.secondary)
        
        HStack(alignment: .firstTextBaseline, spacing: 8) {
          Text("\(Int(result.toneScore))")
            .font(.system(size: 64, weight: .bold, design: .rounded))
            .foregroundColor(scoreColor(result.toneScore))
          
          Text("/ 100")
            .font(.title)
            .foregroundColor(.secondary)
        }
      }
      
      Divider()
      
      // 레이블
      HStack {
        Text("감정 레이블")
          .font(.headline)
          .foregroundColor(.secondary)
        
        Spacer()
        
        Text(result.toneLabel)
          .font(.title3)
          .bold()
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(labelColor(result.toneLabel))
          .foregroundColor(.white)
          .cornerRadius(20)
      }
      
      Divider()
      
      // 키워드
      VStack(alignment: .leading, spacing: 12) {
        Text("감정 키워드")
          .font(.headline)
          .foregroundColor(.secondary)
        
        FlowLayout(spacing: 10) {
          ForEach(result.toneKeywords, id: \.self) { keyword in
            Text(keyword)
              .font(.subheadline)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(Color.primaryColor.opacity(0.15))
              .foregroundColor(Color.primaryColor)
              .cornerRadius(20)
          }
        }
      }
      
      // 분석 근거
      if let reasoning = result.reasoning {
        Divider()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("분석 근거")
            .font(.headline)
            .foregroundColor(.secondary)
          
          Text(reasoning)
            .font(.body)
            .foregroundColor(.primary)
            .lineSpacing(4)
        }
      }
      
      // 다시 분석하기 버튼
      Button {
        viewModel.reset()
      } label: {
        Label("새로운 분석 시작", systemImage: "arrow.clockwise")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.gray.opacity(0.1))
          .cornerRadius(12)
      }
    }
    .padding(20)
    .background(Color.cardBackground)
    .cornerRadius(16)
    .cardShadow()
  }
  
  /// 에러 표시
  private func errorSection(_ error: String) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.title2)
          .foregroundColor(.red)
        
        Text("오류 발생")
          .font(.headline)
      }
      
      Text(error)
        .font(.body)
        .foregroundColor(.secondary)
      
      Button {
        viewModel.reset()
      } label: {
        Label("다시 시도", systemImage: "arrow.clockwise")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.emotionNegative.opacity(0.1))
          .foregroundColor(Color.emotionNegative)
          .cornerRadius(12)
      }
    }
    .padding(20)
    .background(Color.cardBackground)
    .cornerRadius(16)
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.emotionNegative.opacity(0.3), lineWidth: 2)
    )
  }
  
  // MARK: - Helper Functions
  
  private func stepShortName(_ step: AnalysisStep) -> String {
    switch step {
    case .performingOCR: return "텍스트 인식"
    case .analyzingTone: return "감정 분석"
    case .savingToDatabase: return "저장"
    default: return ""
    }
  }
  
  private func scoreColor(_ score: Double) -> Color {
    switch score {
    case 0..<46: return .red
    case 46..<56: return .orange
    default: return .green
    }
  }
  
  private func labelColor(_ label: String) -> Color {
    switch label {
    case "Positive": return .green
    case "Neutral": return .orange
    case "Negative": return .red
    default: return .gray
    }
  }
  
  // MARK: - Permission Check
  
  private func checkPhotoLibraryPermissionAndShowPicker() {
    Task {
      switch permissionManager.photoLibraryStatus {
      case .authorized, .limited:
        // 권한 있음 → 피커 표시
        showImagePicker = true
        
      case .notDetermined:
        // 권한 요청
        let granted = await permissionManager.requestPhotoLibraryPermission()
        if granted {
          showImagePicker = true
        } else {
          deniedPermissionType = .photoLibrary
          showPermissionDenied = true
        }
        
      case .denied, .restricted:
        // 권한 거부 → 안내 화면
        deniedPermissionType = .photoLibrary
        showPermissionDenied = true
        
      @unknown default:
        break
      }
    }
  }
}

// MARK: - Flow Layout (키워드 배치용)

struct FlowLayout: Layout {
  var spacing: CGFloat
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let result = FlowResult(
      in: proposal.width ?? 0,
      subviews: subviews,
      spacing: spacing
    )
    return result.size
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    let result = FlowResult(
      in: bounds.width,
      subviews: subviews,
      spacing: spacing
    )
    for (index, subview) in subviews.enumerated() {
      subview.place(
        at: CGPoint(
          x: bounds.minX + result.positions[index].x,
          y: bounds.minY + result.positions[index].y
        ),
        proposal: .unspecified
      )
    }
  }
  
  struct FlowResult {
    var size: CGSize
    var positions: [CGPoint]
    
    init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
      var positions: [CGPoint] = []
      var size: CGSize = .zero
      var currentX: CGFloat = 0
      var currentY: CGFloat = 0
      var lineHeight: CGFloat = 0
      
      for subview in subviews {
        let subviewSize = subview.sizeThatFits(.unspecified)
        
        if currentX + subviewSize.width > maxWidth && currentX > 0 {
          currentX = 0
          currentY += lineHeight + spacing
          lineHeight = 0
        }
        
        positions.append(CGPoint(x: currentX, y: currentY))
        lineHeight = max(lineHeight, subviewSize.height)
        currentX += subviewSize.width + spacing
        size.width = max(size.width, currentX - spacing)
      }
      
      size.height = currentY + lineHeight
      self.size = size
      self.positions = positions
    }
  }
}
