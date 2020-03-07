//
//  AttendanceViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAGeometry.h>
#import "AttendAnceManageViewController.h"
#import "AttendanceInfoViewController.h"
#import "KxMenu.h"
#import "XFSegementView.h"
#import "XBKeychain.h"
#import <MAMapKit/MAMapKit.h>

@interface AttendanceViewController ()<AMapLocationManagerDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TouchLabelDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocationManager *cllocationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) UILabel *lab_State;
@property (nonatomic, strong) UILabel *lab_Title;
@property (nonatomic, strong) UIButton *btn_clockIn;
@property (nonatomic, strong) UILabel *lab_time;
@property (nonatomic, strong) NSDate *date_network;
@property (nonatomic, strong) UILabel *lab_LocationInfo;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, strong) NSTimer *time_lab;
@property (nonatomic, assign) CLLocationCoordinate2D location_select;
@property (nonatomic, strong) AMapLocationReGeocode *amp_select;
@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) NSArray *arr_addrs;
@property (nonatomic, strong) NSArray *arr_Hips;
@property (nonatomic, strong) UITableView *tbv;

@property (nonatomic, strong) UIView *view_Sure;
@property (nonatomic, strong) UITextView *txv_Remark;

@property (nonatomic, strong) NSMutableArray *arr_totle;
@property (nonatomic, strong) NSString *str_img;
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign) NSInteger IsOut;

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"" backButton:YES];
    _IsOut = 0;
    _str_img = @"";
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(75, 0, Main_Screen_Width-150, 44)];
    if ([self.userdatas.arr_XBCode containsObject:@"OffsitePunch"]) {
        _segementView.titleArray = @[Custing(@"上下班打卡", nil),Custing(@"外出打卡",nil)];
        [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
        _segementView.titleSelectedColor = Color_Blue_Important_20;
        if (self.userdatas.SystemType==1) {
            _segementView.titleColor = Color_form_TextFieldBackgroundColor;
            _segementView.titleSelectedColor = Color_form_TextFieldBackgroundColor;
            [_segementView.scrollLine setBackgroundColor:Color_form_TextFieldBackgroundColor];
        }
    }else{
        _segementView.titleArray =@[Custing(@"上下班打卡", nil)];
        [_segementView.scrollLine setBackgroundColor:Color_form_TextFieldBackgroundColor];
        _segementView.titleSelectedColor = Color_Unsel_TitleColor;
        if (self.userdatas.SystemType==1) {
            _segementView.titleColor = Color_form_TextFieldBackgroundColor;
            _segementView.titleSelectedColor = Color_form_TextFieldBackgroundColor;
            [_segementView.scrollLine setBackgroundColor:[UIColor clearColor]];
        }
    }
    _segementView.titleFont = 16;
    _segementView.touchDelegate = self;
    _segementView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _segementView;
    
    self.view.backgroundColor = Color_White_Same_20;
    _date_network = [NSDate getInternetDate];
    [self initializeData];
    [self configLocationManager];
    [self initCompleteBlock];
    [self createView];
    
    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRecording) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_time forMode:NSRunLoopCommonModes];
    _time_lab = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(label_Time) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_time_lab forMode:NSRunLoopCommonModes];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_arr_totle.count<=0) {
        [self requestAttendanceGetAttendance];
    }
}

