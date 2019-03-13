//
//  NoteListBuilder.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 13/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit
import ReactiveSwift
import BentoKit
import Result

struct NoteListBuilder {
    func make(
        context: NoteListRendererContext,
        presentationFlow: Flow,
        presenting: Flow
    ) -> UIViewController {
        let viewModel = NoteListViewModel()

        let viewController = BoxViewController.init(
            viewModel: viewModel,
            renderer: NoteListRenderer.self,
            rendererConfig: NoteListRenderer.Config(
                context: context
            ),
            appearance: Property.init(value: NoteListRenderer.Appearance())
        )

        let flowController = NoteListFlowController(
            presentationFlow: presentationFlow,
            presenting: presenting
        )

        viewModel.routes
            .observe(on: UIScheduler())
            .observeValues(flowController.handle)

        return viewController
    }
}
