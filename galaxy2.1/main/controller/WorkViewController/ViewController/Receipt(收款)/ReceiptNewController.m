//
//  ReceiptNewController.m
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReceiptNewController.h"

@interface ReceiptNewController ()

@end

@implementation ReceiptNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[ReceiptFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeStatus=[self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    if (self.pushFlowGuid) {
        self.FormDatas.str_flowGuid = self.pushFlowGuid;
    }
    [self setTitle:nil backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self getFormData];
}

-(void)createDealBtns{
    if (self.FormDatas.int_comeStatus==1||self.FormDatas.int_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf saveInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else if (self.FormDatas.int_comeStatus==3&&![self.FormDatas.str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf directInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf submitInfo];
            }
        };
    }
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
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
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
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount=[[UIView alloc]init];
    _View_Amount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized=[[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Amount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];


    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiptDate=[[UIView alloc]init];
    _View_ReceiptDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiptDate];
    [_View_ReceiptDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Method=[[UIView alloc]init];
    _View_Method.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Method];
    [_View_Method mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiptDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Method.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project=[[UIView alloc]init];
    _View_Project.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EffectiveDate=[[UIView alloc]init];
    _View_EffectiveDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EffectiveDate];
    [_View_EffectiveDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpiryDate=[[UIView alloc]init];
    _View_ExpiryDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpiryDate];
    [_View_ExpiryDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EffectiveDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractAmount=[[UIView alloc]init];
    _View_ContractAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractAmount];
    [_View_ContractAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpiryDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReturnedAmount=[[UIView alloc]init];
    _View_ReturnedAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReturnedAmount];
    [_View_ReturnedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_UnReturnedAmount=[[UIView alloc]init];
    _View_UnReturnedAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_UnReturnedAmount];
    [_View_UnReturnedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReturnedAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceBillTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_ReceBillTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_ReceBillTable.delegate=self;
    _View_ReceBillTable.dataSource=self;
    _View_ReceBillTable.scrollEnabled=NO;
    _View_ReceBillTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_ReceBillTable];
    [_View_ReceBillTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_UnReturnedAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Application=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0019"];
    _View_Application.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Application];
    [_View_Application mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceBillTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Application.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Bank=[[UIView alloc]init];
    _View_Bank.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Bank];
    [_View_Bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount=[[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Bank.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
//MARK:网络部分
//MARK:第一次打开借款表单
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:获取收款信息
//1只取回款记录 2取所有信息
-(void)requestReceiveBillInfoWithType:(NSInteger)type{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getReceiveBillInfoUrl] Parameters:[self.FormDatas getReceiveBillInfoParameters] Delegate:self SerialNum: type==1?5:6 IfUserCache:NO];
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    self.FormDatas.dict_resultDict=responceDic;
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
        {
            [self.FormDatas DealWithFormBaseData];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            if (self.FormDatas.int_comeStatus==3){
                [self requestApproveNote];
            }else{
                [self updateMainView];
                [self createDealBtns];
                if (self.FormDatas.int_comeStatus!=1) {
                    [self requestReceiveBillInfoWithType:1];
                }
            }
        }
            break;
        case 1:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
            
        }
            break;
        case 3:
        {
            
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"result"]] forKey:@"TaskId"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goSubmitSuccessTo:) userInfo:dict repeats:NO];
        }
            break;
        case 4:
        {
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
            if (self.FormDatas.int_comeStatus!=1) {
                [self requestReceiveBillInfoWithType:1];
            }
        }
            break;
        case 5:
            [self.FormDatas dealWithReceiveBillInfoWithType:1];
            if (self.FormDatas.arr_receiveBillHistory.count>0) {
                [self updateReceiveBillTableView];
            }
            break;
        case 6:
        {
            [self.FormDatas dealWithReceiveBillInfoWithType:2];
            self.txf_Project.text=self.FormDatas.personalData.ProjName;
            self.txf_EffectiveDate.text=self.FormDatas.str_ContEffectiveDate;
            self.txf_ExpiryDate.text=self.FormDatas.str_ContExpiryDate;
            self.txf_ContractAmount.text=[GPUtils transformNsNumber:self.FormDatas.str_ContAmount];
            self.txf_ReturnedAmount.text=[GPUtils transformNsNumber:self.FormDatas.str_RepaidAmount];
            self.txf_UnReturnedAmount.text=[GPUtils transformNsNumber:self.FormDatas.str_UnpaidAmount];
            if (self.FormDatas.arr_receiveBillHistory.count>0) {
                [self updateReceiveBillTableView];
            }
        }
            break;
        case 10:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
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

