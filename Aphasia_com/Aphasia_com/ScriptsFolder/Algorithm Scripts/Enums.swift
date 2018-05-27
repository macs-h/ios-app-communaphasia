//
//  Enums.swift
//  CommunAphasia
//
//  Created by RedSQ on 25/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import Foundation

///   An enum file containing all the enum declarations.

/// The type of word, in terms of linguistics (e.g. noun).
enum wordType :String {
    case noun, properNoun
    case verb, adverb
    case adjective
    case preposition
}

/// The category of the image (e.g. animals).
enum imageCategory :String {
    case animal
    case food
    case colours
    case emotions
}

