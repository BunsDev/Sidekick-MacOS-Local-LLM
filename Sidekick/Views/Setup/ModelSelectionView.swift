//
//  ModelSelectionView.swift
//  Sidekick
//
//  Created by Bean John on 9/23/24.
//

import SwiftUI

struct ModelSelectionView: View {
	
	@EnvironmentObject private var downloadManager: DownloadManager
	@Binding var selectedModel: Bool
	
    var body: some View {
		VStack {
			welcome
			HStack {
				downloadButton
				selectButton
			}
			.padding(.top, 5)
			downloadProgress
		}
		.padding(.horizontal)
		.padding()
		.onChange(of: downloadManager.didFinishDownloadingModel) {
			selectedModel = downloadManager.didFinishDownloadingModel
		}
    }
	
	var welcome: some View {
		Group {
			Image(.appIcon)
				.resizable()
				.foregroundStyle(.secondary)
				.frame(width: 100, height: 100)
			Text("Welcome to Sidekick")
				.foregroundStyle(.primary)
				.font(.largeTitle)
			Text("Select a Model to get started")
				.foregroundStyle(.secondary)
				.font(.title3)
		}
	}
	
	var downloadProgress: some View {
		Group {
			ForEach(
				self.downloadManager.tasks,
				id: \.self
			) { task in
				ProgressView(task.progress)
					.progressViewStyle(.linear)
			}
		}
		.padding(.top)
	}
	
	var downloadButton: some View {
		Button {
			// Start download of the default model
			self.downloadManager.startDownload(
				url: InferenceSettings.defaultModelUrl
			)
		} label: {
			HStack {
				Text("Download Default Model")
			}
			.padding(.horizontal, 20)
		}
		.keyboardShortcut(.defaultAction)
		.controlSize(.large)
		.frame(minWidth: 250)
	}
	
	var selectButton: some View {
		Button {
			// Select a model
			let didSelect: Bool = Settings.selectModel()
			// After selection, move to next screen
			selectedModel = didSelect
		} label: {
			Text("Select a Model")
		}
		.controlSize(.large)
	}
	
}

//#Preview {
//    ModelSelectionView()
//}
