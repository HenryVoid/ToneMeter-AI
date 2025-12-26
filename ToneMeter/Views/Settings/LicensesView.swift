//
//  LicensesView.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/12/25.
//

import SwiftUI

struct LicensesView: View {
  var body: some View {
    List {
      Section {
        LicenseRow(
          name: "GRDB.swift",
          author: "Gwendal Roué",
          license: "MIT",
          url: "https://github.com/groue/GRDB.swift"
        )
        
        LicenseRow(
          name: "Firebase iOS SDK",
          author: "Google",
          license: "Apache 2.0",
          url: "https://github.com/firebase/firebase-ios-sdk"
        )
      } header: {
        Text(L10n.Settings.usedOpenSource)
      } footer: {
        Text(L10n.Settings.openSourceDescription)
      }
    }
    .navigationTitle(L10n.Settings.openSource)
    .navigationBarTitleDisplayMode(.inline)
  }
}

/// 라이선스 행
struct LicenseRow: View {
  let name: String
  let author: String
  let license: String
  let url: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(name)
        .font(.headline)
      
      Text(L10n.Settings.licenseAuthorBy(author))
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      HStack {
        Text(license)
          .font(.caption)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(Color.blue.opacity(0.1))
          .foregroundColor(.blue)
          .cornerRadius(4)
        
        Spacer()
        
        if let url = URL(string: url) {
          Link(destination: url) {
            Image(systemName: "link")
              .font(.caption)
          }
        }
      }
    }
    .padding(.vertical, 4)
  }
}
