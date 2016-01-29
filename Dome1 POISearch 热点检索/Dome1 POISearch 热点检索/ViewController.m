//
//  ViewController.m
//  Dome1 POISearch 热点检索
//
//  Created by Qianfeng on 16/1/29.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createLocationManager];
    [self createMapView];
    [self createDataSource];
    [self createButton];
}

-(void)createDataSource {
    _dataSource = [[NSMutableArray alloc]init];
    [_dataSource addObject:@"餐厅"];
    [_dataSource addObject:@"地铁站"];
    [_dataSource addObject:@"银行"];
    [_dataSource addObject:@"网吧"];
    [_dataSource addObject:@"酒店"];
    [_dataSource addObject:@"商场"];
}

#pragma mark - 创建按钮
-(void)createButton {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 30, 100, 60);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"列表" forState:0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
}
//点击按钮的时候 把dataSource里面的东西弹出来
-(void)btnPressed {
    
    UIAlertController *act = [UIAlertController alertControllerWithTitle:@"附近" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
   [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           NSLog(@"点击了%@",obj);
           
           //调用 搜索
           [self searchShop:obj];
           
           
       }];
       [act addAction:action];
   }];
    //显示
    [self presentViewController:act animated:YES completion:nil];
}
//在这个方法里面搜索附近的商店 POI检索 （热点检索）
-(void)searchShop:(NSString*)title {
   // MKLocalSearch;//创建搜索
   // MKLocalSearchRequest;//创建搜索的请求
    
    //搜索之前删除地图上之前有的大头针
    [_mapView removeAnnotations:_mapView.annotations];
    
    //先去创建搜索的请求
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    
    //设置搜索的关键字
    request.naturalLanguageQuery = title;
    
    //搜索的范围 用户附近
    /*
     1.当前用户的位置
     2.设置跨度
     */
    request.region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, MKCoordinateSpanMake(0.02, 0.02));
    
    //发起搜索
    
    //先创建搜索 参数 搜索请求
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    //一个异步的请求
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response.mapItems);
        
        //循环
       [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           MyAnnotation *annotation = [[MyAnnotation alloc]init];
           annotation.coordinate = obj.placemark.coordinate;
           annotation.title = obj.name;
           annotation.subtitle = obj.phoneNumber;
           [_mapView addAnnotation:annotation];
       }];
        
        
        
        
        
    }];
}


#pragma mark - 创建地图视图
-(void)createMapView {
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
}
//地图视图的协议方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"更新用户位置信息");
}

#pragma mark - 创建定位管理器
-(void)createLocationManager {
    _locationManager = [[CLLocationManager alloc]init];
    //申请定位权限
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



































