func simple() {
    print("hi")
}

simple()                                // hi


// Parameter types and the return type must be specified.
func plus(a: Int, b: Int) ->Int {
    return a + b
}

func sum(numbers: [Double]) -> Double {
    var sum: Double = 0.0
    for num in numbers {
        sum += num
    }
    return sum
}

// Functions can return tuples.
func stats(numbers: [Int]) -> (min: Int, max: Int) {
    var min = Int.max, max = Int.min

    for i in numbers {
        if i < min {
            min = i
        }
        if i > max {
            max = i
        }
    }

    return (min, max)
}

// Functions that don't return anything return
// `Void` (an empty tuple) by default.
func noop(){}
noop()

var result = stats(numbers: [1, 2, 4])
print(result.min)                      // 1
print(result.max)                      // 4

// Named parameters use an 'external' name before the 'internal' name.
// Kind of a kludgy holdover from Obj-C selectors...
func increment(number: Int, by incrementer: Int) -> Int {
    return number + incrementer
}

print(increment(number: 1, by: 10))           // 11

// ...So fortunately there's a shorthand for re-using the same name.
func incrementTakeTwo(number: Int, by: Int) -> Int {
    return number + by
}

print(increment(number: 1, by: 10))           // 11

// Parameter values aren't modifiable by default.
// But you can declare that you want to change a parameter
// value (within the function) with a var keyword.
func addOne(num: Int) -> Int {
    return num + 1
}
addOne(num: 1)                             // 2

// # Default parameter values

// Swift realizes that the verbosity is becoming a burden.
// So default params' internal names are also auto-exposed
// with the same external name.
func incrementTakeThree(number: Int, by: Int = 3) -> Int {
    return number + by
}

print(incrementTakeThree(number: 1))         // 4
print(incrementTakeThree(number: 1, by:1))   // 2


// # Variadic parameters

// (Aside: functions can be overloaded since they're different types [more below])
func sum(nums: Double...) -> Double {
    var sum: Double = 0.0
    for num in nums {
        sum += num
    }
    return sum
}

// Unfortunately, splats aren't supported
// <https://devforums.apple.com/message/970958#970958>
// So you can't call a variadic function with an array of args.
func average(nums: Double...) -> Double {
    return sum(numbers: nums) / Double(nums.count)
}
average(nums: 1.0, 2.0, 3.0, 4.0)            // 2.5

// # In-Out (pass-by-reference) parameters

// inout params cannot be declared as var or let.
func addOneSideEffect(num: inout Int) {
    num += 1
}
// Cannot pass constants and literals.
var num = 1
// Use an & before the var's name.
addOneSideEffect(num: &num)
print(num)                         // 2

// # Function Types

// Assign functions to variables.
// The function type (signature) of the function
// must be repeated.
var mean: (Double...) -> Double = average
mean(1.0, 4.0)                      // 2.5

// The variable can be re-assigned to another function as
// long as that function has the same type.

// Function types can be used as parameters.
func skewedMean(mean: (Double...) -> Double, num1: Double, num2: Double) -> Double {
    return mean(num1, num2) + 1.0
}
skewedMean(mean: mean, num1: 1.0, num2: 4.0)          // 3.5

// Function types can be returned from functions.
func choose(which: String) -> (Double...) -> Double {
    if which == "sum" {
        return sum
    }
    return mean
}
choose(which: "sum")(1.0, 2.0)            // 3.0
choose(which: "mean")(1.0, 2.0)           // 1.5

