//
//  addPositionViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "addPositionViewController.h"

@interface addPositionViewController ()<UITextFieldDelegate,GPClientDelegate>
@property (nonatomic,strong)UITextField * costTF;
@property (nonatomic,strong)UITextField * levelTF;
@property (nonatomic,strong)UITextField * levelNoTF;


@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSString * amount;
@property (nonatomic,strong)NSString * status;

@property (nonatomic,strong)NSDictionary * dic;
@end

@implementation addPositionViewController
-(id)initWithType:(NSDictionary *)type Name:(NSString *)str{
    self = [super init];
    if (self) {
        self.status = str;
        if (![type isKindOfClass:[NSNull class]] && type != nil && type.count != 0){
            self.dic = type;
        }
    }
    
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.costTF becomeFirstResponder];
    [self.levelTF becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if ([self.status isEqualToString:@"addPosition"]) {
        [self setTitle:Custing(@"新增职位", nil) backButton:YES ];
        [self createAddPositionTextField];
    }else if ([self.status isEqualToString:@"editPosition"]){
        [self setTitle:Custing(@"修改职位", nil) backButton:YES ];
        [self createAddPositionTextField];
    }else if ([self.status isEqualToString:@"addLeavel"]){
        [self setTitle:Custing(@"新增级别", nil) backButton:YES ];
        [self createAddLevelTextField];
    }else{
        [self setTitle:Custing(@"修改级别", nil) backButton:YES ];
        [self createAddLevelTextField];
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(amountSave:)];

    // Do any additional setup after loading the view.
}


//级别
-(void)createAddLevelTextField{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 48)];
    backView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:backView];
    
    UILabel * ShortLa = [GPUtils createLable:CGRectMake(15, 0, 35, 48) text:Custing(@"级别", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    ShortLa.backgroundColor = [UIColor clearColor];
    [backView addSubview:ShortLa];
    
    self.levelTF = [GPUtils createTextField:CGRectMake(53, 0, Main_Screen_Width-65, 48) placeholder:Custing(@"请输入级别", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.levelTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.levelTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.levelTF.adjustsFontSizeToFitWidth = YES;
    self.levelTF.delegate=self;
    self.levelTF.tag = 0;
    self.levelTF.keyboardType = UIKeyboardTypeEmailAddress;
//    [self.levelTF becomeFirstResponder];
    self.idd = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"userLevel"]];
    if (self.idd !=nil&&![self.idd isEqualToString:@"<null>"]&&![self.idd isEqualToString:@"(null)"]) {
        self.levelTF.text = self.idd;
    }
    [backView addSubview:self.levelTF];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addLevelFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.levelTF];
    
    UIView * backMView = [[UIView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 48)];
    backMView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:backMView];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    
    UILabel * CodeLa = [GPUtils createLable:CGRectMake(15, 0, ((lan)?35:80), 48) text:Custing(@"描述", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    CodeLa.backgroundColor = [UIColor clearColor];
    [backMView addSubview:CodeLa];
    
    self.costTF = [GPUtils createTextField:CGRectMake(((lan)?53:100), 0, Main_Screen_Width-65, 48) placeholder:Custing(@"请输入描述", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.costTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.costTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.costTF.adjustsFontSizeToFitWidth = YES;
    self.costTF.delegate=self;
    self.costTF.tag = 1;
    self.costTF.keyboardType = UIKeyboardTypeDefault;
    self.amount = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"description"]];
    if (self.amount !=nil&&![self.amount isEqualToString:@"<null>"]&&![self.amount isEqualToString:@"(null)"]) {
        self.costTF.text = self.amount;
    }
    [backMView addSubview:self.costTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPositionFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.costTF];
    
    
    
    UIView * backNoView = [[UIView alloc]initWithFrame:CGRectMake(0, 126, Main_Screen_Width, 48)];
    backNoView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:backNoView];
    
    
    UILabel * NoLal = [GPUtils createLable:CGRectMake(15, 0, ((lan)?35:80), 48) text:Custing(@"等级", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NoLal.backgroundColor = [UIColor clearColor];
    [backNoView addSubview:NoLal];
    
    self.levelNoTF = [GPUtils createTextField:CGRectMake(((lan)?53:100), 0, Main_Screen_Width-65, 48) placeholder:Custing(@"请输入等级", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.levelNoTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.levelNoTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.levelNoTF.adjustsFontSizeToFitWidth = YES;
    self.levelNoTF.delegate=self;
    self.levelNoTF.tag = 1;
    self.levelNoTF.keyboardType = UIKeyboardTypeNumberPad;
    if ([NSString isEqualToNull:self.dic[@"userLevelNo"]]) {
        self.levelNoTF.text = [NSString stringWithFormat:@"%@",self.dic[@"userLevelNo"]];
    }
    [backNoView addSubview:self.levelNoTF];

}


//职位
-(void)createAddPositionTextField{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 48)];
    backView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:backView];
    
    UILabel * ShortLa = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 48) text:Custing(@"职位", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    ShortLa.backgroundColor = [UIColor clearColor];
    [backView addSubview:ShortLa];
    
    self.levelTF = [GPUtils createTextField:CGRectMake(12+XBHelper_Title_Width+15, 0, Main_Screen_Width-24-15-XBHelper_Title_Width, 48) placeholder:Custing(@"请输入职位", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.levelTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.levelTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.levelTF.adjustsFontSizeToFitWidth = YES;
    self.levelTF.delegate=self;
    self.levelTF.keyboardType = UIKeyboardTypeDefault;
    //    [self.levelTF becomeFirstResponder];
    if ([NSString isEqualToNull:self.dic[@"jobTitle"]]) {
        self.levelTF.text = [NSString stringWithFormat:@"%@",self.dic[@"jobTitle"]];

    }
    [backView addSubview:self.levelTF];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPositionFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.levelTF];
    
    
    UIView * backMView = [[UIView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 48)];
    backMView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:backMView];
    
    
    UILabel * CodeLa = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 48) text:Custing(@"审批职位", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    CodeLa.backgroundColor = [UIColor clearColor];
    CodeLa.numberOfLines=2;
    [backMView addSubview:CodeLa];
    
    self.costTF = [GPUtils createTextField:CGRectMake(12+XBHelper_Title_Width+15, 0, Main_Screen_Width-24-15-XBHelper_Title_Width, 48) placeholder:Custing(@"请输入审批职位", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.costTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.costTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.costTF.adjustsFontSizeToFitWidth = YES;
    self.costTF.delegate=self;
    self.costTF.tag = 1;
    self.costTF.keyboardType = UIKeyboardTypeDefault;
    if ([NSString isEqualToNull:self.dic[@"jobTitleCode"]]) {
        self.costTF.text=[NSString stringWithFormat:@"%@",self.dic[@"jobTitleCode"]];
    }
    [backMView addSubview:self.costTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPositionFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.costTF];
}

-(void)addPositionFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    //    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                if ([self.status isEqualToString:@"addPosition"]||[self.status isEqualToString:@"editPosition"]) {
                    if (textField==self.levelTF) {
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"职位名称不超过20位", nil)];
                    }else if (textField==self.costTF){
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"审批职位不超过20位", nil)];
                    }
                }else{
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"描述不超过20位", nil)];
                }
                
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            if ([self.status isEqualToString:@"addPosition"]||[self.status isEqualToString:@"editPosition"]) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"职位名称不超过20位", nil)];
            }else{
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"描述不超过20位", nil)];
            }
        }
    }
    
}

