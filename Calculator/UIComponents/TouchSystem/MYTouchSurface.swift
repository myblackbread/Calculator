//
//  Untitled.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//

import UIKit

class MYTouchSurface: UICollectionView {
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		isMultipleTouchEnabled = true
		isScrollEnabled = false
	}
	
	private var touchTrackingMap: [UITouch: MYHighlightableContainerCell] = [:]

	required init?(coder: NSCoder) { fatalError() }
	
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
		touchTrackingMap.removeValue(forKey: touch)?.registerTouchExit()
		
		let location = touch.location(in: self)
		
		if touchTrackingMap.isEmpty {
			(hitTest(location, with: nil) as? MYTouchSurfaceActionable)?.touchSurfaceDidTrigger()
		}
	}
	
	@inline(__always)
	private func foundItemContainer(_ point: CGPoint) -> MYHighlightableContainerCell? {
		var responder: UIResponder? = hitTest(point, with: nil)
		while responder != nil, !(responder is MYHighlightableContainerCell) {
			responder = responder?.next
		}
		return responder as? MYHighlightableContainerCell
	}
}
