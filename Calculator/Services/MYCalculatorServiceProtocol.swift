//
//  MYCalculatorServiceProtocol.swift
//  Calculator
//
//  Created by Garib Agaev on 19.02.2026.
//


import Foundation

protocol MYCalculatorServiceProtocol: AnyObject {
	associatedtype Output: MYCalculatableValue
	var outputStream: AsyncStream<Output?> { get }
	var activeState: Bool { get }
	var activeOperation: MYBinaryOperation? { get }
	func handle(_ action: MYCalculatorAction)
}