-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled=YES;
    [self goSubmitSuccessToWithModel:self.FormDatas];

}

//MARK:视图更新
-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        
        if ([model.fieldName isEqualToString:@"Reason"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Amount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCapitalizedAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_CurrencyCodeView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_ExchangeRateView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_LocalCyAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiveDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiptDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiveMethod"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateMethodViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiveType"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContEffectiveDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEffectiveDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContExpiryDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpiryDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RepaidAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReturnedAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UnpaidAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateUnReturnedAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvoiceAppNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateApplicationView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClientId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateClientView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankViewWithModel:model];
                [self.FormDatas.dict_reservedDic setValue:model.Description forKey:model.fieldName];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankAccount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankAccountViewWithModel:model];
                [self.FormDatas.dict_reservedDic setValue:model.Description forKey:model.fieldName];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRemarkViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];;
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAttachImgViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];;
            }
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:self.FormDatas.model_ApprovelPeoModel.fieldName];
                [self updateApproveViewWithModel:self.FormDatas.model_ApprovelPeoModel];
                [self.FormDatas.arr_UnShowmsArray removeObject:@"FirstHandlerUserName"];
            }
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCcPeopleViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }
    }
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    [self updateContentView];
    [self.FormDatas getEndShowArray];
    
}

//MARK:更新事由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Reason addSubview:view];
}
//MARK:更新借款金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Amount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Amount WithContent:_txf_Amount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_Capitalized.text=[NSString getChineseMoneyByString:amount];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
    }];
    [_View_Amount addSubview:view];
}
//MARK:更新金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Capitalized addSubview:view];
}
//MARK:更新币种视图
-(void)update_CurrencyCodeView:(MyProcurementModel *)model{
    _txf_CurrencyCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf changeCurrency];
    }];
    [_View_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text=self.FormDatas.str_Currency;
    }else{
        _txf_CurrencyCode.text=self.FormDatas.str_Currency;
    }
}
//更新汇率视图
-(void)update_ExchangeRateView:(MyProcurementModel *)model{
    _txf_ExchangeRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.FormDatas.str_ExchangeRate=exchange;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")]];
    }];
    [_View_ExchangeRate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_ExchangeRate=model.fieldValue;
    }else{
        _txf_ExchangeRate.text=[NSString stringWithFormat:@"%@",self.FormDatas.str_ExchangeRate];
    }
}
//更新本位币金额视图
-(void)update_LocalCyAmountView:(MyProcurementModel *)model{
    _txf_LocalCyAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_LocalCyAmount addSubview:view];
}
//MARK:收款日期
-(void)updateReceiptDateViewWithModel:(MyProcurementModel *)model{
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSString *DateFormat=@"yyyy/MM/dd";
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter *Formatter = [[NSDateFormatter alloc]init];
        Formatter.timeZone = [NSTimeZone localTimeZone];
        [Formatter setDateFormat:DateFormat];
        NSString *currDateStr= [NSString stringWithFormat:@"%@",[Formatter stringFromDate:pickerDate]];
        model.fieldValue=currDateStr;
    }
    _txf_ReceiptDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ReceiptDate WithContent:_txf_ReceiptDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceiptDate addSubview:view];
}
//MARK:更新收款方式
-(void)updateMethodViewWithModel:(MyProcurementModel *)model{
    _txf_Method=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Method WithContent:_txf_Method WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ReceiveMethodClick];
    }];
    [_View_Method addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_Type=model.fieldValue;
    }
}
//MARK:更新类型
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId=weakSelf.FormDatas.str_TypeId;
        vc.ChooseModel=model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_Type.text=model.name;
            weakSelf.FormDatas.str_Type=model.name;
            weakSelf.FormDatas.str_TypeId=model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString stringIsExist:model.fieldValue]) {
        self.FormDatas.str_Type=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_Type addSubview:view];

}

