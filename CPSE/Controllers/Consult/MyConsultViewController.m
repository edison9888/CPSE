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
    
    NSMutableArray *_questions;
    NSMutableArray *_questionIndices;
    NSMutableDictionary *_answers;
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topOffset, 320, 0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:@"api.php?action=consultlist"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      _questions = [NSMutableArray array];
                      _questionIndices = [NSMutableArray array];
                      _answers = [NSMutableDictionary dictionary];
                      
                      NSDictionary *allFaqs = JSON[@"data"];
                      int idx = 0;
                      for (NSDictionary *faq in allFaqs.allValues) {
                          [_questions addObject:faq[@"data"]];
                          [_questionIndices addObject:@(idx)];
                          
                          NSArray *replies = faq[@"replay"];
                          if (isEmpty(replies))
                              replies = @[];
                          [_answers setObject:replies forKey:faq[@"data"][@"id"]];
                          idx += 1 + [replies count];
                      }
                      [_tableView reloadData];
                      
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
        NSString *q = [NSString stringWithFormat:@"api.php?action=consult&username=%@&content=%@",
                       DataMgr.currentAccount.name, [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [AFClient getPath:q
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      if ([JSON[@"errno"] boolValue]) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                      }
                      else {
                          
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
    int count = 0;
    for (int i=0; i<[_questions count]; i++) {
        count++;
        NSArray *replies = _answers.allValues[i];
        count += [replies count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (int i=0; i<[_questions count]; i++) {
        int idx = [_questionIndices[i] intValue];
        if (idx == indexPath.row) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d, %@", [[_questions[i] objectForKey:@"id"] intValue], [_questions[i] objectForKey:@"content"]];
            break;
        }
        else if (idx > indexPath.row) {
            int lastIdx = [_questionIndices[i-1] intValue];
            int delta = indexPath.row - lastIdx;
            NSArray *replies = _answers[_questions[i-1][@"id"]];
            cell.textLabel.text = [NSString stringWithFormat:@"回复：%@", replies[delta-1][@"content"]];
            break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end