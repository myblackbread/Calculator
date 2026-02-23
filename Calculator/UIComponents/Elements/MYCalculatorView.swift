//
//  MYCalculatorView.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import UIKit

extension MYCalculatorButton: MYTouchSurfaceActionable {
	func touchSurfaceDidTrigger() {
		delegate?.calculatorButtonDidTap(self.model)
	}
}

final class MYCalculatorView: MYTouchSurface {
	
	typealias ButtonID = MYCalculatorAction
	private typealias GridContainer = MYGridContainer<MYCalculatorAction>
	private typealias GridLayout = MYGridContainer<MYCalculatorAction>.GridLayout
	
	private lazy var buttons = Dictionary(
		uniqueKeysWithValues: MYButtonModelFactory().makeButtonModels().map {
			($0.action, $0)
		}
	)
	
	private func updateDate(model: MYCalculatorButtonModel) {
		guard let oldModel = buttons[model.action.id] else { return }
		if model.visualState != oldModel.visualState || model.title != oldModel.title {
			buttons[model.action.id] = model
			actionPaths[model.action.id].map { indexPath in
				reloadItems(at: [indexPath])
			}
		}
	}
	
	private var indexesPath: [IndexPath: ButtonID] = [:]
	private var actionPaths: [ButtonID: IndexPath] = [:]
	
	// MARK: - Properties
	
	private var isScientificMode = false {
		didSet { configure() }
	}
	
	var orientation: MYOrientation = .vertical {
		didSet { configure() }
	}
	
	private var container: GridContainer

	private var currentGrid: GridLayout {
		switch (isScientificMode, orientation) {
		case (_, .vertical): container.vertical
		case (false, .horizontal): container.horizontal
		case (true, .horizontal): container.horizontalSecond
		}
	}
	
	weak var calculatorService: (any MYCalculatorServiceProtocol)?
	
	// MARK: - Init
	
	init(
		gridContainer: MYGridContainer<MYCalculatorAction>,
		frame: CGRect = .zero
	) {
		self.container = gridContainer
		let adapter = MyGridLayoutAdapter<MYCalculatorAction>()
		super.init(frame: frame, collectionViewLayout: adapter)
		delegate = self
		dataSource = self
		configure()
		
		register(MYCapsuleHighlightableContainerCell.self, forCellWithReuseIdentifier: "MYCapsuleHighlightableContainerCell")
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	// MARK: - Lifecycle
	
	override var intrinsicContentSize: CGSize {
		currentGrid.width = bounds.width
		return CGSize(width: UIView.noIntrinsicMetric, height: currentGrid.totalHeight)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
	}
	
	// MARK: - Public Methods
	
	func configure() {
		(collectionViewLayout as? MyGridLayoutAdapter<MYCalculatorAction>).map {
			(indexesPath, actionPaths) = $0.configure(with: currentGrid)
		}
		reloadData()
	}
	
	func safeUpdate(spacing: CGFloat) {
		container.vertical.spacing = spacing
		container.horizontal.spacing = spacing
		container.horizontalSecond.spacing = spacing
		setNeedsLayout()
	}
	
	// MARK: - Private Methods
	
	private func forEachButton(_ closure: (MYCalculatorAction) -> Void) {
		buttons.values.forEach { closure($0.action) }
	}
}

// MARK: - MYCalculatorButtonDelegate

extension MYCalculatorView: MYCalculatorButtonDelegate {
	
	func calculatorButtonDidTap(_ model: MYCalculatorButtonModel) {
		if case .shift = model.action {
			let isSelected = model.visualState == .selected
			isScientificMode = !isSelected
			updateDate(model: {
				var newModel = model
				newModel.visualState = isSelected ? .normal : .selected
				return newModel
			}())
			return
		}
		
		calculatorService?.handle(model.action)
		
		forEachButton { id in
			guard var newModel = buttons[id], let calculatorService else { return }
			switch id {
			case let .binaryOperation(op):
				let isActive = op == calculatorService.activeOperation
				newModel.visualState = isActive ? .selected : .normal
				updateDate(model: newModel)
			case .clear:
				newModel.title = calculatorService.activeState ? "C" : "AC"
				updateDate(model: newModel)
			default:
				break
			}
		}
	}
}

extension MYCalculatorView: UICollectionViewDelegate {}
extension MYCalculatorView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		indexesPath.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard
			let cell = dequeueReusableCell(withReuseIdentifier: "MYCapsuleHighlightableContainerCell", for: indexPath) as? MYCapsuleHighlightableContainerCell,
			let id = indexesPath[indexPath],
			let model = buttons[id]
		else {
			return UICollectionViewCell()
		}

		let button: MYCalculatorButton
		if model.spacingFlag {
			button = MYCalculatorButton(model: model, anchor: .leading(spacing: currentGrid.spacing))
		} else {
			button = MYCalculatorButton(model: model)
		}
		button.delegate = self
		cell.setHostedView(button)
		return cell
	}
}

import SwiftUI

struct MYCalculatorViewRepresentable: UIViewRepresentable {
	let orientation: MYOrientation = .vertical
	let service = MYCalculatorService()
	
	func makeUIView(context: Context) -> MYCalculatorView {
		let calculatorView = MYCalculatorView(gridContainer: MYCalculatorGridFactory().makeGrid())
		calculatorView.calculatorService = service
		calculatorView.configure()
		return calculatorView
	}
	
	func updateUIView(_ uiView: MYCalculatorView, context: Context) {
		if uiView.orientation != orientation {
			uiView.orientation = orientation
		}
	}
}

private struct MYExampleView: View {
	var body: some View {
		MYCalculatorViewRepresentable()
			.ignoresSafeArea()
	}
}

#Preview {
	MYExampleView()
}
