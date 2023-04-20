//
//  Debouncer.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 02/04/2023.
//

protocol Debouncing {
    var callback: (() -> Void)? {get set}
    func call()
}

import Foundation

final class Debouncer : Debouncing {
    var callback: (() -> Void)?
    var delay: TimeInterval
    weak var timer: Timer?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func call() {
        timer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.callback?()
            self.timer = nil
        }
        self.timer = timer
    }
}
