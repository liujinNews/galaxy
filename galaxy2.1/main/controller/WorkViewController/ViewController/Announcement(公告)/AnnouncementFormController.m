//
//  AnnouncementFormController.m
//  galaxy
//
//  Created by hfk on 2018/2/11.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AnnouncementFormController.h"
#import "DepartmentSelectViewController.h"
#import "ComPeopleModel.h"
@interface AnnouncementFormController ()<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>

@end

@implementation AnnouncementFormController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[AnnouncementData alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"发公告", nil) backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self createDealBtns];
    [self initData];
}
-(void)createDealBtns{
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"发布", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            weakSelf.int_EditType=0;
            [weakSelf dockClick];
        }else if (index==1){
            weakSelf.int_EditType=1;
            [weakSelf dockClick];
        }
    };
}
-(void)initData{
    self.arr_imagesArray=[NSMutableArray array];
    self.arr_totalFileArray=[NSMutableArray array];
    if (self.EditFormData) {
        self.FormDatas.Id=[NSString isEqualToNull:_EditFormData.Id]?[NSString stringWithFormat:@"%@",_EditFormData.Id]:@"";
        self.FormDatas.Subject=[NSString isEqualToNull:_EditFormData.subject]?[NSString stringWithFormat:@"%@",_EditFormData.subject]:@"";
        self.FormDatas.Body=[NSString isEqualToNull:_EditFormData.body]?[NSString stringWithFormat:@"%@",_EditFormData.body]:@"";
        self.FormDatas.ReceiverObject=[NSString isEqualToNull:_EditFormData.receiverObject]?[NSString stringWithFormat:@"%@",_EditFormData.receiverObject]:@"";
        self.FormDatas.Author=[NSString isEqualToNull:_EditFormData.author]?[NSString stringWithFormat:@"%@",_EditFormData.author]:@"";
        self.FormDatas.PublishedDate=[NSString isEqualToNull:_EditFormData.publishedDate]?[NSString stringWithFormat:@"%@",_EditFormData.publishedDate]:@"";
        self.FormDatas.PublishedDate=[NSString isEqualToNull:_EditFormData.publishedDate]?[NSString stringWithFormat:@"%@",_EditFormData.publishedDate]:@"";
        self.FormDatas.PublishedDate=[NSString isEqualToNull:_EditFormData.publishedDate]?[NSString stringWithFormat:@"%@",_EditFormData.publishedDate]:@"";
        self.FormDatas.NoticeReceiverDtos=[NSMutableArray array];
        if ([NSString isEqualToNull:_EditFormData.attachment]) {
            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_EditFormData.attachment]];
            for (NSDictionary *dict in array) {
                [self.arr_totalFileArray addObject:dict];
            }
            [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:10];
        }
    }else{
        self.FormDatas.NoticeReceiverDtos=[NSMutableArray array];
    }
    [self updateMainView];
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
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SendRange=[[UIView alloc]init];
    _View_SendRange.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SendRange];
    [_View_SendRange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Subject.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Sender=[[UIView alloc]init];
    _View_Sender.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Sender];
    [_View_Sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SendRange.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Content=[[UIView alloc]init];
    _View_Content.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Content];
    [_View_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Sender.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Content.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
-(void)updateMainView{
    [self updateSubjectView];
    [self updateSendRangeView];
    [self updateSenderView];
    [self updateContentView];
    [self updateAttachImgView];
    [self updateBottomView];
}
//MARK:更新标题
-(void)updateSubjectView{
    _txf_Subject=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Subject WithContent:_txf_Subject WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"标题", nil) WithInfodict:@{@"value1":self.FormDatas.Subject} WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请输入标题", nil),Custing(@"(必填)", nil)] WithNumLimit:0];
    [_View_Subject addSubview:view];
}
//MARK:更新发送范围
-(void)updateSendRangeView{
    _txf_SendRange=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SendRange WithContent:_txf_SendRange WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"发送范围", nil) WithInfodict:@{@"value1":self.FormDatas.ReceiverObject} WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请选择发送范围", nil),Custing(@"(必选)", nil)] WithNumLimit:0];
    
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SendRangeClick];
    }];
    [_View_SendRange addSubview:view];
}
//MARK:更新发起人
-(void)updateSenderView{
    _txf_Sender=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Sender WithContent:_txf_Sender WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"发起人", nil) WithInfodict:@{@"value1":self.FormDatas.Author} WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请输入发起人", nil),Custing(@"(必填)", nil)] WithNumLimit:0];
    [_View_Sender addSubview:view];
}
//MARK:更新内容
-(void)updateContentView{
    _txv_Content=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Content WithContent:_txv_Content WithFormType:formViewLongTextView WithSegmentType:lineViewNoneLine WithString:nil WithInfodict:@{@"value1":self.FormDatas.Body} WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请输入内容", nil),Custing(@"(必填)", nil)] WithNumLimit:600];
    [_View_Content addSubview:view];
}
//MARK:更新图片
-(void)updateAttachImgView{
  
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:nil];
    view.maxCount=10;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.arr_totalFileArray WithImgArray:self.arr_imagesArray];
}
-(void)updateBottomView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_AttachImg.bottom);
    }];
    [self.contentView layoutIfNeeded];
}

