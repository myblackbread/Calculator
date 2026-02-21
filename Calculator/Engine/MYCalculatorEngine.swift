//
//  MYCalculatorEngine.swift
//  Calculator
//
//  Created by Garib Agaev on 16.02.2026.
//

import Foundation

final class MYCalculatorEngine {
	
	enum CalculationValue: Equatable {
		case raw(String)
		case numeric(Double)
	}
	
	// MARK: - Private Types
	
	private enum ExpressionToken {
		case operand(CalculationValue)
		case implicitOperand(CalculationValue)
		case binary(MYBinaryOperation)
		case unary(MYUnaryOperation)
		case openingBracket
		case closingBracket
	}
	
	private struct RepeatState { //?
		let operation: MYBinaryOperation
		var operand: CalculationValue?
	}
	
	// MARK: - State
	private(set) var active = false //?
	
	var activeOperation: MYBinaryOperation? {
		activeBinaryOperationIndex.flatMap {
			guard case let .binary(op) = tokens[$0] else { return nil }
			return op
		}
	}
	
	private var tokens: [ExpressionToken] = []
	private var leftParenCount = 0 //?
	private var repeatState: RepeatState? //?
	
	// MARK: - Public Output
	
	var currentOutput: CalculationValue {
		switch tokens.last {
		case .none:
			return .raw("0")
		case let .operand(value), let .implicitOperand(value):
			return value
		default:
			return evaluateExpression().display
		}
	}
	
	// MARK: - Input Actions
	
	func appendDigit(_ character: MYDecimalCharacter) { //?
		active = true
		guard let digitString = character.digitValue.map({ "\($0)" }) else {
			appendDecimalPoint()
			return
		}
		
		switch tokens.last {
		case let .operand(value):
			guard case let .raw(str) = value else { return }
			
			tokens.removeLast()
			let newDigitString: String
			
			switch str {
			case "0":
				newDigitString = digitString
			case "-0":
				newDigitString = "-\(digitString)"
			default:
				newDigitString = str + digitString
			}
			tokens.append(.operand(.raw(newDigitString)))
		default:
			tokens.append(.operand(.raw(digitString)))
		}
	}
	
	private func appendDecimalPoint() {
		switch tokens.last {
		case .operand(let value):
			guard case let .raw(str) = value else { break }
			guard !str.contains(".") else { break }
			
			tokens.removeLast()
			tokens.append(.operand(.raw(str + ".")))
		default:
			tokens.append(.operand(.raw("0.")))
		}
	}
	
	func toggleSign() {
		// Это просто костыль, чтобы соотвествовать работе оригинального калькулятора
		if let index = activeBinaryOperationIndex, index > 0 {
			switch tokens[index - 1] {
			case .operand:
				tokens.append(.operand(.raw("-0")))
			default:
				tokens.append(.implicitOperand(.raw("-0")))
			}
			return
		}
		switch tokens.last {
		case .none:
			tokens.append(.operand(.raw("-0")))
		case let .operand(value):
			tokens.removeLast()
			tokens.append(.operand(value.negated))
		case let .implicitOperand(value):
			tokens.removeLast()
			tokens.append(.implicitOperand(value.negated))
		case .unary:
			tokens.append(.unary(.plusminus))
		case .openingBracket, .closingBracket:
			tokens.append(.implicitOperand(.raw("-0")))
		case .binary: break
		}
	}
	
	// MARK: - Operations
	
	func pushOpeningBracket() {
		leftParenCount += 1
		tokens.append(.openingBracket)
	}
	
	func pushClosingBracket() {
		guard leftParenCount > 0 else { return }
		leftParenCount -= 1
		switch tokens.last {
		case .none:
			break
		case .openingBracket:
			tokens.removeLast()
		default:
			tokens.append(.closingBracket)
		}
	}
	
	func pushMathConstant(_ const: MYMathConstant) {
		active = true
		tokens.append(.operand(.get(constant: const)))
	}
	
	func pushBinaryOperation(_ op: MYBinaryOperation) {
		repeatState = RepeatState(operation: op)
		
		if let index = activeBinaryOperationIndex {
			tokens[index..<tokens.endIndex].forEach {
				switch $0 {
				case .openingBracket: leftParenCount -= 1
				case .closingBracket: leftParenCount += 1
				default: break
				}
			}
			tokens = Array(tokens[0..<index])
		}
		tokens.append(.binary(op))
	}
	
	func pushUnaryOperation(_ op: MYUnaryOperation) {
		switch op {
		case .plusminus:
			toggleSign()
		default:
			tokens.append(.unary(op))
		}
	}
	
	// MARK: - Lifecycle
	
	func performEquals() {
		let (displayValue, total) = evaluateExpression()
		
		let finalResult: CalculationValue
		
		if let state = repeatState, let rhs = state.operand {
			finalResult = total.perform(state.operation, with: rhs)
		} else {
			repeatState?.operand = displayValue
			finalResult = total
		}
		
		tokens.removeAll()
		tokens.append(.implicitOperand(finalResult))
	}
	
	func clear() {
		if active {
			tokens.lastIndex {
				switch $0 {
				case .binary: true
				default : false
				}
			}.map {
				tokens[$0..<tokens.endIndex].forEach {
					switch $0 {
					case .openingBracket: leftParenCount -= 1
					case .closingBracket: leftParenCount += 1
					default: break
					}
				}
				tokens = Array(tokens[0...$0])
				
			}
			active = false
		} else {
			repeatState = nil
			tokens.removeAll()
		}
		tokens.append(.implicitOperand(.raw("0")))
	}
	
