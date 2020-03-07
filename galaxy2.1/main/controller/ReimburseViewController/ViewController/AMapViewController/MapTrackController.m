//
//  MapTrackController.m
//  galaxy
//
//  Created by hfk on 2017/8/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MapTrackController.h"
#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"
#import "Record.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MapRecordController.h"
#import "RouteViewController.h"

@interface MapTrackController ()<AMapLocationManagerDelegate,GPClientDelegate,MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) MAMutablePolyline *mutablePolyline;
@property (nonatomic, strong) MAMutablePolylineRenderer *render;

@property (nonatomic, strong) Record *currentRecord;

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
//开始按钮
@property (nonatomic, strong)UIButton *RecordBtn;
@property(nonatomic,strong)NSDictionary *resultDict;

@property(nonatomic,assign)NSInteger requestCount;
@property(nonatomic,strong)NSString  *UpdateInfId;

@property(nonatomic,strong)NSMutableArray *pointArray;

@end

@implementation MapTrackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"自驾车", nil) backButton:YES];
    self.isRecording = NO;
    self.UpdateInfId=@"";
    [self initMapView];
    [self initRecordView];
    [self initLocationButton];
    [self initOverlay];
    
    if ([_type isEqualToString:@"UnFinsh"]) {
        self.currentRecord = [[Record alloc] init];
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_model.track]];
        if (![array isKindOfClass:[NSNull class]]&&array.count>0) {
            for (NSDictionary *dict in array) {
                CLLocation *cll=[[CLLocation alloc]initWithLatitude:[dict[@"latitude"] doubleValue] longitude:[dict[@"longitude"] doubleValue]];
                [self.currentRecord.locationsArray addObject:cll];
            }
        }
        self.currentRecord.startTime=[NSString isEqualToNull:_model.departureTimeStr]?_model.departureTimeStr:@"";
        self.currentRecord.startplace=[NSString isEqualToNull:_model.departureName]?_model.departureName:@"";
        _UpdateInfId=[NSString isEqualToNull:_model.Id]?_model.Id:@"";
    }else{
        [self createNavBtn];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
    [self.mapView addOverlay:self.mutablePolyline];
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
-(void)createNavBtn{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"我的行程", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(Myschedule)];
}
- (void)initMapView{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.distanceFilter =20;
    self.mapView.showsCompass=NO;
    self.mapView.showsScale=NO;
    self.mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates=YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

-(void)initRecordView{
    _RecordBtn=[GPUtils createButton:CGRectMake(0, 0, 106, 106) action:@selector(actionRecordAndStop) delegate:self];
    _RecordBtn.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height-NavigationbarHeight-68);
    [_RecordBtn setBackgroundImage:[self.type isEqualToString:@"UnFinsh"]?[UIImage imageNamed:@"Self_Drive_Arrive"]:[UIImage imageNamed:@"Self_Drive_Start"] forState:UIControlStateNormal];
    [self.view addSubview:_RecordBtn];
}
- (void)initLocationButton
{
    
    UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)*0.8, 50, 50)];
    locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    locationBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    locationBtn.layer.cornerRadius = 5;
    [locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn setImage:[UIImage imageNamed:@"Self_Drive_Location"] forState:UIControlStateNormal];
    [self.view addSubview:locationBtn];
}

- (void)initOverlay{
    self.mutablePolyline = [[MAMutablePolyline alloc] initWithPoints:@[]];
}
-(void)Myschedule{
    if (self.isRecording==YES) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请在结束行程后在操作", nil) duration:1.0];
    }else{
        RouteViewController *route = [[RouteViewController alloc]init];
        [self.navigationController pushViewController:route animated:YES];

    }
}
-(void)actionRecordAndStop{
    if (self.currentRecord == nil){
        self.currentRecord = [[Record alloc] init];
    }
//    if(self.isRecording==YES||[_type isEqualToString:@"UnFinsh"]){
//        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    }else{
//        [YXSpritesLoadingView showWithText:Custing(@"获取出发信息",nil) andShimmering:NO andBlurEffect:NO];
//    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

    _requestCount=0;
    [self getInfo];
}

-(void)actionLocation{
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    if (self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree =self.mapView.userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }

}
#pragma mark - MapView Delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation)
    {
        if (self.userLocationAnnotationView != nil) {
            [UIView animateWithDuration:0.1 animations:^{
    
                double degree = userLocation.heading.trueHeading;
                self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
                
            }];
        }
        return;
    }
    if (self.isRecording)
    {
        if (userLocation.location.horizontalAccuracy < 80 && userLocation.location.horizontalAccuracy > 0)
        {
            [self.currentRecord addLocation:userLocation.location];
            [self.mutablePolyline appendPoint: MAMapPointForCoordinate(userLocation.location.coordinate)];
            [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            [self.render invalidatePath];
        }
    }
}

- (MAOverlayPathRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineRenderer *renderer = [[MAMutablePolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 4.0f;
        
        renderer.strokeColor = [UIColor redColor];
        self.render = renderer;
        
        return renderer;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    [self.mapView setZoomLevel:16 animated:YES];
}

//点击蓝点跳出地理位置信息，不能实时更新
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    

}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //改变定位图标
    MAAnnotationView *view = views[0];
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor clearColor];
        pre.image = [UIImage imageNamed:@"Self_Drive_Head"];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }
}

