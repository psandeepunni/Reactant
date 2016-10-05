//
//  ViewBase.swift
//  Pods
//
//  Created by Tadeáš Kříž on 12/06/16.
//
//

import RxSwift
import RxCocoa
import UIKit

open class ViewBase<STATE>: UIView, Component {
    // MARK: Dispose bags
    open let lifecycleDisposeBag = DisposeBag()
    open var stateDisposeBag = DisposeBag()

    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    open var observableState: Observable<STATE> {
        return observableStateSubject
    }
    private let observableStateSubject = ReplaySubject<STATE>.create(bufferSize: 1)

    open private(set) var previousComponentState: STATE?
    open var componentState: STATE {
        get {
            if let model = stateStorage {
                return model
            } else {
                fatalError("Model accessed, before stored!")
            }
        }
        set {
            previousComponentState = stateStorage
            stateStorage = newValue
            observableStateSubject.onNext(newValue)
            stateDisposeBag = DisposeBag()
            render()
        }
    }
    private var stateStorage: STATE?

    public init() {
        super.init(frame: CGRect.zero)

        prepareView()

        setVoidStateIfPossible()
    }

    public init(initialState: STATE?) {
        super.init(frame: CGRect.zero)

        prepareView()

        if let state = initialState {
            componentState = state
        } else {
            setVoidStateIfPossible()
        }
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func prepareView() {
        layoutMargins = ReactantConfiguration.global.layoutMargins
        translatesAutoresizingMaskIntoConstraints = false

        loadView()
        setupConstraints()
    }

    private func setVoidStateIfPossible() {
        if let voidState = Void() as? STATE {
            componentState = voidState
        }
    }

    open func render() { }

    open func loadView() { }

    open func setupConstraints() { }
}