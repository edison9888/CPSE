//
//  VenueCellView.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VenueCellView.h"
#import "UIColor+BR.h"

@interface VenueCellView ()
{
    UIColor *_color;
}
@end

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
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if (_color == nil)
        _color = backgroundColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [_color darkerColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = _color;
    if (self.tapHandler)
        self.tapHandler();
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = _color;
}

@end