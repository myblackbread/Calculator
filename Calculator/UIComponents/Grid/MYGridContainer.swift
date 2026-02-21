//
//  MYGridContainer.swift
//  Calculator
//
//  Created by Garib Agaev on 20.02.2026.
//


import Foundation

struct MYGridContainer {	
	lazy var vertical: GridLayout = verticalClosure()
	lazy var horizontal: GridLayout = horizontalClosure()
	lazy var horizontalSecond: GridLayout = horizontalSecondClosure()
	
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
