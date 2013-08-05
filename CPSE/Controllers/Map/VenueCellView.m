//
//  VenueCellView.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VenueCellView.h"

@implementation VenueCellView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title subtitle:(NSString *)subtitle {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.text = title;
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        label.layer.shadowOpacity = .5;
        label.layer.shadowOffset = CGSizeMake(0, 2);
        [self addSubview:label];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-30, CGRectGetWidth(self.bounds), 30)];
        subLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        subLabel.backgroundColor = [UIColor clearColor];
        subLabel.font = [UIFont systemFontOfSize:12];
        subLabel.text = subtitle;
        subLabel.textAlignment = UITextAlignmentCenter;
        subLabel.textColor = [UIColor whiteColor];
        [self addSubview:subLabel];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCell:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)tapOnCell:(UIGestureRecognizer *)gesture {
    DLog(@"tap on cell");
    if (self.tapHandler)
        self.tapHandler();
}

@end