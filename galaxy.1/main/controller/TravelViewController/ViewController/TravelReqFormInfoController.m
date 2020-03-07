//
//  TravelReqFormInfoController.m
//  galaxy
//
//  Created by hfk on 2018/5/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelReqFormInfoController.h"
#import "CtripMainController.h"
#import "TravelReqFormEditController.h"
@interface TravelReqFormInfoController ()<GPClientDelegate,UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;
/**
 *  下部按钮底层视图
 */
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 单号
 */
@property(nonatomic,strong)UIView *View_SerialNo;
/**
 申请人
 */
@property(nonatomic,strong)UIView *View_UserDspName;
/**
 出发日期
 */
@property(nonatomic,strong)UIView *View_goDate;
/**
出发地
 */
@property(nonatomic,strong)UIView *View_FromCity;
/**
 目的地
 */
@property(nonatomic,strong)UIView *View_ToCity;
/**
 乘客
 */
@property(nonatomic,strong)UIView *View_People;

/**
入住城市
 */
@property(nonatomic,strong)UIView *View_CheckInCity;
/**
入住日期
 */
@property(nonatomic,strong)UIView *View_CheckInDate;
/**
退房日期
 */
@property(nonatomic,strong)UIView *View_CheckOutDate;
/**
房间数
 */
@property(nonatomic,strong)UIView *View_Rooms;
/**
备注
 */
@property(nonatomic,strong)UIView *View_Remark;

@end

@implementation TravelReqFormInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    [self createScrollView];
    [self updateViews];
}

-(void)createScrollView{
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(([NSString isEqualToNull:self.model_Data.expiredTime] ? @0:@50));
    }];
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.dockView.top);
    }];
   
    [self createContentView];
    [self createMainView];
}
-(void)createContentView{
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    _View_SerialNo=[[UIView alloc]init];
    [self.contentView addSubview:_View_SerialNo];
    [_View_SerialNo updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];

    _View_UserDspName=[[UIView alloc]init];
    [self.contentView addSubview:_View_UserDspName];
    [_View_UserDspName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SerialNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_goDate=[[UIView alloc]init];
    [self.contentView addSubview:_View_goDate];
    [_View_goDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_UserDspName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_FromCity=[[UIView alloc]init];
    [self.contentView addSubview:_View_FromCity];
    [_View_FromCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_goDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToCity=[[UIView alloc]init];
    [self.contentView addSubview:_View_ToCity];
    [_View_ToCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_People=[[UIView alloc]init];
    [self.contentView addSubview:_View_People];
    [_View_People makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_CheckInCity=[[UIView alloc]init];
    [self.contentView addSubview:_View_CheckInCity];
    [_View_CheckInCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_People.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CheckInDate=[[UIView alloc]init];
    [self.contentView addSubview:_View_CheckInDate];
    [_View_CheckInDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CheckInCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_CheckOutDate=[[UIView alloc]init];
    [self.contentView addSubview:_View_CheckOutDate];
    [_View_CheckOutDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CheckInDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Rooms=[[UIView alloc]init];
    [self.contentView addSubview:_View_Rooms];
    [_View_Rooms makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CheckOutDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Remark=[[UIView alloc]init];
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Rooms.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
-(void)updateViews{
    
    [self updateView_SerialNo];
    [self updateView_UserDspName];
    [self updateView_Remark];
    NSArray *arr_btn;
    if (_int_Type==0) {
        [self setTitle:Custing(@"机票需求单", nil) backButton:YES];
        arr_btn=@[Custing(@"订机票", nil),Custing(@"修改行程", nil),Custing(@"结束行程", nil)];
        [self updateView_goDate];
        [self updateView_FromCity];
        [self updateView_ToCity];
        [self updateView_PeopleWithPeople:_model_Data.flyPeople];
    }else if (_int_Type==1){
        [self setTitle:Custing(@"酒店需求单", nil) backButton:YES];
        arr_btn=@[Custing(@"订酒店", nil),Custing(@"修改行程", nil),Custing(@"结束行程", nil)];
        [self updateView_CheckInCity];
        [self updateView_CheckInDate];
        [self updateView_CheckOutDate];
        [self updateView_Rooms];
    }else if (_int_Type==2){
        [self setTitle:Custing(@"火车票需求单", nil) backButton:YES];
        arr_btn=@[Custing(@"订火车票", nil),Custing(@"修改行程", nil),Custing(@"结束行程", nil)];
        [self updateView_goDate];
        [self updateView_FromCity];
        [self updateView_ToCity];
        [self updateView_PeopleWithPeople:_model_Data.passenger];
    }
    
    [self.dockView updateViewWithTitleArray:arr_btn WithTitleColorArray:@[Color_form_TextFieldBackgroundColor,Color_form_TextFieldBackgroundColor,Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_Blue_Important_20,Color_Blue_Important_20,Color_Blue_Important_20] WithLineColroArray:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]] WithLineStyle:2];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf GotoCtrip];
        }else if (index==1){
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"暂未开放", nil) duration:2.0];
            return;
//            [weakSelf editTravelForm];
        }else if (index==2){
            [weakSelf endTravelPlan];
        }
    };
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Remark);
    }];
    [self.contentView layoutIfNeeded];
}

