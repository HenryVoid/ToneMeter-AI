//
//  L10n.swift
//  ToneMeter
//
//  Created by Cursor on 12/26/25.
//

import Foundation

enum L10n {
    enum Common {
        static let appName = String(localized: "common_app_name")
        static let appDescription = String(localized: "common_app_description")
        static let confirm = String(localized: "common_confirm")
        static let cancel = String(localized: "common_cancel")
        static let ok = String(localized: "common_ok")
        static let delete = String(localized: "common_delete")
        static let viewAll = String(localized: "common_view_all")
        static let reset = String(localized: "common_reset")
        static let retry = String(localized: "common_retry")
        static let filter = String(localized: "common_filter")
        static let sort = String(localized: "common_sort")
    }
    
    enum Home {
        static let welcome = String(localized: "home_welcome")
        static let subtitle = String(localized: "home_subtitle")
        static let todayTone = String(localized: "home_today_tone")
        static let quickStart = String(localized: "home_quick_start")
        static let startAnalysis = String(localized: "home_start_analysis")
        static let analysisDescription = String(localized: "home_analysis_description")
        static let recentAnalysis = String(localized: "home_recent_analysis")
    }
    
    enum Analysis {
        static let title = String(localized: "analysis_title")
        static let selectImage = String(localized: "analysis_select_image")
        static let selectImageDescription = String(localized: "analysis_select_image_description")
        static let completed = String(localized: "analysis_completed")
        static let toneScore = String(localized: "analysis_tone_score")
        static let toneLabel = String(localized: "analysis_tone_label")
        static let toneKeywords = String(localized: "analysis_tone_keywords")
        static let reasoning = String(localized: "analysis_reasoning")
        static let error = String(localized: "analysis_error")
        static let positiveLabel = String(localized: "analysis_positive_label")
        static let neutralLabel = String(localized: "analysis_neutral_label")
        static let negativeLabel = String(localized: "analysis_negative_label")
        static let selectAnotherImage = String(localized: "analysis_select_another_image")
        static let startAnalysisAction = String(localized: "analysis_start_analysis_action")
        
        enum Step {
            static let ocr = String(localized: "analysis_step_ocr")
            static let analysis = String(localized: "analysis_step_analysis")
            static let save = String(localized: "analysis_step_save")
            static let idleDescription = String(localized: "analysis_step_idle_description")
            static let ocrDescription = String(localized: "analysis_step_ocr_description")
            static let analysisDescription = String(localized: "analysis_step_analysis_description")
            static let saveDescription = String(localized: "analysis_step_save_description")
            static let completedDescription = String(localized: "analysis_step_completed_description")
            static let failedDescription = String(localized: "analysis_step_failed_description")
        }
    }
    
    enum History {
        static let title = String(localized: "history_title")
        static let noRecord = String(localized: "history_no_record")
        static let startFirstAnalysis = String(localized: "history_start_first_analysis")
        static let totalAnalysis = String(localized: "history_total_analysis")
        static let todayAverage = String(localized: "history_today_average")
        static let averageScore = String(localized: "history_average_score")
        static let countSuffix = String(localized: "history_count_suffix")
        static let scoreSuffix = String(localized: "history_score_suffix")
        static let deleteTitle = String(localized: "history_delete_title")
        static let deleteMessage = String(localized: "history_delete_message")
        static let noImage = String(localized: "history_no_image")
    }
    
