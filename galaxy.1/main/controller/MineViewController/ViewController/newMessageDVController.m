//
//  newMessageDVController.m
//  galaxy
//
//  Created by 赵碚 on 15/8/13.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#define add       @"1"
#define release   @"0"

#import "newMessageDVController.h"

@interface newMessageDVController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,GPClientDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic, strong)NSString * app;
@property(nonatomic, strong)NSString * companyId;
@property(nonatomic, strong)NSString * finished;
@property(nonatomic, strong)NSString * idd;
@property(nonatomic, strong)NSString * maill;
@property(nonatomic, strong)NSString * newtaskStr;
@property(nonatomic, strong)NSString * operationObjectId;
@property(nonatomic, strong)NSString * operationType;
@property(nonatomic, strong)NSString * pay;
@property(nonatomic, strong)NSString * rejected;
@property(nonatomic, strong)NSString * returned;
@property(nonatomic, strong)NSString * redirected;
@property(nonatomic, strong)NSString * cced;


@property(nonatomic,strong)UISwitch * appImage;
@property(nonatomic,strong)UISwitch * emailImage;
@property(nonatomic,strong)UISwitch * newtaskImage;
@property(nonatomic,strong)UISwitch * finishImage;
@property(nonatomic,strong)UISwitch * returnImage;
@property(nonatomic,strong)UISwitch * rejectImage;
@property(nonatomic,strong)UISwitch * payImage;
@property(nonatomic,strong)UISwitch * sw_RedirectMe;
@property(nonatomic,strong)UISwitch * sw_CCMe;


//填写信息视图
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,strong)UIView * mainView;

@property(nonatomic,strong)NSDictionary * parametersDic;
@property(nonatomic,strong)UILabel * chooseBtn;
@property(nonatomic,strong)UIButton * mainBtn;

@property (nonatomic,assign)NSInteger headerHeight;
@property (nonatomic,assign)NSInteger mainHeight;

@end

@implementation newMessageDVController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

-(void)loadView{
    [super loadView];
    [self requestMsgsubscribe];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*1.6);
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTitle:Custing(@"消息设置", nil) backButton:YES ];
    
    
   
    // Do any additional setup after loading the view.
}
-(void)back:(UIButton *)btn{
    [YXSpritesLoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createheaderView{
    
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 25)];
    blueView.backgroundColor = Color_Blue_Important_20;
    [self.scrollView addSubview:blueView];
    
    UILabel * number = [GPUtils createLable:CGRectMake(15, 0, 200, 25) text:Custing(@"消息提醒项目", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    number.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:number];
    
    
    self.headerHeight = 55*2;
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(blueView), Main_Screen_Width, self.headerHeight)];
    self.headerView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:self.headerView ];
    
    NSArray * setArr = @[
                         @{@"image":[NSString stringWithFormat:@"%@",self.app],@"name":Custing(@"给我手机推送消息", nil),@"tag":@"0"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.maill],@"name":Custing(@"给我邮箱推送消息", nil),@"tag":@"1"}];
    
    
    for (int j = 0 ; j < [setArr count] ; j ++ ) {
        
        self.chooseBtn = [GPUtils createLable:CGRectMake(15, j*55, WIDTH(self.headerView)-80, 55) text:[[setArr objectAtIndex:j]  objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.headerView  addSubview:self.chooseBtn];

    }
    //WIDTH(numberHLa)-40*scale
    UISwitch * nicai = [[UISwitch alloc]init];
    
    self.appImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.headerView)-15-WIDTH(nicai),self.headerHeight/4-HEIGHT(nicai)/2, 0, 0)];
    self.appImage.backgroundColor = [UIColor clearColor];
    if ([self.app isEqualToString:release]) {
       [self.appImage setOn:[self.app boolValue] animated:NO];
    }else{
        [self.appImage setOn:[self.app boolValue] animated:NO];
    }
    self.appImage.tag = 101;
    [self.appImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.appImage.onTintColor=Color_Blue_Important_20;

    [self.headerView addSubview:self.appImage];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.headerView)/2, WIDTH(self.headerView)-30, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.headerView  addSubview:line];
    
    
    self.emailImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.headerView)-15-WIDTH(nicai), self.headerHeight/4*3-HEIGHT(nicai)/2, 0, 0)];
    self.emailImage.backgroundColor = [UIColor clearColor];
    if ([self.maill isEqualToString:release]) {
       [self.emailImage setOn:[self.maill boolValue] animated:NO];
    }else{
       [self.emailImage setOn:[self.maill boolValue] animated:NO];
    }
    self.emailImage.tag = 102;
    [self.emailImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.emailImage.onTintColor=Color_Blue_Important_20;
    [self.headerView addSubview:self.emailImage];
    
    
}