//MARK:更新合同名称
-(void)updateContractViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName],
                           @"Model":model
                           };
    [_View_ContractName updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ContractName.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf ContractClick];
    };
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}
//MARK:更新合同开始日期
-(void)updateEffectiveDateViewWithModel:(MyProcurementModel *)model{
    _txf_EffectiveDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EffectiveDate WithContent:_txf_EffectiveDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_ContEffectiveDate=selectTime;
    }];
    [_View_EffectiveDate addSubview:view];
}

//MARK:更新合同截止日期
-(void)updateExpiryDateViewWithModel:(MyProcurementModel *)model{
    _txf_ExpiryDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExpiryDate WithContent:_txf_ExpiryDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_ContExpiryDate=selectTime;
    }];
    [_View_ExpiryDate addSubview:view];
}
//MARK:更新合同金额
-(void)updateContractAmountView:(MyProcurementModel *)model{
    _txf_ContractAmount = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContractAmount WithContent:_txf_ContractAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContractAmount addSubview:view];
}
//MARK:更新已回款
-(void)updateReturnedAmountView:(MyProcurementModel *)model{
    _txf_ReturnedAmount = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ReturnedAmount WithContent:_txf_ReturnedAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReturnedAmount addSubview:view];
}
//MARK:更新未回款
-(void)updateUnReturnedAmountView:(MyProcurementModel *)model{
    _txf_UnReturnedAmount = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_UnReturnedAmount WithContent:_txf_UnReturnedAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_UnReturnedAmount addSubview:view];
}
//MARK:更新回款信息
-(void)updateReceiveBillTableView{
    if (self.FormDatas.bool_isOpenDetail) {
        NSInteger height=10;
        for (NSDictionary *dict in self.FormDatas.arr_receiveBillHistory) {
            height=height+[ProcureDetailsCell HasReturnAmountCellHeightWithDict:dict];
        }
        [_View_ReceBillTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        NSDictionary *dict=self.FormDatas.arr_receiveBillHistory[0];
        NSInteger height=10+[ProcureDetailsCell HasReturnAmountCellHeightWithDict:dict];
        [_View_ReceBillTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
    [_View_ReceBillTable reloadData];
}
//MARK:更新开票
-(void)updateApplicationView:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_InvoiceAppNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_InvoiceAppInfo=@"";
        self.FormDatas.str_InvoiceAppNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_InvoiceAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_InvoiceAppInfo],
                           @"Model":model
                           };
    [_View_Application updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_Application.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf ApplicationClick];
    };
}

//MARK:更新客户视图
-(void)updateClientView:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ClientName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ClientClick];
    }];
    [_View_Client addSubview:view];
}
//MARK:更新银行
-(void)updateBankViewWithModel:(MyProcurementModel *)model{
    _txf_Bank = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Bank WithContent:_txf_Bank WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.FormDatas.str_BankName=text;
    }];
    [_View_Bank addSubview:view];
}

