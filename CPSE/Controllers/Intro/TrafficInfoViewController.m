//
//  TrafficInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "TrafficInfoViewController.h"

@interface TrafficInfoViewController ()
{
    MKMapView *_mapView;
}
@end

@implementation TrafficInfoViewController

- (void)loadView {
    self.view = _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.53308, 114.05856);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1200, 1200);
    [_mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    if ([mapView.annotations count] == 0) {
        // add annotation
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = mapView.centerCoordinate;
        annotation.title = @"CPSE安博会";
        annotation.subtitle = @"深圳市福田区福华三路深圳会展中心";
        [mapView addAnnotation:annotation];
    }
}

@end