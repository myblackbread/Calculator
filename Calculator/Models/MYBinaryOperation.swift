//
//  MYBinaryOperation.swift
//  Calculator
//
//  Created by Garib Agaev on 20.02.2026.
//

import Foundation

enum MYBinaryOperation {
	case add, subtract, multiply, divide
	
	case power
	case powerReverse
	case root
	case logBase
	case ee
	
	var priority: Int {
		switch self {
		case .power, .powerReverse, .root, .logBase, .ee: 3
		case .multiply, .divide: 2
		case .add, .subtract: 1
		}
	}
}
