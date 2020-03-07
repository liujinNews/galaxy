//
//  ReimburseViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.1
//
#import "bwInvoiceExaViewController.h"
#import "bwInvoiceElectViewController.h"
#import "bwAuthInfoViewController.h"
#import "InvoicePhotoViewController.h"
#import "StatisticalView.h"

#import "ReimburseViewController.h"
#import "CustomNotesNewViewController.h"
#import "ReimburseCell.h"
#import "NewAddCostViewController.h"

#import "AddDetailsModel.h"
#import "MyApplyViewController.h"
#import "MyApproveViewController.h"
#import "OtherReimTypeController.h"
#import "MapTrackController.h"
#import "QRCodeBaseController.h"
#import "WeChatInvoiceController.h"
#import "ManInputInvoiceController.h"
#import "NewEInvoiceController.h"
#import "FPTInvoiceController.h"
#import "RootWebViewController.h"


#define ReimburseGuide 1
@interface ReimburseViewController ()<UITableViewDelegate,UITableViewDataSource,StatisticalViewDelegate>
/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  tableView头视图
 */
@property(nonatomic,strong)UIView *headView;
/**
 *  Add添加记一笔按钮
 */
@property(nonatomic,strong)UIButton *AddButton;
/**
 *  总金额
 */
@property(nonatomic,strong)NSString *totolMoney;
/**
 *  最近消费记录字典
 */
@property(nonatomic,strong)NSDictionary *MeunDict;
@property(nonatomic,strong)AddDetailsModel *model;

@property (nonatomic, strong) UIButton *btn_right;
@property (nonatomic, strong) NSString *str_TaskId;
@property (nonatomic, strong) NSString *str_ProcId;
@property (nonatomic, strong) NSString *str_Status;
@property (nonatomic, strong) NSString *str_Finished;
@property (nonatomic, strong) NSString *str_OwnerUserId;
@property (nonatomic, strong) NSString *str_FlowCode;
@property (nonatomic,strong)StatisticalView * dateView;
@property (nonatomic,strong)ReimburseCell * cell;
@property (nonatomic, strong) PopMenu *myPopMenu;

@property (nonatomic,strong) NSString * examinStr;

@property (nonatomic, strong) NSString *api_ticket;

@property (nonatomic, assign) NSInteger int_BaiWangType;//3拍照4二维码

@end

@implementation ReimburseViewController
-(FestivalHeadView *)festivalHead
{
    if (_festivalHead == nil) {
        _festivalHead =  [[FestivalHeadView alloc]init];
    }
    return _festivalHead;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        self.navigationController.navigationBar.hidden = YES;
    }
    if (![_requestType isEqualToString:@"1"]) {
        [self requestTotolAgain];
    }
    _requestType=@"0";
    if (self.userdatas.SystemType == 1) {
        [_btn_right setImage:[UIImage imageNamed:@"NavBarImg_Scan_white"] forState:UIControlStateNormal];
    }else{
        [_btn_right setImage:[UIImage imageNamed:@"NavBarImg_Scan"] forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closePopMenu];
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=Color_form_TextFieldBackgroundColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setTitle:Custing(@"费用", nil)];
    //微信卡包代理
    [WXApiManager sharedManager].delegate = self;
    
    [self requestTotol];
    _requestType=@"1";
    
    _btn_right = [[UIButton alloc]init];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:_btn_right title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_Scan_white":@"NavBarImg_Scan" target:self action:@selector(selectImage:)];
    
    [self initializeMenu];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    if ([NSString isEqualToNull:[userdefa objectForKey:@"3dtouch"]]) {
        [ApplicationDelegate PushTo3d];
    }
    if ([NSString isEqualToNull:[userdefa objectForKey:@"push"]]) {
        [ApplicationDelegate pushView:[userdefa objectForKey:@"push"]];
    }
}

#pragma mark - 二维码扫描

