//
//  examineViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "examineViewController.h"
#import "selectExamineViewController.h"
#import "buildCellInfo.h"
#import "ExmineApproveView.h"
#import "ExmineApproveModel.h"

@interface examineViewController ()<UITextViewDelegate,UITextFieldDelegate,selectExamineViewControllerDelegate,GPClientDelegate>

@property (nonatomic, strong) UITextField *txf_opinion;//意见
@property (nonatomic, strong) UITextField *txf_people;//申请人
@property (nonatomic, strong) NSDictionary *dic_people;
@property (nonatomic, strong) buildCellInfo *buil;
@property (nonatomic, strong) NSArray *array_people;

@property (nonatomic, strong) UIImageView *img_people;
@property (nonatomic, strong) UILabel *lab_depa;

@property (nonatomic, strong) UITextView *txv_Remark;

@property (nonatomic, strong) NSMutableArray *arr_Approver;

@property (nonatomic, strong) NSString *str_OpinionId;


@end

@implementation examineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    
    //设置确定按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_click:)];
    
    if ([_Type isEqualToString:@"0"]) {
        [self createBackView];
    }else if ([_Type isEqualToString:@"2"]) {
        [self createSubmit];
    }else if ([_Type isEqualToString:@"1"]){
        [self createCountersignView];
    }else if ([_Type isEqualToString:@"3"]){
        [self createDelegate];
    }else if ([_Type isEqualToString:@"4"]){
        [self createCc];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - function
//创建退回视图
-(void)createBackView
{
    [self setTitle:Custing(@"退回", nil) backButton:YES];
    //创建视图
    UIView * view_one = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 30)];
    view_one.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_one];
    //选择意见
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 30) action:@selector(btn_Click:) delegate:self];
    btn.tag = 104;
    [view_one addSubview:btn];
    UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImage.frame = CGRectMake(Main_Screen_Width-32, 5, 20, 20);
    [view_one addSubview:iconImage];
    _txf_opinion = [GPUtils createTextField:CGRectMake(110, 5, Main_Screen_Width-150, 20) placeholder:Custing(@"请选择常用意见", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_opinion.textAlignment = NSTextAlignmentRight;
    _txf_opinion.userInteractionEnabled = NO;
    [view_one addSubview:_txf_opinion];
    UILabel *title=[GPUtils createLable:CGRectMake(20,5,70, 20) text:Custing(@"退回原因", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view_one addSubview:title];
    //退回原因
    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 80)];
    view_two.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_two];
    
    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(16, 2, Main_Screen_Width-40, 53)];
    _remarksTextView.delegate=self;
    _remarksTextView.font=Font_Important_15_20;
    _remarksTextView.textColor=Color_form_TextField_20;
    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [view_two addSubview:_remarksTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
                                              object:_remarksTextView];
    
    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-120, 14)];
    _remarkTipField.font=Font_Important_15_20;
    _remarkTipField.enabled=NO;
    _remarkTipField.placeholder = [NSString stringWithFormat:@"%@%@",Custing(@"请输入退回原因", nil),Custing(@"(必填)", nil)];
    [_remarksTextView addSubview:_remarkTipField];
    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice_gray"] forState:UIControlStateNormal];
    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:_remarkVoiceBtn];
    //退回到
    UIView *view_three = [[UIView alloc]initWithFrame:CGRectMake(0, 130, Main_Screen_Width, 49)];
    view_three.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_three];
    UILabel *titles=[GPUtils createLable:CGRectMake(20,14,70, 20) text:Custing(@"退回到", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view_three addSubview:titles];
    _txf_people = [GPUtils createTextField:CGRectMake(110, 14, Main_Screen_Width-150, 20) placeholder:Custing(@"请选择退回到的审批人", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_opinion.userInteractionEnabled = NO;
    _txf_people.textAlignment = NSTextAlignmentRight;
    [view_three addSubview:_txf_people];
    UIImageView * iconImages=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImages.frame = CGRectMake(Main_Screen_Width-32, 14, 20, 20);
    [view_three addSubview:iconImages];
    UIButton *btn_peo=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 49) action:@selector(btn_Click:) delegate:self];
    btn_peo.tag = 105;
    [view_three addSubview:btn_peo];
}

