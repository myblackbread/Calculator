//
//  MYCalculatorView.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//

import UIKit

final class MYCalculatorView: MYTouchSurface {
	
	
	// MARK: - Properties
	
	private var isScientificMode = false {
		willSet {
			updateVisibility(isHidden: true)
		}
		didSet {
			updateVisibility(isHidden: false)
			setNeedsLayout()
		}
	}
	
	var orientation: MYOrientation = .vertical {
		willSet {
			updateVisibility(isHidden: true)
		}
		didSet {
			updateVisibility(isHidden: false)
			setNeedsLayout()
		}
	}
	
	private lazy var container = loadGrid()
	private let loadGrid: () -> MYGridContainer
	
	private var allGrids: [GridLayout] {
		[container.vertical, container.horizontal, container.horizontalSecond]
	}
	
	private var currentGrid: GridLayout {
		switch (isScientificMode, orientation) {
		case (_, .vertical): container.vertical
		case (false, .horizontal): container.horizontal
		case (true, .horizontal): container.horizontalSecond
		}
	}
	
	weak var delegate: (any MYCalculatorServiceProtocol)?
	
	// MARK: - Init
	
	init(
		builder: @escaping () -> MYGridContainer,
		frame: CGRect = .zero
	) {
		self.loadGrid = builder
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	// MARK: - Lifecycle
	
	override var intrinsicContentSize: CGSize {
		currentGrid.width = bounds.width
		return CGSize(width: UIView.noIntrinsicMetric, height: currentGrid.totalHeight)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		currentGrid.width = bounds.width
		let unitWidth = currentGrid.unitWidth
		
		currentGrid.layout(fittingHeight: bounds.height) { view, rect in
			view.frame = rect
			(view as? MYCalculatorButton)?.subview.frame = CGRect(
				origin: .zero,
				size: CGSize(width: unitWidth, height: rect.height)
			)
		}
		
		invalidateIntrinsicContentSize()
	}
		
	// MARK: - Public Methods
	
	func configure() {
		updateVisibility(isHidden: false)
	}
	
	func safeUpdate(spacing: CGFloat? = nil) {
		allGrids.forEach { grid in
			spacing.map { grid.spacing = $0 }
		}
		setNeedsLayout()
	}
	
	// MARK: - Private Methods
	
	private func updateVisibility(isHidden: Bool) {
		currentGrid.items.flatMap { $0 }.forEach { item in
			guard case let .view(view, _) = item else { return }
			if view.superview == nil {
				addTile(view)
			}
			view.alpha = isHidden ? 0 : 1
			view.isUserInteractionEnabled = !isHidden
		}
	}
	
	private func forEachButton(_ closure: (MYCalculatorButton) -> Void) {
		allGrids.lazy.flatMap(\.items).joined().forEach { item in
			if case .view(let view, _) = item, let button = view as? MYCalculatorButton {
				closure(button)
			}
		}
	}
}

// MARK: - MYCalculatorButtonDelegate

extension MYCalculatorView: MYCalculatorButtonDelegate {
	
	func calculatorButtonDidTap(_ button: MYCalculatorButton) {
		if case .shift = button.model.action {
			let isSelected = button.visualState == .selected
			button.visualState = isSelected ? .normal : .selected
			isScientificMode = !isSelected
			return
		}
		
		delegate?.handle(button.model.action)
		
		forEachButton { button in
			switch button.model.action {
			case let .binaryOperation(op):
				let isActive = (op == delegate?.activeOperation)
				button.visualState = isActive ? .selected : .normal
				
			case .clear:
				let hasActiveState = delegate?.activeState ?? false
				button.title = hasActiveState ? "C" : nil
				
			default:
				break
			}
		}
	}
}

extension MYCalculatorView {
	static func recursive(_ closure: @escaping (MYCalculatorView?) -> MYGridContainer) -> MYCalculatorView {
		Recursive.build { resolve in
			MYCalculatorView(builder: resolve)
		} resolve: { myself in
			closure(myself)
		}
	}
}
