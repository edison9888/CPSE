//
//  ConsultTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 8/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultTableViewCell.h"
#import "ConsultTableViewCellContentView.h"

@interface ConsultTableViewCell ()
{
    ConsultTableViewCellContentView *_contentView;
}
@end

@implementation ConsultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.numberOfLines = 0;
        
        _contentView = [[ConsultTableViewCellContentView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.tableViewCell = self;
        [self insertSubview:_contentView atIndex:0];
    }
    return self;
}

- (void)setConsultSet:(ConsultSetModel *)consultSet {
    if (_consultSet != consultSet) {
        _consultSet = consultSet;
        self.textLabel.text = consultSet.question.content;
        [self setNeedsDisplay];
        [_contentView setNeedsDisplay];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(10, 20, CGRectGetWidth(self.bounds)-20, CGFLOAT_MAX);
    CGSize size = [_consultSet.question.content sizeWithFont:self.textLabel.font constrainedToSize:frame.size];
    frame.size.height = size.height;
    self.textLabel.frame = frame;
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
}

+ (CGFloat)heightForConsultSet:(ConsultSetModel *)consultSet {
    CGFloat h = 20;
    CGSize size = [consultSet.question.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    h += size.height + 20;
    
    for (ConsultModel *reply in consultSet.replies) {
        h += 25;
        size = [[NSString stringWithFormat:@"回复：%@", reply.content] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
        h += size.height;
    }
    
    return h;
}

@end