//创建加签视图
-(void)createCountersignView
{
    [self setTitle:Custing(@"加签", nil) backButton:YES];
    
    //退回原因
    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 110)];
    view_two.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_two];
    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(8, 10, Main_Screen_Width-115, 68)];
    _remarksTextView.delegate=self;
    _remarksTextView.font=Font_Important_15_20;
    _remarksTextView.textColor=Color_form_TextField_20;
    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [view_two addSubview:_remarksTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
                                              object:_remarksTextView];
    
    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-12, 14)];
    _remarkTipField.font=Font_Important_15_20;
    _remarkTipField.enabled=NO;
    _remarkTipField.placeholder = Custing(@"请输入加签原因", nil);
    [_remarksTextView addSubview:_remarkTipField];
    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice_gray"] forState:UIControlStateNormal];
    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:_remarkVoiceBtn];
    //退回到
    UIView *view_three = [[UIView alloc]initWithFrame:CGRectMake(0, 120, Main_Screen_Width, 137)];
    view_three.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_three];
    self.arr_Approver=[NSMutableArray array];
    ExmineApproveView *ex=[[ExmineApproveView alloc]initWithBaseView:nil Withmodel:nil WithInfodict:@{@"title":Custing(@"加签人", nil),@"array":self.arr_Approver}];
    [view_three addSubview:ex];
}

-(void)createSubmit{
    [self setTitle:Custing(@"同意", nil) backButton:YES];
    
    //同意原因
    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 110)];
    view_two.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_two];
    
    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(15, 10, Main_Screen_Width-30, 68)];
    _remarksTextView.delegate=self;
    _remarksTextView.font=Font_Important_15_20;
    _remarksTextView.textColor=Color_form_TextField_20;
    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [view_two addSubview:_remarksTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
                                              object:_remarksTextView];
    
    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-38, 14)];
    _remarkTipField.font=Font_Important_15_20;
    _remarkTipField.enabled=NO;
    _remarkTipField.placeholder = Custing(@"请输入审批意见", nil);
    [_remarksTextView addSubview:_remarkTipField];
    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice_gray"] forState:UIControlStateNormal];
    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:_remarkVoiceBtn];
}

//创建转交视图
-(void)createDelegate{
    [self setTitle:Custing(@"转交", nil) backButton:YES];
    
    //转交原因
    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 110)];
    view_two.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_two];
    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(8, 10, Main_Screen_Width-115, 68)];
    _remarksTextView.delegate=self;
    _remarksTextView.font=Font_Important_15_20;
    _remarksTextView.textColor=Color_form_TextField_20;
    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [view_two addSubview:_remarksTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
                                              object:_remarksTextView];
    
    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-12, 14)];
    _remarkTipField.font=Font_Important_15_20;
    _remarkTipField.enabled=NO;
    _remarkTipField.placeholder = Custing(@"请输入转交意见", nil);
    [_remarksTextView addSubview:_remarkTipField];
    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice_gray"] forState:UIControlStateNormal];
    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:_remarkVoiceBtn];
    //退回到
    UIView *view_three = [[UIView alloc]initWithFrame:CGRectMake(0, 130, Main_Screen_Width, 116)];
    view_three.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_three];
    
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"转交人", nil);
    
    _txf_people = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:view_three WithContent:_txf_people WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{}];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.img_people=image;
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"1";
        contactVC.Radio = @"1";
        contactVC.arrClickPeople = weakSelf.array_people;
        contactVC.itemType = 99;
        contactVC.menutype= 1;
        [contactVC setBlock:^(NSMutableArray *array) {
            weakSelf.buil = array[0];
            weakSelf.txf_people.text = [NSString isEqualToNull:weakSelf.buil.requestor]?weakSelf.buil.requestor:@"";
            weakSelf.lab_depa.text = [NSString isEqualToNull:weakSelf.buil.requestorDept]?weakSelf.buil.requestorDept:@"";
            if ([NSString isEqualToNull:weakSelf.buil.photoGraph]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:weakSelf.buil.photoGraph];
                if (![[dic objectForKey:@"filepath"] isKindOfClass:[NSNull class]]) {
                    NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                    [weakSelf.img_people sd_setImageWithURL:[NSURL URLWithString:str]];
                }else{
                    weakSelf.img_people.image=[UIImage imageNamed:@"Message_Man"];
                }
            }else{
                weakSelf.img_people.image=[UIImage imageNamed:@"Message_Man"];
            }
        }];
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    [view_three addSubview:view];
    
    [view_three mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_two.bottom);
        make.edges.equalTo(view);
    }];
}

