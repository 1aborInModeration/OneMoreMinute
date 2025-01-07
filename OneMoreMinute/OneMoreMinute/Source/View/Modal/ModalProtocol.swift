//
//  ModalProtocol.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//


protocol ModalLifecycleNotifiable: AnyObject {
    func onModalWillAppear()
    func onModalWillDisappear()
}

protocol ModalCloseDelegate: AnyObject {
    func closeModal()
}

protocol ModalCloseable: AnyObject {
    var delegate: ModalCloseDelegate? { get set }
    func closeModal()
}
