//
//  MYCalculatorGridFactory.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import UIKit

struct MYCalculatorGridFactory {
	
	func makeGrid() -> MYGridContainer<MYCalculatorAction> {
		func make(
			_ action: MYCalculatorAction,
			width: Int = 1
		) -> MYGridLayout<MYCalculatorAction>.Item {
			
			return .id(action, w: width)
		}
		
		// MARK: - 1st Page Scientific Buttons
		let eToX = make(.unary(.powerOfE))
		let tenToX = make(.unary(.powerOfTen))
		let lnBtn = make(.unary(.ln))
		let log10Btn = make(.unary(.log10))
		let sinBtn = make(.unary(.sin))
		let cosBtn = make(.unary(.cos))
		let tanBtn = make(.unary(.tan))
		let sinhBtn = make(.unary(.sinh))
		let coshBtn = make(.unary(.cosh))
		let tanhBtn = make(.unary(.tanh))
		
		// MARK: - 2nd Page Scientific Buttons
		let secondBtnActive = make(.shift)
		let yToX = make(.binaryOperation(.powerReverse))
		let twoToX = make(.unary(.powerOfTwo))
		let logY = make(.binaryOperation(.logBase))
		let log2 = make(.unary(.log2))
		let sinInv = make(.unary(.asin))
		let cosInv = make(.unary(.acos))
		let tanInv = make(.unary(.atan))
		let sinhInv = make(.unary(.asinh))
		let coshInv = make(.unary(.acosh))
		let tanhInv = make(.unary(.atanh))
		
		let openBracket = make(.bracket(.opening))
		let closeBracket = make(.bracket(.closing))
		let mc = MYGridLayout<MYCalculatorAction>.Item.space(w: 1) // make(.clear)
		let mPlus = MYGridLayout<MYCalculatorAction>.Item.space(w: 1) // make(.clear)
		let mMinus = MYGridLayout<MYCalculatorAction>.Item.space(w: 1) // make(.clear)
		let mr = MYGridLayout<MYCalculatorAction>.Item.space(w: 1) // make(.clear)
		
		let xSquared = make(.unary(.square))
		let xCubed = make(.unary(.cube))
		let xToY = make(.binaryOperation(.power))
		
		let oneOverX = make(.unary(.inverse))
		let sqrtX = make(.unary(.sqrt))
		let cubeRootX = make(.unary(.cbrt))
		let yRootX = make(.binaryOperation(.root))
		
		let factorial = make(.unary(.factorial))
		let eBtn = make(.constant(.e))
		let eeBtn = make(.binaryOperation(.ee))
		
		let radBtn = MYGridLayout<MYCalculatorAction>.Item.space(w: 1) // make(.clear)
		let piBtn = make(.constant(.pi))
		let randBtn = make(.constant(.rand))
		
		let acButton = make(.clear)
		let toggleSignButton = make(.unary(.plusminus))
		let percentButton = make(.unary(.present))
		let divideButton = make(.binaryOperation(.divide))
		
		let sevenButton = make(.digit(.seven))
		let eightButton = make(.digit(.eight))
		let nineButton = make(.digit(.nine))
		let multiplyButton = make(.binaryOperation(.multiply))
		
		let fourButton = make(.digit(.four))
		let fiveButton = make(.digit(.five))
		let sixButton = make(.digit(.six))
		let subtractButton = make(.binaryOperation(.subtract))
		
		let oneButton = make(.digit(.one))
		let twoButton = make(.digit(.two))
		let threeButton = make(.digit(.three))
		let addButton = make(.binaryOperation(.add))
		
		let zeroButton = make(.digit(.zero), width: 2)
		let decimalButton = make(.digit(.dot))
		let equalsButton = make(.calculate)

		return MYGridContainer(
			vertical: .init(items: [
				[acButton, toggleSignButton, percentButton, divideButton],
				[sevenButton, eightButton, nineButton, multiplyButton],
				[fourButton, fiveButton, sixButton, subtractButton],
				[oneButton, twoButton, threeButton, addButton],
				[zeroButton, decimalButton, equalsButton]
			]),
			horizontal: .init(items: [
				[openBracket, closeBracket, mc, mPlus, mMinus, mr, acButton, toggleSignButton, percentButton, divideButton],
				[secondBtnActive, xSquared, xCubed, xToY, eToX, tenToX, sevenButton, eightButton, nineButton, multiplyButton],
				[oneOverX, sqrtX, cubeRootX, yRootX, lnBtn, log10Btn, fourButton, fiveButton, sixButton, subtractButton],
				[factorial, sinBtn, cosBtn, tanBtn, eBtn, eeBtn, oneButton, twoButton, threeButton, addButton],
				[radBtn, sinhBtn, coshBtn, tanhBtn, piBtn, randBtn, zeroButton, decimalButton, equalsButton]
			]),
			horizontalSecond: .init(items: [
				[openBracket, closeBracket, mc, mPlus, mMinus, mr, acButton, toggleSignButton, percentButton, divideButton],
				[secondBtnActive, xSquared, xCubed, xToY, yToX, twoToX, sevenButton, eightButton, nineButton, multiplyButton],
				[oneOverX, sqrtX, cubeRootX, yRootX, logY, log2, fourButton, fiveButton, sixButton, subtractButton],
				[factorial, sinInv, cosInv, tanInv, eBtn, eeBtn, oneButton, twoButton, threeButton, addButton],
				[radBtn, sinhInv, coshInv, tanhInv, piBtn, randBtn, zeroButton, decimalButton, equalsButton]
			])
		)
	}
}