-(void)selectImage:(UIButton *)btn{
    
    [self pushToQRCodeScanViewWithType:1];
}
//MARK:创建tabelView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(iPhoneX ? @-83:@ -49);
    }];
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        [self.festivalHead stretchHeaderForTableView:_tableView];
        [self createNaView];
    }
}
-(void)createNaView
{
    self.festivalNav=[[FestivalNavView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, NavigationbarHeight)];
    self.festivalNav.title =Custing(@"费用", nil);
    self.festivalNav.head_bg_Image=@"Festival_NavBar";
    
    if (self.userdatas.SystemType == 1) {
        [_btn_right setImage:[UIImage imageNamed:@"NavBarImg_Scan_white"] forState:UIControlStateNormal];
    }else{
        self.festivalNav.hasRinght=YES;
        self.festivalNav.right_bt_Image = @"NavBarImg_Scan_white";
        self.festivalNav.delegate = self;
    }
    
    [self.view addSubview:self.festivalNav];
}
//MARK:创建添加消费记录按钮
-(void)createAddBtn{
    _AddButton=[[UIButton alloc]init];
    [_AddButton addTarget:self action:@selector(AddExpenseCalendar) forControlEvents:UIControlEventTouchUpInside];
    [_AddButton setBackgroundImage:([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0)?[UIImage imageNamed:@"Reimburse_Add_Festival"]:[UIImage imageNamed:@"Reimburse_Add"] forState:UIControlStateNormal];
    [_AddButton setBackgroundImage:([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0)?[UIImage imageNamed:@"Reimburse_Add_Festival"]:[UIImage imageNamed:@"Reimburse_Add"] forState:UIControlStateSelected];
    [self.view addSubview:_AddButton];
    [_AddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.bottom.equalTo(self.view.mas_bottom).offset(iPhoneX ? -116:-82);
        make.height.equalTo(@53);
        make.width.equalTo(@53);
    }];
}
//MARK:请求消费总额
-(void)requestTotol{
    //    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ReimburseGetTotol];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}
//MARK:请求消费总额
-(void)requestTotolAgain{
    //    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ReimburseGetTotol];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}

//MARK:开通电子发票权限
-(void)requestElectAuth
{
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",GetCoCard] Parameters:nil Delegate:self SerialNum:[self.examinStr intValue] IfUserCache:NO];
}

// 百望个人报销发票授权接口
-(void)requestGetPoauthData {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetPoauth"] Parameters:nil Delegate:self SerialNum:11 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//获取最新状态
-(void)requestGetTaskformessage{
    NSString *taskid =[NSString stringWithFormat:@"%@",_str_TaskId];
    NSString *procid=[NSString stringWithFormat:@"%@",_str_ProcId];
    [[GPClient shareGPClient]REquestByPostWithPath:XB_FormState Parameters:@{@"TaskId":taskid,@"ProcId":procid} Delegate:self SerialNum:7 IfUserCache:NO];
}
//验证百望云是否开启
-(void)requestBaiWCloudOpen{
    NSString *url=[NSString stringWithFormat:@"%@",BAIWOPEN];
    NSDictionary *parameters = @{@"Type":[NSString stringWithFormat:@"%ld",(long)_int_BaiWangType]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}
//获取微信卡包ticket_api
-(void)requestWeChatTickApi{
    NSString *url=[NSString stringWithFormat:@"%@",WECHATCARDAPI];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    //    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //        临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 0://请求消费总额
        {
            [self dealWithData];
            [self createTableView];
            [self createAddBtn];
            [self createGuideViews];
            [self createcheckExpiryDic];
            if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
                [self createFestivalGuideViews];
            }
        }
            break;
        case 1://请求消费总额
            [self dealWithData];
            if (_tableView==nil) {
                [self createTableView];
                [self createAddBtn];
            }else{
                [_tableView reloadData];
            }
            break;
        case 3://二维码扫描后结果
        {
            NSDictionary *result = _resultDict[@"result"];
            if ([result isEqual:nil]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前二维码无效", nil) duration:1.0];
                return;
            }
            _str_ProcId = [NSString stringWithFormat:@"%@",result[@"procId"]];
            _str_FlowCode = [NSString stringWithFormat:@"%@",result[@"flowCode"]];
            _str_Status = [NSString stringWithFormat:@"%@",result[@"status"]];
            _str_Finished = [NSString stringWithFormat:@"%@",result[@"finished"]];
            _str_OwnerUserId = [NSString stringWithFormat:@"%@",result[@"ownerUserId"]];
            
            //finished 0 当前单据未审批 1 当前啊单据已审批
            if ([[NSString stringWithFormat:@"%@",_str_Finished] isEqualToString:@"1"]) {
                if ([self.userdatas.userId integerValue] == [_str_OwnerUserId integerValue]) {
                    [self requestGetTaskformessage];
                    return;
                }else{
                    _str_Status = @"3";
                }
            }
            [self WaitToPayWithWithResultDict:result];
        }
            break;
        case 4://请求百望云开启
        {
            if ([_resultDict[@"result"]isKindOfClass:[NSDictionary class]]) {
                if (![[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"isOpen"]] isEqualToString:@"1"]) {
                    [self createAlerWithStr:Custing(@"开通此功能,请联系客服", nil)];
                    return;
                }else if (![[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"isPermission"]] isEqualToString:@"1"]){
                    [self createAlerWithStr:Custing(@"开通此权限,请联系管理员", nil)];
                    return;
                }
                if (self.int_BaiWangType == 3) {
                    [self performBlock:^{
                        [self PushTakeInvoiceImg];
                    } afterDelay:0.3];
                }else if (self.int_BaiWangType == 4){
                    [self PushBillVerify];
                }
            }
        }
            break;
        case 5://微信卡包
        {
            if ([NSString isEqualToNull:_resultDict[@"result"]]) {
                _api_ticket=_resultDict[@"result"];
                [self gotoWeChat];
            }
        }
            break;
        case 7 :{
            NSDictionary *dict=[responceDic objectForKey:@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                if ([[NSString stringWithFormat:@"%@",dict[@"status"]] isEqualToString:@"6"]) {
                    [YXSpritesLoadingView dismiss];
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:@"已被撤回" duration:1.0];
                    return;
                }else{
                    if ([[NSString stringWithFormat:@"%@",dict[@"finished"]]isEqualToString:@"0"]) {
                        [self WaitToPayWithWithResultDict:dict];
                    }else if([[NSString stringWithFormat:@"%@",dict[@"finished"]] isEqualToString:@"1"]){
                        _str_Status = @"6";
                        [self WaitToPayWithWithResultDict:dict];
                    }
                }
            }
        }
            break;
        case 11://电子发票
        {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                return;
            }else {
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isoAuth"]] isEqualToString:@"0"]) {
                    if ([self.examinStr isEqualToString:@"12"]) {
                        bwInvoiceElectViewController * examain = [[bwInvoiceElectViewController alloc]initWithType:@{@"list":@"12",@"result":result}];
                        [self.navigationController pushViewController:examain animated:YES];
                    }else {
                        bwInvoiceExaViewController * examain = [[bwInvoiceExaViewController alloc]initWithType:@{@"list":@"13",@"result":result}];
                        [self.navigationController pushViewController:examain animated:YES];
                    }
                }else {
                    if ([self.examinStr isEqualToString:@"12"]) {
                        bwInvoiceElectViewController * examain = [[bwInvoiceElectViewController alloc]initWithType:@{@"list":@"15",@"result":result}];
                        [self.navigationController pushViewController:examain animated:YES];
                    }else {
                        bwInvoiceExaViewController * examain = [[bwInvoiceExaViewController alloc]initWithType:@{@"list":@"16",@"result":result}];
                        [self.navigationController pushViewController:examain animated:YES];
                    }
                }
            }
        }
            break;
        case 12://电子发票
        {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                return;
            }else {
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"einvoice"]] isEqualToString:@"0"]) {
                    bwAuthInfoViewController * bw = [[bwAuthInfoViewController alloc]initWithType:@{@"list":@"elect",@"dict":result}];
                    [self.navigationController pushViewController:bw animated:YES];
                }else {
                    [self requestGetPoauthData];
                }
            }
        }
            break;
        case 13://发票查询
        {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                return;
            }else {
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"einvoice"]] isEqualToString:@"0"]) {
                    bwAuthInfoViewController * bw = [[bwAuthInfoViewController alloc]initWithType:@{@"list":@"Examination",@"dict":result}];
                    [self.navigationController pushViewController:bw animated:YES];
                }else {
                    [self requestGetPoauthData];
                }
            }
        }
            break;
        default:
            break;
    }
    
}
-(void)dealWithData{
    //    NSArray *arr=@[@"1"];
    //    NSString *str=arr[2];
    NSDictionary *result=_resultDict[@"result"];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"totalAmount"]]]) {
        _totolMoney=[NSString stringWithFormat:@"%@",result[@"totalAmount"]];
    }else{
        _totolMoney=@"0";
    }
    _MeunDict=[[NSDictionary alloc]init];
    if ([NSString isEqualToNull:result[@"expUser"]]) {
        _model=[[AddDetailsModel alloc]init];
        _MeunDict=result[@"expUser"];
        [AddDetailsModel getCostOneDataByDictionary:result[@"expUser"] model:_model];
    }else{
        _model=nil;
    }
}
//MARK:二维码扫描支付
-(void)WaitToPayWithWithResultDict:(NSDictionary *)dict{
    NSDictionary *dic=@{@"status":_str_Status,
                        @"flowCode":_str_FlowCode,
                        @"taskId":_str_TaskId,
                        @"procId":_str_ProcId,
                        @"userId":self.userdatas.userId
    };
    [ApplicationDelegate pushControllerByMess:dic];
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

//MARK:添加消费记录
-(void)AddExpenseCalendar{
    if (!_myPopMenu.isShowed) {
        [_myPopMenu showMenuAtView:[UIApplication sharedApplication].keyWindow startPoint:CGPointMake(0, Main_Screen_Height+100) endPoint:CGPointMake(0, Main_Screen_Height+100)];
    } else{
        [self closeMenu];
    }
}
-(void)closeMenu{
    if ([_myPopMenu isShowed]) {
        [_myPopMenu dismissMenu];
    }
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.userdatas.arr_ReimMeumArray.count==0) {
        return 1;
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.userdatas.arr_ReimMeumArray.count==0) {
        return 2;
    }else{
        if (section==1){
            return self.userdatas.arr_ReimMeumArray.count;
        }else{
            return 2;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 74;
        }else{
            NSDictionary *parameters =_MeunDict;
            if ([NSString isEqualToNull:parameters[@"expenseType"]]){
                CGSize size = [parameters[@"expenseType"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-205, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                return 35+size.height;
            }else{
                return 62;
            }
        }
        
    }else{
        return 70;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 27;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self createHeadViewWithSection:section];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ReimburseCell"];
    if (_cell==nil) {
        _cell=[[ReimburseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReimburseCell"];
    }
    if (indexPath.section==0) {
        NSDictionary *parameters =_MeunDict;
        [_cell configSectionZeroWithrRow:indexPath.row withTolMoney:_totolMoney withNote:parameters];
    }else{
        [_cell configSectionOtherWithrIndexPath:indexPath WithShowArray:self.userdatas.arr_ReimMeumArray];
    }
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                //消费记录
                CustomNotesNewViewController *customNote=[[CustomNotesNewViewController alloc]init];
                [self.navigationController pushViewController:customNote animated:YES];
            }
                break;
            case 1:
            {
                //记一笔查看
                if (_model==nil||[_model isKindOfClass:[NSNull class]]) {
                    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
                    return;
                }
                _model.OrderId = [NSString stringWithIdOnNO:_model.OrderId];
                NewAddCostViewController * add = [[NewAddCostViewController alloc]init];
                add.Id = [_model.Id integerValue];
                add.Type = [_model.type integerValue];
                add.Action = 2;
                add.Enabled_addAgain = 1;
                add.dateSource = _model.DataSource;
                [self.navigationController pushViewController:add animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        if (indexPath.section==1){
            NSString *flowKey = self.userdatas.arr_ReimMeumArray[indexPath.row];
            NSDictionary *dict = self.userdatas.dict_XBAllFlowInfo[flowKey];
            NSString *flowCode = dict[@"flowCode"];
            if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
                NSString *pushController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:flowCode][@"pushController"];
                NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:flowKey][@"Title"];
                NSDictionary *dict1 = @{@"flowGuid":flowKey,@"taskId":@"",@"procId":@"",@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@1};
                RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],pushController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                vc.str_flowCode = flowCode;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([flowCode isEqualToString:@"F0010"]&&![NSString isEqualToNull:dict[@"expenseCode"]]) {
                OtherReimTypeController *Travel=[[OtherReimTypeController alloc]init];
                Travel.flowGuid = flowKey;
                [self.navigationController pushViewController:Travel animated:YES];
            }else{
                NSString *pushController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:flowCode][@"pushController"];
                Class cls = NSClassFromString(pushController);
                UIViewController *vc = [[cls alloc] init];
                vc.pushFlowGuid = flowKey;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
//MARK:ScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.festivalHead scrollViewDidScroll:scrollView];
    //    if (scrollView.contentOffset.y<=NavigationbarHeight) {
    //        _tableView.bounces = NO;
    //    }else{
    //        _tableView.bounces = YES;
    //    }
    if (scrollView.contentOffset.y<=(Main_Screen_Width/1.37-64)) {
        self.festivalNav.headBackView.alpha = scrollView.contentOffset.y/(Main_Screen_Width/1.4);
    }else{
        self.festivalNav.headBackView.alpha = 1;
    }
}

//MARK:festiavlNav代理
-(void)NaRight
{
    [self pushToQRCodeScanViewWithType:1];
}

#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    if (section!=0) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
        
        UIImageView *ImgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_headView addSubview:ImgView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width-30, 18)];
        titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+Main_Screen_Width/2-4, 13.5);
        titleLabel.font=Font_Important_15_20 ;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        if (@available(iOS 13.0, *)) {
            titleLabel.textColor=[UIColor labelColor];
        } else {
            // Fallback on earlier versions
            titleLabel.textColor=Color_Unsel_TitleColor;
        }
        [_headView addSubview:titleLabel];
        
        UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, 0.5)];
        upView.backgroundColor=Color_LineGray_Same_20;
        [_headView addSubview:upView];
        
        UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, 26.5, Main_Screen_Width, 0.5)];
        downView.backgroundColor=Color_LineGray_Same_20;
        [_headView addSubview:downView];
        titleLabel.text=Custing(@"创建", nil);
    }else{
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    }
    _headView.backgroundColor=Color_White_Same_20;
}

