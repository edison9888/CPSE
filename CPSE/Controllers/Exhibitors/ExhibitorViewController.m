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
#import "ExhibitorListViewController.h"
#import "AFHTTPRequestOperation.h"

@interface ExhibitorViewController ()
{
    UISearchBar *_searchBar;
    ExhibitorListViewController *_resultList;
}
@end

@implementation ExhibitorViewController

- (id)init {
    if (self = [super init]) {
        ExhibitorsByAlphabetViewController *vc1 = [[ExhibitorsByAlphabetViewController alloc] init];
        ExhibitorsByIndustryViewController *vc2 = [[ExhibitorsByIndustryViewController alloc] init];
        ExhibitorsByAreaViewController *vc3 = [[ExhibitorsByAreaViewController alloc] init];
        
        vc1.title = NSLocalizedString(@"Search alphabetically", nil);
        vc2.title = NSLocalizedString(@"Search by Category", nil);
        vc3.title = NSLocalizedString(@"Search by Area", nil);
        
        self.viewControllers = @[vc1, vc2, vc3];
        
        _resultList = [[ExhibitorListViewController alloc] init];
        _resultList.owner = self;
        [_resultList setData:@[@{@"name": NSLocalizedString(@"Please enter keyword", nil)}]];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = NSLocalizedString(@"enter name or first character to search", nil);
    self.headerView = _searchBar;
    
    UIToolbar *_keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    barButtonItem.tintColor = [UIColor blueColor];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:flex, barButtonItem, nil];
    [_keyboardToolbar setItems:items];
    _searchBar.inputAccessoryView = _keyboardToolbar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_resultList.table deselectRowAtIndexPath:[_resultList.table indexPathForSelectedRow]  animated:YES];
}

- (void)tapLeftBarButton {
    if (_resultList.view.superview != nil) {
        [_searchBar resignFirstResponder];
        [_resultList.view removeFromSuperview];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dismissKeyboard:(id)sender {
	[_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
#pragma mark -
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (_resultList.view.superview == nil) {
        _resultList.view.frame = CGRectMake(0, 44, 320, CGRectGetHeight(self.view.frame)-44);
        [self.view addSubview:_resultList.view];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self cancelPreviousSearch];
    if (isEmpty(searchText)) {
        [_resultList setData:@[@{@"name": NSLocalizedString(@"Please enter keyword", nil)}]];
    }
    else {
        [_resultList setData:@[@{@"name": @"正在搜索..."}]];
        NSString *q = [NSString stringWithFormat:@"api.php?language_type=%@&action=search&type=name&q=%@",
                       NSLocalizedString(@"language_type", nil),
                       [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [AFClient getPath:q
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      if (isEmpty(JSON[@"data"]))
                          [_resultList setData:@[@{@"name": NSLocalizedString(@"no matching result found :(", nil)}]];
                      else
                          [_resultList setData:JSON[@"data"]];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"error: %@", [error description]);
                  }];
    }
}

- (void)cancelPreviousSearch {
    for (NSOperation *operation in [AFClient.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        [operation cancel];
    }
}

@end