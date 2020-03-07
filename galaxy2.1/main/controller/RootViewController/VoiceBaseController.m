//
//  VoiceBaseController.m
//  galaxy
//
//  Created by hfk on 16/4/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "dockView.h"

#import "VoiceBaseController.h"
#import "UIImage+ReatMark.h"
#import "StepWarningView.h"
#import "StepWarningViewController.h"
#import "RootTabViewController.h"
#import "PDFLookViewController.h"
#import "KxMenu.h"
@interface VoiceBaseController ()<DockViewDelegate>
@property (nonatomic,strong)dockView * printView;

@end

@implementation VoiceBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    returnHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[BottomView class]];
    [[IQKeyboardManager sharedManager]considerToolbarPreviousNextInViewClass:[BottomView class]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
    [_iflyRecognizerView cancel]; //取消识别
    [_iflyRecognizerView setDelegate:nil];
    [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
     
    
}
-(void)startVoice{
    _remarkVoiceBtn.userInteractionEnabled=NO;
    
    if(_iflyRecognizerView == nil)
    {
        [self initRecognizer];
    }
    [_remarksTextView resignFirstResponder];
    
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iflyRecognizerView start];
    
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    //有界面
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 140, 10)];
        view.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+122);
        view.backgroundColor=[GPUtils colorHString:@"#35383a"];
        [_iflyRecognizerView addSubview:view];
    }
    
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"errorCode:%d",[error errorCode]);
    _remarkVoiceBtn.userInteractionEnabled=YES;
}
/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _remarkTipField.hidden = YES;
    _remarksTextView.text = [NSString stringWithFormat:@"%@%@",_remarksTextView.text,result];
    
}
/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void)createPrintNoticeWithMessage:(NSString *)message{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"这是一个链接" message:@"www.baidu.com" canDismis:NO];
    [alert addButton:Button_OTHER withTitle:@"微信" handler:^(JKAlertDialogItem *item) {
        NSLog(@"click %@",item.title);
    }];;
    [alert addButton:Button_OTHER withTitle:@"QQ" handler:^(JKAlertDialogItem *item) {
        NSLog(@"click %@",item.title);
    }];;
    [alert addButton:Button_OTHER withTitle:@"复制链接" handler:^(JKAlertDialogItem *item) {
        NSLog(@"click %@",item.title);
    }];
    [alert show];
}
//MARK:创建打印图标
-(void)createMoreBtnWithArray:(NSArray *)array WithDict:(NSDictionary *)dict{
    if (array.count>0) {
        self.arr_MoreBtn=array;
        if (dict) {
            self.dict_MoreBtnDict=dict;
        }
        self.PrintfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIBarButtonItem *addBar = [UIBarButtonItem RootCustomNavButtonWithWithButton:self.PrintfBtn title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMore":@"NavBarImg_More" target:self action:@selector(GoToMore:)];
        self.navigationItem.rightBarButtonItem = addBar;
    }
}
-(void)GoToMore:(id)obj{
    
    if ([KxMenu isShowingInView:self.view]) {
        [KxMenu dismissMenu:YES];
    }else{
        [KxMenu setTitleFont:Font_Important_15_20];
        [KxMenu setTintColor:Color_form_TextFieldBackgroundColor];
        [KxMenu setOverlayColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [KxMenu setLineColor:Color_GrayLight_Same_20];

        NSMutableArray *menuItems=[NSMutableArray array];
        if ([self.arr_MoreBtn containsObject:@1]){
            
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"抄送", nil) image:[UIImage imageNamed:@"Apply_CopyTo"] target:self action:@selector(GoToCopy)]];
        }
        if ([self.arr_MoreBtn containsObject:@2]) {
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"转交", nil) image:[UIImage imageNamed:@"Apply_DeliverTo"] target:self action:@selector(GoToDeliver)]];
        }
        if ([self.arr_MoreBtn containsObject:@3]){
        
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"打印", nil) image:[UIImage imageNamed:@"Apply_Push"] target:self action:@selector(GoToPush)]];
        }
        [menuItems setValue:Color_Blue_Important_20 forKey:@"foreColor"];
        CGRect senderFrame = CGRectMake(Main_Screen_Width - (kDevice_Is_iPhone6Plus? 30: 26), NavigationbarHeight, 0, 0);
        [KxMenu showMenuInView:ApplicationDelegate.window
                      fromRect:senderFrame
                     menuItems:menuItems];
    }
}
-(void)GoToCopy{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.Type=@"4";
    vc.ProcId=self.dict_MoreBtnDict[@"ProcId"];
    vc.TaskId=self.dict_MoreBtnDict[@"TaskId"];
    vc.FlowCode=self.dict_MoreBtnDict[@"FlowCode"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)GoToDeliver{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.Type=@"3";
    vc.ProcId=self.dict_MoreBtnDict[@"ProcId"];
    vc.TaskId=self.dict_MoreBtnDict[@"TaskId"];
    vc.FlowCode=self.dict_MoreBtnDict[@"FlowCode"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GoToPush{
    
}
//MARK:审批流程
-(void)updateAprovalProcess:(NSString *)flowCode WithProcId:(NSString *)procid{
    [StepWarningView initWithViews:1 view:[[StepWarningView alloc]init] controller:self Click:^(NSInteger buttonIndex) {
        NSLog(@"111");
        RootTabViewController *root = (RootTabViewController *)[RootViewController getCurrentVC];
        NavigationViewController *nav = (NavigationViewController *)root.selectedViewController;
        StepWarningViewController *step = [[StepWarningViewController alloc]init];
        step.FlowGuid = flowCode;
        step.procid = procid;
        [nav pushViewController:step animated:YES];
    }];
}

//MARK:打印
-(void)gotoPrintfForm:(SendEmailModel *)model{
    if (!self.printView) {
        self.printView = [[dockView alloc]initWithDockFrame:CGRectMake(0,Main_Screen_Height, 0, 0) sendModel:model];
        self.printView.delegate = self;
    }
    [self.printView showDock];
}

//////////////打印事件、、、、、、、、、、、、、、、、、、、、、、///////////////////////////

//键盘取消
- (void)dimsissDockPDActionView{
    self.printView = nil;
}
//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (_printView) {
        [_printView removeDock];
    }
}

-(void)actionDockViewClick:(id)obj type:(NSInteger)type{
    if (type==1) {
        SendEmailViewController *vc=[[SendEmailViewController alloc]init];
        vc.model_Send=(SendEmailModel *)obj;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type==2){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"复制成功", nil) duration:1.5];
    }
}

-(void)LookViewLinkToFormWithTaskId:(NSString *)taskId WithFlowCode:(NSString *)flowCode{
    if ([NSString isEqualToNullAndZero:taskId]) {
        NSDictionary *dict=[[VoiceDataManger sharedManager]getControllerNameWithFlowCode:flowCode];
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
            NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":@"",@"userId":self.userdatas.userId,@"rowData":@{@"taskId":[NSString stringWithFormat:@"%@",taskId],@"procId":@"",@"flowGuid":@"",@"flowCode":flowCode,@"pageType":@1,@"canUrge":@0}};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],dict[@"pushHasController"],[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *controller=dict[@"pushHasController"];
            Class cls = NSClassFromString(controller);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId=[NSString stringWithFormat:@"%@",taskId];
            vc.pushComeStatus=@"5";
            vc.pushFlowCode = flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)goToFlowChartWithUrl:(NSString *)url{
    boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@/%@",[UrlKeyManager getHelpURL:XB_FlowChart],url,self.userdatas.language]];
    bo.str_title = Custing(@"流程图", nil);
    [self.navigationController pushViewController:bo animated:YES];
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
