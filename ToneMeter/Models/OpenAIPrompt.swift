//
//  OpenAIPrompt.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/11/25.
//

import Foundation

// MARK: - Prompt Templates

extension OpenAIService {
  
  /// 현재 사용자의 언어 코드 (ko, en 등)
  private var currentLanguage: String {
    if #available(iOS 16, *) {
      return Locale.current.language.languageCode?.identifier ?? "en"
    } else {
      return Locale.current.languageCode ?? "en"
    }
  }
  
  /// 감정 분석을 위한 시스템 프롬프트
  internal var systemPrompt: String {
    if currentLanguage == "ko" {
      return """
        당신은 대화 텍스트의 감정 톤을 정확하게 분석하는 AI 전문가입니다.
        
        다음 규칙을 따라 분석해주세요:
        1. 전체적인 대화의 분위기와 감정을 종합적으로 판단
        2. 긍정적, 중립적, 부정적 요소를 모두 고려
        3. 문맥과 뉘앙스를 파악하여 정확한 감정 파악
        4. 반드시 JSON 형식으로만 응답
        """
    } else {
      return """
        You are an AI expert specializing in accurately analyzing the emotional tone of conversation texts.
        
        Please follow these rules for analysis:
        1. Comprehensively judge the overall atmosphere and emotions of the conversation.
        2. Consider positive, neutral, and negative elements together.
        3. Identify precise emotions by understanding context and nuances.
        4. Respond strictly in JSON format only.
        """
    }
  }
  
  /// 감정 분석 사용자 프롬프트 생성
  internal func createAnalysisPrompt(text: String) -> String {
    if currentLanguage == "ko" {
      return """
        다음 대화 텍스트의 감정 톤을 분석해주세요:
        
        \"\"\"
        \(text)
        \"\"\"
        
        아래 JSON 형식으로 정확히 응답해주세요:
        
        {
          "toneScore": <0에서 100 사이의 숫자>,
          "toneLabel": "<Positive 또는 Neutral 또는 Negative>",
          "toneKeywords": ["키워드1", "키워드2", "키워드3"],
          "reasoning": "<분석 근거 설명>"
        }
        
        점수 기준:
        - 0~30: 매우 부정적 (화남, 짜증, 불만 등)
        - 31~45: 부정적 (불편함, 걱정, 우울 등)
        - 46~55: 중립적 (일상적, 사실 전달 등)
        - 56~70: 긍정적 (기쁨, 만족, 편안함 등)
        - 71~100: 매우 긍정적 (감사, 사랑, 행복 등)
        
        레이블 기준:
        - Negative: 0~45점
        - Neutral: 46~55점
        - Positive: 56~100점
        
        키워드는 3~5개의 감정을 나타내는 단어로 작성해주세요.
        """
    } else {
      return """
        Please analyze the emotional tone of the following conversation text:
        
        \"\"\"
        \(text)
        \"\"\"
        
        Please respond exactly in the JSON format below:
        
        {
          "toneScore": <Number between 0 and 100>,
          "toneLabel": "<Positive or Neutral or Negative>",
          "toneKeywords": ["keyword1", "keyword2", "keyword3"],
          "reasoning": "<Explanation of analysis reasoning>"
        }
        
        Score Criteria:
        - 0~30: Very Negative (Anger, Annoyance, Dissatisfaction, etc.)
        - 31~45: Negative (Discomfort, Worry, Depression, etc.)
        - 46~55: Neutral (Casual, Fact-delivery, etc.)
        - 56~70: Positive (Joy, Satisfaction, Comfort, etc.)
        - 71~100: Very Positive (Gratitude, Love, Happiness, etc.)
        
        Label Criteria:
        - Negative: 0~45 points
        - Neutral: 46~55 points
        - Positive: 56~100 points
        
        Please write 3 to 5 words representing the emotions for keywords.
        """
    }
  }
}
