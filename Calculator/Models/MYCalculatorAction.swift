//
//  MYCalculatorAction.swift
//  Calculator
//
//  Created by Garib Agaev on 19.02.2026.
//


import Foundation

enum MYCalculatorAction: Equatable {
	case digit(MYDecimalCharacter)
	case binaryOperation(MYBinaryOperation)
	case unary(MYUnaryOperation)
	case constant(MYMathConstant)
	case bracket(MYBracket)
	case calculate
	case clear
	case shift
}
