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
    //    NSDictionary *_data;
    
    UIScrollView *_scrollView;
    UILabel *_userIdLabel;
    UILabel *_userNameLabel;
    UILabel *_descriptionLabel;
    UILabel *_operationLabel;
    
    UIImageView* _barImageView;
    //    UIWebView *_webView;
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
    _operationLabel.font = [UIFont systemFontOfSize:15];
    _operationLabel.numberOfLines = 0;
    _operationLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_operationLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textColor = [UIColor colorWithHex:0x999999];
    [_scrollView addSubview:_descriptionLabel];
    
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 200, 60)];
    //    _barImageView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [_scrollView addSubview:_barImageView];
    
    UILongPressGestureRecognizer* pan = [[UILongPressGestureRecognizer alloc]
           initWithTarget:self action:@selector(handleLongPress:)] ;
    [_scrollView addGestureRecognizer:pan];
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
    NSString *info=[NSString stringWithFormat :@"用户名：%@", _userName];
    
    CGSize size = [info sizeWithFont:_userNameLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _userNameLabel.frame = CGRectMake(10,topOffset, size.width, size.height);
    _userNameLabel.center = CGPointMake(_scrollView.frame.size.width/2, _userNameLabel.center.y);
    _userNameLabel.text = info;
    topOffset += size.height + 10;
    
    
    /*------------------------
     barcodeStr
     ------------------------*/
    NSString* barcodeStr = [NSString stringWithFormat:@"%i",_userId ];
    
    
    ZXMultiFormatWriter* writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix* result = [writer encode:barcodeStr
                                  format:kBarcodeFormatCode128
                                   width:_barImageView.frame.size.width
                                  height:_barImageView.frame.size.height
                                   error:nil];
    if (result) {
        _barImageView.image = [UIImage imageWithCGImage:[ZXImage imageWithMatrix:result].cgimage];
    } else {
        _barImageView.image = nil;
    }
    _barImageView.center = CGPointMake(_scrollView.frame.size.width/2,
                                       topOffset+_barImageView.frame.size.height/2);
    topOffset += _barImageView.frame.size.height + 10;
    
    
    /*------------------------
     _userIdLabel
     ------------------------*/
    info=[NSString stringWithFormat :@"卡号：%i", _userId];
    size = [info sizeWithFont:_userIdLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _userIdLabel.frame = CGRectMake(0,topOffset, size.width, size.height);
    _userIdLabel.center = CGPointMake(_scrollView.frame.size.width/2, _userIdLabel.center.y);
    _userIdLabel.text = info;
    topOffset += size.height + 10;
    
    /*------------------------
     _operationLabel
     ------------------------*/
    info=[NSString stringWithFormat :@"条形码作为入场标识 长按进行保存"];
    size = [info sizeWithFont:_operationLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _operationLabel.frame = CGRectMake(0,topOffset, size.width, size.height);
    _operationLabel.center = CGPointMake(_scrollView.frame.size.width/2, _operationLabel.center.y);
    _operationLabel.text = info;
    topOffset += size.height + 10;
    
    
    /*------------------------
     _descriptionLabel
     ------------------------*/
    NSString *desc = @"先插一下，介绍A片为什么会分为有码无码：日本法律规定媒体上不允许出现人体性器官，于是日本国内注册的公司就得遵守这一规定，所以如果无码的骗子几乎都是日本国外的公司拍的，极小部分是公司流出的。有码片都是在日本国内公司出品并且在国内租售的，版权保护得很好，所以比较赚钱。赚的钱多，给女优的钱也多，所以能签到一些比较优秀的女优，这也是有码片的女主角普遍比无码片女主角优秀的原因。赚的钱多，还可以让片子的剧情啊、环境啊神马的更好。\n\n先插一下，介绍A片为什么会分为有码无码：日本法律规定媒体上不允许出现人体性器官，于是日本国内注册的公司就得遵守这一规定，所以如果无码的骗子几乎都是日本国外的公司拍的，极小部分是公司流出的。有码片都是在日本国内公司出品并且在国内租售的，版权保护得很好，所以比较赚钱。赚的钱多，给女优的钱也多，所以能签到一些比较优秀的女优，这也是有码片的女主角普遍比无码片女主角优秀的原因。赚的钱多，还可以让片子的剧情啊、环境啊神马的更好。\n\n先插一下，介绍A片为什么会分为有码无码：日本法律规定媒体上不允许出现人体性器官，于是日本国内注册的公司就得遵守这一规定，所以如果无码的骗子几乎都是日本国外的公司拍的，极小部分是公司流出的。有码片都是在日本国内公司出品并且在国内租售的，版权保护得很好，所以比较赚钱。赚的钱多，给女优的钱也多，所以能签到一些比较优秀的女优，这也是有码片的女主角普遍比无码片女主角优秀的原因。赚的钱多，还可以让片子的剧情啊、环境啊神马的更好。";
    size = [desc sizeWithFont:_descriptionLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descriptionLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descriptionLabel.text = desc;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(_descriptionLabel.frame));
    
    
}

- (IBAction) renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_scrollView.contentSize);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0,
                                       _scrollView.contentSize.width,
                                       _scrollView.contentSize.height);
        
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image,nil,NULL,NULL);
    }
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        DLog(@"long press began.");
        [self renderScrollViewToImage];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"用户信息已保存到相册。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        DLog(@"long press end.");
    }
}

@end