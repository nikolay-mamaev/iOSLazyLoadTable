//
//  TableViewCell.h
//  LazyLoadTable
//
//  Created by Nikolay Mamaev on 6/15/14.
//  Copyright (c) 2014 Nikolay Mamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
