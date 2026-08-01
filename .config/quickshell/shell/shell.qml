//@ pragma UseQApplication

import Quickshell
import "bar"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Bar {}
    }
}
