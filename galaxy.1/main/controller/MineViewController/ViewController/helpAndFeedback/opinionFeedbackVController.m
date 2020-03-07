//
//  opinionFeedbackVController.m
//  galaxy
//
//  Created by 赵碚 on 15/8/14.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "opinionFeedbackVController.h"

@interface opinionFeedbackVController ()<UITextViewDelegate,UIGestureRecognizerDelegate,GPClientDelegate>
@property (nonatomic,strong)UITextView * opinionTV;
@property (nonatomic,strong)UITextField * placeHolder;
@property (nonatomic,assign)NSInteger height;
@end

@implementation opinionFeedbackVController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.opinionTV becomeFirstResponder];
}

-(void)dealloc{
    self.opinionTV = nil;
    self.placeHolder = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:self.opinionTV];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"提交", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(save:)];

    
    [self setTitle:Custing(@"意见反馈",nil) backButton:YES ];
    [self createCredentialsView];
    
    // Do any additional setup after loading the view.
}


-(void)createCredentialsView{
    
    UIView * contenteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 115)];
    contenteView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:contenteView];
    
    
    UIImageView * aboutIm = [[UIImageView alloc]initWithImage:GPImage(@"my_feedback")];
    aboutIm.frame = CGRectMake(15, 13, 19, 19);
    aboutIm.backgroundColor = [UIColor clearColor];
    [contenteView addSubview:aboutIm];
    
    self.opinionTV = [[UITextView alloc]initWithFrame:CGRectMake(45, 10, ScreenRect.size.width-60, 95)];
    self.opinionTV.font = Font_cellContent_16;
    self.opinionTV.text = @"";
   
    self.opinionTV.clearsContextBeforeDrawing = YES;
    self.opinionTV.keyboardType = UIKeyboardTypeDefault;
    [self.opinionTV setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.opinionTV.scrollEnabled
    = YES;//是否可以拖动
    //self.opinionTV.autocapitalizationType = NO;
     self.opinionTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.opinionTV.delegate = self;
    self.opinionTV.backgroundColor = [UIColor clearColor];
    [contenteView addSubview:self.opinionTV];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(opinionTextFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:self.opinionTV];
    
    self.placeHolder = [GPUtils createTextField:CGRectMake(5, 0, WIDTH(self.opinionTV), 28) placeholder:@"请输入反馈意见" delegate:self font:Font_cellContent_16 textColor:[UIColor grayColor]];
    self.placeHolder.enabled = NO;
    [self.opinionTV addSubview:self.placeHolder];
    
}

-(void)opinionTextFiledEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 255) {
                textField.text = [toBeString substringToIndex:255];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"意见反馈信息输入过多请删减再输入"];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 255) {
            textField.text = [toBeString substringToIndex:255];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"意见反馈信息输入过多请删减再输入"];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //不允许输入空格
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeHolder.hidden = NO;
    }else{
        self.placeHolder.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.opinionTV.text = textView.text;
    if (textView.tag != 0&&![textView.text isEqualToString:@"请输入反馈意见"]) {
        textView.textColor = [XBColorSupport supportScreenListColor];
        textView.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.opinionTV resignFirstResponder];
}
-(void)save:(UIButton *)btn{
    [self.opinionTV resignFirstResponder];
    if ((self.opinionTV.text.length ==0)||[self.opinionTV.text isEqualToString:@"请输入反馈意见"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"请输入反馈意见" duration:1.0f];
    }else{
        [self requestRetrievePasswordList];
    }
    
}


- (void)back:(UIButton *)btn
{
    [self.opinionTV resignFirstResponder];
    [self Navback];
}
-(void)requestRetrievePasswordList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * parametersDic = @{@"Description":[NSString stringWithFormat:@"%@",self.opinionTV.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",feedback] Parameters:parametersDic Delegate:self SerialNum:0 IfUserCache:NO];
    
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
//    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
//    if ([success isEqualToString:@"0"]) {
//        
//        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.5];
//        return;
//    }
    if ([success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"您的意见我们已经收到" duration:2.0];
        
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self popSettingViewControl];
        });
    }
    
    
    
    switch (serialNum) {
        case 0://
           
            
            break;
        default:
            break;
    }
    
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}

-(void)popSettingViewControl {
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
