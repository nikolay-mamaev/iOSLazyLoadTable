iOSLazyLoadTable
================

**Lazy load table data in background with time-consuming thread-blocking cell data loading operation**

This example provides a table view with infinite number of cells; data for each cell is loaded in a background thread only when all of the following conditions are true:
* UITableView requests that cell;
* Cell that data is requested for is visible;
* UITableView is not scrolling OR scrolling is not decelerated (i.e. scrolling is performed while user’s finger touches the screen).

That is, excessive load of the system during fast scrolling is eliminated, and data is loaded only for cells that user really needs to see.

In this example, time-consuming and thread-blocking data loading operation is emulated for each cell with sleeping a background thread for 0.2 seconds. To use this example in your real application please do the following:

* Replace implementations of the `tableElementPlaceholder` getter;
* In the `performActualFetchTableCellDataForIndexPaths:` method, replace the following line with your actual loading cell data:
  `[NSThread sleepForTimeInterval:0.2];  // emulation of time-consuming and thread-blocking operation`
* Tune implementation of the `tableView:cellForRowAtIndexPath:` method for your cells implementation. 

Please note that any object data needed in the loading code should be thread-safe since loading is performed in non-main thread (i.e. `atomic` properties and probably `NSLock` should be used inside the `tableDataLoadDelayTimerFired:` method in your time-consuming thread blocking code replacing the `sleep()` call).
