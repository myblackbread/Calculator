//
//  MYTouchSurface.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//

import UIKit

class MYTouchSurface: UIView {
	private var containers: [ItemContainer] = []
	private var touchTrackingMap: [UITouch: ItemContainer] = [:]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isMultipleTouchEnabled = true
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	func addTile(_ view: UIView) {
		let container = ItemContainer(contentView: view)
		addSubview(container)
		containers.append(container)
	}
	
	// MARK: - Touch Handling Lifecycle
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		touches.forEach { handleTouchUpdate($0) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		touches.forEach { handleTouchUpdate($0) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		touches.forEach { stopTracking($0) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		touches.forEach { stopTracking($0) }
	}
	
	// MARK: - Private Logic
	
	private func handleTouchUpdate(_ touch: UITouch) {
		let location = touch.location(in: self)
		
		let foundContainer = foundItemContainer(location)
		let previousContainer = touchTrackingMap[touch]
		
		if foundContainer !== previousContainer {
			previousContainer?.registerTouchExit()
			touchTrackingMap[touch] = foundContainer
			
			if let foundContainer {
				foundContainer.registerTouchEntry()
				
				let impact = UIImpactFeedbackGenerator(style: .light)
				impact.impactOccurred()
			}
		}
	}
	
	private func stopTracking(_ touch: UITouch) {
		guard let container = touchTrackingMap.removeValue(forKey: touch) else { return }
		
		container.registerTouchExit()
		
		let location = touch.location(in: self)
		let endedInside = container.point(inside: location, with: nil)
		let isLastTouch = touchTrackingMap.isEmpty
		
		if endedInside, isLastTouch {
			(container.contentView as? MYTouchSurfaceActionable)?.touchSurfaceDidTrigger()
		}
	}
	
	@inline(__always)
	private func foundItemContainer(_ point: CGPoint) -> ItemContainer? {
		var responder: UIResponder? = hitTest(point, with: nil)
		while responder != nil, !(responder is ItemContainer) {
			responder = responder?.next
		}
		return responder as? ItemContainer
	}
}


private final class ItemContainer: MYTouchTrackingControl {
	private let dimmingView = UIView()
	let contentView: UIView
	
	init(contentView: UIView) {
		self.contentView = contentView
		super.init(frame: .zero)
		
		setupViews()
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	private func setupViews() {
		dimmingView.backgroundColor = .white.withAlphaComponent(0.5)
		dimmingView.alpha = 0
		dimmingView.isUserInteractionEnabled = false
		
		addSubview(contentView)
		addSubview(dimmingView)
	}
	
	// MARK: - Layout & HitTest
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let pointInContent = convert(point, to: contentView)
		let hitView = contentView.hitTest(pointInContent, with: event)
		return hitView != nil
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		contentView.layoutIfNeeded()
		
		dimmingView.frame = contentView.frame
		dimmingView.layer.cornerRadius = contentView.layer.cornerRadius
		dimmingView.clipsToBounds = true
	}
	
	// MARK: - State Handling
	override func didUpdateTouchState(isActive: Bool) {
		let targetAlpha: CGFloat = isActive ? 1.0 : 0.0
		
		UIView.animate(withDuration: 0.44) { [weak self] in
			self?.dimmingView.alpha = targetAlpha
		}
	}
}