-(void)addLevelFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    //    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"级别名称不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"级别名称不超过20位", nil)];
        }
    }
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.costTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.levelTF];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    return YES;
}


-(void)amountSave:(UIButton *)btn{
    [self.costTF resignFirstResponder];
    [self.levelTF resignFirstResponder];
    
    if ([self.status isEqualToString:@"addPosition"]||[self.status isEqualToString:@"editPosition"]) {
        
        if (self.levelTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入职位名称", nil)];
            return;
        }
        if (self.levelTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"职位名称不超过20位", nil)];
            return;
        }
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入审批职位", nil)];
            return;
        }

        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"审批职位不超过20位", nil)];
            return;
        }
    }else{
        if (self.levelTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入级别", nil)];
            return;
        }
        if (self.levelTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"级别名称不超过20位", nil)];
            return;
        }
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入描述", nil)];
            return;
        }
        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"描述不超过20位", nil)];
            return;
        }
    }
    
    [self requestReimbursementAmountData];
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.costTF resignFirstResponder];
    [self.levelTF resignFirstResponder];
}



-(void)requestReimbursementAmountData {
    if ([self.status isEqualToString:@"addPosition"]) {//添加职位
        NSDictionary * dic =@{@"jobTitle":[NSString stringWithFormat:@"%@",self.levelTF.text],@"jobTitleCode":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",insertjobtitle] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"editPosition"]){//修改职位
        NSDictionary * dic =@{@"id":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"id"]],@"jobTitle":self.levelTF.text,@"creater":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"creater"]],@"jobTitleCode":self.costTF.text,@"jobTitleEn":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"jobTitleEn"]]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updatejobtitle] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"addLeavel"]){//添加等级
        NSDictionary * dic =@{@"userLevel":self.levelTF.text,@"description":self.costTF.text,@"userLevelNo":self.levelNoTF.text};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",insertuserlevel] Parameters:dic Delegate:self SerialNum:2 IfUserCache:NO];
    }else{
        NSDictionary * dic =@{@"active":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"active"]],@"companyId":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"companyId"]],@"createTime":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"createTime"]],@"creater":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"creater"]],@"description":self.costTF.text,@"id":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"id"]],@"total":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"total"]],@"updateTime":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"updateTime"]],@"updater":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"updater"]],@"userLevel":self.levelTF.text,@"userLevelEn":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"userLevelEn"]],@"userLevelNo":self.levelNoTF.text,};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updateuserlevel] Parameters:dic Delegate:self SerialNum:3 IfUserCache:NO];
    }
    
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
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self backBorrowRecord];
    });
    switch (serialNum) {
        case 0:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"员工职位添加成功", nil) duration:2.0];
            break;
        case 1:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"员工职位修改成功", nil) duration:2.0];
            break;
        case 2:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"员工级别添加成功", nil) duration:2.0];
            break;
        case 3:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"员工级别修改成功", nil) duration:2.0];
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)backBorrowRecord{
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
