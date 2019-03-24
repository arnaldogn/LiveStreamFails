//
//  Constants.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/24/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Swinject

public class Binder {
    
    private lazy var container = Container()
    public static let shared = Binder()
    
    init() {
        setup()
    }
    
    func setup() {
        bind(StreamServiceProtocol.self, to: StreamService())
        container.register(StreamViewModelProtocol.self) {
            return StreamViewModel(service: $0.resolve(StreamServiceProtocol.self)!)
        }
    }
}

public extension Binder {
    public func bind<T>(_ interface: T.Type, to assembly: T, scope: ObjectScope = .graph) {
        container.register(interface) { _ in assembly }.inObjectScope(scope)
    }
    public func resolve<T>(interface: T.Type) -> T! {
        return container.resolve(interface)
    }
    static func bind<T>(interface: T.Type, to assembly: T) {
        Binder.shared.bind(interface, to: assembly)
    }
    static func resolve<T>(_ interface: T.Type) -> T! {
        return Binder.shared.resolve(interface: interface)
    }
}
