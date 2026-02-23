//
//  MYCalculatorButtonModel.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//


import Foundation

struct MYCalculatorButtonModel {
	var title: String
	let action: MYCalculatorAction
	let style: MYCalculatorButtonStyle
	var visualState: MYCalculatorButtonVisualState = .normal
	let spacingFlag: Bool
}
