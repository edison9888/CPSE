//
//  ExhibitNewsViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface NewsListViewController : UITableViewController <EGORefreshTableDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
}

- (id)initWithType:(NSString *)newstype;

@end