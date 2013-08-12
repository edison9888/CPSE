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

@interface ExhibitorInfoViewController ()
{
    NSInteger _id;
    NSDictionary *_data;
    
    UIScrollView *_scrollView;
    UILabel *_infoLabel;
    UILabel *_descLabel;

    UIImageView *_logoView;
    UIActivityIndicatorView *_activityIndicator;
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

    _infoLabel = [[UILabel alloc] init];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.font = [UIFont systemFontOfSize:13];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_infoLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_descLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_activityIndicator startAnimating];
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=ccinfo&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = JSON[@"data"];
                  [self populateInterface];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)populateInterface {
    CGRect rect = _scrollView.bounds;
    
    // set logo
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_data[@"logo"]]];
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
    
    NSMutableString *info = [NSMutableString string];
    [info appendFormat:@"企业名称：%@\n", _data[@"name"]];
    [info appendString:@"展位号：\n"];
    [info appendFormat:@"E-mail：%@\n", _data[@"email"]];
    [info appendFormat:@"联系地址：\n%@\n", _data[@"link_address"]];

    CGSize size = [info sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _infoLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _infoLabel.text = info;
    topOffset += size.height + 10;
    
    NSString *desc = _data[@"profile"];
    size = [desc sizeWithFont:_descLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _descLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _descLabel.text = desc;
    
    _scrollView.contentSize = CGSizeMake(rect.size.width, CGRectGetMaxY(_descLabel.frame));
}

@end