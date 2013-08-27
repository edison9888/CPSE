//
//  WebViewController.h
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface WebViewController : BaseChannelViewController <UIWebViewDelegate>

- (id)initWithUrl:(NSString *)url;

@end