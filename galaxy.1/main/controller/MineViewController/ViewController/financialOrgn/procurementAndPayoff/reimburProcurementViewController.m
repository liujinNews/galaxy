//
//  reimburProcurementViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "reimburProcurementViewController.h"

@interface reimburProcurementViewController ()<UITextFieldDelegate,GPClientDelegate>
@property (nonatomic,strong)UITextField * costTF;
@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSString * amount;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSString * requestor;
@end

@implementation reimburProcurementViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(id)initWithType:(NSDictionary *)type Name:(NSString *)str{
    self = [super init];
    if (self) {
        self.status = str;
        if (![type isKindOfClass:[NSNull class]] && type != nil && type.count != 0){
            self.idd = [NSString stringWithFormat:@"%@",[type objectForKey:@"idd"]];
            self.amount = [NSString stringWithFormat:@"%@",[type objectForKey:@"type"]];
            
        }
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];//procurement
    if ([self.status isEqualToString:@"procurement"]) {
        [self setTitle:Custing(@"修改采购类型", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"addProcurement"]){
        [self setTitle:Custing(@"新增采购类型", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"addPayoffWay"]){
        [self setTitle:Custing(@"新增支付方式", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"payoffWay"]){
        [self setTitle:Custing(@"修改支付方式", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"addTravelType"]){
        [self setTitle:Custing(@"新增出差类型", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"travelType"]){
        [self setTitle:Custing(@"修改出差类型", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"AddProjectType"]){
        [self setTitle:Custing(@"新建项目类型", nil) backButton:YES ];
    }else if ([self.status isEqualToString:@"EditProjectType"]){
        [self setTitle:Custing(@"修改项目类型", nil) backButton:YES ];
    }
    [self createCostCenterTextField];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(amountSave:)];

    
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.costTF becomeFirstResponder];
}

-(void)createCostCenterTextField{
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 49)];
    phoneView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:phoneView];
    
    self.costTF = [GPUtils createTextField:CGRectMake(15, 0, Main_Screen_Width-30, 49) placeholder:Custing(@"请输入名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.costTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.costTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.costTF.adjustsFontSizeToFitWidth = YES;
    self.costTF.delegate=self;
    self.costTF.keyboardType = UIKeyboardTypeDefault;
//    [self.costTF becomeFirstResponder];
    if ([NSString isEqualToNull:self.idd]) {
        self.costTF.text = self.amount;
    }
    [phoneView addSubview:self.costTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CostCenterRFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.costTF];
    
}
-(void)CostCenterRFiledEditChanged:(NSNotification *)obj{
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
                if ([self.status isEqualToString:@"procurement"]||[self.status isEqualToString:@"addProcurement"]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"采购类型名称不超过20位", nil)];
                }else if ([self.status isEqualToString:@"addPayoffWay"]||[self.status isEqualToString:@"payoffWay"]){
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"支付方式名称不超过20位", nil)];
                }else if ([self.status isEqualToString:@"addTravelType"]||[self.status isEqualToString:@"travelType"]){
                     [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"出差类型名称不超过20位", nil)];
                }else if ([self.status isEqualToString:@"AddProjectType"]|[self.status isEqualToString:@"EditProjectType"]){
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"项目类型不超过20位", nil)];
                }
                
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            if ([self.status isEqualToString:@"procurement"]||[self.status isEqualToString:@"addProcurement"]) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"采购类型名称不超过20位", nil)];
            }else if ([self.status isEqualToString:@"addPayoffWay"]||[self.status isEqualToString:@"payoffWay"]){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"支付方式名称不超过20位", nil)];
            }else if ([self.status isEqualToString:@"addTravelType"]||[self.status isEqualToString:@"travelType"]){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"出差类型名称不超过20位", nil)];
            }else if ([self.status isEqualToString:@"AddProjectType"]|[self.status isEqualToString:@"EditProjectType"]){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"项目类型不超过20位", nil)];
            }
        }
    }
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.costTF];
    
}



