//
//  MYDecimalCharacter.swift
//  Calculator
//
//  Created by Garib Agaev on 19.02.2026.
//


import Foundation

enum MYDecimalCharacter: Character, Equatable {
	case dot = "."
	case zero = "0"
	case one = "1"
	case two = "2"
	case three = "3"
	case four = "4"
	case five = "5"
	case six = "6"
	case seven = "7"
	case eight = "8"
	case nine = "9"
	
	var digitValue: Int? {
		switch self {
		case .dot: nil
		case .zero: 0
		case .one: 1
		case .two: 2
		case .three: 3
		case .four: 4
		case .five: 5
		case .six: 6
		case .seven: 7
		case .eight: 8
		case .nine: 9
		}
	}
}
