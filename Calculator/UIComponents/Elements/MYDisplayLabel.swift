//
//  MYDisplayLabel.swift
//  Calculator
//
//  Created by Garib Agaev on 21.02.2026.
//


import UIKit

final class MYDisplayLabel<T: MYCalculatableValue>: UILabel {
	
	private var lastValue: T?
	
	private let formatter: NumberFormatter = {
		let f = NumberFormatter()
		f.numberStyle = .decimal
		f.groupingSeparator = ""
		f.usesSignificantDigits = true
		f.maximumSignificantDigits = 9
		return f
	}()
	
	var orientation: MYOrientation = .vertical {
		didSet {
			guard oldValue != orientation else { return }
			formatter.maximumSignificantDigits = (orientation == .vertical) ? 9 : 16
			self.text = self.format(lastValue)
		}
	}
	
	func subscribe(to stream: AsyncStream<T?>) {
		Task { @MainActor [weak self] in
			for await output in stream {
				self?.lastValue = output // Запоминаем
				self?.text = self?.format(output)
			}
		}
	}
	
	private func format(_ output: T?) -> String {
		guard let output else { return "0" }
		let limit = (orientation == .vertical) ? 9 : 16
				
		if let string = output.asString {
			let digitCount = string.filter { $0.isNumber }.count
			if digitCount <= limit {
				return string
			}
		}
		
		let value = output.asDouble
		
		let threshold = pow(10.0, Double(limit))
		
		if abs(value) >= threshold {
			formatter.numberStyle = .scientific
			formatter.exponentSymbol = "e"
		} else {
			formatter.numberStyle = .decimal
		}
		
		return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
	}
}
