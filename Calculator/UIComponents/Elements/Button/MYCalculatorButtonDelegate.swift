//
//  MYCalculatorButtonDelegate.swift
//  Calculator
//
//  Created by Garib Agaev on 19.02.2026.
//


import Foundation

protocol MYCalculatorButtonDelegate: AnyObject {
	func calculatorButtonDidTap(_ button: MYCalculatorButton)
}