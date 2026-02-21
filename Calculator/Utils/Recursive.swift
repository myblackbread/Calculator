//
//  Recursive.swift
//  Calculator
//
//  Created by Garib Agaev on 14.02.2026.
//


import Foundation

enum Recursive {
	
	final private class Box<T: AnyObject> {
		weak var value: T?
	}
	
	static func build<T: AnyObject, R>(
		_ construct: (_ resolve: @escaping () -> R) -> T,
		resolve: @escaping (_ myself: T?) -> R
	) -> T {
		
		let box = Box<T>()
		
		let instance = construct {
			resolve(box.value)
		}
		
		box.value = instance
		return instance
	}
}
