//
//  CtripSettingController.m
//  galaxy
//
//  Created by hfk on 2017/5/16.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "CtripSettingController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "CtripSettingCell.h"
@interface CtripSettingController ()<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)UIView * dockView;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@property (nonatomic,strong)NSString *id;
//关联出差申请单
@property (nonatomic,strong)NSString  *RelateTravelForm;
//公司统一订票
@property (nonatomic,strong)NSString  *UnifiedBooking;
//关联住宿
@property (nonatomic,strong)NSString  *AccomStandard;

//管控出差时间
@property (nonatomic,strong)NSString  *flightDeptDate;
//管控出发地
@property (nonatomic,strong)NSString  *flightFromCity;
//管控目的地
@property (nonatomic,strong)NSString  *flightToCity;
//管控出差人员
@property (nonatomic,strong)NSString  *flightPeople;

@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSMutableArray *choosePeopleArray;

@property (nonatomic,strong)UIView *firstView;//开通
@property (nonatomic,strong)UIView *secondView;//关联机票政策
@property (nonatomic,strong)UIView *thirdView;//关联住宿标准统一订票
@property(nonatomic,strong)UITableView *tableView;//设置
@property (nonatomic,strong)CtripSettingCell *sonCell;

@property (nonatomic,strong)UIView *fourthView;//更多
@end

@implementation CtripSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"差旅设置", nil) backButton:YES];
    _resultArray=[NSMutableArray array];
    _choosePeopleArray=[NSMutableArray array];
    _id=@"0";
    _RelateTravelForm=@"0";
    _UnifiedBooking=@"0";
    _AccomStandard=@"0";
    _flightDeptDate=@"0";
    _flightFromCity=@"0";
    _flightToCity=@"0";
    _flightPeople=@"0";
    [self createScrollView];
    [self createMainView];
    [self getCtripSetting];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.dockView=[[UIView alloc]init];
    self.dockView.backgroundColor=Color_White_Same_20;
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    _firstView=[[UIView alloc]init];
    [self.contentView addSubview:_firstView];
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _secondView=[[UIView alloc]init];
    _secondView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_secondView];
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _thirdView=[[UIView alloc]init];
    [self.contentView addSubview:_thirdView];
    [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_form_TextFieldBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _fourthView=[[UIView alloc]init];
    [self.contentView addSubview:_fourthView];
    [_fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
//MARK:获取差旅设置
-(void)getCtripSetting{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetCtripSetting];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:权限人数
-(void)requestPowerMember{
    NSString *url=[NSString stringWithFormat:@"%@",PowerMemberNew];
    NSDictionary *parameters =@{@"roleId":@"8",@"PageIndex":@"1",@"PageSize":@100,@"OrderBy":@"UserDspName",@"IsAsc":@"asc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:权限人数
-(void)requestPowerMemberAgain{
    NSString *url=[NSString stringWithFormat:@"%@",PowerMemberNew];
    NSDictionary *parameters =@{@"roleId":@"8",@"PageIndex":@"1",@"PageSize":@100,@"OrderBy":@"UserDspName",@"IsAsc":@"asc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:保存差旅设置
-(void)saveCtripSetting{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",SaveCtripSetting];
    NSDictionary *parameters =@{@"id":_id,@"RelateTravelForm":_RelateTravelForm,@"UnifiedBooking":_UnifiedBooking,@"AccomStandard":_AccomStandard,@"FlightDeptDate":_flightDeptDate,@"FlightFromCity":_flightFromCity,@"FlightToCity":_flightToCity,@"FlightPeople":_flightPeople};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    
    switch (serialNum) {
        case 0:
            [self dealWithData];
            break;
        case 1:
            [self dealWithTravelBook];
            [self updateView];
            break;
        case 2:
            [self dealWithTravelBook];
            [self updateTravelManagerView];
            break;
        case 3:
            [self requestPowerMemberAgain];
            break;
        case 4:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0];
        }
            break;
        default:
            break;
    }
}


//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}
//MARK:处理数据
-(void)dealWithData{
    if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
        _AccomStandard=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"accomStandard"]]isEqualToString:@"1"]?@"1":@"0";
        _id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"id"]]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"id"]]:@"0";
        _UnifiedBooking=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"unifiedBooking"]]isEqualToString:@"1"]?@"1":@"0";
        _RelateTravelForm=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"relateTravelForm"]]isEqualToString:@"1"]?@"1":@"0";
        _flightDeptDate=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"flightDeptDate"]]isEqualToString:@"1"]?@"1":@"0";
        _flightFromCity=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"flightFromCity"]]isEqualToString:@"1"]?@"1":@"0";
        _flightToCity=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"flightToCity"]]isEqualToString:@"1"]?@"1":@"0";
        _flightPeople=[[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"flightPeople"]]isEqualToString:@"1"]?@"1":@"0";

    }
    if ([_UnifiedBooking isEqualToString:@"1"]) {
        [self requestPowerMember];
    }else{
        [self updateView];
    }
}

