//
//  ControllerBase.swift
//  Reactant
//
//  Created by Filip Dolnik on 09.11.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SnapKit
import RxSwift

open class ControllerBase<STATE, ROOT: UIView>: UIViewController, ComponentWithDelegate, Configurable where ROOT: Component {
    
    public typealias StateType = STATE
    public typealias ActionType = Void
    
    open var navigationBarHidden: Bool {
        return false
    }
    
    public let lifetimeDisposeBag = DisposeBag()
    
    public let componentDelegate = ComponentDelegate<STATE, Void, ControllerBase<STATE, ROOT>>()
    
    public let action: Observable<Void> = Observable.empty()
    
    public let actions: [Observable<Void>] = []
    
    public let rootView: ROOT
    
    open var configuration: Configuration = .global {
        didSet {
            (rootView as? Configurable)?.configuration = configuration
            (view as? Configurable)?.configuration = configuration
            navigationItem.backBarButtonItem = configuration.get(valueFor: Properties.defaultBackButton)
        }
    }
    
    private var castRootView: RootView? {
        return rootView as? RootView
    }

    /* The following inits are here to workaround a SegFault 11 in Swift 3.0 
       when implementation controller don't implement own init. [It's fixed in Swift 3.1] */
    public init() {
        rootView = ROOT()

        super.init(nibName: nil, bundle: nil)

        setupController(title: "")
    }

    public init(root: ROOT) {
        rootView = root

        super.init(nibName: nil, bundle: nil)

        setupController(title: "")
    }
    
    public init(title: String, root: ROOT = ROOT()) {
        rootView = root
        
        super.init(nibName: nil, bundle: nil)

        setupController(title: title)
    }

    private func setupController(title: String) {
        componentDelegate.ownerComponent = self
        rootView.action
            .subscribe(onNext: { [weak self] in
                self?.act(on: $0)
            })
            .addDisposableTo(lifetimeDisposeBag)

        self.title = title

        reloadConfiguration()

        afterInit()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func afterInit() {
    }

    open func update() {
    }

    open func needsUpdate() -> Bool {
        return true
    }

    public func observeState(_ when: ObservableStateEvent) -> Observable<STATE> {
        return componentDelegate.observeState(when)
    }

    open override func loadView() {
        view = ControllerRootViewContainer().with(configuration: configuration)
        
        view.addSubview(rootView)
    }
    
    open override func updateViewConstraints() {
        updateRootViewConstraints()
        
        super.updateViewConstraints()
    }
    
    open func updateRootViewConstraints() {
        rootView.snp.remakeConstraints { make in
            make.leading.equalTo(view)
            if castRootView?.edgesForExtendedLayout.contains(.top) == true {
                make.top.equalTo(view)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.trailing.equalTo(view)
            if castRootView?.edgesForExtendedLayout.contains(.bottom) == true {
                make.bottom.equalTo(view).priority(UILayoutPriorityDefaultHigh)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).priority(UILayoutPriorityDefaultHigh)
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(navigationBarHidden, animated: animated)
        
        componentDelegate.canUpdate = true
        
        castRootView?.viewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        castRootView?.viewDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        componentDelegate.canUpdate = false
        
        castRootView?.viewWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        castRootView?.viewDidDisappear()
    }
    
    public final func perform(action: Void) {
    }
    
    public final func resetActions() {
    }
    
    open func act(on action: ROOT.ActionType) {
    }
}
