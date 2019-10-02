//
//  WKPMapVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/17.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPMapVC.h"
#import <MapKit/MapKit.h>
#import "WKPAnnotation.h"
@interface WKPMapVC ()<MKMapViewDelegate>
@property(nonatomic,strong)MKMapView* mapView;
@end

@implementation WKPMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];

    //1.设置地图类型
    self.mapView.mapType = MKMapTypeStandard;
    //2.是否旋转
    self.mapView.rotateEnabled=YES;
    //3.是否缩放
    self.mapView.zoomEnabled = YES;
    //4.是否滚动
    self.mapView.scrollEnabled = YES;
    //5.开启用户位置
    self.mapView.showsUserLocation = YES;
    //设置代理
    self.mapView.delegate =  self;
    //设置用户追踪
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CLLocationCoordinate2D coordinate =self.location.coordinate;
    WKPAnnotation* annotation =[[WKPAnnotation alloc]init];
    annotation.coordinate=coordinate;
    annotation.title = self.localStr;
    [self.mapView addAnnotation:annotation];
    //7.0设置范围
    MKCoordinateSpan spac = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region =MKCoordinateRegionMake(coordinate, spac);
    self.mapView.region =region;
}
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[WKPAnnotation class]]) {
        MKAnnotationView* view=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cell"];
        if (!view) {
            view=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"cell"];
            view.canShowCallout = YES;
            
        }
        view.annotation = annotation;
        view.image = [UIImage imageNamed:@"chat_location_annotation_someone"];
        return view;
    }else{
        return [[MKAnnotationView alloc]init];
    }
  
}
@end
