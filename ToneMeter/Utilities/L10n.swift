//
//  L10n.swift
//  ToneMeter
//
//  Created by Cursor on 12/26/25.
//

import Foundation

enum L10n {
    enum Common {
        static let confirm = String(localized: "common_confirm")
        static let cancel = String(localized: "common_cancel")
        static let ok = String(localized: "common_ok")
        static let delete = String(localized: "common_delete")
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
    }
    
    enum History {
        static let title = String(localized: "history_title")
        static let noRecord = String(localized: "history_no_record")
        static let startFirstAnalysis = String(localized: "history_start_first_analysis")
        static let totalAnalysis = String(localized: "history_total_analysis")
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
    }
    
    enum Onboarding {
        static let startWithPermissions = String(localized: "onboarding_start_with_permissions")
        static let next = String(localized: "onboarding_next")
        static let skip = String(localized: "onboarding_skip")
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
    }
}

