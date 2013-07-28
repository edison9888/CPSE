//
//  NewsTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation NewsTableViewCell

- (void)setData:(NSDictionary *)data {
    self.textLabel.text = data[@"title"];
    [self.imageView setImageWithURL:[NSURL URLWithString:data[@"img"]] placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]];
}

@end