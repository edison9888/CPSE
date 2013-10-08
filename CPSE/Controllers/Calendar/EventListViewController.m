//
//  EventListViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EventListViewController.h"
#import "EventTableViewCell.h"
#import "EventInfoViewController.h"
#import "EventModel.h"

@interface EventListViewController ()
{
}
@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)setData:(NSArray *)data {
    _data = data;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    EventModel *eventModel = _data[indexPath.row];
    cell.textLabel.text = eventModel.timeExpression;
    cell.detailTextLabel.text = eventModel.description;
    
    if (eventModel.eventType == EventTypeOfficial)
        cell.imageView.image = [UIImage imageNamed:@"icon-logo"];
    else
        cell.imageView.image = [UIImage imageNamed:@"icon-speaker"];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size1 = [@"00:00" sizeWithFont:[UIFont systemFontOfSize:15]];
    EventModel *eventModel = _data[indexPath.row];
    CGSize size2 = [eventModel.description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(320-size1.width-64, CGFLOAT_MAX)];
    return MAX(44, size2.height+20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventModel *eventModel = _data[indexPath.row];
    EventInfoViewController *vc = [[EventInfoViewController alloc] initWithId:eventModel.id];
    vc.title = NSLocalizedString(@"Event Info", nil);
    [self.ownerController.navigationController pushViewController:vc animated:YES];
}


@end