-(void)createCc{
    [self setTitle:Custing(@"抄送", nil) backButton:YES];
    //抄送原因
    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 110)];
    view_two.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_two];
    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(8, 10, Main_Screen_Width-115, 68)];
    _remarksTextView.delegate=self;
    _remarksTextView.font=Font_Important_15_20;
    _remarksTextView.textColor=Color_form_TextField_20;
    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [view_two addSubview:_remarksTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
                                              object:_remarksTextView];
    
    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-12, 14)];
    _remarkTipField.font=Font_Important_15_20;
    _remarkTipField.enabled=NO;
    _remarkTipField.placeholder = Custing(@"请输入抄送意见", nil);
    [_remarksTextView addSubview:_remarkTipField];
    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice_gray"] forState:UIControlStateNormal];
    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:_remarkVoiceBtn];
    //退回到
    UIView *view_three = [[UIView alloc]initWithFrame:CGRectMake(0, 120, Main_Screen_Width, 137)];
    view_three.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_three];
    self.arr_Approver=[NSMutableArray array];
    ExmineApproveView *ex=[[ExmineApproveView alloc]initWithBaseView:nil Withmodel:nil WithInfodict:@{@"title":Custing(@"抄送人", nil),@"array":self.arr_Approver}];
    [view_three addSubview:ex];
}


//退回
-(void)requestRECEDE{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * parameters = @{@"Comment":[_txf_opinion.text isEqualToString:_remarksTextView.text]?_remarksTextView.text:[NSString stringWithFormat:@"%@%@",_txf_opinion.text,_remarksTextView.text],@"CommentItemId":self.str_OpinionId,@"FlowCode":_FlowCode,@"TaskId":_TaskId,@"ProcId":_ProcId,@"ToProcId":_dic_people[@"procId"],@"FeeAppNumber":[NSString isEqualToNull:_FeeAppNumber]?_FeeAppNumber:@"0",@"ContractNumber":[NSString isEqualToNull:_ContractNumber]?_ContractNumber:@"0",@"AdvanceNumber":[NSString isEqualToNull:_AdvanceNumber]?_AdvanceNumber:@"0",@"CommonField":_str_CommonField};
    NSString *url=[NSString stringWithFormat:@"%@",RECEDE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}
//加签
-(void)requestEndorse{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    NSDictionary * parameters = @{@"Comment":[NSString stringWithFormat:@"%@",_remarksTextView.text],@"ProcId":_ProcId,@"HandlerUserId":[NSNumber numberWithInteger:_buil.requestorUserId],@"HandlerUserName":_buil.requestor,@"CommonField":_str_CommonField};
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<self.arr_Approver.count; i++) {
        buildCellInfo *model = self.arr_Approver[i];
        [arr addObject:@{@"HandlerUserId":[NSNumber numberWithInteger:model.requestorUserId],@"HandlerUserName":model.requestor}];
    }
    NSDictionary * parameters = @{@"Comment":[NSString stringWithFormat:@"%@",_remarksTextView.text],@"ProcId":_ProcId,@"UsersJson":[NSString transformToJson:arr],@"CommonField":_str_CommonField};
    NSString *url=[NSString stringWithFormat:@"%@",Endorse];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
}

