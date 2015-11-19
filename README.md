# ASDKSearchIssue

This is a simple test app that has a tableView of names, and a search bar to filter the names. Using UIKit, everything works as expected, but using AsyncDisplayKit, a crash occurs when trying to delete sections/rows or reload the data after the data source has been filtered. Defaults to use UIKit. To use AsyncDisplayKit, delete the flag `-D USE_UIKIT` in the target build settings, under `Other Swift Flags`.