#pragma mark - function
-(void)onRecording{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

-(void)label_Time{
    if (_date_network==nil) {
        _date_network = [NSDate getInternetDate];
    }
    _date_network =  [NSDate dateWithTimeInterval:1 sinceDate:_date_network];
    _lab_time.text = [NSString stringWithTime:_date_network];
}

- (void)createView{
    _lab_State = [GPUtils createLable:CGRectMake(0, Main_Screen_Height-380, Main_Screen_Width, 50) text:Custing(@"未进入打卡范围", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    _lab_State.numberOfLines = 0;
    [self.view addSubview:_lab_State];
    
    _btn_clockIn  = [GPUtils createButton:CGRectMake(Main_Screen_Width/2-72, Main_Screen_Height-330, 144, 144) action:nil delegate:nil];
    [self.view addSubview:_btn_clockIn];
    [_btn_clockIn setBackgroundImage:[UIImage imageNamed:@"Attendance_BackNo"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [_btn_clockIn bk_whenTapped:^{
        if (weakSelf.amp_select) {
            if (weakSelf.location_select.latitude) {
                [weakSelf.time invalidate];
                weakSelf.time = nil;
                [weakSelf addAttendanceInfo];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
            }
        }else{
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
        }
    }];
    
    _lab_time = [GPUtils createLable:CGRectMake(0, 37, 144, 50) text:[NSString stringWithTime:[NSDate getInternetDate]] font:Font_Amount_21_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    [_btn_clockIn addSubview:_lab_time];
    _lab_Title = [GPUtils createLable:CGRectMake(0, 67, 144, 50) text:Custing(@"上班打卡", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    [_btn_clockIn addSubview:_lab_Title];
    if (_IsOut == 1) {
        _lab_Title.text =  Custing(@"打卡", nil);
    }
    _lab_time.textColor = Color_GrayDark_Same_20;
    _lab_Title.textColor = Color_GrayDark_Same_20;
    _btn_clockIn.userInteractionEnabled = NO;
    
    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2-12.5, Main_Screen_Height-180, 25, 28) imageName:@"Attendance_LocationIcon"];
    [self.view addSubview:img];
    
    _lab_LocationInfo = [GPUtils createLable:CGRectMake(0, Main_Screen_Height-140, Main_Screen_Width, 30) text:Custing(@"加载中", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lab_LocationInfo];
    
    UIButton *rigbtn = [UIButton new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rigbtn title:nil titleColor:nil titleIndex:0 imageName:@"Attendance_Info" target:self action:@selector(rightbtn)];
    if ([self.userdatas.isSystem isEqualToString:@"1"]) {
        [rigbtn setImage:[UIImage imageNamed:@"NavBarImg_More"] forState:UIControlStateNormal];
    }
}

- (void)initCompleteBlock
{
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed){
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
            return;
        }else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
            return;
        }else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation){
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
            return;
        }else{
            //修改label显示内容
            if (regeocode)
            {
                if ([NSString isEqualToNull:regeocode.formattedAddress]) {
                    weakSelf.lab_LocationInfo.text = regeocode.formattedAddress;
                    if (weakSelf.IsOut == 1) {
                        weakSelf.amp_select = regeocode;
                        weakSelf.location_select = location.coordinate;
                        weakSelf.lab_State.text = Custing(@"你已进入打卡范围", nil);
                        weakSelf.lab_State.textColor = Color_form_TextField_20;
                        weakSelf.lab_time.textColor = Color_Blue_Important_20;
                        weakSelf.lab_Title.textColor = Color_Blue_Important_20;
                        weakSelf.btn_clockIn.userInteractionEnabled = YES;
                        [weakSelf.btn_clockIn setImage:[UIImage imageNamed:@"Attendance_Back"] forState:UIControlStateNormal];
                    }else{
                        if (weakSelf.arr_addrs.count>0) {
                            for (int i = 0; i<weakSelf.arr_addrs.count; i++) {
                                NSDictionary *dic = weakSelf.arr_addrs[i];
                                NSArray *arr_location = [[NSString stringWithIdOnNO:dic[@"latitude"]]componentsSeparatedByString:@","];
                                CLLocationCoordinate2D center = CLLocationCoordinate2DMake([arr_location[0] doubleValue],[arr_location[1] doubleValue]);
                                BOOL isContains = MACircleContainsCoordinate(center, location.coordinate, [[NSString stringWithIdOnNO:weakSelf.dic_request[@"result"][@"signScope"]] doubleValue]);
                                if (isContains) {
                                    weakSelf.amp_select = regeocode;
                                    weakSelf.location_select = location.coordinate;
                                    weakSelf.lab_State.text = Custing(@"你已进入打卡范围", nil);
                                    weakSelf.lab_State.textColor = Color_form_TextField_20;
                                    weakSelf.lab_time.textColor = Color_Blue_Important_20;
                                    weakSelf.lab_Title.textColor = Color_Blue_Important_20;
                                    weakSelf.btn_clockIn.userInteractionEnabled = YES;
                                    [weakSelf.btn_clockIn setImage:[UIImage imageNamed:@"Attendance_Back"] forState:UIControlStateNormal];
                                    break;
                                }else{
                                    weakSelf.lab_State.text = Custing(@"未进入打卡范围", nil);
                                    weakSelf.lab_State.textColor = Color_GrayDark_Same_20;
                                    weakSelf.lab_time.textColor = Color_GrayDark_Same_20;
                                    weakSelf.lab_Title.textColor = Color_GrayDark_Same_20;
                                    weakSelf.btn_clockIn.userInteractionEnabled = NO;
                                    [weakSelf.btn_clockIn setImage:[UIImage imageNamed:@"Attendance_BackNo"] forState:UIControlStateNormal];
                                }
                            }
                        }else{
                            weakSelf.lab_State.text = Custing(@"未进入打卡范围", nil);
                            weakSelf.lab_State.textColor = Color_GrayDark_Same_20;
                            weakSelf.lab_time.textColor = Color_GrayDark_Same_20;
                            weakSelf.lab_Title.textColor = Color_GrayDark_Same_20;
                            weakSelf.btn_clockIn.userInteractionEnabled = NO;
                            [weakSelf.btn_clockIn setImage:[UIImage imageNamed:@"Attendance_BackNo"] forState:UIControlStateNormal];
                        }
                    }
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
                    return;
                }
            }else{
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"定位信息有误", nil) duration:1.5];
                return;
            }
        }
    };
}

- (void)configLocationManager
{
    self.mapView = [[MAMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:3];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:5];

}

-(void)createTableView{
    NSInteger height = _arr_Hips.count*40;
    if (height>Main_Screen_Height-460) {
        height = Main_Screen_Height-460;
    }
    if (_tbv==nil) {
        _tbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height) style:UITableViewStylePlain];
        _tbv.allowsMultipleSelection = NO;
        _tbv.backgroundColor = Color_form_TextFieldBackgroundColor;
        _tbv.delegate = self;
        _tbv.dataSource = self;
        _tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tbv];
    }else{
        _tbv.frame = CGRectMake(0, 0, Main_Screen_Width, height);
        [_tbv reloadData];
    }
    if ([_arr_Hips count]) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_arr_Hips.count-1 inSection:0];
        [_tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)createSureView{
    if (_view_Sure) {
        [_view_Sure removeFromSuperview];
        _view_Sure = nil;
    }
    _view_Sure = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _view_Sure.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_view_Sure];
    __weak typeof(self) weakSelf = self;
    [_view_Sure bk_whenTapped:^{
        [weakSelf.view_Sure removeFromSuperview];
        weakSelf.view_Sure = nil;
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(27, Main_Screen_Height/2-172, Main_Screen_Width-54, 172)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    view.layer.cornerRadius = 15;
    [_view_Sure addSubview:view];
    
    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2-55, 25, 56, 56) imageName:@"Attendance_Affirm"];
    [view addSubview:img];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(0, 100, Main_Screen_Width-54, 25) text:Custing(@"今日打卡已完成", nil) font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab];
    
    UILabel *lab_time = [GPUtils createLable:CGRectMake(0, 125, Main_Screen_Width-54, 25) text:[NSString stringWithFormat:@"%@%@",Custing(@"打卡时间", nil),_lab_time.text] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab_time];
    NSArray *arr = _dic_request[@"result"][@"attendanceHists"];
    NSDictionary *dic = arr.lastObject;
    if ([NSString isEqualToNull:dic[@"timeCard"]]) {
        lab_time.text = [NSString stringWithFormat:@"%@%@",Custing(@"打卡时间", nil),dic[@"timeCard"]];
    }
}

