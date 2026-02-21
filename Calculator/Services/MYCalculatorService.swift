//
//  CalculatorService.swift
//  Calculator
//
//  Created by Garib Agaev on 16.02.2026.
//


import Foundation

final class MYCalculatorService: MYCalculatorServiceProtocol {
	
	private let core = MYCalculatorEngine()
	
	typealias Output = MYCalculatorEngine.CalculationValue
	
	var outputStream: AsyncStream<Output?> { stream }
	private let (stream, continuation) = AsyncStream.makeStream(of: Output?.self)
	
	var activeState: Bool { core.active }
	var activeOperation: MYBinaryOperation? { core.activeOperation }
	
	init() {
		continuation.yield(core.currentOutput)
	}
	
	func handle(_ action: MYCalculatorAction) {
		switch action {
		case .digit(let decimalCharacter):
			core.appendDigit(decimalCharacter)
		case .binaryOperation(let op):
			core.pushBinaryOperation(op)
		case .unary(let unaryOp):
			core.pushUnaryOperation(unaryOp)
		case .constant(let const):
			core.pushMathConstant(const)
		case .calculate:
			core.performEquals()
		case .clear:
			core.clear()
		case .bracket(.opening):
			core.pushOpeningBracket()
		case .bracket(.closing):
			core.pushClosingBracket()
		default:
			return
		}
		continuation.yield(core.currentOutput)
	}
}

extension MYCalculatorEngine.CalculationValue: MYCalculatableValue {
	var asString: String? {
		guard case let .raw(string) = self else { return nil }
		return string
	}
	
	var asDouble: Double {
		switch self {
		case let .raw(string):
			Double(string) ?? .nan
		case let .numeric(value):
			value
		}
	}
}