//同意
-(void)requestAPPROVAL{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dic_APPROVAL options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];

    NSDictionary * parameters = @{@"ActionLinkName":@"同意",@"Comment":[NSString stringWithFormat:@"%@",_remarksTextView.text],@"TaskId":_TaskId,@"ProcId":_ProcId,@"FormData":stri,@"ExpIds":@"",@"MainForm":_dic_AgreeAmount?[self transformToJson:_dic_AgreeAmount]:@"",@"FeeAppNumber":[NSString isEqualToNull:_FeeAppNumber]?_FeeAppNumber:@"0",@"ContractNumber":[NSString isEqualToNull:_ContractNumber]?_ContractNumber:@"0",@"AdvanceNumber":[NSString isEqualToNull:_AdvanceNumber]?_AdvanceNumber:@"0",@"FlowCode":_FlowCode,@"CommonField":_str_CommonField};
    NSString *url=[NSString stringWithFormat:@"%@",APPROVAL];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:7 IfUserCache:NO];
}

//转交
-(void)requestDelegate{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * parameters = @{@"ProcId":_ProcId,@"Comment":[NSString stringWithFormat:@"%@",_remarksTextView.text],@"UsersJson":[NSString transformToJson:@[@{@"HandlerUserId":[NSNumber numberWithInteger:_buil.requestorUserId],@"HandlerUserName":_buil.requestor}]]};
    NSString *url=[NSString stringWithFormat:@"%@",bpmDelegate];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:8 IfUserCache:NO];
}

//抄送
-(void)requestCc{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *extractedExpr = self.arr_Approver;
    for (int i = 0; i<extractedExpr.count; i++) {
        buildCellInfo *model = self.arr_Approver[i];
        [arr addObject:@{@"HandlerUserId":[NSNumber numberWithInteger:model.requestorUserId],@"HandlerUserName":model.requestor}];
    }
    NSDictionary * parameters = @{@"TaskId":_TaskId,@"Comment":[NSString stringWithFormat:@"%@",_remarksTextView.text],@"UsersJson":[NSString transformToJson:arr]};
    NSString *url=[NSString stringWithFormat:@"%@",bpmCc];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:9 IfUserCache:NO];
}

#pragma mark - action
//确定按钮
-(void)btn_right_click:(UIButton *)btn{
    if (![NSString isEqualToNull:_txf_opinion.text]&&![NSString isEqualToNull:_remarksTextView.text]) {
        if ([_Type isEqualToString:@"0"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入退回原因", nil) duration:1.0];
            return;
        }else if ([_Type isEqualToString:@"1"]){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入加签原因", nil) duration:1.0];
            return;
        }else if ([_Type isEqualToString:@"3"]){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入转交意见", nil) duration:1.0];
            return;
        }
    }
    if ([_Type isEqualToString:@"0"]||[_Type isEqualToString:@"3"]) {
        if (_dic_people == nil && _buil == nil) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[_Type isEqualToString:@"0"]?Custing(@"请选择退回人", nil):[_Type isEqualToString:@"3"]?Custing(@"请选择转交人", nil):Custing(@"保存错误", nil) duration:1.0];
            return;
        }
    }else if ([_Type isEqualToString:@"1"]) {
        if (self.arr_Approver == nil || self.arr_Approver.count == 0) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择加签人", nil) duration:1.0];
            return;
        }
    }else if ([_Type isEqualToString:@"4"]) {
        if (self.arr_Approver == nil || self.arr_Approver.count == 0) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择抄送人", nil) duration:1.0];
            return;
        }
    }
    if ([_Type isEqualToString:@"0"]) {
        [self requestRECEDE];
    }else if ([_Type isEqualToString:@"1"]){
        [self requestEndorse];
    }else if ([_Type isEqualToString:@"2"]){
        [self requestAPPROVAL];
    }else if ([_Type isEqualToString:@"3"]){
        [self requestDelegate];
    }else if ([_Type isEqualToString:@"4"]){
        [self requestCc];
    }
}