-(void)createMainView{
    
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, Y(self.headerView)+HEIGHT(self.headerView), 5, 25)];
    blueView.backgroundColor = Color_Blue_Important_20;
    [self.scrollView addSubview:blueView];
    
    UILabel * number = [GPUtils createLable:CGRectMake(15, Y(self.headerView)+HEIGHT(self.headerView), 200, 25) text:Custing(@"需要提醒的项目", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    number.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:number];
    
    self.mainHeight = 7*56;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, Y(self.headerView)+HEIGHT(self.headerView)+25, Main_Screen_Width, self.mainHeight)];
    self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:self.mainView ];

    NSArray * setArr = @[
                         @{@"image":[NSString stringWithFormat:@"%@",self.newtaskStr],@"name":Custing(@"需要我审批的申请", nil),@"tag":@"2"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.finished],@"name":Custing(@"我提交的申请审批完成", nil),@"tag":@"3"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.pay],@"name":Custing(@"我提交的申请支付完成", nil),@"tag":@"6"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.returned],@"name":Custing(@"我提交的申请被退回", nil),@"tag":@"4"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.rejected],@"name":Custing(@"我提交的申请被作废", nil),@"tag":@"5"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.rejected],@"name":Custing(@"转交给我审批的申请", nil),@"tag":@"6"},
                         @{@"image":[NSString stringWithFormat:@"%@",self.rejected],@"name":Custing(@"抄送给我的申请", nil),@"tag":@"7"}
                
                         ];
    
    
    for (int j = 0 ; j < [setArr count] ; j ++ ) {
    
        self.chooseBtn = [GPUtils createLable:CGRectMake(15, j*self.mainHeight/7, WIDTH(self.headerView)-30, self.mainHeight/7) text:[[setArr objectAtIndex:j]  objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView  addSubview:self.chooseBtn];
        if (j!=setArr.count-1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, j*self.mainHeight/7+self.mainHeight/7, WIDTH(self.headerView)-30, 0.5)];
            line.backgroundColor = Color_GrayLight_Same_20;
            [self.mainView  addSubview:line];
        }
    }
    UISwitch * nicai = [[UISwitch alloc]init];
    
    self.newtaskImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14-HEIGHT(nicai)/2, 0,0)];
    self.newtaskImage.backgroundColor = [UIColor clearColor];
    if ([self.newtaskStr isEqualToString:release]) {
        [self.newtaskImage setOn:[self.newtaskStr boolValue] animated:NO];
    }else{
        [self.newtaskImage setOn:[self.newtaskStr boolValue] animated:NO];
    }
    self.newtaskImage.tag = 103;
    [self.newtaskImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.newtaskImage.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.newtaskImage];
    
    self.finishImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*3-HEIGHT(nicai)/2, 0, 0)];
    self.finishImage.backgroundColor = [UIColor clearColor];
    if ([self.finished isEqualToString:release]) {
        [self.finishImage setOn:[self.finished boolValue] animated:NO];
    }else{
        [self.finishImage setOn:[self.finished boolValue] animated:NO];
    }
    self.finishImage.tag = 104;
    [self.finishImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.finishImage.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.finishImage];
    
    self.returnImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*5-HEIGHT(nicai)/2, 0, 0)];
    self.returnImage.backgroundColor = [UIColor clearColor];
    if ([self.returned isEqualToString:release]) {
        [self.returnImage setOn:[self.returned boolValue] animated:NO];
    }else{
        [self.returnImage setOn:[self.returned boolValue] animated:NO];
    }
    self.returnImage.tag = 105;
    [self.returnImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.returnImage.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.returnImage];
    
    self.rejectImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*7-HEIGHT(nicai)/2, 0, 0)];
    self.rejectImage.backgroundColor = [UIColor clearColor];
    if ([self.rejected isEqualToString:release]) {
        [self.rejectImage setOn:[self.rejected boolValue] animated:NO];
    }else{
        [self.rejectImage setOn:[self.rejected boolValue] animated:NO];
    }
    self.rejectImage.tag = 106;
    [self.rejectImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.rejectImage.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.rejectImage];
    
    self.payImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*9-HEIGHT(nicai)/2, 0, 0)];
    self.payImage.backgroundColor = [UIColor clearColor];
    if ([self.pay isEqualToString:release]) {
        [self.payImage setOn:[self.pay boolValue] animated:NO];
    }else{
        [self.payImage setOn:[self.pay boolValue] animated:NO];
    }
    self.payImage.tag = 107;
    [self.payImage addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.payImage.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.payImage];
    
    
    self.sw_RedirectMe = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*11-HEIGHT(nicai)/2, 0, 0)];
    self.sw_RedirectMe.backgroundColor = [UIColor clearColor];
    if ([self.redirected isEqualToString:release]) {
        [self.sw_RedirectMe setOn:[self.redirected boolValue] animated:NO];
    }else{
        [self.sw_RedirectMe setOn:[self.redirected boolValue] animated:NO];
    }
    self.sw_RedirectMe.tag = 108;
    [self.sw_RedirectMe addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.sw_RedirectMe.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.sw_RedirectMe];
    
    
    self.sw_CCMe = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-15-WIDTH(nicai), self.mainHeight/14*13-HEIGHT(nicai)/2, 0, 0)];
    self.sw_CCMe.backgroundColor = [UIColor clearColor];
    if ([self.cced isEqualToString:release]) {
        [self.sw_CCMe setOn:[self.cced boolValue] animated:NO];
    }else{
        [self.sw_CCMe setOn:[self.cced boolValue] animated:NO];
    }
    self.sw_CCMe.tag = 109;
    [self.sw_CCMe addTarget:self action:@selector(chooseSettingBtn:) forControlEvents:UIControlEventValueChanged];
    self.sw_CCMe.onTintColor=Color_Blue_Important_20;
    [self.mainView addSubview:self.sw_CCMe];
    
}