//MARK:更新银行账号
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_BankAccount = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.FormDatas.str_BankAccount=text;
    }];
    [_View_BankAccount addSubview:view];
    _txf_BankAccount.keyboardType = UIKeyboardTypeEmailAddress;
}
//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[[ReserverdMainView alloc]initArr:self.FormDatas.arr_FormMainArray isRequiredmsdic:self.FormDatas.dict_isRequiredmsdic reservedDic:self.FormDatas.dict_reservedDic UnShowmsArray:self.FormDatas.arr_UnShowmsArray view:_View_Reserved model:self.FormDatas.model_ReserverModel block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}
//MARK:审批记录
-(void)updateNotesTableView{
    __weak typeof(self) weakSelf = self;
    [_View_Note addSubview:[[FlowChartView alloc] init:self.FormDatas.arr_noteDateArray Y:10 HeightBlock:^(NSInteger height) {
        [weakSelf.View_Note addSubview:[weakSelf createLineView]];
        [weakSelf.View_Note updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height+10+15);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}
//MARK:更新采购审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_firstHanderPhotoGraph,@"value2":self.FormDatas.str_firstHandlerGender}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.View_ApproveImg=image;
        [self ApproveClick];
    }];
    [_View_Approve addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _txf_Approver.text=model.fieldValue;
        self.FormDatas.str_firstHanderName=model.fieldValue;
    }
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}
//MARK:更新滚动视图
-(void)updateContentView{
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_CcToPeople.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:修改收款方式
-(void)ReceiveMethodClick{
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"payWay"];
    choose.ChooseCategoryArray=self.FormDatas.arr_payWay;
    choose.ChooseCategoryId=self.FormDatas.str_PayCode;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        if (array) {
            ChooseCategoryModel *model = array[0];
            weakSelf.FormDatas.str_PayCode=[NSString stringWithFormat:@"%@",model.payCode];
            weakSelf.FormDatas.str_PayMode=[NSString stringWithFormat:@"%@",model.payMode];
            weakSelf.txf_Method.text=[NSString stringWithFormat:@"%@",model.payMode];
        }else{
            weakSelf.FormDatas.str_PayCode=@"";
            weakSelf.FormDatas.str_PayMode=@"";
            weakSelf.txf_Method.text=@"";

        }
    };
    [self.navigationController pushViewController:choose animated:YES];
}
//MARK:修改币种
-(void)changeCurrency{
    [self keyClose];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_CurrencyCode=Model.Id;
        weakSelf.FormDatas.str_Currency=Model.Type;
        weakSelf.txf_CurrencyCode.text=Model.Type;
        weakSelf.txf_ExchangeRate.text=Model.exchangeRate;
        weakSelf.FormDatas.str_ExchangeRate=Model.exchangeRate;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
    }];
    picker.typeTitle=Custing(@"币种", nil);
    picker.DateSourceArray=self.FormDatas.arr_CurrencyCode;
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull: self.FormDatas.str_CurrencyCode]?self.FormDatas.str_CurrencyCode:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:修改合同
-(void)ContractClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ContractsV3"];
    vc.ChooseCategoryId=self.FormDatas.str_ContractAppNumber;
    vc.dict_otherPars=@{@"Type":@"2",@"flowCode":self.FormDatas.str_flowCode,@"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_ContractNo = model.contractNo;
        weakSelf.FormDatas.str_ContractAppNumber = model.taskId;
        weakSelf.FormDatas.str_ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName] WithCompare:@"/"];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName]                               };
        [weakSelf.View_ContractName updateView:dict];
        [weakSelf requestReceiveBillInfoWithType:2];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
