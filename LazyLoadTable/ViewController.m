//
//  ViewController.m
//  LazyLoadTable
//
//  Created by Nikolay Mamaev on 6/15/14.
//  Copyright (c) 2014 Nikolay Mamaev. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

const NSUInteger kTableSizeIncrement = 20;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* tableData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) id tableElementPlaceholder;

- (void)fetchTableCellDataForIndexPath:(NSIndexPath*)indexPath;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray arrayWithCapacity:20];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableData setObject:[NSString stringWithFormat:@"Text at cell #%d", indexPath.row] atIndexedSubscript:indexPath.row];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    });
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
    
    if (cell == nil) {
        cell = [[TableViewCell alloc] init];
    }
    
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