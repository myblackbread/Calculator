//
//  MYGridLayout.swift
//  Calculator
//
//  Created by Garib Agaev on 21.02.2026.
//

import Foundation
import CoreGraphics

final class MYGridLayout<T: Identifiable & Hashable> {
	
	enum Item {
		case id(T, w: Int = 1)
		case space(w: Int = 1)
		
		var width: Int {
			switch self {
			case .id(_, let w), .space(let w):
				return w
			}
		}
		
		var id: T? {
			switch self {
			case .id(let t, _):
				return t
			case .space:
				return nil
			}
		}
	}
	
	let items: [[Item]]
	var width: CGFloat
	var spacing: CGFloat
	
	init(items: [[Item]], width: CGFloat = 0, spacing: CGFloat = 0) {
		self.items = items
		self.width = width
		self.spacing = spacing
	}
	
	// MARK: - Derived metrics
	
	private lazy var columns = items
		.map {
			row in row.reduce(0) { $0 + $1.width }
		}
		.max() ?? 0
	
	private var rows: Int { items.count }
	
	private var totalHorizontalSpacing: CGFloat {
		CGFloat(max(columns - 1, 0)) * spacing
	}
	
	private var totalVerticalSpacing: CGFloat {
		CGFloat(max(rows - 1, 0)) * spacing
	}
	
	var unitWidth: CGFloat {
		guard columns > 0 else { return 0 }
		return (width - totalHorizontalSpacing) / CGFloat(columns)
	}
	
	var unitHeight: CGFloat {
		unitWidth
	}
	
	var totalHeight: CGFloat {
		guard rows > 0 else { return 0 }
		return CGFloat(rows) * unitHeight + totalVerticalSpacing
	}
	
	// MARK:
	
	private lazy var set: Set<T> = Set(items.flatMap { $0.compactMap { $0.id } })
	
	func contains(_ id: T) -> Bool {
		set.contains(id)
	}
	
	// MARK: - Layout
	
	func layout(fittingHeight: Double? = nil, completion: (T, CGRect) -> Void) {
		guard columns > 0, rows > 0 else { return }
		
		let calculatedUnitHeight = fittingHeight.map {
			($0 - totalVerticalSpacing) / CGFloat(rows)
		} ?? unitHeight
		
		let currentUnitWidth = unitWidth
		
		for (rowIndex, row) in items.enumerated() {
			var x: CGFloat = 0
			let y = CGFloat(rowIndex) * (calculatedUnitHeight + spacing)
			
			for item in row {
				let itemWidth = CGFloat(item.width) * (currentUnitWidth + spacing) - spacing
				
				
				item.id.map {
					let rect = CGRect(
						x: x,
						y: y,
						width: itemWidth,
						height: calculatedUnitHeight
					)
					completion($0, rect)
				}
				
				x += itemWidth + spacing
			}
		}
	}
}
