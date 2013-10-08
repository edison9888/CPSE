//
//  ExhibitorInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "UIColor+BR.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface AccountInfoViewController ()
{
    NSInteger _userId;
    NSString* _userName;
    
    UIScrollView *_scrollView;
    UILabel *_cardNoLabel;
    UILabel *_userNameLabel;
    UILabel *_operationLabel;
    
    UIImageView *_qrCodeImageView;
}
@end

@implementation AccountInfoViewController

- (id)initWithAccount:(Account*)account {
    if (self = [super init]) {
        _userId = account.id;
        _userName = account.name;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont systemFontOfSize:16];
    _userNameLabel.numberOfLines = 0;
    _userNameLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_userNameLabel];
    
    _cardNoLabel = [[UILabel alloc] init];
    _cardNoLabel.backgroundColor = [UIColor clearColor];
    _cardNoLabel.font = [UIFont systemFontOfSize:16];
    _cardNoLabel.numberOfLines = 0;
    _cardNoLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_cardNoLabel];
    
    _operationLabel = [[UILabel alloc] init];
    _operationLabel.backgroundColor = [UIColor clearColor];
    _operationLabel.font = [UIFont systemFontOfSize:14];
    _operationLabel.numberOfLines = 0;
    _operationLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_operationLabel];
    
    _qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, 0, 200, 200)];
    _qrCodeImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_qrCodeImageView];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbum)];
    [_qrCodeImageView addGestureRecognizer:gesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateInterface];
}

- (void)populateInterface {
    CGRect rect = _scrollView.bounds;
    CGFloat topOffset = 20.f;
    
    /*------------------------
     _userNameLabel
     ------------------------*/
    NSString *info = [NSString stringWithFormat :@"%@：%@", NSLocalizedString(@"User Name", nil), _userName];
    CGSize size = [info sizeWithFont:_userNameLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _userNameLabel.frame = CGRectMake(_scrollView.frame.size.width/2-size.width/2, topOffset, size.width, size.height);
    _userNameLabel.text = info;
    topOffset += size.height + 10;
    
    

    /*------------------------
     QR code
     ------------------------*/
    _qrCodeImageView.center = CGPointMake(_scrollView.frame.size.width/2, topOffset + _qrCodeImageView.frame.size.height/2);
    
    NSString *qrCode = [NSString stringWithFormat:@"v:%@", DataMgr.currentAccount.cardNumber];
    UIImage* qrcodeImage = [QRCodeGenerator qrImageForString:qrCode imageSize:_qrCodeImageView.bounds.size.width];
    _qrCodeImageView.image = qrcodeImage;
    topOffset += _qrCodeImageView.frame.size.height + 10;
    
    
    /*------------------------
     _userIdLabel
     ------------------------*/
    info = [NSString stringWithFormat :@"%@：%@", NSLocalizedString(@"Card Number", nil), DataMgr.currentAccount.cardNumber];
    size = [info sizeWithFont:_cardNoLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _cardNoLabel.frame = CGRectMake(CGRectGetMinX(_qrCodeImageView.frame), topOffset, size.width, size.height);
    _cardNoLabel.text = info;
    topOffset += size.height + 10;
    
    /*------------------------
     _operationLabel
     ------------------------*/
    info = NSLocalizedString(@"Barcode for Admission Identification, Long Press to Save", nil);
    size = [info sizeWithFont:_operationLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _operationLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _operationLabel.text = info;
    topOffset += size.height + 10;
    
 
    /*------------------------
     _descriptionLabel
     ------------------------*/
    // 1st paragraph
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"%@\n\n", NSLocalizedString(@"Thanks for your pre-registration to visit the CPSE 2013. To facilitate your success in admission, please follow the following procedure to receive your visit card:", nil)];
    [desc appendFormat:@"1、%@\n", NSLocalizedString(@"To get the two-dimension code via “Visit Application” on your phone.", nil)];
    [desc appendFormat:@"2、%@\n\n", NSLocalizedString(@"To receive your visit card after sweeping your two-dimension code at the pre-registration desk.", nil)];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x999999];
    [_scrollView addSubview:label];

    size = [desc sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10, topOffset, size.width, size.height);
    label.text = desc;
    topOffset += size.height;
    
    // 2nd paragraph
    desc = [NSMutableString string];
    [desc appendFormat:@"%@\n\n", NSLocalizedString(@"Thanks for your registration of CPS member.This account and two-dimension code is your  permit for CPS website, as well as for other activities organized by CPS and more member services.", nil)];
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0xff0000];
    [_scrollView addSubview:label];
    
    size = [desc sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10, topOffset, size.width, size.height);
    label.text = desc;
    topOffset += size.height;
    
    // 3rd paragraph
    desc = [NSMutableString string];
    [desc appendFormat:@"%@：\n%@：\n%@ 09:30\n\n", NSLocalizedString(@"Exhibition Time", nil), NSLocalizedString(@"Opening Ceremony", nil), NSLocalizedString(@"Oct 29", nil)];
    [desc appendFormat:@"%@：\n%@ 09:30 – 17:00\n%@ 09:30 – 17:00\n%@ 09:30 – 17:00\n%@ 09:30 – 12:00\n\n", NSLocalizedString(@"Date", nil), NSLocalizedString(@"Oct 29", nil), NSLocalizedString(@"Oct 30", nil), NSLocalizedString(@"Oct 31", nil), NSLocalizedString(@"Nov 01", nil)];
    [desc appendFormat:@"%@：\n%@\n\n", NSLocalizedString(@"Location", nil), NSLocalizedString(@"Shenzhen Convention & Exhibition Centre, China",  nil)];
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHex:0x999999];
    [_scrollView addSubview:label];
    
    size = [desc sizeWithFont:label.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10, topOffset, size.width, size.height);
    label.text = desc;
    topOffset += size.height;
    
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(label.frame) + 10);
}

- (void)saveToAlbum {
    UIImageWriteToSavedPhotosAlbum(_qrCodeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        DLog(@"%@", error.description);
    }
    else {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"Saved to Album", nil);
        [hud show:YES];
        [hud hide:YES afterDelay:.7];
    }
}

@end