-(void)chooseSettingBtn:(UISwitch *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前网络不可用，请检查您的网络设置" delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
        return;
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    switch (btn.tag) {
        case 101:
            if ([self.app isEqualToString:release]) {
                self.app = @"1";
                [self requestSaveMessage];
                [self.appImage setOn:[self.app boolValue] animated:YES];
            }
            else
            {
                self.app = @"0";
                [self requestSaveMessage];
                [self.appImage setOn:[self.app boolValue] animated:YES];
            }
            break;
        case 102:
            if ([self.maill isEqualToString:release]) {
                self.maill = @"1";
                [self requestSaveMessage];
                [self.emailImage setOn:[self.maill boolValue] animated:YES];
            }
            else
            {
                self.maill = @"0";
                [self requestSaveMessage];
                [self.emailImage setOn:[self.maill boolValue] animated:YES];
            }
            break;
        case 103:
            if ([self.newtaskStr isEqualToString:release]) {
                self.newtaskStr = @"1";
                [self requestSaveMessage];
                [self.newtaskImage setOn:[self.newtaskStr boolValue] animated:YES];
            }
            else
            {
                self.newtaskStr = @"0";
                [self requestSaveMessage];
                [self.newtaskImage setOn:[self.newtaskStr boolValue] animated:YES];
            }
            break;
        case 104:
            if ([self.finished isEqualToString:release]) {
                self.finished = @"1";
                [self requestSaveMessage];
                [self.finishImage setOn:[self.finished boolValue] animated:YES];
            }
            else
            {
                self.finished = @"0";
                [self requestSaveMessage];
                [self.finishImage setOn:[self.finished boolValue] animated:YES];
            }
            
            break;
        case 105:
            if ([self.returned isEqualToString:release]) {
                self.returned = @"1";
                [self requestSaveMessage];
                [self.returnImage setOn:[self.returned boolValue] animated:YES];
            }
            else
            {
                self.returned = @"0";
                [self requestSaveMessage];
                [self.returnImage setOn:[self.returned boolValue] animated:YES];
            }
            
            break;
        case 106:
            if ([self.rejected isEqualToString:release]) {
                self.rejected = @"1";
                [self requestSaveMessage];
                [self.rejectImage setOn:[self.rejected boolValue] animated:YES];
            }
            else
            {
                self.rejected = @"0";
                [self requestSaveMessage];
                [self.rejectImage setOn:[self.rejected boolValue] animated:YES];
            }
            
            break;
        case 107:
            if ([self.pay isEqualToString:release]) {
                self.pay = @"1";
                [self requestSaveMessage];
                [self.payImage setOn:[self.pay boolValue] animated:YES];
            }
            else
            {
                self.pay = @"0";
                [self requestSaveMessage];
                [self.payImage setOn:[self.pay boolValue] animated:YES];
            }
            
            break;
        case 108:
            if ([self.redirected isEqualToString:release]) {
                self.redirected = @"1";
                [self requestSaveMessage];
                [self.sw_RedirectMe setOn:[self.redirected boolValue] animated:YES];
            }else{
                self.redirected = @"0";
                [self requestSaveMessage];
                [self.sw_RedirectMe setOn:[self.redirected boolValue] animated:YES];
            }

            break;
        case 109:
            if ([self.cced isEqualToString:release]) {
                self.cced = @"1";
                [self requestSaveMessage];
                [self.sw_CCMe setOn:[self.cced boolValue] animated:YES];
            }else{
                self.cced = @"0";
                [self requestSaveMessage];
                [self.sw_CCMe setOn:[self.cced boolValue] animated:YES];
            }
            
            break;
            
        default:
            break;
    }
   
}


