//
//  MYInscribedSquareView.swift
//  Calculator
//
//  Created by Garib Agaev on 20.02.2026.
//


import UIKit

class MYInscribedSquareView: UIView {
	let subview: UIView
	
	init(subview: UIView) {
		self.subview = subview
		super.init(frame: .zero)
		
		addSubview(subview)

		subview.transform = CGAffineTransform(scaleX: sqrt(0.5), y: sqrt(0.5))
	}

	required init?(coder: NSCoder) { fatalError() }
}