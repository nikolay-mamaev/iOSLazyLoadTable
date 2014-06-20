//
//  ViewController.m
//  LazyLoadTable
//
//  Created by Nikolay Mamaev on 6/15/14.
//  Copyright (c) 2014 Nikolay Mamaev. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

static const NSUInteger kTableSizeIncrement = 20;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* tableData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) id tableElementPlaceholder;
@property (nonatomic, strong) NSTimer* tableDataLoadDelayTimer;

- (void)fetchTableCellDataForIndexPath:(NSIndexPath*)indexPath;
- (void)performActualFetchTableCellDataForIndexPaths:(NSArray*)indexPaths;
- (void)tableDataLoadDelayTimerFired:(NSTimer*)timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray arrayWithCapacity:kTableSizeIncrement];
    for (NSUInteger i = 0; i < kTableSizeIncrement; i++) {
        [self.tableData addObject:self.tableElementPlaceholder];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (id)tableElementPlaceholder
{
    return @"";
}

- (void)fetchTableCellDataForIndexPath:(NSIndexPath*)indexPath
{
    if (self.tableView.decelerating && !self.tableView.tracking) {
        if (self.tableDataLoadDelayTimer != nil) {
            [self.tableDataLoadDelayTimer invalidate];
        }
        
        self.tableDataLoadDelayTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(tableDataLoadDelayTimerFired:)
                                           userInfo:nil
                                            repeats:NO];
    } else {
        [self performActualFetchTableCellDataForIndexPaths:@[indexPath]];
    }
}

- (void)tableDataLoadDelayTimerFired:(NSTimer*)timer
{
    [self.tableDataLoadDelayTimer invalidate];
    self.tableDataLoadDelayTimer = nil;
    
    NSArray* indexPathsForVisibleRows = [self.tableView indexPathsForVisibleRows];
    [self performActualFetchTableCellDataForIndexPaths:indexPathsForVisibleRows];
}

- (void)performActualFetchTableCellDataForIndexPaths:(NSArray*)indexPaths
{
    for (NSIndexPath* indexPath in indexPaths) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [NSThread sleepForTimeInterval:0.2];  // emulation of time-consuming and thread-blocking operation
            NSString* value = [NSString stringWithFormat:@"Text at cell #%ld", (long)indexPath.row];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableData[indexPath.row] = value;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        });
    }
}

#pragma mark UITableViewDataSource protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (self.tableData.count - 1)) {
        for (NSUInteger i = 0; i < 20; i++) {
            [self.tableData addObject:self.tableElementPlaceholder];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    NSString* text = [self.tableData objectAtIndex:indexPath.row];
    if (text.length == 0) {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        cell.label.hidden = YES;
        [self fetchTableCellDataForIndexPath:indexPath];
    } else {
        [cell.activityIndicator stopAnimating];
        cell.activityIndicator.hidden = YES;
        cell.label.hidden = NO;
        cell.label.text = text;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
