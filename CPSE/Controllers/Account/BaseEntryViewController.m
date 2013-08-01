//
//  BaseEntryViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseEntryViewController.h"

@interface BaseEntryViewController ()

@property (nonatomic, assign) BOOL resizeWhenKeyboardPresented;
@property (nonatomic, strong) UIToolbar *actionBar;

- (UITextField *)getTextEntryWithTag:(NSUInteger)tag;

@end

@implementation BaseEntryViewController
{
    UISegmentedControl *_prevNext;
    NSMutableArray *_textEntries;
    UITextField *_actingEntry;
    
    BOOL _keyboardVisible;
    BOOL _viewOnScreen;
}

- (id)init {
    if (self = [super init]) {
        _resizeWhenKeyboardPresented = YES;
        _textEntries = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    _viewOnScreen = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_resizeWhenKeyboardPresented) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    _viewOnScreen = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIToolbar *)actionBar {
    if (_actionBar == nil) {
        _actionBar = [[UIToolbar alloc] init];
        _actionBar.translucent = YES;
        [_actionBar sizeToFit];
        _actionBar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(handleActionBarDone:)];
        
        _prevNext = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Previous", @""), NSLocalizedString(@"Next", @"")]];
        _prevNext.momentary = YES;
        _prevNext.segmentedControlStyle = UISegmentedControlStyleBar;
        _prevNext.tintColor = _actionBar.tintColor;
        [_prevNext addTarget:self action:@selector(handleActionBarPreviousNext:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *prevNextWrapper = [[UIBarButtonItem alloc] initWithCustomView:_prevNext];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [_actionBar setItems:@[prevNextWrapper, flexible, doneButton]];
    }
    return _actionBar;
}

- (UITextField *)getTextEntryWithTag:(NSUInteger)tag {
    for (int i=0; i<[_textEntries count]; i++) {
        UITextField *entry = _textEntries[i];
        if (entry.tag == tag)
            return entry;
    }
    return nil;
}

- (UITextField *)createTextEntryWithTag:(NSUInteger)tag {
    UITextField *textField = [self getTextEntryWithTag:tag];
    if (textField != nil)
        return textField;
    
    textField = [[UITextField alloc] init];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;

    textField.tag = tag;
    int idx = 0;
    for (int i=0; i<[_textEntries count]; i++) {
        UITextField *entry = _textEntries[i];
        if (entry.tag > tag)
            break;
        idx = i;
    }
    [_textEntries insertObject:textField atIndex:idx];
    
    textField.inputAccessoryView = self.actionBar;
    return textField;
}

- (void)handleActionBarPreviousNext:(UISegmentedControl *)control {
	UITextField *element;
    const BOOL isNext = control.selectedSegmentIndex == 1;
    if (isNext) {
		element = [self findNextElementToFocusOn];
	}
    else {
		element = [self findPreviousElementToFocusOn];
	}
    
	[element becomeFirstResponder];
    [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (void)updatePrevNextStatus {
    [_prevNext setEnabled:[self findPreviousElementToFocusOn]!=nil forSegmentAtIndex:0];
    [_prevNext setEnabled:[self findNextElementToFocusOn]!=nil forSegmentAtIndex:1];
}

- (BOOL)handleActionBarDone:(UIBarButtonItem *)doneButton {
    [_actingEntry endEditing:YES];
    [_actingEntry endEditing:NO];
    [_actingEntry resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    return NO;
}

- (UITextField *)findPreviousElementToFocusOn {
    if (_actingEntry == nil)
        return nil;
    
    UITextField *previousElement = nil;
    for (int i=[_textEntries count]-1; i>=0; i--) {
        previousElement = _textEntries[i];
        if (previousElement.tag < _actingEntry.tag)
            return previousElement;
    }
    return nil;
}

- (UITextField *)findNextElementToFocusOn {
    if (_actingEntry == nil)
        return nil;
    
    UITextField *nextElement = nil;
    for (int i=0; i<[_textEntries count]; i++) {
        nextElement = _textEntries[i];
        if (nextElement.tag > _actingEntry.tag)
            return nextElement;
    }
    return nil;
}

- (void)resizeForKeyboard:(NSNotification*)notification {
    if (!_viewOnScreen)
        return;
    
    BOOL up = notification.name == UIKeyboardWillShowNotification;
    
    if (_keyboardVisible == up)
        return;
    
    _keyboardVisible = up;
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
                         const UIEdgeInsets oldInset = self.scrollView.contentInset;
                         CGFloat bottom = up ? keyboardFrame.size.height : 0;
                         self.scrollView.contentInset = UIEdgeInsetsMake(oldInset.top, oldInset.left,  bottom, oldInset.right);
                         self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
                     }
                     completion:NULL];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSUInteger ii[2] = {0, textField.tag};
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
        rect = [self.tableView convertRect:rect toView:self.scrollView];
        [self.scrollView scrollRectToVisible:rect animated:YES];
        
        _actingEntry = textField;
        [self updatePrevNextStatus];
    });
    
    
    if (textField.returnKeyType == UIReturnKeyDefault) {
        UIReturnKeyType returnType = ([self findNextElementToFocusOn]!=nil) ? UIReturnKeyDone : UIReturnKeyNext;
        textField.returnKeyType = returnType;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    UITextField *element = [self findNextElementToFocusOn];
    if (element != nil){
        [element becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end