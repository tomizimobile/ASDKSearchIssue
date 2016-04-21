# ASDKSearchIssue

This is a simple test app that has a tableView of names, and a search bar to filter the names. A crash occurs when you navigate back from the pushed view controller, if one of the section headers is partially offscreen and the tableView isn't scrolled.

Defaults to use AsyncDisplayKit. To use UIKit, add the flag `-D USE_UIKIT` in the target build settings, under `Other Swift Flags`.