//MARK:创建导航页判断
-(void)createGuideViews{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"GuideView"]isEqualToString:@"1"]) {
        [self createGuideView];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"GuideView"];
    }
}

//MARK:导航页
-(void)createGuideView{
    _guideView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _guideView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _guideView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    longPress.delegate = self;
    [_guideView addGestureRecognizer:longPress];
    
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    [window addSubview:_guideView];
    
    UIImageView *guide=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height)];
    guide.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
    guide.image=[UIImage imageNamed:Custing(@"RoleGuide", nil)];
    guide.userInteractionEnabled=YES;
    [_guideView addSubview:guide];
    
    UIButton *bossBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2-25, Main_Screen_Height-75, 50, 50) action:@selector(LeadBossGuide) delegate:self type:UIButtonTypeCustom];
    [bossBtn setImage:[UIImage imageNamed:@"RoleGuide_Delegate"] forState:UIControlStateNormal];
    //    bossBtn.center=CGPointMake(130, 100);
    [guide addSubview:bossBtn];
}
//MARK:创建剩余使用天数
-(void)createcheckExpiryDic{
    if (self.userdatas.checkExpiryDic != nil) {
        NSString * isExpiry = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"isExpiry"]];
        NSString * isAdmin = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"isAdmin"]];
        NSString * days = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"days"]];
        if (![days isEqualToString:@"0"]&&[isAdmin isEqualToString:@"1"]&&[isExpiry isEqualToString:@"1"]) {
            [self createZuiHouQiXianLogin];
            [YXSpritesLoadingView dismiss];
            return;
        }
    }
    
}
//MARK:创建节假日判断
-(void)createFestivalGuideViews{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Christmas"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NewYear"];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"NewYear"]isEqualToString:@"1"]) {
        [self createFestivalView];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NewYear"];
    }
}

