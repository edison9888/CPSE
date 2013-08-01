//
//  BaseEntryViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface BaseEntryViewController : BaseChannelViewController <UITextFieldDelegate>

@property (nonatomic, readonly) UITableView *tableView;

- (void)updatePrevNextStatus;

- (UITextField *)createTextEntryWithTag:(NSUInteger)tag;

- (UITextField *)findNextElementToFocusOn;

- (UITextField *)findPreviousElementToFocusOn;

- (BOOL)handleActionBarDone:(UIBarButtonItem *)doneButton;

@end