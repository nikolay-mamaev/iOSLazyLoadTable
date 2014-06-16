iOSLazyLoadTable
================

**Lazy load table data in background with thread-blocking cell data loading operation**

This example provides a table view with infinite number of cells; data for each cell is loaded only when UITableView requests that cell.

In this example, I emulate a thread-blocking cell data loading operation with sleeping thread for 2 seconds. To use this example in your real application you need to replace implementations of the `tableElementPlaceholder` getter and `fetchTableCellDataForIndexPath:` method; also, you'll need to tune implementation of the `tableView:cellForRowAtIndexPath:` method for your cells implementation.
