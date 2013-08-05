//
//  VenueCellView.h
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

typedef void (^VenueTapHandler)();

@interface VenueCellView : UIView

@property (readwrite, nonatomic, copy) VenueTapHandler tapHandler;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title subtitle:(NSString *)subtitle;

@end