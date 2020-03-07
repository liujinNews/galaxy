//
//  EditCostClassesController.m
//  galaxy
//
//  Created by hfk on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "EditCostClassesController.h"

@interface EditCostClassesController ()<UITextFieldDelegate,GPClientDelegate>
@property (nonatomic,strong)NSString * approvalStatus;
@property (nonatomic,strong)UIButton *CompleteBtn;//保存/下一步按钮
@property (nonatomic,strong)UITextField *nameTextField;//修改内容
@property (nonatomic,strong)UITextField *txf_name_en;//修改内容

@property (nonatomic,strong)UITextField *txf_des;//描述内容
@property (nonatomic,strong)UITextField *txf_des_en;//描述内容英文

@end

@implementation EditCostClassesController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.approvalStatus=type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    if ([_approvalStatus isEqualToString:@"1"]) {
        [self setTitle:Custing(@"修改一级费用类别", nil) backButton:YES ];
    }else if ([_approvalStatus isEqualToString:@"2"]){
        [self setTitle:Custing(@"修改二级费用类别", nil) backButton:YES ];
    }
    [self setNavigationBar];
    [self createAddTextField];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear :YES];
    [_nameTextField becomeFirstResponder];
}
//MARK:下一步操作按钮
-(void)setNavigationBar{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(completeClick:)];
}
//MARK:新增内容textField创建
-(void)createAddTextField{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 50)];
    view.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view];
    
    _nameTextField=[GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入中文名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
      _nameTextField.returnKeyType=UIReturnKeyDone;
    _nameTextField.text=[NSString isEqualToNull:_editModel.expenseType]?_editModel.expenseType:@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_nameTextField];
    [view addSubview:_nameTextField];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 50)];
    view1.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view1];
    
    _txf_name_en = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入英文名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_name_en.returnKeyType=UIReturnKeyDone;
    _txf_name_en.text=[NSString isEqualToNull:_editModel.expenseTypeEn]?_editModel.expenseTypeEn:@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_name_en];
    [view1 addSubview:_txf_name_en];
    
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 130, Main_Screen_Width, 50)];
    view2.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view2];
    
    _txf_des = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入中文描述", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_des.returnKeyType=UIReturnKeyDone;
    _txf_des.text=[NSString isEqualToNull:_editModel.expenseDesc]?_editModel.expenseDesc:@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_des];
    [view2 addSubview:_txf_des];
    
    
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0, 190, Main_Screen_Width, 50)];
    view3.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view3];
    
    _txf_des_en = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入英文描述", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_des_en.returnKeyType=UIReturnKeyDone;
    _txf_des_en.text=[NSString isEqualToNull:_editModel.expenseDescEn]?_editModel.expenseDescEn:@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_des_en];
    [view3 addSubview:_txf_des_en];
}
//MARK:下一步操作事件
-(void)completeClick:(UIButton *)btn{
    [self keyClose];
    if ([_nameTextField.text isEqualToString:@""]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能为空" duration:1.0];
        return;
    }else if (_nameTextField.text.length>100){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能超过100位" duration:2.0];
        return;
    }else{
        if ([_approvalStatus isEqualToString:@"1"]) {
            [self requestEditFirstCostClass];
        }else if ([_approvalStatus isEqualToString:@"2"]){
            [self requestEditSecondCostClass];
        }
    }
}
//MARK:保存添加操作
//一级
-(void)requestEditFirstCostClass{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",UpdateExpTypV3];
    NSDictionary *parameters = @{@"id":_editModel.Id,@"expenseType":_nameTextField.text,@"expenseTypeEn":_txf_name_en.text,@"ExpenseDesc":_txf_des.text,@"ExpenseDescEn":_txf_des_en.text};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    
}
//二级
-(void)requestEditSecondCostClass{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",UpdateExpTypV3];
    NSDictionary *parameters = @{@"id":_editModel.Id,@"expenseType":_nameTextField.text,@"expenseTypeEn":_txf_name_en.text,@"ExpenseDesc":_txf_des.text,@"ExpenseDescEn":_txf_des_en.text};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        if (![[responceDic objectForKey:@"msg"]isKindOfClass:[NSNull class]]) {
            NSString * error =[responceDic objectForKey:@"msg"];
            if (![error isKindOfClass:[NSNull class]]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            }
        }
        return;
    }
    if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]isEqualToString:@"-1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"费用类别已存在", nil) duration:1.0];
        return;
    }
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:1.0];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldChanged{
    if (_nameTextField.text.length>100) {
        [self keyClose];
        _nameTextField.text = [_nameTextField.text substringToIndex:100];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能超过100位" duration:2.0];
    }
}


//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] >100) { //如果输入框内容大于12
        textField.text = [toBeString substringToIndex:100];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能超过100位" duration:2.0];
        return NO;
    }
    return YES;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    [_txf_name_en resignFirstResponder];
//    [self.costTF resignFirstResponder];
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
