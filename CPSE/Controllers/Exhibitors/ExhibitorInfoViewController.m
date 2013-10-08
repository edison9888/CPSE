//
//  ExhibitorInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ExhibitorInfoViewController.h"
#import "UIColor+BR.h"
#import "UIImage+BR.h"
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
    label.text = NSLocalizedString(@"Retrieving data", nil);
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.view addSubview:_loadingView];
    
    [_activityIndicator startAnimating];
    [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=ccinfo&id=%d", NSLocalizedString(@"language_type", nil), _id]
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
    label.text = NSLocalizedString(@"corp_name", nil);
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
    label.text = NSLocalizedString(@"corp_exhibits", nil);
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
    label.text = NSLocalizedString(@"corp_scope", nil);
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
    label.text = NSLocalizedString(@"corp_location", nil);
    label.frame = CGRectMake(10, topOffset, capSize.width, capSize.height);
    [_scrollView addSubview:label];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithHex:0xc9071e];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = _exhibitor.location;
    label.userInteractionEnabled = YES;
    size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20-capSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.layer.cornerRadius = size.height/2.0;
    label.frame = CGRectMake(10+capSize.width, topOffset, size.width+10, size.height);
    [_scrollView addSubview:label];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapExhibition:)];
    [label addGestureRecognizer:gesture];
    
    topOffset += size.height + 5;
    
    // email
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = NSLocalizedString(@"corp_mailbox", nil);
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
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmail:)];
    [label addGestureRecognizer:gesture];
    
    topOffset += size.height + 5;
    
    // phone
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHex:0x666666];
    label.text = NSLocalizedString(@"corp_phone", nil);
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
    label.text = NSLocalizedString(@"corp_address", nil);
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
    
    // buttons
    UIImage *buttonBg = [[UIImage imageNamed:@"red-button-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    UIImage *selectedButtonBg = [buttonBg imageTintedWithColor:[UIColor colorWithHex:0xee2222]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, topOffset, 100, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setBackgroundImage:selectedButtonBg forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"Company Info", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleDetailPanel:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(170, topOffset, 100, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setBackgroundImage:selectedButtonBg forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"Favorite", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(starOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    topOffset += buttonBg.size.height + 10;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, topOffset);
    
    NSString *desc = _exhibitor.description;
    size = [desc sizeWithFont:_descLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descLabel.text = desc;
    _descLabel.hidden = YES;
}

- (void)tapExhibition:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    DLog(@"%@", label.text);
}

- (void)tapEmail:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    vc.mailComposeDelegate = self;
    [vc setSubject:NSLocalizedString(@"corp_enquiry", nil)];
    [vc setToRecipients:@[label.text]];
    [vc setMessageBody:NSLocalizedString(@"corp_enquiry_body", nil) isHTML:NO];
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
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"corp_calling", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], nil];
    }
    else if ([numbers count] == 2) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"corp_calling", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], numbers[1], nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"corp_calling", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:numbers[0], numbers[1], numbers[2], nil];
    }
    [actionSheet showInView:self.view];
}

- (void)toggleDetailPanel:(UIButton *)button {
    CGSize size = _scrollView.contentSize;
    if (_descLabel.hidden) {
        _descLabel.hidden = NO;
        size.height += _descLabel.frame.size.height + 10;
        _scrollView.contentSize = size;
    }
    else {
        _descLabel.hidden = YES;
        size.height -= _descLabel.frame.size.height + 10;
        _scrollView.contentSize = size;
    }
}

- (void)starOrNot:(UIButton *)button {
    
}

#pragma mark - MFMailComposeViewControllerDelegate
#pragma mark -
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = NSLocalizedString(@"corp_mail_cancel", nil);
            break;
        case MFMailComposeResultSaved:
            message = NSLocalizedString(@"corp_mail_saved", nil);
            break;
        case MFMailComposeResultSent:
            message = NSLocalizedString(@"corp_mail_sent", nil);
            break;
        case MFMailComposeResultFailed:
            message = NSLocalizedString(@"corp_mail_failed", nil);
            break;
        default:
            message = NSLocalizedString(@"corp_mail_unsent", nil);
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