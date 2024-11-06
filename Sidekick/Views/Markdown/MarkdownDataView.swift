//
//  MarkdownDataView.swift
//  Sidekick
//
//  Created by Bean John on 11/6/24.
//

import Charts
import SwiftUI
import MarkdownUI

struct MarkdownDataView: View {
	
	init(configuration: BlockConfiguration) {
		self.configuration = configuration
		self._controller = StateObject(
			wrappedValue: MarkdownDataViewController(
				configuration: configuration
			)
		)
	}
	
	var configuration: BlockConfiguration
	@StateObject private var controller: MarkdownDataViewController
	
	var showPicker: Bool {
		return controller.visualizationTypes.count > 1 && controller.canVisualize
	}

	var body: some View {
		VStack(
			alignment: .center
		) {
			display
			if showPicker {
				visualizationPicker
					.fixedSize()
			}
		}
	}
	
	var display: some View {
		Group {
			switch controller.selectedVisualization {
				case .table:
					MarkdownTableView(configuration: configuration)
				case .pieChart:
					MarkdownPieChartView()
				case .barChart:
					MarkdownBarChartView()
				case .scatterPlot:
					MarkdownScatterPlotView()
				case .lineChart:
					MarkdownLineChartView()
			}
		}
		.environmentObject(controller)
		.transition(.scale)
	}
	
	var visualizationPicker: some View {
		Picker(
			selection: $controller.selectedVisualization.animation(
				.linear
			)
		) {
			ForEach(controller.visualizationTypes) { type in
				Text(type.description)
					.padding(.horizontal, 3)
					.tag(type)
			}
		}
		.pickerStyle(.segmented)
	}
	
}

extension Color {
	
	fileprivate static let text = Color(
		light: Color(rgba: 0x0606_06ff), dark: Color(rgba: 0xfbfb_fcff)
	)
	fileprivate static let secondaryText = Color(
		light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
	)
	fileprivate static let tertiaryText = Color(
		light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x6d70_7dff)
	)
	fileprivate static let background = Color.clear
	fileprivate static let secondaryBackground = Color(
		light: Color(rgba: 0xf7f7_f9ff), dark: Color(rgba: 0x2526_2aff)
	)
	fileprivate static let link = Color(
		light: Color(rgba: 0x2c65_cfff), dark: Color(rgba: 0x4c8e_f8ff)
	)
	fileprivate static let border = Color(
		light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
	)
	fileprivate static let divider = Color(
		light: Color(rgba: 0xd0d0_d3ff), dark: Color(rgba: 0x3334_38ff)
	)
	fileprivate static let checkbox = Color(rgba: 0xb9b9_bbff)
	fileprivate static let checkboxBackground = Color(rgba: 0xeeee_efff)
	
}
