//
//  MYCalculatableValue.swift
//  Calculator
//
//  Created by Garib Agaev on 21.02.2026.
//


import Foundation

protocol MYCalculatableValue {
	var asString: String? { get }
	var asDouble: Double { get }
}
