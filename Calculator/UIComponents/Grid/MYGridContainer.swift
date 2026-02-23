//
//  MYGridContainer.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import Foundation

struct MYGridContainer<T: Identifiable & Hashable> {
	
	typealias GridLayout = MYGridLayout<T>
	
	lazy var vertical = verticalClosure()
	lazy var horizontal = horizontalClosure()
	lazy var horizontalSecond = horizontalSecondClosure()
	
	private let verticalClosure: () -> GridLayout
	private let horizontalClosure: () -> GridLayout
	private let horizontalSecondClosure: () -> GridLayout
	
	init(vertical: @escaping @autoclosure () -> GridLayout,
		 horizontal: @escaping @autoclosure () -> GridLayout,
		 horizontalSecond: @escaping @autoclosure () -> GridLayout) {
		self.verticalClosure = vertical
		self.horizontalClosure = horizontal
		self.horizontalSecondClosure = horizontalSecond
	}
}
