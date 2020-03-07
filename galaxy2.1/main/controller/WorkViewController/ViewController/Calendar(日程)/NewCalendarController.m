//
//  NewCalendarController.m
//  galaxy
//
//  Created by hfk on 2018/1/16.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "NewCalendarController.h"

@interface NewCalendarController ()<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>

@end

@implementation NewCalendarController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[NewCalendarData alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    [self createScrollView];
    [self createMainView];
    [self createDealBtns];
    [self initData];
    if (self.resultDict) {
        [self setTitle:Custing(@"修改日程", nil) backButton:YES];
        [self dealWithData];
        [self updateMainView];
    }else{
        [self setTitle:Custing(@"新建日程", nil) backButton:YES];
        [self updateMainView];
    }
}
-(void)initData{
//    self.str_imageDataString=@"";
    self.arr_imagesArray=[NSMutableArray array];
    self.arr_totalFileArray=[NSMutableArray array];
}
-(void)createDealBtns{
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveInfo];
        }
    };
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
    _View_Subject=[[UIView alloc]init];
    _View_Subject.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Subject];
    [_View_Subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_Address=[[UIView alloc]init];
    _View_Address.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Address];
    [_View_Address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Subject.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StartTime=[[UIView alloc]init];
    _View_StartTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StartTime];
    [_View_StartTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Address.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EndTime=[[UIView alloc]init];
    _View_EndTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EndTime];
    [_View_EndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StartTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Notify=[[UIView alloc]init];
    _View_Notify.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Notify];
    [_View_Notify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Private=[[UIView alloc]init];
    _View_Private.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Private];
    [_View_Private mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Notify.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project=[[UIView alloc]init];
    _View_Project.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Private.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Client=[[UIView alloc]init];
    _View_Client.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Supplier=[[UIView alloc]init];
    _View_Supplier.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
 
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LookDetail=[[UIView alloc]init];
    _View_LookDetail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LookDetail];
    [_View_LookDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
        case 1:
        {
            if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:1.0];
                __weak typeof(self) weakSelf = self;
                [self performBlock:^{
                    if (weakSelf.resultDict) {
                        int index = (int)[[weakSelf.navigationController viewControllers]indexOfObject:weakSelf];
                        [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
                    }else{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                } afterDelay:1];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存失败", nil) duration:1.0];
            }
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
-(void)dealWithData{
        [self.FormDatas setValuesForKeysWithDictionary:_resultDict];
        self.FormDatas.StartTime=[NSString isEqualToNull:_resultDict[@"startTimeStr"]]?[NSString stringWithFormat:@"%@",_resultDict[@"startTimeStr"]]:@"";
        self.FormDatas.EndTime=[NSString isEqualToNull:_resultDict[@"endTimeStr"]]?[NSString stringWithFormat:@"%@",_resultDict[@"endTimeStr"]]:@"";
        self.FormDatas.IsPrivate=[[NSString stringWithFormat:@"%@",_resultDict[@"isPrivate"]]isEqualToString:@"1"]?@"1":@"0";
        if (![_resultDict[@"attachments"] isKindOfClass:[NSNull class]]) {
//            self.str_imageDataString=_resultDict[@"attachments"];
            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_resultDict[@"attachments"]]];
            for (NSDictionary *dict in array) {
                [self.arr_totalFileArray addObject:dict];
            }
            [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:5];
        }else{
//            self.str_imageDataString=@"";
        }
}
//MARK:视图更新
-(void)updateMainView{
    [self updateSubject];
    [self updateAdress];
    [self updateStartTime];
    [self updateEndTime];
    [self updateNotifyView];
    [self updatePrivateView];
    [self updateProjView];
    [self updateClientView];
    [self updateSupplierView];
    [self updateRemarkView];
    [self updateAttachImgView];
    [self updateLookDetailView];
    [self updateContentView];
}

