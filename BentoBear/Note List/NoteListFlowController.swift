//
//  NoteListFlowController.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 13/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit

protocol Flow {
    func present()
    func dismiss()
}

struct SampleFlow: Flow {
    func present() {}
    func dismiss() {}
}

final class NoteListFlowController {
    private let presentationFlow: Flow
    private let presenting: Flow

    init(presentationFlow: Flow, presenting: Flow) {
        self.presentationFlow = presentationFlow
        self.presenting = presenting
    }

    func handle(_ route: NoteListViewModel.Route) {
        switch route {
        case .showNote:
            presenting.dismiss()
        }
    }
}