-(void)createTxfView:(NSInteger)type{
    if (_view_Sure) {
        [_view_Sure removeFromSuperview];
        _view_Sure = nil;
    }
    _view_Sure = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _view_Sure.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_view_Sure];
    __weak typeof(self) weakSelf = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(27, Main_Screen_Height/2-(_IsOut==1?250:200), Main_Screen_Width-54, _IsOut==1?455:355)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    view.layer.cornerRadius = 15;
    [_view_Sure addSubview:view];
    
    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2-55, 20, 56, 56) imageName:@"Attendance_Warring"];
    [view addSubview:img];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(0, 90, Main_Screen_Width-54, 25) text:type==1?Custing(@"迟到打卡", nil):Custing(@"早退打卡", nil) font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab];
    
    if (_IsOut == 1&&type == 0) {
        [img setImage:[UIImage imageNamed:@"Attendance_normal"]];
        lab.text = Custing(@"外出打卡", nil);
    }
    
    UIImageView *img_line = [GPUtils createImageViewFrame:CGRectMake(0, 130, Main_Screen_Width-54, 0.5) imageName:@""];
    img_line.backgroundColor = Color_GrayLight_Same_20;
    [view addSubview:img_line];
    
    UILabel *lab_time = [GPUtils createLable:CGRectMake(12, 140, Main_Screen_Width-78, 30) text:[NSString stringWithFormat:@"%@%@",Custing(@"时间：", nil),_lab_time.text] font:Font_Important_15_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_time];
    
    UILabel *lab_content = [GPUtils createLable:CGRectMake(12, 170, Main_Screen_Width-78, 35) text:[NSString stringWithFormat:@"%@%@",Custing(@"位置：", nil),_amp_select.formattedAddress] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_content];
    
    UIView *view_txv = [[UIView alloc]initWithFrame:CGRectMake(0, 210, Main_Screen_Width-54, 105)];
    view_txv.backgroundColor = Color_White_Same_20;
    [view addSubview:view_txv];
    
    _txv_Remark = [GPUtils createUITextView:CGRectMake(12, 5, Main_Screen_Width-78, 95) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    __block UILabel *lab_txv = [GPUtils createLable:CGRectMake(0, 0, WIDTH(_txv_Remark), 20) text:Custing(@"报告原因", nil) font:Font_Important_15_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentLeft];
    [_txv_Remark addSubview:lab_txv];
    _txv_Remark.delegate = self;
    [view_txv addSubview:_txv_Remark];
    
    if (_IsOut == 1) {
        EditAndLookImgView *imgview=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 310, Main_Screen_Width-54, 88) withEditStatus:1];
        imgview.imgCollectView.frame = CGRectMake(X(imgview.imgCollectView), Y(imgview.imgCollectView), Main_Screen_Width-74, HEIGHT(imgview.imgCollectView));
        imgview.maxCount=5;
        [view addSubview:imgview];
        [imgview updateWithTotalArray:_arr_totle WithImgArray:[NSMutableArray array]];
        for (UIView *view in [imgview subviews]) {
            if ([view isKindOfClass:[UIView class]]) {
                if (view.frame.size.height == 10) {
                    view.frame = CGRectMake(X(view), Y(view), Main_Screen_Width-54, HEIGHT(view));
                }
            }
        }
        UIImageView *img_line1 = [GPUtils createImageViewFrame:CGRectMake(0, _IsOut==1?405:305, Main_Screen_Width-54, 0.5) imageName:@""];
        img_line1.backgroundColor = Color_GrayLight_Same_20;
        [view addSubview:img_line1];
    }
    
    UIButton *btn = [GPUtils createButton:CGRectMake(0, _IsOut==1?410:310, WIDTH(view)/2, 45) action:nil delegate:nil title:Custing(@"取消", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    [btn bk_whenTapped:^{
        [weakSelf.view_Sure removeFromSuperview];
        weakSelf.view_Sure = nil;
    }];
    [view addSubview:btn];
    
    UIImageView *img_line_b = [GPUtils createImageViewFrame:CGRectMake(WIDTH(view)/2, _IsOut==1?420:320, 0.5, 25) imageName:@""];
    img_line_b.backgroundColor = Color_GrayLight_Same_20;
    [view addSubview:img_line_b];
    
    UIButton *btn_right = [GPUtils createButton:CGRectMake(WIDTH(view)/2, _IsOut==1?410:310, WIDTH(view)/2, 45) action:nil delegate:nil title:Custing(@"确认打卡", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
    [btn_right bk_whenTapped:^{
        if (weakSelf.IsOut == 1) {
            [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:weakSelf.arr_totle WithUrl:WorkCarduploader WithBlock:^(id data, BOOL hasError) {
                [YXSpritesLoadingView dismiss];
                weakSelf.arr_totle = [NSMutableArray array];
                weakSelf.str_img = data;
                if (hasError) {
                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
                }else{
                    [weakSelf requestAttendanceClockIn];
                }
            }];
        }else{
            [weakSelf requestAttendanceClockIn];
        }
    }];
    [view addSubview:btn_right];
}

#pragma mark  data
- (void)initializeData{
    _arr_addrs = [NSArray array];
    _dic_request = [NSDictionary dictionary];
    _arr_totle = [NSMutableArray array];
}

-(void)analysisRequestData{
    if ([_dic_request[@"result"][@"attendanceAddrs"] isKindOfClass:[NSArray class]]) {
        _arr_addrs = _dic_request[@"result"][@"attendanceAddrs"];
    }
    if ([_dic_request[@"result"][@"attendanceHists"] isKindOfClass:[NSArray class]]) {
        _arr_Hips = _dic_request[@"result"][@"attendanceHists"];
    }
    if (_arr_Hips.count>0) {
        [self createTableView];
    }
    NSArray *arr = _dic_request[@"result"][@"attendanceHists"];
    if (_IsOut == 0) {
        if (arr.count==0) {
            _lab_Title.text = Custing(@"上班打卡", nil);
        }else if (arr.count == 1){
            NSDictionary *dic = arr[0];
            if ([dic[@"type"] integerValue]==2) {
                _lab_Title.text = Custing(@"上班打卡", nil);
            }else{
                _lab_Title.text = Custing(@"下班打卡", nil);
            }
        }else{
            NSDictionary *dic = arr[0];
            if ([dic[@"type"] integerValue]!=2) {
                [self createSureView];
            }
            _lab_Title.text = Custing(@"下班打卡", nil);
        }
    }else{
        _lab_Title.text = Custing(@"打卡", nil);
    }
}

#pragma mark network
-(void)requestAttendanceGetAttendance{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceGetAttendance];
    NSDictionary *parameters = @{@"TimeCardDate":[NSString stringWithDate:[NSDate date]],@"Type":[NSNumber numberWithInteger:_IsOut]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)requestAttendanceClockIn{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceClockIn];
    NSDictionary *parameters = @{@"Address":_amp_select.formattedAddress,@"Remark":[NSString stringWithIdOnNO:_txv_Remark.text],@"Type":[NSNumber numberWithInteger:_IsOut],@"Attachments":_str_img,@"DeviceNumber":[XBKeychain getDeviceIDInKeychain]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

#pragma mark - action
-(void)rightbtn{
    if ([self.userdatas.isSystem isEqualToString:@"0"]) {
        [self GoToInfo];
    }else{
        if ([KxMenu isShowingInView:self.view]) {
            [KxMenu dismissMenu:YES];
        }else{
            [KxMenu setTitleFont:Font_Important_15_20];
            [KxMenu setTintColor:Color_form_TextFieldBackgroundColor];
            [KxMenu setOverlayColor:[UIColor colorWithWhite:0 alpha:0.4]];
            [KxMenu setLineColor:Color_GrayLight_Same_20];
            
            NSMutableArray *menuItems=[NSMutableArray array];
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"管理", nil) image:[UIImage imageNamed:@"Attendance_Manage"] target:self action:@selector(GoToManage)]];
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"统计", nil) image:[UIImage imageNamed:@"Attendance_Info"] target:self action:@selector(GoToInfo)]];
            [menuItems setValue:Color_Blue_Important_20 forKey:@"foreColor"];
            CGRect senderFrame = CGRectMake(Main_Screen_Width - (kDevice_Is_iPhone6Plus? 30: 26), NavigationbarHeight, 0, 0);
            [KxMenu showMenuInView:ApplicationDelegate.window
                          fromRect:senderFrame
                         menuItems:menuItems];
        }
    }
}

