//
//  PropertySpec.swift
//  SwiftCheck
//
//  Created by Robert Widmann on 6/5/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import SwiftCheck

class PropertySpec : XCTestCase {
	func testAll() {
		property("Once really only tests a property once") <- forAll { (n : Int) in
			var bomb : Optional<Int> = .Some(n)
			return forAll { (_ : Int) in
				let b = bomb! // Will explode if we test more than once
				bomb = nil
				return b == n
			}.once
		}

		property("Conjamb randomly picks from multiple generators") <- forAll { (n : Int, m : Int, o : Int) in
			return conjamb({
				return true <?> "picked 1"
			}, {
				return true <?> "picked 2"
			}, {
				return true <?> "picked 3"
			})
		}

		property("Invert turns passing properties to failing properties") <- forAll { (n : Int) in
			return n == n
		}.invert.expectFailure

		property("Invert turns failing properties to passing properties") <- forAll { (n : Int) in
			return n != n
		}.invert

		property("Invert does not affect discards") <- forAll { (n : Int) in
			return Discard()
		}.invert

		property("Existential Quantification works") <- exists { (x : Int) in
			return true
		}

		property("within works") <- forAllNoShrink(Int.arbitrary) { (_ : Int) in
			sleep(1)
			return true
		}.within(1000).once.expectFailure

		property("within works") <- forAllNoShrink(Int.arbitrary) { (_ : Int) in
			sleep(1)
			return true
		}.within(1500000).once
	}
}