//MARK:发送范围点击
-(void)SendRangeClick{
    DepartmentSelectViewController *de = [[DepartmentSelectViewController alloc]init];
    de.Type = 1;
    __weak typeof(self) weakSelf = self;
    de.block = ^(NSMutableArray *arr) {
        NSMutableArray *disName=[NSMutableArray array];
        for (ComPeopleModel *model in arr) {
            NSDictionary *dict;
            if ([NSString isEqualToNull:model.groupId]) {
               dict=@{@"OperatorType":@"1",
                                     @"OperatorId":[NSString stringWithFormat:@"%@",model.groupId],
                                     @"Receiver":[NSString isEqualToNull:model.groupName]?[NSString stringWithFormat:@"%@",model.groupName]:@""
                                     };
            }else{
                dict=@{@"OperatorType":@"2",
                                     @"OperatorId":[NSString isEqualToNull:model.userId]?[NSString stringWithFormat:@"%@",model.userId]:@"",
                                     @"Receiver":[NSString isEqualToNull:model.userDspName]?[NSString stringWithFormat:@"%@",model.userDspName]:@""
                                         };
            }
            [disName addObject:dict[@"Receiver"]];
            [weakSelf.FormDatas.NoticeReceiverDtos addObject:dict];
        }
        weakSelf.txf_SendRange.text=[GPUtils getSelectResultWithArray:disName WithCompare:@","];
    };
    [self.navigationController pushViewController:de animated:YES];
}
//MARK:保存发布公告
-(void)dockClick{
    self.dockView.userInteractionEnabled=NO;
    [self inModelContent];
    self.FormDatas.Status=[NSString stringWithFormat:@"%ld",(long)self.int_EditType];
    if (self.int_EditType==1) {
        if (![NSString isEqualToNull:self.FormDatas.Subject]) {
            self.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入标题", nil) duration:1.0];
            return;
        }else if (![NSString isEqualToNull:self.FormDatas.ReceiverObject]){
            self.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择发送范围", nil) duration:1.0];
            return;
        }else if (![NSString isEqualToNull:self.FormDatas.Author]){
            self.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入发起人", nil) duration:1.0];
            return;
        }else if (![NSString isEqualToNull:self.FormDatas.Body]){
            self.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入内容", nil) duration:1.0];
            return;
        }
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
            weakSelf.FormDatas.Attachment=data;
            [weakSelf readySave];
        }
    }];
}
-(void)inModelContent{
    self.FormDatas.Subject=self.txf_Subject.text;
    self.FormDatas.ReceiverObject=self.txf_SendRange.text;
    self.FormDatas.Author=self.txf_Sender.text;
    self.FormDatas.Body=self.txv_Content.text;
}
-(void)readySave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url;
    NSMutableDictionary *modelDic=[AnnouncementData initDicByModel:self.FormDatas];
    if (self.EditFormData) {
        url =[NSString stringWithFormat:@"%@",UPDATENOTICES];
    }else{
        url =[NSString stringWithFormat:@"%@",INSERTNOTICES];
        [modelDic removeObjectForKey:@"Id"];
    }
    NSDictionary *parameters=@{@"NoticesJson":[GPUtils transformToDictionaryFromJson:modelDic]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
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
            [[GPAlertView sharedAlertView]showAlertText:self WithText:self.int_EditType==1?Custing(@"发布成功", nil):Custing(@"保存成功", nil) duration:1.0];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
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
    [self.navigationController popViewControllerAnimated:YES];
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
