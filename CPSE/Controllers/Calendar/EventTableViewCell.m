//
//  EventTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.numberOfLines = 0;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.numberOfLines = 0;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size1 = [@"00:00" sizeWithFont:self.textLabel.font];
    self.textLabel.frame = CGRectMake(10, 10, size1.width, size1.height);
    
    CGSize size2 = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-size1.width-64, CGFLOAT_MAX)];
    self.detailTextLabel.frame = CGRectMake(size1.width+20, 10, size2.width, size2.height);
    
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.frame)-44, 0, 44, 44);
}

@end