-(void)updateSubject{
    _txf_Subject=[[UITextField alloc]init];
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Subject WithContent:_txf_Subject WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"主题", nil) WithInfodict:@{@"value1":self.FormDatas.Subject} WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请输入主题", nil),Custing(@"(必填)", nil)] WithNumLimit:0];
    [_View_Subject addSubview:view];
}

-(void)updateAdress{
    _txf_Address=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Address WithContent:_txf_Address WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"地点", nil) WithInfodict:@{@"value1":self.FormDatas.Address} WithTips:Custing(@"请输入地点", nil) WithNumLimit:0];
    [_View_Address addSubview:view];
}
-(void)updateStartTime{
    _txf_StartTime=[[UITextField alloc]init];
    if (![NSString isEqualToNull:self.FormDatas.StartTime]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        self.FormDatas.StartTime=currStr;
    }
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StartTime WithContent:_txf_StartTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine WithString:Custing(@"开始时间", nil) WithInfodict:@{@"value1":self.FormDatas.StartTime} WithTips:Custing(@"请选择开始时间", nil) WithNumLimit:0];
    [_View_StartTime addSubview:view];
}
-(void)updateEndTime{
    _txf_EndTime=[[UITextField alloc]init];
    if (![NSString isEqualToNull:self.FormDatas.EndTime]) {
        NSDate *pickerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:3600];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        self.FormDatas.EndTime=currStr;
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndTime WithContent:_txf_EndTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine WithString:Custing(@"结束时间", nil) WithInfodict:@{@"value1":self.FormDatas.EndTime} WithTips:Custing(@"请选择结束时间", nil) WithNumLimit:0];
    [_View_EndTime addSubview:view];
}

//MARK:知会人员
-(void)updateNotifyView{
    _txf_Notify = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Notify WithContent:_txf_Notify WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"知会s", nil) WithInfodict:@{@"value1":self.FormDatas.NotifyUserName} WithTips:Custing(@"请选择知会人", nil) WithNumLimit:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf NotifyClick];
    }];
    [_View_Notify addSubview:view];
}

//MARK:隐私
-(void)updatePrivateView{
    _Swh_Private=[[UISwitch alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initWithBaseView:_View_Private WithSwitch:_Swh_Private WithString:Custing(@"私密日程", nil) WithInfo:[self.FormDatas.IsPrivate isEqualToString:@"1"]?YES:NO WithTips:Custing(@"私密开启后,日程仅知会同事可见,其他同事查看为忙碌状态", nil)];
    [_View_Private addSubview:view];
}

//MARK:外出项目
-(void)updateProjView{
    _txf_Project=[[UITextField alloc]init];
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"项目", nil) WithInfodict:@{@"value1":self.FormDatas.ProjName} WithTips:Custing(@"请选择项目", nil) WithNumLimit:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}

//MARK:外出项目
-(void)updateClientView{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"客户", nil) WithInfodict:@{@"value1":self.FormDatas.ClientName} WithTips:Custing(@"请选择客户", nil) WithNumLimit:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ClientClick];
    }];
    [_View_Client addSubview:view];
}

//MARK:项目
-(void)updateSupplierView{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"供应商", nil) WithInfodict:@{@"value1":self.FormDatas.SupplierName} WithTips:Custing(@"请选择供应商", nil) WithNumLimit:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}

//MARK:备注
-(void)updateRemarkView{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"备注", nil) WithInfodict:@{@"value1":self.FormDatas.Remark} WithTips:Custing(@"请输入备注", nil) WithNumLimit:0];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}

//MARK:更新采购图片
-(void)updateAttachImgView{    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:nil];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.arr_totalFileArray WithImgArray:self.arr_imagesArray];
}

//MARK:更新查看明细
-(void)updateLookDetailView{
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_LookDetail withTitle:Custing(@"展开关联事项", nil) withTitleAlignment:0 withImageArray:@[@"work_Open",@"work_Close"] withBtnLocation:0 withlineStyle:1];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        self.bool_openDetail = !self.bool_openDetail;
        [self updateDetailViews];
    }];
    [_View_LookDetail addSubview:view];
    [self updateDetailViews];
}

