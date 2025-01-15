//
//  AlarmNotificationHours.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

enum AlarmNotificationHours: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    case ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen
    case twenty, twentyOne, twentyTwo, twentyThree
    
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
        }
    }
}
