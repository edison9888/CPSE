//
//  ExhibitorInfoViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "BaseChannelViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ExhibitorInfoViewController : BaseChannelViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

- (id)initWithId:(NSInteger)exhibitorId;

@end