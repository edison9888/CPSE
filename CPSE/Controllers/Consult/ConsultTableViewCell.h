//
//  ConsultTableViewCell.h
//  CPSE
//
//  Created by Lei Perry on 8/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultSetModel.h"

@interface ConsultTableViewCell : UITableViewCell

@property (nonatomic, strong) ConsultSetModel *consultSet;
@property (nonatomic, assign) UITableView *tableView;

+ (CGFloat)heightForConsultSet:(ConsultSetModel *)consultSet;

@end