-(void)updateContentView{
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_LookDetail.bottom).offset(@10);
    }];
}

-(void)updateDetailViews{
    
    [self.View_Project updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.bool_openDetail ? @60:@0));
    }];
    [self.View_Client updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.bool_openDetail ? @60:@0));
    }];
    [self.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.bool_openDetail ? @60:@0));
    }];
    [self.View_Remark updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.bool_openDetail ? @110:@0));
    }];
    [self.View_AttachImg updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.bool_openDetail ? @88:@0));
    }];
}

//MARK:修改同行人员
-(void)NotifyClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"9";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.NotifyUserId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople =array;
    contactVC.menutype=2;
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
        weakSelf.FormDatas.NotifyUserId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.NotifyUserName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_Notify.text=weakSelf.FormDatas.NotifyUserName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(void)ProjectClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId=self.FormDatas.ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.ProjId=model.Id;
        weakSelf.FormDatas.ProjName=[GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text=weakSelf.FormDatas.ProjName;
        weakSelf.FormDatas.ProjMgrUserId=model.projMgrUserId;
        weakSelf.FormDatas.ProjMgr=model.projMgr;
    };
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)ClientClick{
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId=self.FormDatas.ClientId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.ClientId = model.Id;
        weakSelf.FormDatas.ClientName=[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Client.text =weakSelf.FormDatas.ClientName;
    };
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)SupplierClick{
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId=self.FormDatas.SupplierId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.SupplierId = model.Id;
        weakSelf.FormDatas.SupplierName =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text =weakSelf.FormDatas.SupplierName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)saveInfo{
    self.dockView.userInteractionEnabled=NO;
    [self inModelContent];
    if (![NSString isEqualToNull:self.FormDatas.Subject]) {
        self.dockView.userInteractionEnabled=YES;
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入主题", nil) duration:1.0];
        return;
    }
    if ([[GPUtils TimeStringTranFromData:self.FormDatas.StartTime WithTimeFormart:@"yyyy/MM/dd HH:mm"] timeIntervalSinceDate:[GPUtils TimeStringTranFromData:self.FormDatas.EndTime WithTimeFormart:@"yyyy/MM/dd HH:mm"]]>=0.0){
        self.dockView.userInteractionEnabled=YES;
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开始时间不能大于等于结束时间", nil) duration:1.0];
        return;
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.arr_totalFileArray WithUrl:CaldanerImgLoad WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:1.0];
            return;
        }else{
            weakSelf.FormDatas.Attachments=data;
            [weakSelf readySave];
        }
    }];
}
-(void)inModelContent{
    self.FormDatas.Subject=self.txf_Subject.text;
    self.FormDatas.Address=self.txf_Address.text;
    self.FormDatas.StartTime=self.txf_StartTime.text;
    self.FormDatas.EndTime=self.txf_EndTime.text;
    self.FormDatas.IsPrivate=_Swh_Private.on?@"1":@"0";
    self.FormDatas.Remark=self.txv_Remark.text;
    self.FormDatas.Id=[NSString isEqualToNull:self.resultDict[@"id"]]?[NSString stringWithFormat:@"%@",self.resultDict[@"id"]]:@"";
}

-(void)readySave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url;
    NSMutableDictionary *modelDic=[NewCalendarData initDicByModel:self.FormDatas];

    if (self.resultDict) {
        url =[NSString stringWithFormat:@"%@",CaldanerUpdate];
    }else{
        url =[NSString stringWithFormat:@"%@",CaldanerInsert];
        [modelDic removeObjectForKey:@"Id"];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:modelDic Delegate:self SerialNum:1 IfUserCache:NO];

}

//NSMutableDictionary *modelDic=[MyAdvanceData initDicByModel:self.SubmitData];

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