//MARK:逆地理编码
-(void)getInfo{
    _requestCount++;
    self.locationManager= [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 5;
    self.locationManager.reGeocodeTimeout = 5;
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (weakSelf.requestCount>5) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"获取出发信息失败", nil) duration:1.0];
                return;
            }
            [weakSelf performBlock:^{
                [weakSelf getInfo];
            } afterDelay:6];
            return;
        }
        if (regeocode){
            if (weakSelf.isRecording==YES||[weakSelf.type isEqualToString:@"UnFinsh"]){
                weakSelf.currentRecord.endPlace=[regeocode.formattedAddress stringByReplacingOccurrencesOfString:@"靠近" withString:@""];
                weakSelf.currentRecord.endTime=[GPUtils getNowTimeDateWithFormatter:@"yyyy/MM/dd HH:mm"];
                [weakSelf.currentRecord.locationsArray addObject:location];
                [weakSelf SaveSelfDriveRoute];
            }else if (weakSelf.isRecording==NO) {
                weakSelf.currentRecord.startplace=[regeocode.formattedAddress stringByReplacingOccurrencesOfString:@"靠近" withString:@""];
                weakSelf.currentRecord.startTime=[GPUtils getNowTimeDateWithFormatter:@"yyyy/MM/dd HH:mm"];
                [weakSelf.currentRecord.locationsArray addObject:location];
                [weakSelf SaveSelfDriveRoute];
            }
        }
    }];
}
//MARK:保存路线及信息
-(void)SaveSelfDriveRoute{
    
    _pointArray=[NSMutableArray array];
    for (CLLocation *cl in self.currentRecord.locationsArray) {
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%f",cl.coordinate.latitude] forKey:@"latitude"];//纬度
        [dict setValue:[NSString stringWithFormat:@"%f",cl.coordinate.longitude] forKey:@"longitude"];//经度
        //        "course" : "344.531250",
        //        "speed" : "2.670000",
        //        "horizontalAccuracy" : "5.000000",
        //        "latitude" : "39.988164",
        //        "longtitude" : "116.313631",
        //        "altitude" : "57.940080",
        //        "timestamp" : "2015-12-10 13:18:31 +0000"
        [_pointArray addObject:dict];
    }

    NSDictionary *parameters;
    NSString *url;
    int SerialNum;
    if ([_type isEqualToString:@"UnFinsh"]) {
        parameters = @{@"Id":_UpdateInfId,@"DepartureTime":self.currentRecord.startTime,@"ArrivalTime":self.currentRecord.endTime,@"DepartureName":self.currentRecord.startplace,@"ArrivalName":self.currentRecord.endPlace,@"Mileage":[NSString stringWithFormat:@"%.2f",[self.currentRecord totalDistance]/1000],@"Track":[NSString transformToJsonWithOutEnter:_pointArray],@"Status":@"1",@"Type":@"1"};
        url =[NSString stringWithFormat:@"%@",UpdateSelfDrive];
        SerialNum=1;

    }else if (self.isRecording==YES){
        parameters= @{@"Id":_UpdateInfId,@"DepartureTime":self.currentRecord.startTime,@"ArrivalTime":self.currentRecord.endTime,@"DepartureName":self.currentRecord.startplace,@"ArrivalName":self.currentRecord.endPlace,@"Mileage":[NSString stringWithFormat:@"%.2f",[self.currentRecord totalDistance]/1000],@"Track":[NSString transformToJsonWithOutEnter:_pointArray],@"Status":@"1",@"Type":@"0"};
        url =[NSString stringWithFormat:@"%@",UpdateSelfDrive];
        SerialNum=1;
    }else{
        parameters= @{@"DepartureTime":self.currentRecord.startTime,@"ArrivalTime":self.currentRecord.endTime,@"DepartureName":self.currentRecord.startplace,@"ArrivalName":self.currentRecord.endPlace,@"Mileage":[NSString stringWithFormat:@"%.2f",[self.currentRecord totalDistance]/1000],@"Track":[NSString transformToJsonWithOutEnter:_pointArray],@"Status":@"0",@"Type":@"0"};
        url =[NSString stringWithFormat:@"%@",SaveSelfDrive];
        SerialNum=0;
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:SerialNum IfUserCache:NO];

}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNullAndZero:_resultDict[@"result"]]&&[_resultDict[@"result"]floatValue]>0) {
                _UpdateInfId=[NSString stringWithFormat:@"%@",_resultDict[@"result"]];
                [self.RecordBtn setBackgroundImage:[UIImage imageNamed:@"Self_Drive_Arrive"] forState:UIControlStateNormal];
                self.isRecording=YES;
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"获取出发信息失败", nil) duration:2.0];
            }
        }
            break;
        case 1:
        {
            if ([NSString isEqualToNullAndZero:_resultDict[@"result"]]&&[_resultDict[@"result"]floatValue]>0) {
                self.isRecording=NO;
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"行程结束", nil) duration:2.0];
                __weak typeof(self) weakSelf = self;
                [self performBlock:^{
                    [weakSelf ShowRouteLine];
                } afterDelay:2];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
            }
        }
            break;
        default:
            break;
    }
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)ShowRouteLine{
    MapRecordController *vc=[[MapRecordController alloc]init];
    RouteModel *model=[[RouteModel alloc]init];
    model.departureName = self.currentRecord.startplace;
    model.departureTimeStr  =self.currentRecord.startTime;
    model.arrivalName=self.currentRecord.endPlace;
    model.arrivalTimeStr = self.currentRecord.endTime;
    model.mileage = [NSString stringWithFormat:@"%.2f",[self.currentRecord totalDistance]/1000];
    model.track = [NSString transformToJsonWithOutEnter:_pointArray];
    model.type = @"0";
    vc.model = model;
    vc.backIndex = @"0";
    [self.navigationController pushViewController:vc animated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