-(void)updateView_SerialNo{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"申请单号", nil);
    model.fieldValue=_model_Data.serialNo;
    __weak typeof(self) weakSelf = self;
    [_View_SerialNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_SerialNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_UserDspName{

    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"申请人", nil);
    model.fieldValue=_model_Data.userDspName;
    __weak typeof(self) weakSelf = self;
    [_View_UserDspName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_UserDspName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_goDate{

    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"出发日期", nil);
    model.fieldValue=_model_Data.departureDateStr;
    __weak typeof(self) weakSelf = self;
    [_View_goDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_goDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}


-(void)updateView_FromCity{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"出发地", nil);
    model.fieldValue=_model_Data.fromCity;
    __weak typeof(self) weakSelf = self;
    [_View_FromCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FromCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_ToCity{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"目的地", nil);
    model.fieldValue=_model_Data.toCity;
    __weak typeof(self) weakSelf = self;
    [_View_ToCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ToCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_PeopleWithPeople:(NSString *)people{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"乘客", nil);
    model.fieldValue=people;
    __weak typeof(self) weakSelf = self;
    [_View_People addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_People updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_CheckInCity{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"城市", nil);
    model.fieldValue=_model_Data.checkInCity;
    __weak typeof(self) weakSelf = self;
    [_View_CheckInCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CheckInCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateView_CheckInDate{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"入住日期", nil);
    model.fieldValue=_model_Data.checkInDateStr;
    __weak typeof(self) weakSelf = self;
    [_View_CheckInDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CheckInDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_CheckOutDate{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"退房日期", nil);
    model.fieldValue=_model_Data.checkOutDateStr;
    __weak typeof(self) weakSelf = self;
    [_View_CheckOutDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CheckOutDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_Rooms{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"房间数", nil);
    model.fieldValue=[NSString stringWithFormat:@"%@",_model_Data.numberOfRooms];
    __weak typeof(self) weakSelf = self;
    [_View_Rooms addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Rooms updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateView_Remark{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"备注", nil);
    model.fieldValue=_model_Data.remark;
    __weak typeof(self) weakSelf = self;
    [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)endTravelPlan{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",CtripENDTRAVEL];
    NSDictionary *parameters=@{@"SerialNo":_model_Data.serialNo,@"TaskId":_model_Data.taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
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
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"结束成功", nil) duration:1.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0f];
        }
            break;
        default:
            break;
    }
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)GotoCtrip{
    NSString *str;
    if (_int_Type==0) {
        str=@"FlightSearch";
    }else if (_int_Type==1){
        str=@"HotelSearch";
    }else if (_int_Type==2){
        str=@"TrainSearch";
    }
    CtripMainController * Ctrip = [[CtripMainController alloc]initWithType:str];
    [self.navigationController pushViewController:Ctrip animated:YES];
}

-(void)editTravelForm{
    TravelReqFormEditController *vc=[[TravelReqFormEditController alloc]init];
    vc.model_Data=_model_Data;
    vc.int_Type=_int_Type;
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