//MARK:修改项目名称
-(void)ProjectClick{
    NSLog(@"修改项目名称");
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId=self.FormDatas.personalData.ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ProjId = model.Id;
        weakSelf.FormDatas.personalData.ProjName=[GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text = weakSelf.FormDatas.personalData.ProjName;
        weakSelf.FormDatas.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.FormDatas.personalData.ProjMgr = model.projMgr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改开票
-(void)ApplicationClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"InvoiceForms"];
    vc.ChooseCategoryId=self.FormDatas.str_InvoiceAppNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":self.FormDatas.str_InvoiceStatus};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_InvoiceAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_InvoiceAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_InvoiceAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_InvoiceAppInfo]                               };
        [weakSelf.View_Application updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改客户
-(void)ClientClick{
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId=self.FormDatas.personalData.ClientId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ClientId = model.Id;
        weakSelf.FormDatas.personalData.ClientName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Client.text = weakSelf.FormDatas.personalData.ClientName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:审批人选择
-(void)ApproveClick{
    NSLog(@"审批人选择");
    [self keyClose];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_firstHanderId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople = array;
    contactVC.status = @"1";
    contactVC.menutype=3;
    contactVC.itemType = 25;
    contactVC.Radio = @"1";
    contactVC.universalDelegate = self;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.txf_Approver.text=bul.requestor;
        weakSelf.FormDatas.str_firstHanderName=bul.requestor;
        weakSelf.FormDatas.str_firstHanderId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                weakSelf.FormDatas.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.FormDatas.str_firstHanderPhotoGraph]];
            }
        }else{
            if ([[NSString stringWithFormat:@"%d",bul.gender] isEqualToString:@"0"]) {
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Man"];
            }else{
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Woman"];
            }
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:选择抄送人
-(void)CcPeopleClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_CcUsersId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.status = @"12";
    contactVC.isCleanSelf = YES;
    contactVC.arrClickPeople =array;
    contactVC.menutype=3;
    contactVC.itemType = 99;
    contactVC.Radio = @"2";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr=[NSMutableArray array];
        NSMutableArray *idArr=[NSMutableArray array];
        if (array.count>0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                }
            }
        }
        weakSelf.FormDatas.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_CcToPeople.text=weakSelf.FormDatas.str_CcUsersName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}
//MARK:保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
    
}
//MARK:提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"提交操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    [self mainDataList];
}

//MARK:-提交保存数据处理
//拼接数据
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }
    }
    [self.FormDatas contectData];
    [self dealWithImagesArray];
}
-(void)configModelOtherData{
    
    self.FormDatas.SubmitData.Reason=_txv_Reason.text;
    self.FormDatas.SubmitData.ReceiveDate=_txf_ReceiptDate.text;
    self.FormDatas.SubmitData.ContAmount = [NSString isEqualToNull:self.txf_ContractAmount.text]?[self.txf_ContractAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
    self.FormDatas.SubmitData.Amount=[NSString isEqualToNull:_txf_Amount.text]?_txf_Amount.text:@"0";//(id)[NSNull null]
    self.FormDatas.SubmitData.CapitalizedAmount=self.txf_Capitalized.text;
    NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")];
    LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    self.FormDatas.SubmitData.LocalCyAmount=[NSString isEqualToNull:LocalCyAmount]?LocalCyAmount:@"0.00";
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
}

//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:AdvanceLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.FormDatas.str_imageDataString=data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf readySubmitAndSave];
        }
    }];
}
-(void)readySubmitAndSave{
    if (self.FormDatas.int_SubmitSaveType==1) {
        [self requestAppSave];
    }else if(self.FormDatas.int_SubmitSaveType==2){
        if (self.FormDatas.int_comeStatus==3) {
            [self requestAppbackSubmit];
        }else if (self.FormDatas.int_comeStatus==4){
            [self requestAppReCallSubmit];
        }else{
            [self requestAppSubmit];
        }
    }else if (self.FormDatas.int_SubmitSaveType ==3){
        [self requestDirect];
    }
}
//MARK:保存
-(void)requestAppSave
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:提交
-(void)requestAppSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:[self.FormDatas SubmitFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:[self.FormDatas SubmitFormAgainWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.FormDatas.arr_receiveBillHistory.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=self.FormDatas.arr_receiveBillHistory[indexPath.row];
    return [ProcureDetailsCell HasReturnAmountCellHeightWithDict:dict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        return [UIView new];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
    if (cell==nil) {
        cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
    }
    NSDictionary *dict=self.FormDatas.arr_receiveBillHistory[indexPath.row];
    [cell configHasReturnAmountDetailCellWithDict:dict withindex:indexPath.row withCount:self.FormDatas.arr_receiveBillHistory.count];
    cell.isOpen=self.FormDatas.bool_isOpenDetail;
    if (cell.LookMore) {
        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)LookMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [self updateReceiveBillTableView];
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
