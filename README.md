# BentoBear

**BentoBear** is a small project which downloads, caches, saves and displays
a list of placeholder posts. It has two screens: the list of posts and a post
detail screen. The goal was to become familiar with ReactiveSwift,
ReactiveFeedback, Bento and BentoKit (see below). This is my first experience
using all of these particular libraries, although I have several years of FRP
under my belt with RxSwift (still, its API is considerably different from
ReactiveSwift).

It is far from perfect, but I feel that at this point I've hit the point of
diminishing returns. It is worthy of discussion, as many decisions may have
been made in a different way, and a lot could be done differently. I have my
reasons for most of it which I am ready to talk about at length :)

The codebase is mostly testable already thanks to the chosen architecture, but
if we were *really* talking about production grade, some of the runtime classes
could be further decomposed to get parameters injected, so that they could be
fully tested. There are also just a few small steps left to make the app fully
runtime-mockable, which means consistent, repeatable UI tests independent of
network or local storage. This is my pet peeve.

### Features

- [x] Uses [Bento](https://github.com/Babylonpartners/Bento).
- [x] Uses BentoKit and StyleSheets from the same repo.
- [x] Uses [ReactiveFeedback](https://github.com/Babylonpartners/ReactiveFeedback).
- [x] Fully localized with plurals support.
- [x] Persistence to local storage with in-memory cache.
- [x] Testable components with protocols, somewhat tested.

### The Checklist™

- [x] SOLID.
- [x] Dependency injection.
- [x] Testable and tested (a little bit).
- [x] Error handling and easily adding new errors.
- [x] Architected for future change.
- [x] Consitent coding style.
- [x] Clean project structure, no cruft.
- [x] Local persistence (with `UserDefaults` to avoid using external
    libraries).
- [x] Download all data, though only visible fields are used.
- [x] “Production grade” code – mostly.
- [x] Point of synchronization with downloading and saving data.

### Acknowledgements

- [@ilyapuchka](https://twitter.com/ilyapuchka) for his
    [post](https://ilya.puchka.me/implementing-features-with-reactivefeedback/)
    which inspired this project (though I had to figure out a few operators and
    classes by myself).
- [@peres](https://twitter.com/peres) for being very accessible and the sample
    [Flow implementation](https://gist.github.com/RuiAAPeres/2b8d195b8e2b43d374686c77722492dd).
- [@sergdort](https://twitter.com/sergdort) for help with Bento and
    ReactiveSwift.
