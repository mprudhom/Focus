//
//  UserExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Focus

// A user example
// an example of why we need SYB, Generics or macros
public class User {
	var name : String
	var age : Int
	var tweets : [String]
	var attr : String
	
	public init(_ n : String, _ a : Int, _ t : [String], _ r : String) {
		name = n
		age = a
		tweets = t
		attr = r
	}
	
	// lens example
	public class func luserName() -> Lens<User, User, String, String> {
		return Lens { user in IxStore(user.name) { User($0, user.age, user.tweets, user.attr) } }
	}
}

public func ==(lhs : User, rhs : User) -> Bool {
	return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attr == rhs.attr
}

protocol Focusable {
}

extension Focusable {
	static func lens<T>(getter: Self -> T, _ setter: (inout Self, T) -> Void) -> Lens<Self, Self, T, T> {
		return Lens(get: getter, set: { this, value in
			var this = this
			setter(&this, value)
			return this
		})
	}
}

extension User : Focusable {
	static let userName = User.lens({ $0.name }, { $0.name = $1 })
	static let userAge = User.lens({ $0.age }, { $0.age = $1 })
	static let userTweets = User.lens({ $0.tweets }, { $0.tweets = $1 })
	static let userAttr = User.lens({ $0.attr }, { $0.attr = $1 })
}
