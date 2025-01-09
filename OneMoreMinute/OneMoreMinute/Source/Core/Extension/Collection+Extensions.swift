//
//  Collection+Extensions.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

extension Collection {
    
    /// 안전하게 index 접근하기 위한 subscript 제공
    ///
    /// 기존 subscript는 범위를 벗어난 index에 접근하면 크래시가 발생하지만,
    /// safe subscript는 nil을 반환합니다.
    ///
    /// Example:
    /// ```swift
    /// let array = [1, 2, 3]
    ///
    /// // Safe access - returns nil for out of bounds
    /// let safeValue = array[safe: 5]    // nil
    ///
    /// // Safe access - returns value for valid index
    /// let validValue = array[safe: 1]   // Optional(2)
    /// ```
    subscript (safe index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
