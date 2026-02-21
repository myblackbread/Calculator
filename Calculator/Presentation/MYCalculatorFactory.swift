//
//  MYCalculatorFactory.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//


import UIKit

struct MYCalculatorFactory {
	
	func makeGrid(
		target: MYCalculatorButtonDelegate?
	) -> MYGridContainer {
		func make(
			action: MYCalculatorAction,
			title: String,
			style: MYCalculatorButtonStyle,
			width: Int = 1
		) -> GridLayout.Item {
			
			let model = MYCalculatorButtonModel(
				title: title,
				action: action,
				style: style
			)
			
			let button = MYCalculatorButton(model: model)
			
			button.delegate = target
			
			return .view(button, w: width)
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
		let eToX = make(action: .unary(.powerOfE), title: "eˣ", style: scientificStyle)
		let tenToX = make(action: .unary(.powerOfTen), title: "10ˣ", style: scientificStyle)
		let lnBtn = make(action: .unary(.ln), title: "ln", style: scientificStyle)
		let log10Btn = make(action: .unary(.log10), title: "log₁₀", style: scientificStyle)
		let sinBtn = make(action: .unary(.sin), title: "sin", style: scientificStyle)
		let cosBtn = make(action: .unary(.cos), title: "cos", style: scientificStyle)
		let tanBtn = make(action: .unary(.tan), title: "tan", style: scientificStyle)
		let sinhBtn = make(action: .unary(.sinh), title: "sinh", style: scientificStyle)
		let coshBtn = make(action: .unary(.cosh), title: "cosh", style: scientificStyle)
		let tanhBtn = make(action: .unary(.tanh), title: "tanh", style: scientificStyle)
		
		// MARK: - 2nd Page Scientific Buttons
		let secondBtnActive = make(action: .shift, title: "2ⁿᵈ", style: scientificActiveStyle)
		let yToX = make(action: .binaryOperation(.powerReverse), title: "yˣ", style: scientificStyle)
		let twoToX = make(action: .unary(.powerOfTwo), title: "2ˣ", style: scientificStyle)
		let logY = make(action: .binaryOperation(.logBase), title: "logᵧ", style: scientificStyle)
		let log2 = make(action: .unary(.log2), title: "log₂", style: scientificStyle)
		let sinInv = make(action: .unary(.asin), title: "sin⁻¹", style: scientificStyle)
		let cosInv = make(action: .unary(.acos), title: "cos⁻¹", style: scientificStyle)
		let tanInv = make(action: .unary(.atan), title: "tan⁻¹", style: scientificStyle)
		let sinhInv = make(action: .unary(.asinh), title: "sinh⁻¹", style: scientificStyle)
		let coshInv = make(action: .unary(.acosh), title: "cosh⁻¹", style: scientificStyle)
		let tanhInv = make(action: .unary(.atanh), title: "tanh⁻¹", style: scientificStyle)
		
		let openBracket = make(action: .bracket(.opening), title: "(", style: scientificStyle)
		let closeBracket = make(action: .bracket(.closing), title: ")", style: scientificStyle)
		let mc = GridLayout.Item.space(w: 1) // make(action: .clear, title: "mc", style: scientificStyle)
		let mPlus = GridLayout.Item.space(w: 1) // make(action: .clear, title: "m+", style: scientificStyle)
		let mMinus = GridLayout.Item.space(w: 1) // make(action: .clear, title: "m-", style: scientificStyle)
		let mr = GridLayout.Item.space(w: 1) // make(action: .clear, title: "mr", style: scientificStyle)
		
		let xSquared = make(action: .unary(.square), title: "x²", style: scientificStyle)
		let xCubed = make(action: .unary(.cube), title: "x³", style: scientificStyle)
		let xToY = make(action: .binaryOperation(.power), title: "xʸ", style: scientificStyle)
		
		let oneOverX = make(action: .unary(.inverse), title: "¹/x", style: scientificStyle)
		let sqrtX = make(action: .unary(.sqrt), title: "²√x", style: scientificStyle)
		let cubeRootX = make(action: .unary(.cbrt), title: "³√x", style: scientificStyle)
		let yRootX = make(action: .binaryOperation(.root), title: "ʸ√x", style: scientificStyle)
		
		let factorial = make(action: .unary(.factorial), title: "x!", style: scientificStyle)
		let eBtn = make(action: .constant(.e), title: "e", style: scientificStyle)
		let eeBtn = make(action: .binaryOperation(.ee), title: "EE", style: scientificStyle)
		
		let radBtn = GridLayout.Item.space(w: 1) // make(action: .clear, title: "Rad", style: scientificStyle)
		let piBtn = make(action: .constant(.pi), title: "π", style: scientificStyle)
		let randBtn = make(action: .constant(.rand), title: "Rand", style: scientificStyle)
		
		let acButton = make(action: .clear, title: "AC", style: actionStyle)
		let toggleSignButton = make(action: .unary(.plusminus), title: "+/-", style: actionStyle)
		let percentButton = make(action: .unary(.present), title: "%", style: actionStyle)
		let divideButton = make(action: .binaryOperation(.divide), title: "÷", style: operatorStyle)
		
		let sevenButton = make(action: .digit(.seven), title: "7", style: digitStyle)
		let eightButton = make(action: .digit(.eight), title: "8", style: digitStyle)
		let nineButton = make(action: .digit(.nine), title: "9", style: digitStyle)
		let multiplyButton = make(action: .binaryOperation(.multiply), title: "×", style: operatorStyle)
		
		let fourButton = make(action: .digit(.four), title: "4", style: digitStyle)
		let fiveButton = make(action: .digit(.five), title: "5", style: digitStyle)
		let sixButton = make(action: .digit(.six), title: "6", style: digitStyle)
		let subtractButton = make(action: .binaryOperation(.subtract), title: "−", style: operatorStyle)
		
		let oneButton = make(action: .digit(.one), title: "1", style: digitStyle)
		let twoButton = make(action: .digit(.two), title: "2", style: digitStyle)
		let threeButton = make(action: .digit(.three), title: "3", style: digitStyle)
		let addButton = make(action: .binaryOperation(.add), title: "+", style: operatorStyle)
		
		let zeroButton = make(action: .digit(.zero), title: "0", style: digitStyle, width: 2)
		let decimalButton = make(action: .digit(.dot), title: ".", style: digitStyle)
		let equalsButton = make(action: .calculate, title: "=", style: fakeOperatorStyle)

		return MYGridContainer(
			vertical: GridLayout(items: [
				[acButton, toggleSignButton, percentButton, divideButton],
				[sevenButton, eightButton, nineButton, multiplyButton],
				[fourButton, fiveButton, sixButton, subtractButton],
				[oneButton, twoButton, threeButton, addButton],
				[zeroButton, decimalButton, equalsButton]
			]),
			horizontal: GridLayout(items: [
				[openBracket, closeBracket, mc, mPlus, mMinus, mr, acButton, toggleSignButton, percentButton, divideButton],
				[secondBtnActive, xSquared, xCubed, xToY, eToX, tenToX, sevenButton, eightButton, nineButton, multiplyButton],
				[oneOverX, sqrtX, cubeRootX, yRootX, lnBtn, log10Btn, fourButton, fiveButton, sixButton, subtractButton],
				[factorial, sinBtn, cosBtn, tanBtn, eBtn, eeBtn, oneButton, twoButton, threeButton, addButton],
				[radBtn, sinhBtn, coshBtn, tanhBtn, piBtn, randBtn, zeroButton, decimalButton, equalsButton]
			]),
			horizontalSecond: GridLayout(items: [
				[openBracket, closeBracket, mc, mPlus, mMinus, mr, acButton, toggleSignButton, percentButton, divideButton],
				[secondBtnActive, xSquared, xCubed, xToY, yToX, twoToX, sevenButton, eightButton, nineButton, multiplyButton],
				[oneOverX, sqrtX, cubeRootX, yRootX, logY, log2, fourButton, fiveButton, sixButton, subtractButton],
				[factorial, sinInv, cosInv, tanInv, eBtn, eeBtn, oneButton, twoButton, threeButton, addButton],
				[radBtn, sinhInv, coshInv, tanhInv, piBtn, randBtn, zeroButton, decimalButton, equalsButton]
			])
		)
	}
}
