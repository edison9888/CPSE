//
//  VenuesViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VenuesViewController.h"
#import "VenueCellView.h"
#import "UIColor+BR.h"
#import "MapViewController.h"

@interface VenuesViewController ()

@end

@implementation VenuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat gap = 5.0;
    CGFloat topOffset = gap;
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CGFloat w = CGRectGetWidth(rect) - 2*gap;
    CGFloat h = (CGRectGetHeight(rect) - 44 - 5*gap) / 3.67;
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    // 1st row
    VenueCellView *cell = [[VenueCellView alloc] initWithFrame:CGRectMake(gap, topOffset, (w-gap)/2, h) title:@"1号馆" subtitle:@"国际馆"];
    cell.backgroundColor = [UIColor colorWithHex:0x57b0ba];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType1];
        vc.title = @"1号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-gap)/2, h) title:@"6号馆" subtitle:@"国际馆"];
    cell.backgroundColor = [UIColor colorWithHex:0x57b0ba];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType6];
        vc.title = @"6号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    topOffset += h + gap;
    DLog(@"generating one row cell views: %.2fms", 1000.0 * (CFAbsoluteTimeGetCurrent() - startTime));
    
    // 2nd row
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(gap, topOffset, w-(w-2*gap)/3-gap, h) title:@"2号馆" subtitle:@"楼宇对讲 防盗报警"];
    cell.backgroundColor = [UIColor colorWithHex:0x5fb47b];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType2];
        vc.title = @"2号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-2*gap)/3, h) title:@"3、4号场馆" subtitle:@"一卡通"];
    cell.backgroundColor = [UIColor colorWithHex:0xb4ad5f];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType3and4];
        vc.title = @"3、4号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    topOffset += h + gap;
    
    // 3rd row
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(gap, topOffset, (w-2*gap)/3, h) title:@"5号馆" subtitle:@"视频监控"];
    cell.backgroundColor = [UIColor colorWithHex:0xc08559];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType5];
        vc.title = @"5号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-2*gap)/3, h) title:@"7、8号馆" subtitle:@"视频监控"];
    cell.backgroundColor = [UIColor colorWithHex:0xc08559];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType7and8];
        vc.title = @"7、8号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-2*gap)/3, h) title:@"9号馆" subtitle:@"视频监控"];
    cell.backgroundColor = [UIColor colorWithHex:0xc08559];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType9];
        vc.title = @"9号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    topOffset += h + gap;
    
    // 4th row
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(gap, topOffset, (w-3*gap)/4, .67 * h) title:@"二楼\n平台" subtitle:@""];
    cell.backgroundColor = [UIColor colorWithHex:0x967bbe];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueTypeGroundOn2ndFloor];
        vc.title = @"二楼 平台";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-3*gap)/4, .67 * h) title:@"二楼\n5号馆" subtitle:@""];
    cell.backgroundColor = [UIColor colorWithHex:0x967bbe];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType5On2ndFloor];
        vc.title = @"二楼 5号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-3*gap)/4, .67 * h) title:@"二楼\n6号管" subtitle:@""];
    cell.backgroundColor = [UIColor colorWithHex:0x967bbe];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType6On2ndFloor];
        vc.title = @"二楼 6号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];
    
    cell = [[VenueCellView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)+gap, topOffset, (w-3*gap)/4, .67 * h) title:@"北广场\n11号管" subtitle:@""];
    cell.backgroundColor = [UIColor colorWithHex:0x967bbe];
    cell.tapHandler = ^{
        MapViewController *vc = [[MapViewController alloc] initWithVenueType:VenueType6On2ndFloor];
        vc.title = @"北广场 11号馆";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:cell];

    DLog(@"generating all cell views: %.2fms", 1000.0 * (CFAbsoluteTimeGetCurrent() - startTime));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // right bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor colorWithHex:0xd52626];
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 4;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setFrame:CGRectMake(0, 8, 65, 28)];
    [rightButton setTitle:@"展馆全图" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(viewWholeMap) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)viewWholeMap {
    MapViewController *vc = [[MapViewController alloc] init];
    vc.title = @"展馆全图";
    [self.navigationController pushViewController:vc animated:YES];
}

@end