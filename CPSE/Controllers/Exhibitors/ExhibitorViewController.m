//
//  ExhibitorViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorViewController.h"
#import "ExhibitorsByAlphabetViewController.h"
#import "ExhibitorsByAreaViewController.h"
#import "ExhibitorsByIndustryViewController.h"
#import "UIView+BR.h"

@interface ExhibitorViewController ()
{
    UISearchBar *_searchBar;
    UIToolbar *_keyboardToolbar;
}
@end

@implementation ExhibitorViewController

- (id)init {
    if (self = [super init]) {
        ExhibitorsByAlphabetViewController *vc1 = [[ExhibitorsByAlphabetViewController alloc] init];
        ExhibitorsByIndustryViewController *vc2 = [[ExhibitorsByIndustryViewController alloc] init];
        ExhibitorsByAreaViewController *vc3 = [[ExhibitorsByAreaViewController alloc] init];
        
        vc1.title = @"按字母搜索";
        vc2.title = @"按行业搜索";
        vc3.title = @"按地区搜索";
        
        self.viewControllers = @[vc1, vc2, vc3];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = @"输入全称或首字母查询";
    self.headerView = _searchBar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _keyboardToolbar = nil;
}

- (void)dismissKeyboard:(id)sender
{
	[[self.view findFirstResponder] resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect beginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
	if (nil == _keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        _keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
        barButtonItem.tintColor = [UIColor blueColor];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [[NSArray alloc] initWithObjects:flex, barButtonItem, nil];
        [_keyboardToolbar setItems:items];
        
        _keyboardToolbar.frame = CGRectMake(beginRect.origin.x,
                                            beginRect.origin.y,
                                            _keyboardToolbar.frame.size.width,
                                            _keyboardToolbar.frame.size.height);
        [self.view addSubview:_keyboardToolbar];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y-108,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

@end