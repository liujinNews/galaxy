//
//  ticketSpecificationViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ticketSpecificationViewController.h"

@interface ticketSpecificationViewController ()<UITextViewDelegate,GPClientDelegate>
@property (nonatomic,strong)UITextView * ticketTV;
@property (nonatomic,strong)NSString * descriptio;
@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSString * status;
@property(nonatomic, strong)NSDictionary *electDic;//缓存数据

@property (nonatomic,strong)UITextField * placeHolder;
@property (nonatomic,strong)UIButton * editBtn;

@end

@implementation ticketSpecificationViewController

-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
                self.electDic = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

-(void)dealloc{
    self.ticketTV = nil;
    self.placeHolder = nil;
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextViewTextDidChangeNotification"  object:self.ticketTV];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"报销规范", nil) backButton:YES];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];

    [self requestSend];
    
    // Do any additional setup after loading the view.
}

-(void)createTicketSpecification {
    self.ticketTV = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, Main_Screen_Width-30, Main_Screen_Height-NavigationbarHeight-15)];
    self.ticketTV.font = Font_cellContent_16;
    self.ticketTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.descriptio stringByReplacingOccurrencesOfString:@"\\\\r" withString:@"/"];
    self.ticketTV.text = [NSString isEqualToNull:self.descriptio] ?self.descriptio :@"";
    self.ticketTV.textColor = Color_form_TextField_20;
    [self.ticketTV becomeFirstResponder];
    self.ticketTV.editable = NO;
    self.ticketTV.scrollEnabled=YES;
    self.ticketTV.delegate = self;
    self.ticketTV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.ticketTV];
    if ([[self.electDic objectForKey:@"ticket"] isEqualToString:@"manager"]) {
        
        self.editBtn = [[UIButton alloc]init];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:self.editBtn title:Custing(@"编辑", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(saveModifyTicket:)];

        self.ticketTV.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.ticketTV.layer.cornerRadius = 5.0;
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ticketTextFiledEditChanged:) name:@"UITextViewTextDidChangeNotification"  object:self.ticketTV];
        if (![NSString isEqualToNull:self.descriptio]) {
            self.placeHolder = [GPUtils createTextField:CGRectMake(5, 0, WIDTH(self.ticketTV), 28) placeholder:Custing(@"还没有规范，请先编辑", nil) delegate:self font:Font_cellContent_16 textColor:[UIColor grayColor]];
            self.placeHolder.enabled = NO;
            [self.ticketTV addSubview:self.placeHolder];
        }
    }
    
}

//-(void)ticketTextFiledEditChanged:(NSNotification *)obj{
//    UITextView *textField = (UITextView *)obj.object;
//    
//    NSString *toBeString = textField.text;
//    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > 255) {
//                textField.text = [toBeString substringToIndex:255];
//                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"贴票规范输入过多请删减再输入"];
//            }
//            
//        }
//    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        
//        if (toBeString.length > 255) {
//            textField.text = [toBeString substringToIndex:255];
//            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"贴票规范输入过多请删减再输入"];
//        }
//    }
//    
//}

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
    
    self.ticketTV.text = textView.text;
    if (textView.tag != 0&&![textView.text isEqualToString:Custing(@"还没有规范，请先编辑", nil)]) {
        textView.textColor = [XBColorSupport supportScreenListColor];
        textView.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.ticketTV resignFirstResponder];
}


- (void)back:(UIButton *)btn
{
    [self.ticketTV resignFirstResponder];
    [self Navback];
}

-(void)saveModifyTicket:(UIButton *)btn {
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        [self.editBtn setTitle:Custing(@"保存", nil) forState:UIControlStateNormal];
        self.ticketTV.editable = YES;
    }else {
        [self.editBtn setTitle:Custing(@"编辑", nil) forState:UIControlStateNormal];
        self.ticketTV.editable = NO;
        [self.ticketTV resignFirstResponder];
        if ((self.ticketTV.text.length ==0)||[self.ticketTV.text isEqualToString:Custing(@"还没有规范，请先编辑", nil)]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"贴票规范不能为空" duration:1.0f];
        }else{
            [self requestModifyTicket];
        }
    }
    
}

//
-(void)requestSend{
    
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"InvoiceSpecs/GetSpecs"] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestModifyTicket {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"InvoiceSpecs/SaveSpecs"] Parameters:@{@"Description":[NSString stringWithFormat:@"%@",self.ticketTV.text]} Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    //description//id
    if (serialNum ==0) {
        self.descriptio = [NSString stringWithFormat:@"%@",[[responceDic objectForKey:@"result"] objectForKey:@"description"]];
    }
    
    if (serialNum ==1) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
    }

    switch (serialNum) {
        case 0://
        {
            [self createTicketSpecification];
        }
            break;
        case 1://
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:2.0];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    
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
