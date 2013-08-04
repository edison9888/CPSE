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
#import "ZXingObjC.h"

@interface AccountInfoViewController ()
{
    NSInteger _userId;
    NSString* _userName;
    
    UIScrollView *_scrollView;
    UILabel *_userIdLabel;
    UILabel *_userNameLabel;
    UILabel *_descriptionLabel;
    UILabel *_operationLabel;
    
    UIImageView* _barImageView;
}
@end

@implementation AccountInfoViewController

- (id)initWithAccount:(Account*)account {
    if (self = [super init]) {
        _userId = account.id;
        _userName =account.name;
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
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    _userNameLabel.numberOfLines = 0;
    _userNameLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_userNameLabel];
    
    _userIdLabel = [[UILabel alloc] init];
    _userIdLabel.backgroundColor = [UIColor clearColor];
    _userIdLabel.font = [UIFont systemFontOfSize:15];
    _userIdLabel.numberOfLines = 0;
    _userIdLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_userIdLabel];
    
    _operationLabel = [[UILabel alloc] init];
    _operationLabel.backgroundColor = [UIColor clearColor];
    _operationLabel.font = [UIFont systemFontOfSize:13];
    _operationLabel.numberOfLines = 0;
    _operationLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_operationLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textColor = [UIColor colorWithHex:0x999999];
    [_scrollView addSubview:_descriptionLabel];
    
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-200,0, 200, 60)];
    _barImageView.backgroundColor = [UIColor colorWithHex:0xcecece];
    _barImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_barImageView];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbum)];
    [_barImageView addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
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
     barcodeStr
     ------------------------*/
    NSString* barcodeStr = [NSString stringWithFormat:@"%i", _userId];
    ZXMultiFormatWriter* writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix* result = [writer encode:barcodeStr
                                  format:kBarcodeFormatCode128
                                   width:_barImageView.frame.size.width
                                  height:_barImageView.frame.size.height
                                   error:nil];
    if (result) {
        _barImageView.image = [UIImage imageWithCGImage:[ZXImage imageWithMatrix:result].cgimage];
    }
    else {
        _barImageView.image = nil;
    }
    _barImageView.center = CGPointMake(_scrollView.frame.size.width/2, topOffset + _barImageView.frame.size.height/2);
    topOffset += _barImageView.frame.size.height + 10;
    
    
    /*------------------------
     _userIdLabel
     ------------------------*/
    info = [NSString stringWithFormat :@"卡号：%i", _userId];
    size = [info sizeWithFont:_userIdLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _userIdLabel.frame = CGRectMake(CGRectGetMinX(_barImageView.frame), topOffset, size.width, size.height);
    _userIdLabel.text = info;
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
    [desc appendString:@"感谢您预注册参观2013中国国际公共安全博览会。为便于您能顺利入场参观，请打印本确认函并且携带至展览现场，以打印确认函在预先登记观众通道获取观众胸牌。顺祝您本次参展愉快！\n\n"];
    [desc appendString:@"若有任何问题，欢迎随时同展览会组委会联系。组委会联系方式为：0755－88309138（深圳安博会展有限公司）。\n\n"];
    [desc appendString:@"注：16周岁以下观众恕不招待。\n\n"];
    [desc appendString:@"展览时间：\n开幕式：\n10月29日 09：30\n\n"];
    [desc appendString:@"参展：\n10月29日 09：30 – 17:00\n10月30日 09：30 – 17:00\n10月31日 09：30 – 17:00\n11月01日 09：30 – 12:00\n\n"];
    [desc appendString:@"地点：\n中国•深圳会展中心\n\n"];
    
    size = [desc sizeWithFont:_descriptionLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descriptionLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descriptionLabel.text = desc;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(_descriptionLabel.frame) + 10);
}

- (void)saveToAlbum {
    UIImageWriteToSavedPhotosAlbum(_barImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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