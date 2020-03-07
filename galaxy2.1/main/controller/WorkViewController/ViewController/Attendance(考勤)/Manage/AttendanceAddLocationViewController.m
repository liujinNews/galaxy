//
//  AttendanceAddLocationViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceAddLocationViewController.h"
#import "AttendanceLocation.h"

#import "PlaceAroundTableView.h"

@interface AttendanceAddLocationViewController ()<PlaceAroundTableViewDeleagate,MAMapViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) PlaceAroundTableView *tableview;
@property (nonatomic, assign) NSInteger             searchPage;
@property (nonatomic, strong) AMapSearchAPI        *search;
@property (nonatomic, strong) MAMapView            *mapView;
@property (nonatomic, assign) BOOL                  isLocated;
@property (nonatomic, strong) UIImageView          *redWaterView;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;
@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;
@property (nonatomic, strong) AMapPOI               *model_return;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation AttendanceAddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"考勤地点", nil) backButton:YES];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(rightbtn)];
    [self initTableview];
    [self initSearch];
    [self initMapView];
    [self initRedWaterView];
    [self initLocationButton];
    [self actionSearchAround];
}

#pragma mark - function
- (void)initTableview
{
    self.tableview = [[PlaceAroundTableView alloc] initWithFrame:CGRectMake(0, 349, CGRectGetWidth(self.view.bounds), Main_Screen_Height-413)];
    self.tableview.delegate = self;
    
    [self.view addSubview:self.tableview];
}

- (void)initSearch
{
    self.searchPage = 1;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self.tableview;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    _searchBar.delegate = self;
    _searchBar.placeholder  = Custing(@"搜索", nil);
    [self.view addSubview:_searchBar];
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 49, CGRectGetWidth(self.view.bounds), 364)];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    self.isLocated = NO;
}

- (void)initRedWaterView
{
    UIImage *image = [UIImage imageNamed:@"wateRedBlank"];
    self.redWaterView = [[UIImageView alloc] initWithImage:image];
    self.redWaterView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, self.mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
    self.redWaterView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.mapView.bounds) / 2 - CGRectGetHeight(self.redWaterView.bounds) / 2);
    [self.view addSubview:self.redWaterView];
}

- (void)initLocationButton
{
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.bounds) - 40, CGRectGetHeight(self.mapView.bounds) - 20, 32, 32)];
    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.locationBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.locationBtn.layer.cornerRadius = 3;
    [self.locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    [self.view addSubview:self.locationBtn];
}

/* 移动窗口弹一下的动画 */
- (void)redWaterAnimimate{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y -= 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y += 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
}

#pragma mark - Utility
/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    request.radius   = 1000;
    request.sortrule = 0;
    request.page     = self.searchPage;
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - action
-(void)rightbtn{
    if (_model_return == nil) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择一个点", nil) duration:1.5];
    }else{
        if (self.block) {
            self.block(_model_return);
        }
        [self returnBack];
    }
}


- (void)actionSearchAround
{
    [self searchReGeocodeWithCoordinate:self.mapView.centerCoordinate];
    [self searchPoiByCenterCoordinate:self.mapView.centerCoordinate];
    self.searchPage = 1;
    [self redWaterAnimimate];
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow){
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }else{
        self.searchPage = 1;
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

#pragma mark - userLocation

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0){
        return ;
    }
    if (!self.isLocated){
        self.isLocated = YES;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        [self actionSearchAround];
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone){
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }else{
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}


#pragma mark - TableViewDelegate

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi
{
    // 防止连续点两次
//    if(self.isMapViewRegionChangedFromTableView == YES){
//        return;
//    }
    _model_return = selectedPoi;
    self.isMapViewRegionChangedFromTableView = YES;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    [self.mapView setCenterCoordinate:location animated:YES];
}

- (void)didPositionCellTapped:(NSString *)Poi
{
    // 防止连续点两次
//    if(self.isMapViewRegionChangedFromTableView == YES){
//        return;
//    }
    _model_return = [[AMapPOI alloc]init];
    _model_return.name = Poi;
    [_model_return setLocation:[AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] ];
    self.isMapViewRegionChangedFromTableView = YES;
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)didLoadMorePOIButtonTapped
{
    self.searchPage++;
    [self searchPoiByCenterCoordinate:self.mapView.centerCoordinate];
}


#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone){
        [self actionSearchAround];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self keyClose];
    [self.searchBar resignFirstResponder];
    if(self.searchBar.text.length == 0) {
        return;
    }
    [self searchPoiByKeyword:self.searchBar.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
