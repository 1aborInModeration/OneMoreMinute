//
//  AlarmNotificationMinutes.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

enum AlarmNotificationMinutes: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    case ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen
    case twenty, twentyOne, twentyTwo, twentyThree, twentyFour, twentyFive, twentySix, twentySeven, twentyEight, twentyNine
    case thirty, thirtyOne, thirtyTwo, thirtyThree, thirtyFour, thirtyFive, thirtySix, thirtySeven, thirtyEight, thirtyNine
    case forty, fortyOne, fortyTwo, fortyThree, fortyFour, fortyFive, fortySix, fortySeven, fortyEight, fortyNine
    case fifty, fiftyOne, fiftyTwo, fiftyThree, fiftyFour, fiftyFive, fiftySix, fiftySeven, fiftyEight, fiftyNine
    
    var value: Int {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .eleven: return 11
        case .twelve: return 12
        case .thirteen: return 13
        case .fourteen: return 14
        case .fifteen: return 15
        case .sixteen: return 16
        case .seventeen: return 17
        case .eighteen: return 18
        case .nineteen: return 19
        case .twenty: return 20
        case .twentyOne: return 21
        case .twentyTwo: return 22
        case .twentyThree: return 23
        case .twentyFour: return 24
        case .twentyFive: return 25
        case .twentySix: return 26
        case .twentySeven: return 27
        case .twentyEight: return 28
        case .twentyNine: return 29
        case .thirty: return 30
        case .thirtyOne: return 31
        case .thirtyTwo: return 32
        case .thirtyThree: return 33
        case .thirtyFour: return 34
        case .thirtyFive: return 35
        case .thirtySix: return 36
        case .thirtySeven: return 37
        case .thirtyEight: return 38
        case .thirtyNine: return 39
        case .forty: return 40
        case .fortyOne: return 41
        case .fortyTwo: return 42
        case .fortyThree: return 43
        case .fortyFour: return 44
        case .fortyFive: return 45
        case .fortySix: return 46
        case .fortySeven: return 47
        case .fortyEight: return 48
        case .fortyNine: return 49
        case .fifty: return 50
        case .fiftyOne: return 51
        case .fiftyTwo: return 52
        case .fiftyThree: return 53
        case .fiftyFour: return 54
        case .fiftyFive: return 55
        case .fiftySix: return 56
        case .fiftySeven: return 57
        case .fiftyEight: return 58
        case .fiftyNine: return 59
        }
    }
}
