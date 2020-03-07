//
//  MapRecordController.m
//  galaxy
//
//  Created by hfk on 2017/8/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MapRecordController.h"
#import "CustomAnnotationView.h"

@interface MapRecordController ()<MAMapViewDelegate,GPClientDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)MAPolyline *polyline;
@property (nonatomic, assign)CLLocationCoordinate2D *runningCoords;
@property (nonatomic, assign)NSUInteger count;

@end

@implementation MapRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"行程详情", nil) backButton:YES];
    [self initMapView];
    [self initDetailView];
    if (![NSString isEqualToNullAndZero:self.model.Id]) {
        [self getRecord];
        [self showRoute];
    }else{
        [self requestRecord];
    }
    
}
-(void)requestRecord{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"Id":[NSString stringWithIdOnNO:_model.Id]};
    [[GPClient shareGPClient]REquestByPostWithPath:GETDRIVERCARROUTE Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    [YXSpritesLoadingView dismiss];
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
            if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
                [self.model setValuesForKeysWithDictionary:responceDic[@"result"]];
                [self getRecord];
                [self showRoute];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    UIEdgeInsets inset = UIEdgeInsetsMake(80, 80, 80, 80);
    [self.mapView setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:NO];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)getRecord{
//    NSMutableArray *pointArray=[NSMutableArray array];
//    for (CLLocation *cl in _record) {
//        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.coordinate.latitude] forKey:@"latitude"];//纬度
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.coordinate.longitude] forKey:@"longitude"];//经度
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.course] forKey:@"course"];
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.speed] forKey:@"speed"];
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.horizontalAccuracy] forKey:@"horizontalAccuracy"];
//        [dict setValue:[NSString stringWithFormat:@"%f",cl.altitude] forKey:@"altitude"];
//        [dict setValue:[NSString stringWithFormat:@"%@",cl.timestamp] forKey:@"timestamp"];
////        "course" : "344.531250",
////        "speed" : "2.670000",
////        "horizontalAccuracy" : "5.000000",
////        "latitude" : "39.988164",
////        "longtitude" : "116.313631",
////        "altitude" : "57.940080",
////        "timestamp" : "2015-12-10 13:18:31 +0000"
//        [pointArray addObject:dict];
//    }
    
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:(NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_model.track]]];
    if (![array isKindOfClass:[NSNull class]]&&array.count>=2) {
        _count = array.count;
        
        NSDictionary *first=[array firstObject];
        NSDictionary *last=[array lastObject];
        if (([first[@"latitude"] doubleValue]==[last[@"latitude"] doubleValue])&&([first[@"longitude"] doubleValue]==[last[@"longitude"] doubleValue])) {
            NSDictionary *dict=@{@"latitude":[NSString stringWithFormat:@"%f",[first[@"latitude"] doubleValue]+0.000001],@"longitude":[NSString stringWithFormat:@"%f",[first[@"longitude"] doubleValue]+0.000001]};
            [array replaceObjectAtIndex:_count-1 withObject:dict];
        }
        
        _runningCoords = (CLLocationCoordinate2D *)malloc(_count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < _count; i++)
        {
            NSDictionary * data = array[i];
            _runningCoords[i].latitude = [data[@"latitude"] doubleValue];
            _runningCoords[i].longitude = [data[@"longitude"] doubleValue];
            
        }
        _polyline= [MAPolyline polylineWithCoordinates:_runningCoords count:_count];
    }
}
- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-215)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    self.mapView.showsCompass=NO;
    self.mapView.showsScale=NO;
    [self.view addSubview:self.mapView];
}

-(void)initDetailView{
    
    RouteDetailView *view=[[RouteDetailView alloc]initRouteDetail:_model withType:1];
    view.frame=CGRectMake(0, Main_Screen_Height-NavigationbarHeight-215, Main_Screen_Width, 215);
    [self.view addSubview:view];
    
}
- (void)showRoute
{
//    [self.mapView addOverlay:_polyline];
//    const CGFloat screenEdgeInset = 20;
//    UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
//    [self.mapView setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:NO];
    if (_count >= 2) {
        MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
        startPoint.coordinate = _runningCoords[0];
        startPoint.title = @"start";
        [self.mapView addAnnotation:startPoint];
        
        MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
        endPoint.coordinate = _runningCoords[_count-1];
        endPoint.title = @"end";
        [self.mapView addAnnotation:endPoint];
        
        if (![[NSString stringWithFormat:@"%@",_model.type] isEqualToString:@"1"]) {
            [self.mapView addOverlay:self.polyline];
        }
        //    UIEdgeInsets inset = UIEdgeInsetsMake(80, 80, 80, 80);
        //    [self.mapView setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:NO];
        [self.mapView setCenterCoordinate:_runningCoords[0] animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        if ([annotation.title isEqualToString:@"start"]) {
            annotationView.portrait = [UIImage imageNamed:@"Self_Drive_StartPoint"];
        }else if ([annotation.title isEqualToString:@"end"]){
            annotationView.portrait = [UIImage imageNamed:@"Self_Drive_EndPoint"];
        }
        return annotationView;
    }
    return nil;
}
- (MAOverlayRenderer*)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [UIColor redColor];
        renderer.lineWidth = 6.0;
        
        return renderer;
    }
    return nil;
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
