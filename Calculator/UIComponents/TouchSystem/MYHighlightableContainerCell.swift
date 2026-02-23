//
//  MYHighlightableContainerCell.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import UIKit

class MYHighlightableContainerCell: MYInteractiveViewCell {
	private let dimmingView = UIView()
	
	private var hostedView: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			if let newValue = hostedView {
				contentView.insertSubview(newValue, belowSubview: dimmingView)
				newValue.frame = contentView.bounds
				newValue.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			}
		}
	}
	
	func setHostedView(_ view: UIView) {
		self.hostedView = view
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	private func setupViews() {
		dimmingView.backgroundColor = .white.withAlphaComponent(0.5)
		dimmingView.alpha = 0
		dimmingView.isUserInteractionEnabled = false
		
		contentView.addSubview(dimmingView)
	}
		
	override func layoutSubviews() {
		super.layoutSubviews()
		dimmingView.frame = contentView.bounds

		contentView.bringSubviewToFront(dimmingView)
	}
	
	override func didUpdateTouchState(isActive: Bool) {
		let targetAlpha: CGFloat = isActive ? 1.0 : 0.0
		
		UIView.animate(withDuration: 0.44) { [weak self] in
			self?.dimmingView.alpha = targetAlpha
		}
	}
}
