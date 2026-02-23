//
//  MyGridLayoutAdapter.swift
//  Calculator
//
//  Created by Garib Agaev on 22.02.2026.
//


import UIKit

final class MyGridLayoutAdapter<T: Identifiable & Hashable>: UICollectionViewLayout {
	
	var gridEngine: MYGridLayout<T>?
	
	private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var contentSize: CGSize = .zero
	
	private var idToIndexPath: [T: IndexPath] = [:]
	
	override func prepare() {
		guard let engine = gridEngine, let cv = collectionView else { return }
		
		cache.removeAll()
		
		let availableWidth = cv.bounds.width - cv.adjustedContentInset.left - cv.adjustedContentInset.right
		let availableHeight = cv.bounds.height - cv.adjustedContentInset.top - cv.adjustedContentInset.bottom
		
		engine.width = availableWidth
		
		engine.layout(fittingHeight: availableHeight) { id, rect in
			if let indexPath = idToIndexPath[id] {
				let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				attributes.frame = rect
				cache[indexPath] = attributes
			}
		}
		
		contentSize = CGSize(width: availableWidth, height: availableHeight)
	}
	
	override var collectionViewContentSize: CGSize {
		return contentSize
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return cache.values.filter { $0.frame.intersects(rect) }
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath]
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return newBounds.size != collectionView?.bounds.size
	}
	
	func configure(with engine: MYGridLayout<T>) -> ([IndexPath: T], [T: IndexPath]) {
		self.gridEngine = engine
		var res: [IndexPath: T] = [:]
		idToIndexPath.removeAll()
		let allIds = engine.items.flatMap { $0.compactMap { $0.id } }
		for (index, id) in allIds.enumerated() {
			let indexPath = IndexPath(item: index, section: 0)
			idToIndexPath[id] = indexPath
			res[indexPath] = id
		}
		
		invalidateLayout()
		
		return (res, idToIndexPath)
	}
}
