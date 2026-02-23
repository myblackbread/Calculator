//
//  MYInscribedSquareView.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//

import UIKit

class MYInscribedSquareView: UIView {
	
	enum AnchorSide {
		case leading(spacing: CGFloat)
		case trailing(spacing: CGFloat)
		case center
	}
	
	let subview: UIView
	
	var spacing: CGFloat? {
		didSet { setNeedsLayout() }
	}
	
	var anchorSide: AnchorSide {
		didSet { setNeedsLayout() }
	}
	
	init(subview: UIView, anchor: AnchorSide = .center) {
		self.subview = subview
		self.anchorSide = anchor
		super.init(frame: .zero)
		addSubview(subview)
		
		subview.transform = CGAffineTransform(scaleX: sqrt(0.5), y: sqrt(0.5))
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let w = bounds.width
		let h = bounds.height
		let minSide = min(w, h)
		let isHorizontal = w > h
		
		let pathForPoint = isHorizontal ? \CGPoint.x : \CGPoint.y
		let pathForSize = isHorizontal ? \CGSize.width : \CGSize.height
		
		var longDimensionSize = isHorizontal ? w : h
		
		switch anchorSide {
		case .leading(let s), .trailing(let s):
			longDimensionSize = (longDimensionSize - s) / 2
		case .center:
			break
		}
		
		subview.bounds.size = {
			var size = CGSize(width: minSide, height: minSide)
			size[keyPath: pathForSize] = longDimensionSize
			return size
		}()
		
		var center = CGPoint(x: w / 2, y: h / 2)
		
		switch anchorSide {
		case .leading:
			center[keyPath: pathForPoint] = longDimensionSize / 2
			
		case .trailing:
			let parentMaxSide = isHorizontal ? w : h
			center[keyPath: pathForPoint] = parentMaxSide - (longDimensionSize / 2)
			
		case .center:
			break
		}
		
		subview.center = center
	}
}