//MARK:节假日导航页
-(void)createFestivalView{
    _FestivalGuideView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _FestivalGuideView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _FestivalGuideView.userInteractionEnabled=YES;
    
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    [window addSubview:_FestivalGuideView];
    
    UIImageView *guide=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width/1.36,Main_Screen_Width*1.066)];
    guide.center=CGPointMake(Main_Screen_Width/2, (Main_Screen_Height-49)/2);
    guide.image=[UIImage imageNamed:@"Festival_Card"];
    [_FestivalGuideView addSubview:guide];
    
    UIImageView *fork=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
    fork.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+36+Main_Screen_Width/2);
    fork.image=[UIImage imageNamed:@"Festival_Fork"];
    [_FestivalGuideView addSubview:fork];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 40) action:@selector(tapFestival:) delegate:self];
    btn.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+36+Main_Screen_Width/2);
    [_FestivalGuideView addSubview:btn];
}
//MARK:没开通专项费
-(void)createNoSpecialView{
    _NoSpecialGuideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _NoSpecialGuideView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _NoSpecialGuideView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNoSpecialGesture:)];
    longPress.delegate = self;
    [_NoSpecialGuideView addGestureRecognizer:longPress];
    
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    [window addSubview:_NoSpecialGuideView];
    
    UIView *BottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 130)];
    BottomView.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
    BottomView.backgroundColor=Color_form_TextFieldBackgroundColor;
    BottomView.layer.cornerRadius = 8.0f;
    BottomView.layer.shadowOffset = CGSizeMake(0, 1);
    BottomView.layer.shadowOpacity = 0.25;
    BottomView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    BottomView.layer.shadowOffset = CGSizeMake(2, 2);
    [_NoSpecialGuideView addSubview:BottomView];
    
    UILabel *titleLabl=[GPUtils createLable:CGRectMake(0, 0, 124, 50) text:Custing(@"开通专项费用报销\n请联系客服", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    titleLabl.numberOfLines=2;
    titleLabl.center=CGPointMake(110, 52);
    [BottomView addSubview:titleLabl];
    
    _servicePhoneNo=@"400-021-5799";
    UIButton *phoneNumebr=[GPUtils createButton:CGRectMake(0, 0, 140, 24) action:@selector(CallPhone:) delegate:self title:_servicePhoneNo font:Font_Important_18_20 titleColor:Color_Blue_Important_20];
    phoneNumebr.center=CGPointMake(110, 100);
    [BottomView addSubview:phoneNumebr];
    
}
//MARK:拨打客服热线
-(void)CallPhone:(UIButton *)btn{
    //判断能否打电话
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                    message:Custing(@"该设备不支持电话功能", nil)
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定", nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@",_servicePhoneNo];
        UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"呼叫", nil), nil];
        [lertView show];
        
    }
}
//alertView的delegate方法（用于打电话）
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag!=1) {
            NSURL * url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel://%@",_servicePhoneNo] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
//MARK:进入老板
-(void)LeadBossGuide{
    //进入老板
    [_guideView removeFromSuperview];
    _guideView=nil;
}
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    [_guideView removeFromSuperview];
    _guideView=nil;
}
-(void)tapFestival:(UIButton *)btn{
    [_FestivalGuideView removeFromSuperview];
    _FestivalGuideView=nil;
}
-(void)tapNoSpecialGesture:(UITapGestureRecognizer *)tapGesture{
    [_NoSpecialGuideView removeFromSuperview];
    _NoSpecialGuideView=nil;
}