    enum Settings {
        static let title = String(localized: "settings_title")
        static let statistics = String(localized: "settings_statistics")
        static let appInfo = String(localized: "settings_app_info")
        static let dataManagement = String(localized: "settings_data_management")
        static let deleteDataTitle = String(localized: "settings_delete_data_title")
        static let deleteDataDescription = String(localized: "settings_delete_data_description")
        static let deleteDataConfirm = String(localized: "settings_delete_data_confirm")
        static let deleteImagesTitle = String(localized: "settings_delete_images_title")
        static let deleteImagesDescription = String(localized: "settings_delete_images_description")
        static let support = String(localized: "settings_support")
        static let contact = String(localized: "settings_contact")
        static let privacyPolicy = String(localized: "settings_privacy_policy")
        static let version = String(localized: "settings_version")
        static let developer = String(localized: "settings_developer")
        static let openSource = String(localized: "settings_open_source")
        static let usedOpenSource = String(localized: "settings_used_open_source")
        static let openSourceDescription = String(localized: "settings_open_source_description")
        static func licenseAuthorBy(_ author: String) -> String {
            return String(localized: "settings_license_author_by \(author)")
        }
        static let clearCache = String(localized: "settings_clear_cache")
        static let clearCacheDescription = String(localized: "settings_clear_cache_description")
        static let clearCacheConfirm = String(localized: "settings_clear_cache_confirm")
        static let deleteDataAction = String(localized: "settings_delete_data_action")
        static let mostFrequentEmotion = String(localized: "settings_most_frequent_emotion")
        static let appNameLabel = String(localized: "settings_app_name_label")
        
        static let contactEmailSubject = String(localized: "settings_contact_email_subject")
        static func contactEmailBody(version: String, device: String, os: String) -> String {
            return String(localized: "settings_contact_email_body \(version) \(device) \(os)")
        }
    }
    
    enum Onboarding {
        static let startWithPermissions = String(localized: "onboarding_start_with_permissions")
        static let next = String(localized: "onboarding_next")
        static let skip = String(localized: "onboarding_skip")
        
        enum Page1 {
            static let title = String(localized: "onboarding_page1_title")
            static let description = String(localized: "onboarding_page1_description")
        }
        enum Page2 {
            static let title = String(localized: "onboarding_page2_title")
            static let description = String(localized: "onboarding_page2_description")
        }
        enum Page3 {
            static let title = String(localized: "onboarding_page3_title")
            static let description = String(localized: "onboarding_page3_description")
        }
        enum Page4 {
            static let title = String(localized: "onboarding_page4_title")
            static let description = String(localized: "onboarding_page4_description")
        }
        enum Page5 {
            static let title = String(localized: "onboarding_page5_title")
            static let description = String(localized: "onboarding_page5_description")
        }
    }
    
    enum Error {
        static let unknown = String(localized: "error_unknown")
        static let noTextFound = String(localized: "error_no_text_found")
        static let imageCompressionFailed = String(localized: "error_image_compression_failed")
        static let imageNotSelected = String(localized: "error_image_not_selected")
        static let invalidURL = String(localized: "error_invalid_url")
        static let invalidResponse = String(localized: "error_invalid_response")
        static let emptyInput = String(localized: "error_empty_input")
        static let emptyResponse = String(localized: "error_empty_response")
        static let parsingFailed = String(localized: "error_parsing_failed")
        
        static func httpError(_ code: Int) -> String {
            return String(localized: "error_http_error \(code)")
        }
        static func openAIError(_ message: String, code: String? = nil) -> String {
            if let code = code {
                return String(localized: "error_openai_error_with_code \(code) \(message)")
            }
            return String(localized: "error_openai_error \(message)")
        }
        static func invalidResult(_ reason: String) -> String {
            return String(localized: "error_invalid_result \(reason)")
        }
        static func networkError(_ error: String) -> String {
            return String(localized: "error_network_error \(error)")
        }
    }
    
    enum Filter {
        static let all = String(localized: "filter_all")
        static let positive = String(localized: "filter_positive")
        static let neutral = String(localized: "filter_neutral")
        static let negative = String(localized: "filter_negative")
        static let today = String(localized: "filter_today")
        static let thisWeek = String(localized: "filter_this_week")
    }
    
    enum Sort {
        static let latest = String(localized: "sort_latest")
        static let oldest = String(localized: "sort_oldest")
        static let highestScore = String(localized: "sort_highest_score")
        static let lowestScore = String(localized: "sort_lowest_score")
    }
}

