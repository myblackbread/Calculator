//
//  MYCapsuleHighlightableContainerCell.swift
//  Calculator
//
//  Created by Garib Agaev on 23.02.2026.
//

import UIKit

final class MYCapsuleHighlightableContainerCell: MYHighlightableContainerCell {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let minSide = min(contentView.bounds.width, contentView.bounds.height)
		let cornerRadius = minSide / 2
		
		contentView.layer.cornerRadius = cornerRadius
		contentView.layer.masksToBounds = true
	}
}
