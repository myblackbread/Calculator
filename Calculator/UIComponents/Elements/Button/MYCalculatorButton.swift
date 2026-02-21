//
//  MYCalculatorButton.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//


import UIKit

extension MYCalculatorButton: MYTouchSurfaceActionable {
	func touchSurfaceDidTrigger() {
		delegate?.calculatorButtonDidTap(self)
	}
}

final class MYCalculatorButton: MYInscribedSquareView {
	
	// MARK: - Properties
	
	let model: MYCalculatorButtonModel
	weak var delegate: MYCalculatorButtonDelegate?
	
	var visualState: MYCalculatorButtonVisualState = .normal {
		didSet { updateVisualState() }
	}
	
	var title: String? {
		get { titleLabel.text }
		set { titleLabel.text = newValue ?? model.title }
	}
	
	// MARK: - UI Components
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.isUserInteractionEnabled = false
		return label
	}()
	
	// MARK: - Init
	
	init(model: MYCalculatorButtonModel) {
		self.model = model
		super.init(subview: titleLabel)
		
		setupView()
		updateVisualState()
	}
	
	required init?(coder: NSCoder) { fatalError() }
		
	// MARK: - Lifecycle
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		layer.cornerRadius = bounds.height / 2
		layer.masksToBounds = true
	}
	
	// MARK: - Private Methods
	
	private func setupView() {
		titleLabel.text = model.title
		titleLabel.font = model.style.font
	}
	
	private func updateVisualState() {
		switch visualState {
		case .normal:
			backgroundColor = model.style.normalBackgroundColor
			titleLabel.textColor = model.style.normalTitleColor
		case .selected:
			backgroundColor = model.style.selectedBackgroundColor
			titleLabel.textColor = model.style.selectedTitleColor
		}
	}
}