//最后三十天
-(void)createZuiHouQiXianLogin {
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-142.5, 0,300, 356)];
    View.backgroundColor = [UIColor clearColor];
    //    View.layer.cornerRadius = 15.0f;
    View.userInteractionEnabled = YES;
    
    UIView * Views = [[UIView alloc]initWithFrame:CGRectMake(0, 121,270, 235)];
    Views.backgroundColor = Color_form_TextFieldBackgroundColor;
    Views.layer.cornerRadius = 15.0f;
    Views.userInteractionEnabled = YES;
    [View addSubview:Views];
    
    UIImageView * alertView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11,270, 372/2)];
    alertView.image = GPImage(@"ArrearsNotification");
    alertView.backgroundColor = [UIColor clearColor];
    [View addSubview:alertView];
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(254.25, -4.75, 31.5, 31.5) action:@selector(wozhdiaole:) delegate:self];
    chooseBtn.backgroundColor = [UIColor clearColor];
    [chooseBtn setImage:GPImage(@"ArrearsNotRelease") forState:UIControlStateNormal];
    [View addSubview:chooseBtn];
    
    NSString * days;
    if (self.userdatas.checkExpiryDic != nil) {
        days = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"days"]];
    }else {
        days = @"0";
    }
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    
    NSString * allAmount = [NSString stringWithFormat:@"%@%@%@",Custing(@"您的企业版剩余",nil),days,Custing(@"天到期",nil)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:allAmount];
    [str addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(0, ((lan)?7:15))];
    [str addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(((lan)?7:15), days.length)];
    [str addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(((lan)?7:15)+days.length, str.length-(((lan)?7:15)+days.length))];
    
    [str addAttribute:NSFontAttributeName value:Font_Important_15_20 range:NSMakeRange(0, ((lan)?7:15))];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:NSMakeRange(((lan)?7:15), days.length)];
    [str addAttribute:NSFontAttributeName value:Font_Important_15_20 range:NSMakeRange(((lan)?7:15)+days.length, str.length-(((lan)?7:15)+days.length))];
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 372/2+31, 270, 30) text:allAmount font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    [oneLa setAttributedText:str];
    
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(0, 372/2+61, 270, 30) text:Custing(@"请前往网页端续费", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [View addSubview:twoLa];
    
    UIButton * zhiBtn = [GPUtils createButton:CGRectMake(67.5, 296, 135, 35) action:@selector(wozhdiaole:) delegate:self title:Custing(@"我知道了", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    zhiBtn.backgroundColor = Color_Blue_Important_20;
    zhiBtn.layer.cornerRadius = 10.0f;
    [View addSubview:zhiBtn];
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
}


//键盘取消
- (void)dimsissStatisticalPDActionView{
    self.dateView = nil;
}
//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (_dateView) {
        [_dateView removeStatistical];
    }
}