//选择
-(void)btn_Click:(UIButton *)btn{
    if (btn.tag == 104) {
        selectExamineViewController *select = [[selectExamineViewController alloc]init];
        select.type = @"0";
        select.select_id = @"0";
        select.style = @"0";
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
    if (btn.tag == 105) {
        if ([_Type isEqualToString:@"1"]) {
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"1";
            contactVC.Radio = @"1";
            contactVC.arrClickPeople = _array_people;
            contactVC.itemType = 99;
            contactVC.menutype= 1;
            __weak typeof(self) weakSelf = self;
            [contactVC setBlock:^(NSMutableArray *array) {
                weakSelf.buil = array[0];
                weakSelf.txf_people.text = [NSString isEqualToNull:weakSelf.buil.requestor]?weakSelf.buil.requestor:@"";
                weakSelf.lab_depa.text = [NSString isEqualToNull:weakSelf.buil.requestorDept]?weakSelf.buil.requestorDept:@"";
                if ([NSString isEqualToNull:weakSelf.buil.photoGraph]) {
                    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:weakSelf.buil.photoGraph];
                    if (![[dic objectForKey:@"filepath"] isKindOfClass:[NSNull class]]) {
                        NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                        [weakSelf.img_people sd_setImageWithURL:[NSURL URLWithString:str]];
                    }else{
                        weakSelf.img_people.image=[UIImage imageNamed:@"Message_Man"];
                    }
                }else{
                    weakSelf.img_people.image=[UIImage imageNamed:@"Message_Man"];
                }
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
        }else{
            selectExamineViewController *select = [[selectExamineViewController alloc]init];
            select.type = @"0";
            select.select_id = @"0";
            select.style = @"1";
            select.delegate = self;
            select.TaskId = _TaskId;
            select.ProcId = _ProcId;
            [self.navigationController pushViewController:select animated:YES];
        }
    }
}

//备注语音输入
-(void)VoiceBtnClick:(UIButton *)btn{
    [self keyClose];
    [self startVoice];
}

//备注限制字数
-(void)AddRemarkTextViewEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >255) {
                textField.text = [toBeString substringToIndex:255];
            }
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 255) {
            textField.text = [toBeString substringToIndex:255];
        }
    }
}

//备注分行显示处理
-(void)changeRemarkView
{
    if (_remarksTextView.text.length == 0) {
        _remarkTipField.hidden = NO;
    }else{
        _remarkTipField.hidden = YES;
    }
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        return;
    }
    
    if (serialNum == 5) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"退回成功", nil) duration:1.5];
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
            NSInteger i=0;
            for (id obj in weakSelf.navigationController.childViewControllers) {
                if ([obj isKindOfClass:[FlowBaseViewController class]]) {
                    i=[weakSelf.navigationController.childViewControllers indexOfObject:obj];
                }
            }
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:i] animated:YES];
        } afterDelay:1.0];
    }else if (serialNum == 7||serialNum == 8) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
            NSInteger i=0;
            for (id obj in weakSelf.navigationController.childViewControllers) {
                if ([obj isKindOfClass:[FlowBaseViewController class]]) {
                    i=[weakSelf.navigationController.childViewControllers indexOfObject:obj];
                }
            }
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:i] animated:YES];
        } afterDelay:1.5];
    }else if (serialNum == 9 || serialNum == 6){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } afterDelay:1.5];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)selectExamineViewController_Delegate:(NSDictionary *)dic type:(NSString *)type style:(NSString *)style{
    if ([style isEqualToString:@"0"]) {
        _txf_opinion.text = dic[@"reason"];
        _str_OpinionId = [NSString stringIsExist:dic[@"id"]];
        if (![NSString isEqualToNull:_remarksTextView.text]) {
            _remarksTextView.text = _txf_opinion.text;
            [self changeRemarkView];
        }
    }else if ([style isEqualToString:@"1"]) {
        _txf_people.text = [NSString stringWithFormat:@"%@/%@",dic[@"nodeName"],dic[@"handlerUserName"]];
        _dic_people = dic;
    }
}
//MARK:textView代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
        if ([textView class] == [_remarksTextView class]) {
        if (textView.text.length>200) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
            textView.text = [textView.text substringToIndex:199];
        }
        _remarksTextView.text = textView.text;
    }
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    [self changeRemarkView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textField.text = [textField.text substringToIndex:199];
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
