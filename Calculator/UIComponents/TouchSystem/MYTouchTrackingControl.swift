//
//  MYTouchTrackingControl.swift
//  Calculator
//
//  Created by Garib Agaev on 18.02.2026.
//


import UIKit

class MYTouchTrackingControl: UIView {
	
	private(set) var activeTouchesCount = 0
	
	var isTrackingTouches: Bool {
		activeTouchesCount > 0
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	final func registerTouchEntry() {
		activeTouchesCount += 1
		didUpdateTouchState(isActive: isTrackingTouches)
	}
	
	final func registerTouchExit() {
		activeTouchesCount = max(0, activeTouchesCount - 1)
		didUpdateTouchState(isActive: isTrackingTouches)
	}
	
	func didUpdateTouchState(isActive: Bool) {}
}