- (void)wozhdiaole:(UIButton *)btn {
    [self.dateView removeStatistical];
}
-(void)initializeMenu{
    //初始化弹出菜单
    NSMutableArray *menuItems=[NSMutableArray array];
    [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"记一笔", nil) iconName:@"Reimburse_Menu_Add" index:0]];
    if ([self.userdatas.arr_XBCode containsObject:@"WeiXinCard"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"微信发票", nil) iconName:@"Reimburse_WeChatCard" index:1]];
    }
        if ([self.userdatas.arr_XBCode containsObject:@"AliPayInv"]) {
            [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"支付宝发票", nil) iconName:@"Reimburse_AliPayCard" index:2]];
        }
    if ([self.userdatas.arr_XBCode containsObject:@"InvoiceOCR"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"发票拍照", nil) iconName:@"Reimburse_Menu_InvoicePho" index:3]];
    }
    if ([self.userdatas.arr_XBCode containsObject:@"baiwang"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"发票扫描", nil) iconName:@"Reimburse_Menu_Verify" index:4]];
    }
    if ([self.userdatas.arr_XBCode containsObject:@"fapiao"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"电子发票Cust", nil) iconName:@"Reimburse_Menu_Bill" index:5]];
    }
    if ([self.userdatas.arr_XBCode containsObject:@"SelfDriving"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"自驾车", nil) iconName:@"Reimburse_Self_driver" index:6]];
    }
    if ([self.userdatas.arr_XBCode containsObject:@"Order"]) {
        [menuItems addObject:[PopMenuItem itemWithTitle:Custing(@"订单导入", nil) iconName:@"Reimburse_Menu_Lead" index:7]];
    }
    if (!_myPopMenu) {
        _myPopMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) items:menuItems];
        _myPopMenu.perRowItemCount =3;
        _myPopMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    __weak typeof(self) weakSelf = self;
    _myPopMenu.didSelectedItemCompletion = ^(PopMenuItem *selectedItem){
        if (!selectedItem) return;
        switch (selectedItem.index) {
            case 0://记一笔
            {
                [weakSelf PushToCustomNote];
            }
                break;
            case 1://微信卡包
                [weakSelf PushWeChatList];
                break;
            case 2://支付宝发票
            {
                [weakSelf PushAliPayInvoiceList];
            }
                break;
            case 3://发票拍照
            {
                weakSelf.int_BaiWangType = 3;
                [weakSelf requestBaiWCloudOpen];
            }
                break;
            case 4://发票扫描
            {
                weakSelf.int_BaiWangType = 4;
                [weakSelf requestBaiWCloudOpen];
            }
                break;
            case 5://电子发票
                [weakSelf PushLeadBill];
                break;
            case 6://自驾车
                [weakSelf PushSelfDriver];
                break;
            case 7://导入三方
                [weakSelf PushLeadInCost];
                break;
            default:
                NSLog(@"%@",selectedItem.title);
                break;
        }
    };
}
//MARK:popMenu界面消失
-(void)closePopMenu{
    if ([_myPopMenu isShowed]) {
        [_myPopMenu dismissMenu];
    }
}
-(void)PushToCustomNote{
    
    NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
    add.Action = 1;
    add.dateSource = @"0";
    [self.navigationController pushViewController:add animated:YES];

}

