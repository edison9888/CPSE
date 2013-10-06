//
//  ChannelIconButton.m
//  CPSE
//
//  Created by Lei Perry on 7/14/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChannelIconButton.h"
#import "UIColor+BR.h"

@implementation ChannelIconButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, .5);
        self.layer.shadowOpacity = .7;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.shadowRadius = 1.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // adjust button height per 3.5/4.0 inch screen
    CGFloat adjust = 0;
    if (CGRectGetHeight(self.frame) < 80)
        adjust = 7;
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 - adjust);
//    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame) - 15 + adjust*.5);
    
    CGFloat height = 30 - adjust * .7;
    self.titleLabel.frame = CGRectMake(5, CGRectGetHeight(self.frame)-height, CGRectGetWidth(self.frame)-10, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithHex:0xdddddd];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = [UIColor whiteColor];
}

@end