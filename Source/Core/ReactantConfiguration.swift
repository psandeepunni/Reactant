//
//  ProjectBaseConfiguration.swift
//  Reactant
//
//  Created by Tadeáš Kříž on 12/06/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import UIKit

public struct ReactantConfiguration {
    
    public static var global = ReactantConfiguration()

    public var layoutMargins = UIEdgeInsets.zero
    public var controllerRootStyle: (ControllerRootViewContainer) -> Void = { _ in }
    public var emptyListLabelStyle: (UILabel) -> Void = { _ in }
    public var defaultLoadingMessage = "Loading .."
    public var closeButtonTitle = "Close"
    public var defaultBackButtonTitle: String? = nil
    public var dialogStyle: (UIView) -> Void = { _ in }
    public var dialogContentContainerStyle: (UIView) -> Void = { _ in }
    public var loadingIndicatorStyle: UIActivityIndicatorViewStyle = .gray
}