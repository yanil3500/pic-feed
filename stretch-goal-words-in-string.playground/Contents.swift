//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func wordsInString(_ str: String) -> Int {
    return str.components(separatedBy: " ").count
}

wordsInString("I've got 99 problems but a nothin' ain't one.")