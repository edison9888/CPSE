//
//  MyConsultViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/15/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "MyConsultViewController.h"
#import "UIColor+BR.h"
#import "ConsultTableViewCell.h"
#import "ConsultModel.h"
#import "ConsultSetModel.h"

#define kPlaceHolderText @"请在此填写您的咨询内容，客服将为您解答"

@interface MyConsultViewController ()
{
    UIScrollView *_scrollView;
    UITextView *_textView;
    UITableView *_tableView;
    UIView *_loadingView;

    NSMutableArray *_consultSets;
}
@end

@implementation MyConsultViewController

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
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
    _textView.delegate = self;
    _textView.text = kPlaceHolderText;
    _textView.textColor = [UIColor lightGrayColor];
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
    [button addTarget:self action:@selector(submitInquiry) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    topOffset += buttonBg.size.height + 20;
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"历史咨询";
    [_scrollView addSubview:label];
    size = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(10, topOffset, size.width, size.height);
    topOffset += size.height + 10;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topOffset, 320, 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHex:0xffffff];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, 44);
    [_loadingView addSubview:indicator];
    label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 220, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"正在努力加载数据";
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [_tableView addSubview:_loadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=consultlist&username=%@", DataMgr.currentAccount.name]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      _consultSets = [NSMutableArray array];
                      
                      NSArray *allFaqs = JSON[@"data"];
                      for (NSDictionary *faq in allFaqs) {
                          ConsultSetModel *set = [[ConsultSetModel alloc] initWithId:[faq[@"id"] intValue] andAttributes:faq];
                          [_consultSets addObject:set];
                      }
                      [_tableView reloadData];
                      [_loadingView removeFromSuperview];
                      
                      // update ui
                      CGRect frame = _tableView.frame;
                      frame.size.height = _tableView.contentSize.height;
                      _tableView.frame = frame;
                      _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(frame));
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)submitInquiry {
    if ([_textView.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入咨询内容" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [_textView becomeFirstResponder];
        return;
    }
    
    [_textView resignFirstResponder];
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        NSString *q = [NSString stringWithFormat:@"api.php?action=consult&username=%@&email=%@&content=%@",
                       DataMgr.currentAccount.name,
                       [DataMgr.currentAccount.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                       [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [AFClient getPath:q
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      if ([JSON[@"errno"] boolValue]) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                      }
                      else {
                          NSDictionary *dict = @{@"data":@{
                                                         @"id": @0,
                                                         @"user_name": DataMgr.currentAccount.name,
                                                         @"content": _textView.text,
                                                         @"add_time": @([[NSDate date] timeIntervalSince1970])
                                                         }};
                          ConsultSetModel *consultSet = [[ConsultSetModel alloc] initWithId:0 andAttributes:dict];
                          CGFloat deltaHeight = [ConsultTableViewCell heightForConsultSet:consultSet];
                          [_consultSets insertObject:consultSet atIndex:0];
                          NSUInteger ii[2] = {0, 0};
                          NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                          [_tableView beginUpdates];
                          [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                          [_tableView endUpdates];
                          
                          // update ui
                          dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                              NSUInteger iiTop[2] = {0, 1};
                              NSIndexPath* indexPathTop = [NSIndexPath indexPathWithIndexes:iiTop length:2];
                              [_tableView reloadRowsAtIndexPaths:@[indexPathTop] withRowAnimation:UITableViewRowAnimationAutomatic];

                              CGRect frame = _tableView.frame;
                              frame.size.height += deltaHeight;
                              _tableView.frame = frame;
                              _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(frame));
                          });
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"error: %@", [error description]);
                  }];
    });
}

#pragma mark - UIScrollViewDelegate
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
#pragma mark -
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceHolderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = kPlaceHolderText;
        textView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_consultSets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ConsultSetModel *set = _consultSets[indexPath.row];
    cell.consultSet = set;
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsultSetModel *set = _consultSets[indexPath.row];
    return [ConsultTableViewCell heightForConsultSet:set];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end