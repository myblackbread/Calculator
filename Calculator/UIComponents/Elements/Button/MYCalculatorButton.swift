//
//  MYCalculatorButton.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//

import UIKit

final class MYCalculatorButton: MYInscribedSquareView {
	
	// MARK: - Properties
	
	let model: MYCalculatorButtonModel

	weak var delegate: MYCalculatorButtonDelegate?
		
	// MARK: - UI Components
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.isUserInteractionEnabled = false
		return label
	}()
	
	// MARK: - Init
	init(model: MYCalculatorButtonModel, anchor: MYInscribedSquareView.AnchorSide = .center) {
		self.model = model
		super.init(subview: titleLabel, anchor: anchor)
		
		setupView()
		updateVisualState()
	}
	
	required init?(coder: NSCoder) { fatalError() }
		
	// MARK: - Private Methods
	
	private func setupView() {
		titleLabel.text = model.title
		titleLabel.font = model.style.font
	}
	
	private func updateVisualState() {
		switch model.visualState {
		case .normal:
			backgroundColor = model.style.normalBackgroundColor
			titleLabel.textColor = model.style.normalTitleColor
		case .selected:
			backgroundColor = model.style.selectedBackgroundColor
			titleLabel.textColor = model.style.selectedTitleColor
		}
	}
}