-(void)amountSave:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.costTF resignFirstResponder];
    if ([self.status isEqualToString:@"procurement"]||[self.status isEqualToString:@"addProcurement"]) {
        
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入采购类型名称", nil)];
            return;
        }
        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"采购类型名称不超过20位", nil)];
            return;
        }
        
        
    }else if ([self.status isEqualToString:@"addPayoffWay"]||[self.status isEqualToString:@"payoffWay"]){
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入支付方式名称", nil)];
            return;
        }
        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"支付方式名称不超过20位", nil)];
            return;
        }
        
    }else if ([self.status isEqualToString:@"addTravelType"]||[self.status isEqualToString:@"travelType"]){
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入出差类型名称", nil)];
            return;
        }
        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"出差类型名称不超过20位", nil)];
            return;
        }
        
    }else if ([self.status isEqualToString:@"AddProjectType"]||[self.status isEqualToString:@"EditProjectType"]){
        if (self.costTF.text.length <=0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入项目类型", nil)];
            return;
        }
        if (self.costTF.text.length >20) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"项目类型不超过20位", nil)];
            return;
        }
    }
    [self requestReimbursementAmountData];
    
}
//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //第一个字符不允许输入空格
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    
    return YES;
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.costTF resignFirstResponder];
}



-(void)requestReimbursementAmountData {
    if ([self.status isEqualToString:@"procurement"]) {//修改采购类型
        NSDictionary * dic =@{@"Id":self.idd,@"type":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",UpdatePurchaseType] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"addProcurement"]){//添加采购类型
        NSDictionary * dic =@{@"type":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",InserPurchaseType] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"payoffWay"]){//添加支付方式
        NSDictionary * dic =@{@"Id":self.idd,@"type":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",UpdatePurchasePay] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"addPayoffWay"]){//修改支付方式
        NSDictionary * dic =@{@"type":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",InserPurchasePay] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"addTravelType"]){
        NSDictionary * dic =@{@"TravelType":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"TravelTyp/Insert"] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"travelType"]){
        NSDictionary * dic =@{@"id":self.idd,@"TravelType":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"TravelTyp/Update"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"AddProjectType"]||[self.status isEqualToString:@"EditProjectType"]){
        NSDictionary * dic =@{@"id":[NSString isEqualToNull:self.idd]?self.idd:@"0",@"ProjTyp":[NSString stringWithFormat:@"%@",self.costTF.text]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DEALPROJTYPE] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
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
    switch (serialNum) {
        case 0:
            if ([self.status isEqualToString:@"procurement"]) {//修改采购类型
               [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"采购类型修改成功", nil) duration:2.0];
                [self backBorrowRecord];
            }else if ([self.status isEqualToString:@"travelType"]){
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"出差类型修改成功", nil) duration:2.0];
                [self backBorrowRecord];
            }else if ([self.status isEqualToString:@"payoffWay"]){//修改支付方式
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"支付方式修改成功", nil) duration:2.0];
                [self backBorrowRecord];
            }else if ([self.status isEqualToString:@"AddProjectType"]||[self.status isEqualToString:@"EditProjectType"]){
                NSString *str=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                if ([str isEqualToString:@"-1"]) {
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"已存在", nil) duration:2.0];
                }else if ([str isEqualToString:@"1"]){
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[self.status isEqualToString:@"AddProjectType"]?Custing(@"保存成功", nil):Custing(@"修改成功", nil) duration:2.0];
                    [self backBorrowRecord];
                }else if ([str isEqualToString:@"0"]){
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[self.status isEqualToString:@"AddProjectType"]?Custing(@"保存失败", nil):Custing(@"修改失败", nil) duration:2.0];
                }
            }
            break;
        case 1:
            if ([self.status isEqualToString:@"addProcurement"]){//添加采购类型
             [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"采购类型添加成功", nil) duration:2.0];
            }else if ([self.status isEqualToString:@"addTravelType"]){
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"出差类型添加成功", nil) duration:2.0];
            }else if ([self.status isEqualToString:@"addPayoffWay"]){//添加支付方式
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"支付方式添加成功", nil) duration:2.0];
            }
            [self backBorrowRecord];
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
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
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
