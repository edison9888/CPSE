//
//  ExhibitorInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorInfoViewController.h"
#import "UIColor+BR.h"
#import "UIImageView+AFNetworking.h"
#import "Exhibitor.h"
#import "MBProgressHUD.h"

@interface ExhibitorInfoViewController ()
{
    NSInteger _id;
    Exhibitor *_exhibitor;
    
    UIScrollView *_scrollView;
    UILabel *_descLabel;

    UIImageView *_logoView;
    UIActivityIndicatorView *_activityIndicator;
    UIView *_loadingView;
    
    NSString *_callingNumber;
}
@end

@implementation ExhibitorInfoViewController

- (id)initWithId:(NSInteger)exhibitorId {
    if (self = [super init]) {
        _id = exhibitorId;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 300, 80)];
    _logoView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_logoView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = _logoView.frame;
    [_scrollView addSubview:_activityIndicator];

    _descLabel = [[UILabel alloc] init];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_descLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, CGRectGetHeight(self.view.bounds));
    [_loadingView addSubview:indicator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 220, CGRectGetHeight(self.view.bounds))];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"正在努力加载数据";
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.view addSubview:_loadingView];
    
    [_activityIndicator startAnimating];
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=ccinfo&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  [_loadingView removeFromSuperview];
                  
                  _exhibitor = [[Exhibitor alloc] initWithAttributes:JSON[@"data"]];
                  [self populateInterface];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)populateInterface {
    CGRect rect = _scrollView.bounds;
    
    // set logo
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_exhibitor.logo]];
    [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __block UIImageView *imageView = _logoView;
    __block UIActivityIndicatorView *indicator = _activityIndicator;
    [_logoView setImageWithURLRequest:req
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                   imageView.image = image;
                                   [indicator stopAnimating];
                                   [indicator removeFromSuperview];
                               }
                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                   DLog(@"error: %@", [error description]);
                                   [indicator stopAnimating];
                                   [indicator removeFromSuperview];
                               }];
    
    CGFloat topOffset = 110.f;
    
    // name
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"企业名称：";
    CGSize capSize = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = _exhibitor.name;
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    topOffset += size.height + 5;
    
    // product
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"展品信息：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = _exhibitor.product;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    topOffset += size.height + 5;
    
    // area
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"参展范围：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = _exhibitor.area;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    topOffset += size.height + 5;
    
    // location
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"展位号：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = _exhibitor.location;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    topOffset += size.height + 5;
    
    // email
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"E-mail：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x0000ff];
    label.text = _exhibitor.email;
    label.userInteractionEnabled = YES;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmail:)];
    [label addGestureRecognizer:gesture];
    
    topOffset += size.height + 5;
    
    // phone
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"联系电话：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x0000ff];
    label.text = _exhibitor.phone;
    label.userInteractionEnabled = YES;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhone:)];
    [label addGestureRecognizer:gesture];
    
    topOffset += size.height + 5;
    
    // address
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = @"联系地址：";
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = _exhibitor.address;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width, size.height);
    [_scrollView addSubview:label];
    
    topOffset += size.height + 10;
    
        
    NSString *desc = _exhibitor.description;
    size = [desc sizeWithFont:_descLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descLabel.text = desc;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(_descLabel.frame)+10);
}

- (void)tapEmail:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    vc.mailComposeDelegate = self;
    [vc setSubject:@"问询"];
    [vc setToRecipients:@[label.text]];
    [vc setMessageBody:@"你好，我从安防网看到了贵公司信息，" isHTML:NO];
    [self presentModalViewController:vc animated:YES];
}

- (void)tapPhone:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    _callingNumber = [label.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *numbers = [_callingNumber componentsSeparatedByString:@" "];
    if ([numbers count] == 0)
        return;
    
    UIActionSheet *actionSheet;
    if ([numbers count] == 1) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"呼叫"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], nil];
    }
    else if ([numbers count] == 2) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"呼叫"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], numbers[1], nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"呼叫"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], numbers[1], numbers[2], nil];
    }
    [actionSheet showInView:self.view];
}


#pragma mark - MFMailComposeViewControllerDelegate
#pragma mark -
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"取消发送";
            break;
        case MFMailComposeResultSaved:
            message = @"邮件已保存";
            break;
        case MFMailComposeResultSent:
            message = @"已发送";
            break;
        case MFMailComposeResultFailed:
            message = @"发送失败";
            break;
        default:
            message = @"未发送";
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:.7];
}

#pragma mark - UIActionSheetDelegate
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray *numbers = [_callingNumber componentsSeparatedByString:@" "];
    if (buttonIndex < actionSheet.numberOfButtons - 1) {
        NSString *tel = [NSString stringWithFormat:@"tel://%@", numbers[buttonIndex]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *tel = [NSString stringWithFormat:@"tel://%@", _callingNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}

@end