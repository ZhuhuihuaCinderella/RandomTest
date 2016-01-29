//
//  ViewController.m
//  地图导航
//
//  Created by Qianfeng on 16/1/29.
//  Copyright © 2016年 ZZ. All rights reserved.
//


/*
 iOS 程序中的地图 一般高德地图 有些公司也用百度地图 百度需要一个SDK（注册一下 一般用第三方的SDK 都需要注册一下 拿到一个key 就相当于一个密码 ）
 安卓里面系统的地图是谷歌地图 腾讯地图 百度地图
 
 //地图坐标系 因为国内的原因 百度地图专门实现了一个坐标系bd 跟高德 谷歌 腾讯等地图的坐标系不一样  坐标的转换 百度地图提供的有转换的方法
 */














#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<MKMapViewDelegate>
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
    _mapView.delegate = self;
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
        
        //在屏幕上 画出起点到终点的路线
        /*
         1.发起一个导航的请求
         */
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
        //起点的item
        request.source = startItem;
        //终点的item
        request.destination = finish;
        
        
        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
        //计算导航结果
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            //respose.routes 计算的路线是个数组
            if (response.routes.count == 0||error) {
                NSLog(@"没有计算出路线 或者 出错");
            }
            //
            [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //遍历所有的路线
                //得到一条路线
                MKPolyline *line = obj.polyline;
                
                //地图上画一条线
                [_mapView addOverlay:line];
            }];
        }];
//        //开始导航
//        /*
//         1.数组  起点和终点 的 mapItem；
//         2.导航的条件 不行 驾车
//         */
//        [MKMapItem openMapsWithItems:@[startItem,finish] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:@YES}];
        
        
        
    }];
    
}


-(void)createLocationManager {
    _locationManager = [[CLLocationManager alloc]init];
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}

//画线的时候要实现这个方法
-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    polylineRenderer.strokeColor = [UIColor redColor];
    return polylineRenderer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
