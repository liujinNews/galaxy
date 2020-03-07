//
//  AddCostClassesController.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddCostClassesController.h"

@interface AddCostClassesController ()<UITextFieldDelegate,GPClientDelegate>
//进入状态
@property (nonatomic,strong)NSString * approvalStatus;
@property (nonatomic,strong)UIButton *sureBtn;//保存/下一步按钮
@property (nonatomic,strong)UITextField *nameTextField;//新增内容
@property (nonatomic,strong)UITextField *txf_name_en;//新增内容

@property (nonatomic,strong)UITextField *txf_des;//描述内容
@property (nonatomic,strong)UITextField *txf_des_en;//描述英文内容


@end

@implementation AddCostClassesController
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
        [self setTitle:Custing(@"新增一级费用类别", nil) backButton:YES ];
    }else if([_approvalStatus isEqualToString:@"2"]){
        [self setTitle:Custing(@"新增二级费用类别", nil) backButton:YES ];
    }else if([_approvalStatus isEqualToString:@"3"]){
        [self setTitle:Custing(@"新增二级费用类别", nil) backButton:NO ];
        [self setOtherBack];
    }
    //    NSLog(@"%@",_superId);
    [self setNavigationBar];
    [self createAddTextField];
//    [_nameTextField becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_nameTextField becomeFirstResponder];
}
//MARK:创建
-(void)setOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,40, 40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
    [leftbtn addTarget:self action:@selector(sideslipBar:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[[UIImage imageNamed:@"pc_nav_btn_back_img"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIBarButtonItem* leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leBtn;
}

-(void)sideslipBar:(UIButton *)btn{
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];

}

//MARK:下一步操作按钮
-(void)setNavigationBar{
    
    NSString *title;
    if ([_approvalStatus isEqualToString:@"1"]) {
        title=Custing(@"下一步", nil);
    }else{
        title=Custing(@"保存", nil);
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:title titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(sureClick:)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//MARK:新增内容textField创建
-(void)createAddTextField{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 50)];
    view.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view];
    
    _nameTextField=[GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入中文名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
//    _nameTextField.backgroundColor=[UIColor redColor];
    _nameTextField.returnKeyType=UIReturnKeyDone;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_nameTextField];
    [view addSubview:_nameTextField];

    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 50)];
    view1.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view1];
    
    _txf_name_en = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入英文名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_name_en.returnKeyType=UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_name_en];
    [view1 addSubview:_txf_name_en];
    
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 130, Main_Screen_Width, 50)];
    view2.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view2];
    
    _txf_des = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入中文描述", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_des.returnKeyType=UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_des];
    [view2 addSubview:_txf_des];
    
    
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0, 190, Main_Screen_Width, 50)];
    view3.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view3];
    
    _txf_des_en = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:Custing(@"请输入英文描述", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    _txf_des_en.returnKeyType=UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txf_des_en];
    [view3 addSubview:_txf_des_en];
    
}


//MARK:下一步操作事件
-(void)sureClick:(UIButton *)btn{
    [self keyClose];
    if ([_nameTextField.text isEqualToString:@""]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能为空" duration:2.0];
        return;
    }else if (_nameTextField.text.length>100){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能超过100位" duration:2.0];
        return;
    }else{
        [self.nameTextField resignFirstResponder];
        if ([_approvalStatus isEqualToString:@"1"]) {
            [self requestAddFirstCostClass];
        }else{
            [self requestAddSecondCostClass];
        }
    }
}

//MARK:保存添加操作
//一级
-(void)requestAddFirstCostClass{
     [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",InsertExpTypV2];
    NSDictionary *parameters = @{@"parentId":@"0",@"expenseTypeEn":_txf_name_en.text,@"expenseType":_nameTextField.text,@"ExpenseDesc":_txf_des.text,@"ExpenseDescEn":_txf_des_en.text,@"ExpenseLevel":@"1"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];

}
//二级
-(void)requestAddSecondCostClass{
     [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",InsertExpTypV2];
    NSDictionary *parameters = @{@"parentId":_superId,@"expenseTypeEn":_txf_name_en.text,@"expenseType":_nameTextField.text,@"ExpenseDesc":_txf_des.text,@"ExpenseDescEn":_txf_des_en.text,@"ExpenseLevel":@"2"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];

}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
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
    switch (serialNum) {
        case 1:
        {
            if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]isEqualToString:@"-1"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"费用类别已存在", nil) duration:1.0];
                return;
            }
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                AddCostClassesController *addVC=[[AddCostClassesController alloc]initWithType:@"3"];
                addVC.superId=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                [self.navigationController pushViewController:addVC animated:YES];
            });
            
        }
            break;
        case 2:
        {
            if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]isEqualToString:@"-1"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"费用类别已存在", nil) duration:1.0];
                return;
            }
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                if ([self.approvalStatus isEqualToString:@"2"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([self.approvalStatus isEqualToString:@"3"]){
                    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
                }
            });
            
            
        }
            break;
        default:
            break;
    }
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
 
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
    if ([toBeString length] >100) { //如果输入框内容大于10
        textField.text = [toBeString substringToIndex:10];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"名称不能超过100位" duration:2.0];
        return NO;
    }
    return YES;
  
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
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
