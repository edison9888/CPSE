//
//  ItemPickerViewController.h
//  CPSE
//
//  Created by Lei Perry on 8/2/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface ItemPickerViewController : BaseChannelViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithDataSource:(NSArray *)data multipleSelectable:(BOOL)multiple;

@end