//
//  Untitled.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//

import UIKit

final class MYCalculatorController: UIViewController {
	
	let delegate = MYCalculatorService()
	
	let label: MYDisplayLabel = {
		let label = MYDisplayLabel<MYCalculatorService.Output>()
		label.font = .systemFont(ofSize: 88, weight: .medium)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0
		label.lineBreakMode = .byClipping
		label.textColor = .white
		return label
	}()
	
	let calculatorGrid = {
		let calculatorGrid = Recursive.build { resolve in
			MYCalculatorView(builder: resolve)
		} resolve: { myself in
			MYCalculatorFactory().makeGrid(target: myself)
		}
		calculatorGrid.configure()
		return calculatorGrid
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(label)
		view.addSubview(calculatorGrid)
		view.backgroundColor = .black
		calculatorGrid.delegate = delegate
		
		calculatorGrid.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false

		let padding = 16.0
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: -padding),
			label.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
			label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
		])
		
		let spacing = padding / 2
		calculatorGrid.safeUpdate(spacing: spacing)
		NSLayoutConstraint.activate([
			calculatorGrid.topAnchor.constraint(equalTo: label.bottomAnchor, constant: spacing),
			calculatorGrid.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
			calculatorGrid.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
			calculatorGrid.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing)
		])
		
		label.subscribe(to: delegate.outputStream)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
		calculatorGrid.orientation = size.width >= size.height ? .horizontal : .vertical
		label.orientation = size.width >= size.height ? .horizontal : .vertical
	}
}

import SwiftUI

struct MYCalculatorControllerRepresentable: UIViewControllerRepresentable {
	
	func makeUIViewController(context: Context) -> MYCalculatorController {
		MYCalculatorController()
	}
	
	func updateUIViewController(
		_ uiViewController: MYCalculatorController,
		context: Context
	) {}
}

private struct MYExampleView: View {
	var body: some View {
		MYCalculatorControllerRepresentable()
			.ignoresSafeArea()
	}
}

#Preview {
	MYExampleView()
}