////////////////////////

-(void)requestMsgsubscribe{
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",getMSG] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}


-(void)requestSaveMessage{
    
     NSDictionary *parameters = @{@"app":[NSString stringWithFormat:@"%@",self.app],
//                                  @"companyId":[NSString stringWithFormat:@"%@",self.companyId],
                                  @"finished":[NSString stringWithFormat:@"%@",self.finished],
                                  @"id":[NSString stringWithFormat:@"%@",self.idd],
                                  @"mail":[NSString stringWithFormat:@"%@",self.maill],
                                  @"newTask":[NSString stringWithFormat:@"%@",self.newtaskStr],
//                                  @"operationObjectId":[NSString stringWithFormat:@"%@",self.operationObjectId],
//                                  @"operationType":[NSString stringWithFormat:@"%@",self.operationType],
                                  @"pay":[NSString stringWithFormat:@"%@",self.pay],
                                  @"discard":[NSString stringWithFormat:@"%@",self.rejected],
                                  @"returned":[NSString stringWithFormat:@"%@",self.returned],
                                  @"delegate":[NSString stringWithFormat:@"%@",self.redirected],
                                  @"cc":[NSString stringWithFormat:@"%@",self.cced]
                                  };
    
      [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",saveMSG] Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
//    NSLog(@"resDic:%@",responceDic);
//    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
//    if (serialNum !=0) {
//        if ([success isEqualToString:@"0"]) {
//            
//            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
//            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
//            return;
//        }
//    }
    
    [YXSpritesLoadingView dismiss];
    if (serialNum ==0) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
            self.app = [NSString stringWithFormat:@"%@",[result objectForKey:@"app"]];
            self.companyId = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyId"]];
            self.finished = [NSString stringWithFormat:@"%@",[result objectForKey:@"finished"]];
            self.idd = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
            self.maill = [NSString stringWithFormat:@"%@",[result objectForKey:@"mail"]];
            self.newtaskStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"newTask"]];
            
            self.operationObjectId = [NSString stringWithFormat:@"%@",[result objectForKey:@"operationObjectId"]];
            self.operationType = [NSString stringWithFormat:@"%@",[result objectForKey:@"operationType"]];
            
            self.pay = [NSString stringWithFormat:@"%@",[result objectForKey:@"pay"]];
            self.rejected = [NSString stringWithFormat:@"%@",[result objectForKey:@"discard"]];
            self.returned = [NSString stringWithFormat:@"%@",[result objectForKey:@"returned"]];
            self.redirected = [NSString stringWithFormat:@"%@",[result objectForKey:@"delegate"]];
            self.cced = [NSString stringWithFormat:@"%@",[result objectForKey:@"cc"]];
        }
    }
    
    switch (serialNum) {
        case 0://
            [self createheaderView];
            [self createMainView];
            break;
        case 1://
//            [self viewDidLoad];
            //[self popSettingViewControl];
            break;
        
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}


-(void)popSettingViewControl{
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
