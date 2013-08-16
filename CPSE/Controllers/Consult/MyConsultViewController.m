//
//  MyConsultViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/15/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "MyConsultViewController.h"
#import "UIColor+BR.h"

@interface MyConsultViewController ()
{
    UIScrollView *_scrollView;
    UITextView *_textView;
}
@end

@implementation MyConsultViewController

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    CGFloat topOffset = 15;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"咨询内容";
    [_scrollView addSubview:label];
    CGSize size = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(10, topOffset, size.width, size.height);
    topOffset += size.height + 10;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, topOffset, 300, 150)];
    _textView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_textView];
    topOffset += 160;
    
    CGRect rect = self.view.bounds;
    UIImage *buttonBg = [UIImage imageNamed:@"red-button-bg"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.frame = CGRectMake(CGRectGetWidth(rect)/2-buttonBg.size.width/2, topOffset, buttonBg.size.width, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setTitle:@"提交咨询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
}

- (void)submitInquiry {
    
}

@end