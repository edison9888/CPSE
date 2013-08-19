//
//  ConsultSetModel.h
//  CPSE
//
//  Created by Lei Perry on 8/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultModel.h"

@interface ConsultSetModel : NSObject

@property (nonatomic, strong) ConsultModel *question;
@property (nonatomic, strong) NSArray *replies;

@end