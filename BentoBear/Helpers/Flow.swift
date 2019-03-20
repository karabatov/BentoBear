//
//  Flow.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 13/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit

extension UIViewController {
    var modalFlow: Flow {
        return ModalFlow(self)
    }

    var navigationFlow: Flow {
        guard let navigationController = self.navigationController else { return modalFlow }
        return NavigationFlow(navigationController)
    }
}

protocol Flow {
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(_ animated: Bool)
}

extension Flow {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

private struct ModalFlow: Flow {
    private let origin: UIViewController

    init(_ viewController: UIViewController) {
        self.origin = viewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        origin.present(viewController, animated: animated, completion: nil)
    }

    func dismiss(_ animated: Bool) {
        origin.dismiss(animated: animated, completion: nil)
    }
}

private struct NavigationFlow: Flow {
    private let origin: UINavigationController

    init(_ viewController: UINavigationController) {
        self.origin = viewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        origin.pushViewController(viewController, animated: animated)
    }

    func dismiss(_ animated: Bool) {
        origin.popViewController(animated: animated)
    }
}