-(void)GoToManage{
    AttendAnceManageViewController *att = [[AttendAnceManageViewController alloc]init];
    [self.navigationController pushViewController:att animated:YES];
}

-(void)GoToInfo{
    AttendanceInfoViewController *att = [[AttendanceInfoViewController alloc]init];
    [self.navigationController pushViewController:att animated:YES];
}

-(void)addAttendanceInfo{
    if (![NSString isEqualToNull:_dic_request[@"result"][@"fromTime"]]&&_IsOut!=1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您还没有设置考勤管理哦", nil) duration:1.5];
        return;
    }
    if (_amp_select) {
        if (_location_select.latitude) {
            if ([NSString isEqualToNull:_lab_time.text]) {
                if (_IsOut == 1) {
                    [self createTxfView:0];
                }else{
                    NSInteger state = 0;//0正常  1 迟到  2 早退
                    NSArray *arr = _dic_request[@"result"][@"attendanceHists"];
                    NSTimeInterval before = [[NSDate TimeFromString:_lab_time.text] timeIntervalSinceDate:[NSDate TimeFromString:_dic_request[@"result"][@"fromTime"]]];
                    NSTimeInterval after = [[NSDate TimeFromString:_lab_time.text] timeIntervalSinceDate:[NSDate TimeFromString:_dic_request[@"result"][@"toTime"]]];
                    if (arr.count==0) {
                        if (before>=0) {
                            state = 1;
                        }
                    }else if (arr.count == 1){
                        NSDictionary *dic = arr[0];
                        if ([dic[@"type"] integerValue]==2) {
                            if (before>=0) {
                                state = 1;
                            }
                        }else{
                            if (after<=0) {
                                state = 2;
                            }
                        }
                    }else{
                        if (after<=0) {
                            state = 2;
                        }
                    }
                    if (state == 0) {
                        [self requestAttendanceClockIn];
                    }else{
                        [self createTxfView:state];
                    }
                }
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"无法获取时间，请确保网络连接后重试。", nil) duration:1.5];
            }
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"定位信息有误", nil) duration:1.5];
        }
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"定位信息有误", nil) duration:1.5];
    }
}

#pragma mark - Delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self onRecording];
    }
    if (serialNum == 1) {
        [_view_Sure removeFromSuperview];
        _view_Sure = nil;
        [self requestAttendanceGetAttendance];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr_Hips.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arr_Hips[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lab_time = [GPUtils createLable:CGRectMake(12, 0, 50, 40) text:dic[@"timeCard"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_time];
    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(64, 0, 8, 40) imageName:@"Attendance_ActionTime"];
    [cell addSubview:img];
    if (_arr_Hips.count == indexPath.row+1) {
        [img setImage:[UIImage imageNamed:@"Attendance_EndTime"]];
    }
    UILabel *lab_address = [GPUtils createLable:CGRectMake(96, 0, Main_Screen_Width-108, 40) text:dic[@"address"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_address];
    return cell;
}

-(void)textViewDidChange:(UITextView *)textView{
    for (UIView *view in [textView subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)touchLabelWithIndex:(NSInteger)index {
    _IsOut = index;
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    [self initializeData];
    _tbv = nil;
    [self createView];
    [self requestAttendanceGetAttendance];
    if (_IsOut == 1) {
        _lab_State.hidden = YES;
    }else{
        _lab_State.hidden = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
