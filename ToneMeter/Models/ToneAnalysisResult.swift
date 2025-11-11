//
//  ToneAnalysisResult.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

struct ToneAnalysisResult: Codable {
  let toneScore: Double
  let toneLabel: String
  let toneKeywords: [String]
  let reasoning: String?        // 선택적: 분석 근거
}
