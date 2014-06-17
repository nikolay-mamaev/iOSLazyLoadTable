iOSLazyLoadTable
================

**Lazy load table data in background with time-consuming thread-blocking cell data loading operation**

This example provides a table view with infinite number of cells; data for each cell is loaded in a background thread only when UITableView requests that cell. To eliminate excessive load of the system with loading data during fast scrolling, actual loading is performed only after scrolling stops and data is loaded for visible cells only; that is, for long tables data is loaded only for cells that user really needs to see.

In this example, I emulate a thread-blocking cell data loading operation with sleeping thread for 2 seconds. To use this example in your real application you need to replace implementations of the `tableElementPlaceholder` getter and `fetchTableCellDataForIndexPath:` method; also, you'll need to tune implementation of the `tableView:cellForRowAtIndexPath:` method for your cells implementation. Please note that any object data needed in the loading code should be thread-safe since loading is performed in non-main thread (i.e. `atomic` properties and probably `NSLock` should be used inside the `tableDataLoadDelayTimerFired:` method in your time-consuming thread blocking code replacing the `sleep()` call).
