//
//  ConversationControlsView.swift
//  Sidekick
//
//  Created by Bean John on 10/8/24.
//

import MarkdownUI
import SwiftUI

struct ConversationControlsView: View {
	
	@StateObject private var promptController: PromptController = .init()
	
	@EnvironmentObject private var conversationManager: ConversationManager
	@EnvironmentObject private var profileManager: ProfileManager
	@EnvironmentObject private var conversationState: ConversationState
	
	@State private var didFinishTyping: Bool = false
	
	@Namespace private var textFieldMoveAnimation
	
	var selectedConversation: Conversation? {
		guard let selectedConversationId = conversationState.selectedConversationId else {
			return nil
		}
		return self.conversationManager.getConversation(
			id: selectedConversationId
		)
	}
	
	var selectedProfile: Profile? {
		guard let selectedProfileId = conversationState.selectedProfileId else {
			return nil
		}
		return profileManager.getProfile(id: selectedProfileId)
	}
	
	var messages: [Message] {
		return selectedConversation?.messages ?? []
	}
	
	var showQuickPrompts: Bool {
		let noPrompt: Bool = promptController.prompt.isEmpty
		let noMessages: Bool = messages.isEmpty
		let noResources: Bool = !promptController.hasResources
		return noPrompt && noMessages && noResources
	}
	
	var maxHeight: CGFloat {
		let center: Bool = promptController.prompt.isEmpty && messages.isEmpty
		return center ? .infinity : 0
	}
	
	var body: some View {
		VStack {
			Spacer()
				.frame(maxHeight: maxHeight)
			controls
			Spacer()
				.frame(maxHeight: maxHeight)
		}
		.environmentObject(promptController)
	}
	
	var controls: some View {
		VStack {
			if promptController.hasResources && !self.promptController.prompt.isEmpty {
				resources
					.matchedGeometryEffect(
						id: "resources",
						in: textFieldMoveAnimation
					)
			}
			if messages.isEmpty {
				Group {
					if promptController.prompt.isEmpty {
						typedText
							.transition(
								.asymmetric(
									insertion: .push(from: .bottom),
									removal: .move(edge: .bottom)
								)
								.combined(with: .opacity)
							)
					}
					inputField
				}
			}
			if showQuickPrompts {
				ConversationQuickPromptsView(
					input: $promptController.prompt
				)
				.transition(
					.asymmetric(
						insertion: .push(from: .top),
						removal: .move(edge: .top)
					)
					.combined(with: .opacity)
				)
			}
			if promptController.hasResources && self.promptController.prompt.isEmpty {
				resources
					.matchedGeometryEffect(
						id: "resources",
						in: textFieldMoveAnimation
					)
			}
			if !messages.isEmpty {
				inputField
			}
		}
		.padding(.leading)
		.onDrop(
			of: ["public.file-url"],
			delegate: promptController
		)
	}
	
	var resources: some View {
		TemporaryResourcesView()
			.transition(
				.opacity
			)
	}
	
	var typedText: some View {
		HStack(
			spacing: 5
		) {
			TypedTextView(
				String(localized: "How can I help you?"),
				duration: 0.6,
				didFinish: $didFinishTyping
			)
			.font(.title)
			.bold()
			if !didFinishTyping {
				Circle()
					.fill(.white)
					.frame(width: 15, height: 15)
			}
		}
	}
	
	var inputField: some View {
		HStack {
			PromptInputField()
				.overlay {
					Color.clear
						.onDrop(
							of: ["public.file-url"],
							delegate: promptController
						)
				}
		}
	}
	
}