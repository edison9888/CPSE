//
//  CommentTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 8/4/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIColor+BR.h"

@interface CommentTableViewCell ()
{
    UILabel *_nameLabel;
}
@end

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    return self;
}

- (void)setComment:(NSDictionary *)comment {
    _nameLabel.text = [NSString stringWithFormat:@"%@：", comment[@"username"]];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@： %@", comment[@"username"], [DataMgr parseText:comment[@"content"]]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(10, 10, size.width, size.height);
    
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.detailTextLabel.frame = CGRectMake(10, 10, 300, size.height);
}

@end