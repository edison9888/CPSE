//
//  NewsTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface NewsTableViewCell ()
{
    NSDictionary *_dict;
}
@end

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSString *type = _dict[@"uritype"];
    if ([type isEqualToString:@"id"]) {
        CGRect frame = self.imageView.frame;
        frame.size.width = 300;
        self.imageView.frame = frame;
    }
    else
        self.imageView.frame = CGRectMake(10, 10, 70, 50);
}

- (void)setData:(NSDictionary *)data {
    _dict = data;
    self.textLabel.text = data[@"title"];
    
    NSString *type = _dict[@"uritype"];
    if ([type isEqualToString:@"id"])
        [self.imageView setImageWithURL:[NSURL URLWithString:data[@"img"]] placeholderImage:[UIImage imageNamed:@"cell-banner-placeholder"]];
    else
        [self.imageView setImageWithURL:[NSURL URLWithString:data[@"img"]] placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]];

    [self setNeedsLayout];
}

@end