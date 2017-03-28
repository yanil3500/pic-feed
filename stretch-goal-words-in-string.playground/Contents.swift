//: Playground - noun: a place where people can play

import UIKit
import Foundation
import Darwin
var str = "Hello, playground"

func wordsInString(_ str: String) -> Int {
    return str.components(separatedBy: " ").count
}

wordsInString("I've got 99 problems but begin broke' ain't one.")

var arr = "1 4 3 2".components(separatedBy: " ").map { (num) -> Int in
    Int(num)!
}
var string = ""
for index in stride(from: arr.count-1, through: 0, by: -1){
    string += "\(arr[index]) "
}
print(string)


var matrix : [[Int]] = Array(repeating: Array(repeatElement(0, count: 6)), count: 6)



var testArr = [[1, 1, 1, 0, 0, 0],
               [0, 1, 0, 0, 0, 0],
               [1, 1, 1, 0, 0, 0],
               [0, 0, 2, 4, 4, 0],
               [0, 0, 0, 2, 0, 0],
               [0, 0, 1, 2, 4, 0]
]


func sumOfHourglass(_ inputArray: [[Int]]) -> Int {
    var maxSum = Int(Int8.min)
    var sum = 0
    for i in 0...3{
        for j in 0...3{
            sum = inputArray[i][j] + inputArray[i][j + 1] + inputArray[i][j + 2]
            + inputArray[i + 1][j + 1] +
            inputArray[i + 2][j] + inputArray[i + 2][j + 1] + inputArray[i + 2][j + 2]
            if sum > maxSum {
                maxSum = sum
            }
        }
    }
    return maxSum
}

