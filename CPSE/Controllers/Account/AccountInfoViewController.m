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
    UILabel *_descriptionLabel;
    UILabel *_operationLabel;
    
    UIImageView *_qrCodeImageView;
    UIActivityIndicatorView *_qrCodeImageLoadingIndicator;
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
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textColor = [UIColor colorWithHex:0x999999];
    [_scrollView addSubview:_descriptionLabel];
    
    _qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, 0, 200, 200)];
    _qrCodeImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_qrCodeImageView];
    
    _qrCodeImageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _qrCodeImageLoadingIndicator.frame = _qrCodeImageView.bounds;
    [_qrCodeImageView addSubview:_qrCodeImageLoadingIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self populateInterface];
}

- (void)populateInterface {
    CGRect rect = _scrollView.bounds;
    CGFloat topOffset = 20.f;
    
    /*------------------------
     _userNameLabel
     ------------------------*/
    NSString *info = [NSString stringWithFormat :@"用户名：%@", _userName];
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
    
//    [_qrCodeImageLoadingIndicator startAnimating];
//    
//    __block UIActivityIndicatorView *indicator = _qrCodeImageLoadingIndicator;
//    __block AccountInfoViewController *controller = self;
//    __block UIImageView *imageView = _qrCodeImageView;
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:DataMgr.currentAccount.qrCodeImageUrl]];
//    [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//    [_qrCodeImageView setImageWithURLRequest:req
//                      placeholderImage:nil
//                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                                   [indicator removeFromSuperview];
//                                   imageView.image = image;
//                                   
//                                   UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:controller action:@selector(saveToAlbum)];
//                                   [imageView addGestureRecognizer:gesture];
//                               }
//                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){}];
    topOffset += _qrCodeImageView.frame.size.height + 10;
    
    
    /*------------------------
     _userIdLabel
     ------------------------*/
    info = [NSString stringWithFormat :@"卡号：%@", DataMgr.currentAccount.cardNumber];
    size = [info sizeWithFont:_cardNoLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _cardNoLabel.frame = CGRectMake(CGRectGetMinX(_qrCodeImageView.frame), topOffset, size.width, size.height);
    _cardNoLabel.text = info;
    topOffset += size.height + 10;
    
    /*------------------------
     _operationLabel
     ------------------------*/
    info = [NSString stringWithFormat :@"条形码作为入场标识 长按进行保存"];
    size = [info sizeWithFont:_operationLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _operationLabel.frame = CGRectMake(_scrollView.frame.size.width/2-size.width/2, topOffset, size.width, size.height);
    _operationLabel.text = info;
    topOffset += size.height + 10;
    
 
    /*------------------------
     _descriptionLabel
     ------------------------*/
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:@"感谢您预注册参观2013中国国际社会公共安全博览会。为便于您能顺利入场参观，请按照以下流程领取观展证：\n\n"];
    [desc appendString:@"1、使用手机“参观申请”功能获得二维码。\n"];
    [desc appendString:@"2、携带手机到展会现场预先登记观众通道自助扫描二维码换取观展证。\n\n"];
    [desc appendString:@"感谢您注册成为CPS中安网会员，此账号和二维码为中安网通行证，可使用其参加中安网举办的其他线下活动，并可登陆中安网（www.cps.com.cn）享受更多会员服务。\n\n"];
    [desc appendString:@"展览时间：\n开幕式：\n10月29日 09：30\n\n"];
    [desc appendString:@"参展：\n10月29日 09：30 – 17:00\n10月30日 09：30 – 17:00\n10月31日 09：30 – 17:00\n11月01日 09：30 – 12:00\n\n"];
    [desc appendString:@"地点：\n中国•深圳会展中心\n\n"];
    
    size = [desc sizeWithFont:_descriptionLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descriptionLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descriptionLabel.text = desc;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(_descriptionLabel.frame) + 10);
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
        hud.labelText = @"保存至相册";
        [hud show:YES];
        [hud hide:YES afterDelay:.7];
    }
}

@end