-(void)dealWithTravelBook{
    [_resultArray removeAllObjects];
    [_choosePeopleArray removeAllObjects];
    NSDictionary *result=_resultDict[@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        NSArray *array=result[@"items"];
        if (![array isKindOfClass:[NSNull class]]&&array.count!=0) {
            _resultArray=[NSMutableArray arrayWithArray:array];
            _choosePeopleArray=[NSMutableArray array];
            for (NSDictionary *dict in array) {
                NSDictionary *chooseDict=@{@"requestor":dict[@"userName"],@"requestorUserId":dict[@"userId"]};
                [_choosePeopleArray addObject:chooseDict];
            }
        }else {
            _resultArray = [NSMutableArray arrayWithArray:@[]];
            _choosePeopleArray = [NSMutableArray arrayWithArray:@[]];
        }
    }
}
-(void)updateView{
    [self createFirView];
    [self createSecView];
    [self updateThirdView];
    [self updateFourthView];
}
-(void)createFirView{
    NSString *txet1=Custing(@"关联出差申请,预订信息必须和出差申请单中的需求相同才能预订成功。", nil);
    CGSize size1=[self getSizeWithString:txet1];
    NSInteger height=26+25+size1.height;
    [_firstView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    
    //上部分灰色块
    UIImageView *ImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0.5, 4, 26) imageName:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_firstView addSubview:ImgView];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-30, 26) text:Custing(@"开通在线预订机票、酒店、火车票标准控制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+Main_Screen_Width/2-4, 13.5);
    [_firstView addSubview:titleLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 25.5, Main_Screen_Width, 0.5)];
    lineView.backgroundColor=Color_GrayLight_Same_20;
    [_firstView addSubview:lineView];
    
    
    //关联出差----公司统一
    UIView *LabbackView=[[UIView alloc]initWithFrame:CGRectMake(0, 26, Main_Screen_Width,height-26)];
    LabbackView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_firstView addSubview:LabbackView];
    
    UILabel *lab1=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-100, size1.height+25) text:txet1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab1.numberOfLines=0;
    [LabbackView addSubview:lab1];
    
    
    UISwitch *switch1 = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    switch1.center=CGPointMake(Main_Screen_Width-12-25, (height-26)/2);
    switch1.backgroundColor = [UIColor clearColor];
    [switch1 setOn:[_RelateTravelForm isEqualToString:@"1"] animated:NO];
    [switch1 addTarget:self action:@selector(ClickSwitch:) forControlEvents:UIControlEventValueChanged];
    switch1.onTintColor = Color_Blue_Important_20;
    switch1.tag=1;
    [LabbackView addSubview:switch1];
    
}
-(void)createSecView{
    
    if ([_RelateTravelForm isEqualToString:@"1"]) {
        [_secondView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(10*2+30*5);
        }];
    }else{
        [_secondView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        for (UIView *view in _secondView.subviews) {
            [view removeFromSuperview];
        }
        return;
    }

    //关联机票政策
    [_secondView addSubview:[self createLineViewOfHeight:0 X:12]];

    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10,Main_Screen_Width-12-12, 30) text:Custing(@"关联机票政策,勾选机票需求单需要管控的字段", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_secondView addSubview:titleLabel];
    
    UILabel *lab1=[GPUtils createLable:CGRectMake(12, 10+30, Main_Screen_Width-12-50, 30) text:Custing(@"乘机人", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab1.numberOfLines=0;
    [_secondView addSubview:lab1];
    UIButton *btn1=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 10+30, 50, 30) action:@selector(Click:) delegate:self];
    [btn1 setImage:[UIImage imageNamed:@"Ctrip_Setting_UnSelect"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"Ctrip_Setting_Select"] forState:UIControlStateSelected];
    btn1.selected=[_flightPeople isEqualToString:@"1"];
    btn1.tag=9;
    [_secondView addSubview:btn1];
    
    
     //是否管控出差时间
    UILabel *lab2=[GPUtils createLable:CGRectMake(12, 10+60, Main_Screen_Width-12-50, 30) text:Custing(@"出发日期", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab2.numberOfLines=0;
    [_secondView addSubview:lab2];
    UIButton *btn2=[GPUtils createButton:CGRectMake(Main_Screen_Width-50,10+60, 50, 30) action:@selector(Click:) delegate:self];
    [btn2 setImage:[UIImage imageNamed:@"Ctrip_Setting_UnSelect"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"Ctrip_Setting_Select"] forState:UIControlStateSelected];
    btn2.tag=6;
    btn2.selected=[_flightDeptDate isEqualToString:@"1"];
    [_secondView addSubview:btn2];
    
    //管控出发地
    UILabel *lab6=[GPUtils createLable:CGRectMake(12, 10+90, Main_Screen_Width-12-50, 30) text:Custing(@"出发地", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_secondView addSubview:lab6];
    UIButton *btn6=[GPUtils createButton:CGRectMake(Main_Screen_Width-50,10+90, 50, 30) action:@selector(Click:) delegate:self];
    [btn6 setImage:[UIImage imageNamed:@"Ctrip_Setting_UnSelect"] forState:UIControlStateNormal];
    [btn6 setImage:[UIImage imageNamed:@"Ctrip_Setting_Select"] forState:UIControlStateSelected];
    btn6.tag=7;
    btn6.selected=[_flightFromCity isEqualToString:@"1"];
    [_secondView addSubview:btn6];
    
    
    //管控目的地
    UILabel *lab7=[GPUtils createLable:CGRectMake(12, 10+120, Main_Screen_Width-12-50, 30) text:Custing(@"目的地", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_secondView addSubview:lab7];
    UIButton *btn7=[GPUtils createButton:CGRectMake(Main_Screen_Width-50,10+120, 50, 30) action:@selector(Click:) delegate:self];
    [btn7 setImage:[UIImage imageNamed:@"Ctrip_Setting_UnSelect"] forState:UIControlStateNormal];
    [btn7 setImage:[UIImage imageNamed:@"Ctrip_Setting_Select"] forState:UIControlStateSelected];
    btn7.tag=8;
    btn7.selected=[_flightToCity isEqualToString:@"1"];
    [_secondView addSubview:btn7];
    
}

-(void)updateThirdView{
    
    NSString *txet1=Custing(@"关联住宿标准，只能预订住宿标准以内的酒店。", nil);
    CGSize size1=[self getSizeWithString:txet1];
    
    NSInteger height=10+25+size1.height+10+65;
    
    [_thirdView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    
    //关联住宿----公司统一
    UIView *LabbackView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width,height-10)];
    LabbackView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_thirdView addSubview:LabbackView];
    
    UILabel *lab1=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-100, size1.height+25) text:txet1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab1.numberOfLines=0;
    [LabbackView addSubview:lab1];
    
    UISwitch *switch1 = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    switch1.center=CGPointMake(Main_Screen_Width-12-25, (25+size1.height)/2);
    switch1.backgroundColor = [UIColor clearColor];
    [switch1 setOn:[_AccomStandard isEqualToString:@"1"] animated:NO];
    [switch1 addTarget:self action:@selector(ClickSwitch:) forControlEvents:UIControlEventValueChanged];
    switch1.onTintColor = Color_Blue_Important_20;
    switch1.tag=2;
    [LabbackView addSubview:switch1];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 25+size1.height, Main_Screen_Width, 10)];
    lineView.backgroundColor = Color_White_Same_20;
    [LabbackView addSubview:lineView];

    
    UILabel *lab3=[GPUtils createLable:CGRectMake(12, 25+size1.height+10, Main_Screen_Width-100, 65) text:Custing(@"公司统一订票", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [LabbackView addSubview:lab3];
    
    UISwitch *switch2 = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    switch2.center=CGPointMake(Main_Screen_Width-12-25, 25+size1.height+10+65/2);
    switch2.backgroundColor = [UIColor clearColor];
    [switch2 setOn:[_UnifiedBooking isEqualToString:@"1"] animated:NO];
    [switch2 addTarget:self action:@selector(ClickSwitch:) forControlEvents:UIControlEventValueChanged];
    switch2.onTintColor = Color_Blue_Important_20;
    switch2.tag=3;
    [LabbackView addSubview:switch2];
    
    [self updateTravelManagerView];
}

-(void)updateFourthView{
//    //更多设置
//    [_fourthView updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@40);
//    }];
//
//    UILabel *lab4=[GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-30, 40) text:Custing(@"更多设置请访问PC端\"https://web.xibaoxiao.com\"", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    lab4.numberOfLines=2;
//    lab4.lineBreakMode=NSLineBreakByCharWrapping;
//    [_fourthView addSubview:lab4];
//    
//    [_fourthView addSubview:[self createLineViewOfHeight:0]];

    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fourthView.bottom);
    }];
    
    UIButton *submit=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 50)action:@selector(Click:) delegate:self];
    submit.backgroundColor =Color_Blue_Important_20;
    submit.tag=5;
    [submit setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
    submit.titleLabel.font=Font_filterTitle_17;
    [submit setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:submit];
    
}
-(void)updateTravelManagerView{
    if (![_UnifiedBooking isEqualToString:@"1"]) {
        [_resultArray removeAllObjects];
        [_tableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        NSInteger height=36+36+_resultArray.count*30;
        [_tableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    [_tableView reloadData];
}

-(void)Click:(UIButton *)btn{
    switch (btn.tag) {
        case 4://添加预订人
        {
            [self addPowerMember];
        }
            break;
        case 5://保存差旅设置
        {
            if ([_RelateTravelForm isEqualToString:@"1"]&&[_flightPeople isEqualToString:@"0"]&&[_flightToCity isEqualToString:@"0"]&&[_flightFromCity isEqualToString:@"0"]&&[_flightDeptDate isEqualToString:@"0"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请至少选择一个机票需求单管控字段", nil) duration:2.0];
                return;
            }
            if ([_UnifiedBooking isEqualToString:@"1"]&&_resultArray.count==0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请设置差旅负责人", nil) duration:2.0];
                return;
            }
            [self saveCtripSetting];
        }
            break;
        case 6://是否管控出差时间
        {
            if ([_flightDeptDate isEqualToString:@"1"]) {
                _flightDeptDate=@"0";
            }else{
                _flightDeptDate=@"1";
            }
            btn.selected=!btn.selected;
        }
            break;
        case 7://管控出发地
        {
            if ([_flightFromCity isEqualToString:@"1"]) {
                _flightFromCity=@"0";
            }else{
                _flightFromCity=@"1";
            }
            btn.selected=!btn.selected;
        }
            break;
        case 8://管控目的地
        {
            if ([_flightToCity isEqualToString:@"1"]) {
                _flightToCity=@"0";
            }else{
                _flightToCity=@"1";
            }
            btn.selected=!btn.selected;
        }
            break;
        case 9://管控出差人员
        {
            if ([_flightPeople isEqualToString:@"1"]) {
                _flightPeople=@"0";
            }else{
                _flightPeople=@"1";
            }
            btn.selected=!btn.selected;
        }
            break;
        default:
            break;
    }
}

-(void)ClickSwitch:(UISwitch *)obj{
    switch (obj.tag) {
        case 1://是否关联出差
        {
            if ([_RelateTravelForm isEqualToString:@"1"]) {
                _RelateTravelForm=@"0";
            }else{
                _RelateTravelForm=@"1";
            }
            [self createSecView];
            [obj setOn:[_RelateTravelForm isEqualToString:@"1"] animated:NO];
        }
            break;
        case 2://是否关联住宿
        {
            if ([_AccomStandard isEqualToString:@"1"]) {
                _AccomStandard=@"0";
            }else{
                _AccomStandard=@"1";
            }
            [obj setOn:[_AccomStandard isEqualToString:@"1"] animated:NO];
        }
            break;
        case 3://是否公司统一订票
        {
            if ([_UnifiedBooking isEqualToString:@"1"]) {
                _UnifiedBooking=@"0";
                [self updateTravelManagerView];
            }else{
                _UnifiedBooking=@"1";
                [self requestPowerMemberAgain];
            }
            [obj setOn:[_UnifiedBooking isEqualToString:@"1"] animated:NO];
        }
            break;
        default:
            break;
    }
}
//MARK:添加成员
-(void)addPowerMember{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople =_choosePeopleArray;
    contactVC.status = @"5";
    contactVC.menutype=3;
    contactVC.Radio = @"2";
    contactVC.isclean = @"1";
    contactVC.itemType = 99;
    [contactVC setBlock:^(NSMutableArray *array) {
        if (array.count > 0) {
            NSMutableArray *roleNames=[NSMutableArray array];
            NSMutableArray *userNames=[NSMutableArray array];
            for (buildCellInfo *info in array) {
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]]) {
                    [roleNames addObject:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];
                }
                if ([NSString isEqualToNull:info.requestor]) {
                    [userNames addObject:[NSString stringWithFormat:@"%@",info.requestor]];
                }
            }
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",PowerMemberInsert];
            NSDictionary *parameters =@{@"RoleId":@"8",@"RoleName":[GPUtils getSelectResultWithArray:roleNames WithCompare:@","],@"UserName":[GPUtils getSelectResultWithArray:userNames WithCompare:@","],@"Description":Custing(@"差旅代订人", nil)};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(CGSize )getSizeWithString:(NSString *)str{
    
    return [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-100, 10000) lineBreakMode:NSLineBreakByCharWrapping];
}


//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 36)];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 0,Main_Screen_Width-12-12, 36) text:Custing(@"设置差旅负责人", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:titleLabel];
    
    [view addSubview:[self createLineViewOfHeight:0 X:12]];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 36)];
    
    UILabel *lab=[GPUtils createLable:CGRectMake(12, 0, 100, 36) text:Custing(@"添加负责人", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 36) action:@selector(addPowerMember) delegate:self];
    [view addSubview:btn];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _sonCell=[tableView dequeueReusableCellWithIdentifier:@"CtripSettingCell"];
    if (_sonCell==nil) {
        _sonCell=[[CtripSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CtripSettingCell"];
    }
    NSDictionary *dict=_resultArray[indexPath.row];
    [_sonCell configItemWithDict:dict];
    [_sonCell.deletBtn addTarget:self action:@selector(deletePeo:) forControlEvents:UIControlEventTouchUpInside];
    _sonCell.deletBtn.tag=300+indexPath.row;
    return _sonCell;
}
//MARK:删除负责人
-(void)deletePeo:(UIButton *)btn{
    if (_resultArray.count==1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少有一个差旅负责人", nil) duration:2.0];
        return;
    }
    NSDictionary *dict=_resultArray[btn.tag-300];
//    NSString *name=dict[@"userName"];
//    if ([name isEqualToString:self.userdatas.userDspName]) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"差旅负责人不允许删除自己", nil) duration:2.0];
//        return;
//    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",PowerMemberDelete];
    NSDictionary *parameters =@{@"RoleId":@"8",@"RoleName":dict[@"userId"],@"UserName":dict[@"userName"],@"Description":Custing(@"差旅代订人", nil)};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    
}
-(UIView *)createLineViewOfHeight:(CGFloat)height{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,height, Main_Screen_Width,0.5)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
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