-(void)PushLeadBill{
    self.examinStr = @"12";
    [self requestElectAuth];
}

-(void)PushBillVerify{
    [self pushToQRCodeScanViewWithType:2];
}

-(void)PushCheckBill{
    self.examinStr = @"13";
    [self requestElectAuth];
}

-(void)PushWeChatList{
    
    if ([WXApi isWXAppInstalled]) {
        [self requestWeChatTickApi];
    }else{
        [UIAlertView bk_showAlertViewWithTitle:@"请安装微信" message:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
}

- (void)PushAliPayInvoiceList{
    __weak typeof(self) weakSelf = self;
     NSString *url = [NSString stringWithFormat:@"/www/invoiceSelect.htm?scene=INVOICE_EXPENSE&einvMerchantId=%@&serverRedirectUrl=%@",XB_EinvMerchantId,[AlipayBack stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                    NSDictionary *params = @{kAFServiceOptionBizParams: @{
                                                     @"url":url
                    },
                                             kAFServiceOptionCallbackScheme: XB_Schems,
                    };
                    [AFServiceCenter callService:AFServiceEInvoice withParams:params andCompletion:^(AFServiceResponse *response)
                    {
                        NSLog(@"%@", response.result);
                        NSString *status = response.result[@"status"];
                        if ([status isEqualToString:@"success"]) {
                            userData *datas = [userData shareUserData];
                            NSString *antinvoiceToken = response.result[@"token"];
                            NSString *uid = [NSString stringWithFormat:@"%@",datas.userId];
                            NSString *cid = [NSString stringWithFormat:@"%@",datas.companyId];
                            NSString *token = [NSString stringWithFormat:@"%@",datas.token];
                            if (![antinvoiceToken isEqualToString:@""]&&![uid isEqualToString:@""]&&![cid isEqualToString:@""]&&![token isEqualToString:@""]) {//https://dingtalk.xibaoxiao.com
                                NSString *urlStr = [NSString stringWithFormat:@"http://139.196.104.114:82/home/form/AlipayInvoice?antinvoiceToken=%@&uid=%@&cid=%@&token=%@",antinvoiceToken,uid,cid,token];
    //                            http://10.1.2.230:3000/home/form/AlipayInvoice
    //                             NSString *urlStr = [NSString stringWithFormat:@"http://10.1.2.230:3000/home/form/AlipayInvoice?antinvoiceToken=%@&uid=%@&cid=%@&token=%@",antinvoiceToken,uid,cid,token];
                                RootWebViewController *vc = [[RootWebViewController alloc] initWithUrl:urlStr];
    //                            vc.token = token;
                                [weakSelf.navigationController pushViewController:vc animated:YES];
                            }
                        }
                    }];
    //                RootWebViewController *vc = [[RootWebViewController alloc]initWithUrl:@"https://www.baidu.com"];
    //                [weakSelf.navigationController pushViewController:vc animated:YES];
}

-(void)PushSelfDriver{
    
    if ([self.userdatas.CorpActTyp isEqualToString:@"4"]) {
        MapTrackController *vc=[[MapTrackController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
            [weakSelf createAlerWithStr:Custing(@"开通自驾车\n请联系公司系统管理员", nil)];
        } afterDelay:0.5];
    }
}

-(void)PushLeadInCost{
    LeadingViewController *lead = [[LeadingViewController alloc]init];
    [self.navigationController pushViewController:lead animated:YES];
}


-(void)PushTakeInvoiceImg{
    
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    cameraVc.maxCount = 1;
    cameraVc.int_place = 1;
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        if (cameras.count!=0) {
            //            InvoicePhotoViewController *vc = [[InvoicePhotoViewController alloc]init];
            //            vc.arr_InvoicePhoto=cameras;
            //            [weakSelf.navigationController pushViewController:vc animated:YES];
            FPTInvoiceController *vc = [[FPTInvoiceController alloc]init];
            vc.arr_InvoicePhoto = cameras;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    [cameraVc showPickerVc:self];
}
-(void)createAlerWithStr:(NSString *)str{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:str
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:Custing(@"确定", nil)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     otherButtonTitles:nil,nil];
    
    alert.tag=1;
    [alert show];
}
-(void)pushToQRCodeScanViewWithType:(NSInteger)type{
    QRCodeBaseController *vc=[[QRCodeBaseController alloc]init];
    vc.type=type;
    if (type==1) {
        __weak typeof(self) weakSelf = self;
        vc.QRCodeScanBackBlock = ^(NSString *codeString, NSInteger type) {
            if ([NSString isEqualToNull:codeString]) {
                if (type==1) {
                    weakSelf.str_TaskId = codeString;
                    NSString *url=[NSString stringWithFormat:@"%@", taskScanQRCode];
                    NSDictionary *parameters = @{@"TaskId":weakSelf.str_TaskId};
                    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:weakSelf SerialNum:3 IfUserCache:NO];
                }
            }else{
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"无效二维码", nil)  duration:1.0];
            }
        };
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoWeChat{
    NSString *nonceStr = @"LrVEbFwVXE0Rprb6";
    NSString *cardType = @"INVOICE";
    UInt32 timestamps=[[GPUtils getTimeStamp] intValue];
    NSLog(@"%@",[NSString stringWithFormat:@"%u%@%@%@%@",(unsigned int)timestamps,cardType,_api_ticket,nonceStr,(NSString *)WeChatKey]);
    NSString *cardSign=[GPUtils sha1:[NSString stringWithFormat:@"%u%@%@%@%@",(unsigned int)timestamps,cardType,_api_ticket,nonceStr,(NSString *)WeChatKey]];
    [WXApiRequestHandler chooseInvoice:(NSString *)WeChatKey
                              cardSign:cardSign
                              nonceStr:nonceStr
                              signType:@"SHA1"
                             timestamp:timestamps];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response {
    [YXSpritesLoadingView dismiss];
    if (response.cardAry.count>0) {
        NSMutableArray *arr=[NSMutableArray array];
        for (WXInvoiceItem* cardItem in response.cardAry) {
            NSDictionary *dict=@{@"card_id":[NSString stringWithFormat:@"%@",cardItem.cardId],@"encrypt_code":[NSString stringWithFormat:@"%@",cardItem.encryptCode]};
            [arr addObject:dict];
        }
        WeChatInvoiceController *vc=[[WeChatInvoiceController alloc]init];
        vc.InvoiceList=arr;
        [self.navigationController pushViewController:vc animated:YES];
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
