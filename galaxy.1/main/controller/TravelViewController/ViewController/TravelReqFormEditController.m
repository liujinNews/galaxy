//
//  TravelReqFormEditController.m
//  galaxy
//
//  Created by hfk on 2018/5/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelReqFormEditController.h"
#import "NewAddressViewController.h"
@interface TravelReqFormEditController ()<GPClientDelegate,UIScrollViewDelegate,NewAddressVCDelegate>

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
@property(nonatomic,strong)UITextField *txf_SerialNo;
/**
 申请人
 */
@property(nonatomic,strong)UIView *View_UserDspName;
@property(nonatomic,strong)UITextField *txf_UserDspName;

/**
 出发日期
 */
@property(nonatomic,strong)UIView *View_goDate;
@property(nonatomic,strong)UITextField *txf_goDate;

/**
 出发地
 */
@property(nonatomic,strong)UIView *View_FromCity;
@property(nonatomic,strong)UITextField *txf_FromCity;

/**
 目的地
 */
@property(nonatomic,strong)UIView *View_ToCity;
@property(nonatomic,strong)UITextField *txf_ToCity;

/**
 乘客
 */
@property(nonatomic,strong)UIView *View_People;
@property(nonatomic,strong)UITextField *txf_People;


/**
 入住城市
 */
@property(nonatomic,strong)UIView *View_CheckInCity;
@property(nonatomic,strong)UITextField *txf_CheckInCity;

/**
 入住日期
 */
@property(nonatomic,strong)UIView *View_CheckInDate;
@property(nonatomic,strong)UITextField *txf_CheckInDate;

/**
 退房日期
 */
@property(nonatomic,strong)UIView *View_CheckOutDate;
@property(nonatomic,strong)UITextField *txf_CheckOutDate;

/**
 房间数
 */
@property(nonatomic,strong)UIView *View_Rooms;
@property(nonatomic,strong)UITextField *txf_Rooms;

