//
//  ConsultTableViewCellContentView.m
//  CPSE
//
//  Created by Lei Perry on 9/30/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultTableViewCellContentView.h"
#import "UIColor+BR.h"
#import "ConsultTableViewCell.h"

@implementation ConsultTableViewCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSIndexPath *indexPath = [self.tableViewCell.tableView indexPathForCell:self.tableViewCell];
    
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
    if ([self.tableViewCell.consultSet.replies count] > 0) {
        CGSize size = [self.tableViewCell.consultSet.question.content sizeWithFont:self.tableViewCell.textLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
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
        for (ConsultModel *reply in self.tableViewCell.consultSet.replies) {
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
    if (![self.tableViewCell.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-.5);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-.5);
        CGContextStrokePath(context);
    }
}

@end