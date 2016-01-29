//
//  ViewController.m
//  地图导航
//
//  Created by Qianfeng on 16/1/29.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self createLocationManager];
}

- (IBAction)startNav:(id)sender {
    //地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //根据输入文本内容 地理编码 得到经纬度
    [geocoder geocodeAddressString:_textField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"没有找到这个位置");
            return ;
        }
        //起点的坐标 终点的坐标
       // _mapView.userLocation.coordinate;
        //终点的坐标
       CLPlacemark *placeMark = [placemarks lastObject];
       
        
        MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];
        
        
        //重点的item
        MKMapItem *finish = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:placeMark]];
        
        
        //开始导航
        /*
         1.数组  起点和终点 的 mapItem；
         2.导航的条件 不行 驾车
         */
        [MKMapItem openMapsWithItems:@[startItem,finish] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:@YES}];
        
        
        
    }];
    
}

-(void)createLocationManager {
    _locationManager = [[CLLocationManager alloc]init];
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
