//
//  MYButtonModelFactory.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import UIKit

struct MYButtonModelFactory {
	
	func makeButtonModels() -> [MYCalculatorButtonModel] {
		func make(
			action: MYCalculatorAction,
			title: String,
			style: MYCalculatorButtonStyle,
			spacingFlag: Bool = false
		) -> MYCalculatorButtonModel {
			
			MYCalculatorButtonModel(
				title: title,
				action: action,
				style: style,
				spacingFlag: spacingFlag
			)
		}
		
		let scientificActiveStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .darkGray,
			selectedBackgroundColor: .white,
			normalTitleColor: .white,
			selectedTitleColor: .black,
			font: .systemFont(ofSize: 18, weight: .regular)
		)
		
		let digitStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .darkGray,
			selectedBackgroundColor: .darkGray,
			normalTitleColor: .white,
			selectedTitleColor: .white,
			font: .systemFont(ofSize: 32, weight: .regular)
		)
		
		let actionStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .lightGray,
			selectedBackgroundColor: .lightGray,
			normalTitleColor: .black,
			selectedTitleColor: .black,
			font: .systemFont(ofSize: 32, weight: .medium)
		)
		
		let operatorStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .systemOrange,
			selectedBackgroundColor: .white,
			normalTitleColor: .white,
			selectedTitleColor: .systemOrange,
			font: .systemFont(ofSize: 32, weight: .medium)
		)
		
		let fakeOperatorStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .systemOrange,
			selectedBackgroundColor: .systemOrange,
			normalTitleColor: .white,
			selectedTitleColor: .white,
			font: .systemFont(ofSize: 32, weight: .medium)
		)
		
		let scientificStyle = MYCalculatorButtonStyle(
			normalBackgroundColor: .darkGray,
			selectedBackgroundColor: .lightGray,
			normalTitleColor: .white,
			selectedTitleColor: .black,
			font: .systemFont(ofSize: 18, weight: .regular)
		)
		
		// MARK: - 1st Page Scientific Buttons
		return [
			make(action: .unary(.powerOfE), title: "eˣ", style: scientificStyle),
			make(action: .unary(.powerOfTen), title: "10ˣ", style: scientificStyle),
			make(action: .unary(.ln), title: "ln", style: scientificStyle),
			make(action: .unary(.log10), title: "log₁₀", style: scientificStyle),
			make(action: .unary(.sin), title: "sin", style: scientificStyle),
			make(action: .unary(.cos), title: "cos", style: scientificStyle),
			make(action: .unary(.tan), title: "tan", style: scientificStyle),
			make(action: .unary(.sinh), title: "sinh", style: scientificStyle),
			make(action: .unary(.cosh), title: "cosh", style: scientificStyle),
			make(action: .unary(.tanh), title: "tanh", style: scientificStyle),
			
			make(action: .shift, title: "2ⁿᵈ", style: scientificActiveStyle),
			make(action: .binaryOperation(.powerReverse), title: "yˣ", style: scientificStyle),
			make(action: .unary(.powerOfTwo), title: "2ˣ", style: scientificStyle),
			make(action: .binaryOperation(.logBase), title: "logᵧ", style: scientificStyle),
			make(action: .unary(.log2), title: "log₂", style: scientificStyle),
			make(action: .unary(.asin), title: "sin⁻¹", style: scientificStyle),
			make(action: .unary(.acos), title: "cos⁻¹", style: scientificStyle),
			make(action: .unary(.atan), title: "tan⁻¹", style: scientificStyle),
			make(action: .unary(.asinh), title: "sinh⁻¹", style: scientificStyle),
			make(action: .unary(.acosh), title: "cosh⁻¹", style: scientificStyle),
			make(action: .unary(.atanh), title: "tanh⁻¹", style: scientificStyle),
			
			make(action: .bracket(.opening), title: "(", style: scientificStyle),
			make(action: .bracket(.closing), title: ")", style: scientificStyle),
//			make(action: .clear, title: "mc", style: scientificStyle),
//			make(action: .clear, title: "m+", style: scientificStyle),
//			make(action: .clear, title: "m-", style: scientificStyle),
//			make(action: .clear, title: "mr", style: scientificStyle),
			
			make(action: .unary(.square), title: "x²", style: scientificStyle),
			make(action: .unary(.cube), title: "x³", style: scientificStyle),
			make(action: .binaryOperation(.power), title: "xʸ", style: scientificStyle),
			
			make(action: .unary(.inverse), title: "¹/x", style: scientificStyle),
			make(action: .unary(.sqrt), title: "²√x", style: scientificStyle),
			make(action: .unary(.cbrt), title: "³√x", style: scientificStyle),
			make(action: .binaryOperation(.root), title: "ʸ√x", style: scientificStyle),
			
			make(action: .unary(.factorial), title: "x!", style: scientificStyle),
			make(action: .constant(.e), title: "e", style: scientificStyle),
			make(action: .binaryOperation(.ee), title: "EE", style: scientificStyle),
			
//			make(action: .clear, title: "Rad", style: scientificStyle),
			make(action: .constant(.pi), title: "π", style: scientificStyle),
			make(action: .constant(.rand), title: "Rand", style: scientificStyle),
			
			make(action: .clear, title: "AC", style: actionStyle),
			make(action: .unary(.plusminus), title: "+/-", style: actionStyle),
			make(action: .unary(.present), title: "%", style: actionStyle),
			make(action: .binaryOperation(.divide), title: "÷", style: operatorStyle),
			
			make(action: .digit(.seven), title: "7", style: digitStyle),
			make(action: .digit(.eight), title: "8", style: digitStyle),
			make(action: .digit(.nine), title: "9", style: digitStyle),
			make(action: .binaryOperation(.multiply), title: "×", style: operatorStyle),
			
			make(action: .digit(.four), title: "4", style: digitStyle),
			make(action: .digit(.five), title: "5", style: digitStyle),
			make(action: .digit(.six), title: "6", style: digitStyle),
			make(action: .binaryOperation(.subtract), title: "−", style: operatorStyle),
			
			make(action: .digit(.one), title: "1", style: digitStyle),
			make(action: .digit(.two), title: "2", style: digitStyle),
			make(action: .digit(.three), title: "3", style: digitStyle),
			make(action: .binaryOperation(.add), title: "+", style: operatorStyle),
			
			make(action: .digit(.zero), title: "0", style: digitStyle, spacingFlag: true),
			make(action: .digit(.dot), title: ".", style: digitStyle),
			make(action: .calculate, title: "=", style: fakeOperatorStyle),
		]
	}
}
