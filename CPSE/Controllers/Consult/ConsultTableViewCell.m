//
//  ConsultTableViewCell.m
//  CPSE
//
//  Created by Lei Perry on 8/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultTableViewCell.h"
#import "UIColor+BR.h"

@implementation ConsultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setConsultSet:(ConsultSetModel *)consultSet {
    if (_consultSet != consultSet) {
        _consultSet = consultSet;
        self.textLabel.text = consultSet.question.content;
        [self setNeedsDisplay];
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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);

    // draw top line
    CGContextSaveGState(context);
    if (indexPath.row == 0) {
        CGContextMoveToPoint(context, 0, .5);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), .5);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // draw replies background
    if ([_consultSet.replies count] > 0) {
        CGSize size = [_consultSet.question.content sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
        CGFloat topOffset = size.height + 35;
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0xe8e8e8].CGColor);
        CGContextMoveToPoint(context, 0, topOffset);
        CGContextAddLineToPoint(context, 40, topOffset);
        CGContextAddLineToPoint(context, 50, topOffset-5);
        CGContextAddLineToPoint(context, 60, topOffset);
        CGContextAddLineToPoint(context, 320, topOffset);
        CGContextAddLineToPoint(context, 320, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, 0, 0);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        // draw replies
        for (ConsultModel *reply in _consultSet.replies) {
            CGContextMoveToPoint(context, 0, topOffset);
            CGContextAddLineToPoint(context, 40, topOffset);
            CGContextAddLineToPoint(context, 50, topOffset-5);
            CGContextAddLineToPoint(context, 60, topOffset);
            CGContextAddLineToPoint(context, 320, topOffset);
            CGContextStrokePath(context);
            
            NSString *content = [NSString stringWithFormat:@"回复：%@", reply.content];
            size = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0x888888].CGColor);
            [content drawInRect:CGRectMake(10, topOffset+10, size.width, size.height) withFont:[UIFont systemFontOfSize:14]];
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            [@"回复：" drawInRect:CGRectMake(10, topOffset+10, size.width, size.height) withFont:[UIFont systemFontOfSize:14]];
            
            topOffset += 25 + size.height;
        }
    }
    
    // draw bottom line
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-.5);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-.5);
    CGContextStrokePath(context);
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