/**
 备注
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;

@property (nonatomic, copy)NSArray * fromcityarray;//去城市
@property (nonatomic, copy)NSArray * tocityarray;//返回城市
@property (nonatomic, copy)NSString *cityType;//请求城市，1出发2目的


@end

@implementation TravelReqFormEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"修改行程", nil) backButton:YES];
    [self createScrollView];
    [self updateViews];

}
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
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
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
    if (_int_Type==0) {
        [self updateView_goDate];
        [self updateView_FromCity];
        [self updateView_ToCity];
        [self updateView_PeopleWithPeople:_model_Data.flyPeople];
    }else if (_int_Type==1){
        [self updateView_CheckInCity];
        [self updateView_CheckInDate];
        [self updateView_CheckOutDate];
        [self updateView_Rooms];
    }else if (_int_Type==2){
        [self updateView_goDate];
        [self updateView_FromCity];
        [self updateView_ToCity];
        [self updateView_PeopleWithPeople:_model_Data.passenger];
    }
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveInfo];
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
    _txf_goDate=[[UITextField alloc]init];
    [_View_goDate addSubview:[[SubmitFormView alloc]initBaseView:_View_goDate WithContent:_txf_goDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine WithString:Custing(@"出发日期", nil) WithTips:Custing(@"请选择出发日期", nil) WithInfodict:@{@"value1":_model_Data.departureDateStr}]];
}


-(void)updateView_FromCity{
    _txf_FromCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"出发地", nil) WithTips:Custing(@"请选择出发地", nil) WithInfodict:@{@"value1":self.model_Data.fromCity}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
        addVc.Type=1;
        addVc.isGocity = @"1";
        addVc.status = @"10";
        addVc.delegate=self;
        addVc.isXiecheng = YES;
        addVc.OnlyInternal = NO;
        [weakSelf.navigationController pushViewController:addVc animated:YES];

    }];
    [_View_FromCity addSubview:view];
}

-(void)updateView_ToCity{
    _txf_ToCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ToCity WithContent:_txf_ToCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"目的地", nil) WithTips:Custing(@"请选择目的地", nil) WithInfodict:@{@"value1":self.model_Data.toCity}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
        addVc.Type=1;
        addVc.isGocity = @"1";
        addVc.status = @"11";
        addVc.delegate=self;
        addVc.isXiecheng = YES;
        addVc.OnlyInternal = NO;
        [weakSelf.navigationController pushViewController:addVc animated:YES];
    }];
    [_View_ToCity addSubview:view];
}

-(void)updateView_PeopleWithPeople:(NSString *)people{
    _txf_People=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_People WithContent:_txf_People WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"乘客", nil) WithTips:Custing(@"请选择乘客", nil) WithInfodict:@{@"value1":people}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio = @"2";
        [contactVC setBlock:^(NSMutableArray *array) {
            NSMutableArray *name=[NSMutableArray array];
            if (array.count>0) {
                for (buildCellInfo *model in array) {
                    if ([NSString isEqualToNull:model.requestor]) {
                        [name addObject:[NSString stringWithFormat:@"%@",model.requestor]];
                    }
                }
            }
            weakSelf.txf_People.text=[GPUtils getSelectResultWithArray:name WithCompare:@","];
        }];
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    [_View_People addSubview:view];
}

-(void)updateView_CheckInCity{
    _txf_CheckInCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CheckInCity WithContent:_txf_CheckInCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"城市", nil) WithTips:Custing(@"请选择城市", nil) WithInfodict:@{@"value1":self.model_Data.checkInCity}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
        addVc.Type=1;
        addVc.isGocity = @"1";
        addVc.status = @"12";
        addVc.delegate=self;
        addVc.OnlyInternal = NO;
        addVc.isXiecheng = YES;
        [weakSelf.navigationController pushViewController:addVc animated:YES];
    }];
    [_View_CheckInCity addSubview:view];
}

-(void)updateView_CheckInDate{
    _txf_CheckInDate=[[UITextField alloc]init];
    [_View_CheckInDate addSubview:[[SubmitFormView alloc]initBaseView:_View_CheckInDate WithContent:_txf_CheckInDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine WithString:Custing(@"入住日期", nil) WithTips:Custing(@"请选择入住日期", nil) WithInfodict:@{@"value1":_model_Data.checkInDateStr}]];
}

-(void)updateView_CheckOutDate{
    
    _txf_CheckOutDate=[[UITextField alloc]init];
    [_View_CheckOutDate addSubview:[[SubmitFormView alloc]initBaseView:_View_CheckOutDate WithContent:_txf_CheckOutDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine WithString:Custing(@"退房日期", nil) WithTips:Custing(@"请选择退房日期", nil) WithInfodict:@{@"value1":_model_Data.checkOutDateStr}]];
}

-(void)updateView_Rooms{
    
    _txf_Rooms=[[UITextField alloc]init];
    [_View_Rooms addSubview:[[SubmitFormView alloc]initBaseView:_View_Rooms WithContent:_txf_Rooms WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine WithString:Custing(@"房间数", nil) WithTips:Custing(@"请输入房间数", nil) WithInfodict:@{@"value1":[NSString stringWithFormat:@"%@",_model_Data.numberOfRooms]}]];
}

-(void)updateView_Remark{
    _txv_Remark=[[UITextView alloc]init];
   SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"备注", nil) WithTips:Custing(@"请输入备注", nil) WithInfodict:@{@"value1":_model_Data.remark}];
    [_View_Remark addSubview:view];
}

-(void)saveInfo{
//    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    NSString *url=[NSString stringWithFormat:@"%@",CtripENDTRAVEL];
//    NSDictionary *parameters=@{@"SerialNo":_model_Data.serialNo,@"TaskId":_model_Data.taskId};
//    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
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

//MARK:城市选择
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start{
    NSInteger int_state = [start integerValue];
    NSDictionary *dic = array[0];
    if (int_state==10) {
        _txf_FromCity.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
    }else if (int_state==11){
        _txf_ToCity.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
    }else if (int_state==12){
        _txf_CheckInCity.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
    }
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