	var activeBinaryOperationIndex: Int? {
		guard let index = tokens.lastIndex(where: {
			switch $0 {
			case .operand: true
			case .binary: true
			default: false
			}
		}), case .binary = tokens[index] else {
			return nil
		}
		
		return index
	}
	
	func evaluateExpression() -> (display: CalculationValue, total: CalculationValue) {
		var scopes: [(values: [CalculationValue], ops: [MYBinaryOperation])] = [([], [])]
		var activeScopeIndex: Int { scopes.count - 1 }
		var current: CalculationValue? = .raw("0")
		
		for item in tokens {
			switch item {
			case .openingBracket:
				current = (current ?? scopes[activeScopeIndex].values.last ?? .raw("0"))
				scopes.append(([], []))
			case .closingBracket:
				let cur = (current ?? scopes[activeScopeIndex].values.last ?? .raw("0"))
				scopes[activeScopeIndex].values.append(cur)
				
				while let op = scopes[activeScopeIndex].ops.popLast() {
					let rhs = scopes[activeScopeIndex].values.removeLast()
					let lhs = scopes[activeScopeIndex].values.removeLast()
					scopes[activeScopeIndex].values.append(lhs.perform(op, with: rhs))
				}
				
				current = scopes[activeScopeIndex].values.last ?? cur
				scopes.removeLast()
				if scopes.isEmpty { scopes = [([], [])] }
			case .operand(let num), .implicitOperand(let num):
				current = num
			case .unary(let op):
				current = (current ?? scopes[activeScopeIndex].values.last ?? .raw("0")).perform(op)
			case .binary(let op):
				current.map {
					scopes[activeScopeIndex].values.append($0)
					current = nil
				}
				
				while let lastOp = scopes[activeScopeIndex].ops.last,
					  lastOp.priority >= op.priority,
					  scopes[activeScopeIndex].values.count >= 2
				{
					defer { scopes[activeScopeIndex].ops.removeLast() }
					let rhs = scopes[activeScopeIndex].values.removeLast()
					let lhs = scopes[activeScopeIndex].values.removeLast()
					scopes[activeScopeIndex].values.append(lhs.perform(lastOp, with: rhs))
				}
				
				scopes[activeScopeIndex].ops.append(op)
			}
		}
		
		let displayValue = current ?? scopes[activeScopeIndex].values.last ?? .raw("0")
		scopes[activeScopeIndex].values.append(displayValue)
		
		while let op = scopes[activeScopeIndex].ops.popLast() {
			let rhs = scopes[activeScopeIndex].values.removeLast()
			let lhs = scopes[activeScopeIndex].values.removeLast()
			scopes[activeScopeIndex].values.append(lhs.perform(op, with: rhs))
		}
		
		return (displayValue, scopes[activeScopeIndex].values.last ?? displayValue)
	}
}

private extension MYCalculatorEngine.CalculationValue {
	
	static func get(constant: MYMathConstant) -> Self {
		switch constant {
		case .pi: .numeric(Double.pi)
		case .e: .numeric(M_E)
		case .rand: .numeric(Double.random(in: 0...1))
		}
	}
	
	// MARK: - Computed Properties
	
	var doubleValue: Double {
		switch self {
		case .raw(let str): return Double(str) ?? 0
		case .numeric(let val): return val
		}
	}
	
	var negated: Self {
		switch self {
		case .raw(let str):
			if str.hasPrefix("-") {
				return .raw(String(str.dropFirst()))
			} else {
				return .raw("-" + str)
			}
		case .numeric(let val):
			return .numeric(-val)
		}
	}
	
	// MARK: - Math Logic
	
	func perform(_ op: MYBinaryOperation, with rhs: Self) -> Self {
		let l = doubleValue
		let r = rhs.doubleValue
		let result: Double
		
		switch op {
		case .add: result = l + r
		case .subtract: result = l - r
		case .multiply: result = l * r
		case .divide: result = l / r
			
		case .power: result = pow(l, r)
		case .powerReverse: result = pow(r, l)
		case .root: result = pow(l, 1/r)
		case .logBase:
			result = (r > 0 && r != 1 && l > 0) ? log(l) / log(r) : .nan
		case .ee:
			result = l * pow(10, r)
		}
		
		return .numeric(result)
	}
	
	func perform(_ op: MYUnaryOperation) -> Self {
		let v = self.doubleValue
		let result: Double
		
		switch op {
		case .present: result = v / 100
		case .plusminus: return self.negated
			
			// Степени
		case .square: result = pow(v, 2)
		case .cube: result = pow(v, 3)
		case .powerOfTwo: result = pow(2, v)
		case .powerOfTen: result = pow(10, v)
		case .powerOfE: result = exp(v)
		case .inverse: result = 1 / v
			
			// Корни
		case .sqrt: result = sqrt(v)
		case .cbrt: result = cbrt(v)
		case .factorial: result = tgamma(v + 1)
			
			// Логарифмы
		case .ln: result = log(v)
		case .log10: result = log10(v)
		case .log2: result = log2(v)
			
			// Тригонометрия
		case .sin: result = sin(v)
		case .cos: result = cos(v)
		case .tan: result = tan(v)
		case .sinh: result = sinh(v)
		case .cosh: result = cosh(v)
		case .tanh: result = tanh(v)
			
			// Обратная тригонометрия
		case .asin: result = asin(v)
		case .acos: result = acos(v)
		case .atan: result = atan(v)
		case .asinh: result = asinh(v)
		case .acosh: result = acosh(v)
		case .atanh: result = atanh(v)
		}
		
		return .numeric(result)
	}
}
