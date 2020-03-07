 //
//  PeopleInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/8.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PeopleInfoViewController.h"
#import "ImageViewController.h"

@interface PeopleInfoViewController ()<GPClientDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_phone;

@property (weak, nonatomic) IBOutlet UIButton *btn_Name;//名称
@property (weak, nonatomic) IBOutlet UIButton *btn_sex;//性别
@property (weak, nonatomic) IBOutlet UIImageView *btn_HeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *lab_Department;//部门
@property (weak, nonatomic) IBOutlet UILabel *lab_position;//职位
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;//手机号码
@property (weak, nonatomic) IBOutlet UILabel *lab_Email;//Email


@property (nonatomic, strong) NSDictionary *UserInfo;//网络获取用户信息

@end

@implementation PeopleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"个人资料", nil) backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _labT_job.text = Custing(@"职位", nil);
    _labT_email.text = Custing(@"邮箱", nil);
    _labT_phone.text = Custing(@"手机", nil);
    _labT_department.text = Custing(@"部门", nil);
//    [_btn_IM setTitle:Custing(@"发送消息", nil) forState:UIControlStateNormal];
    _btn_IM.hidden = YES;
    _img_head.hidden = YES;
    _img_cap.hidden = YES;
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
//        _img_head.hidden = NO;
//        _img_cap.hidden = NO;
//        [_btn_sex setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
//        [_btn_Name setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
//
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        [self.navigationController.navigationBar setTranslucent:YES];
//        self.navigationController.navigationBar.translucent = YES;
    }
    [self getUserInfoData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
//        self.tabBarController.navigationController.navigationBar.alpha = 1.0;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
//        _img_head.hidden = NO;
//        _img_cap.hidden = NO;
//        [_btn_sex setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
//        [_btn_Name setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        [self.navigationController.navigationBar setTranslucent:YES];
//        self.navigationController.navigationBar.translucent = YES;
    }
}

#pragma mark - 方法
//获取用户信息
-(void)getUserInfoData
{
    NSString *url=[NSString stringWithFormat:@"%@",GetUserMobContact];
    NSDictionary *parameters = @{@"UserId":[NSString isEqualToNull:_model.userId]?_model.userId:_model.requestorUserId,@"CompanyId":[NSString isEqualToNull:_model.companyId]?_model.companyId:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//设置页面元素
-(void)setViewInfo
{
    [_btn_Name setTitle:[NSString isEqualToNull:_UserInfo[@"userDspName"]]?_UserInfo[@"userDspName"]:@"" forState:UIControlStateNormal];
    [_btn_sex setTitle:[[NSString stringWithFormat:@"%@",_UserInfo[@"gender"]]isEqualToString:@"1" ] ?Custing(@"女", nil):Custing(@"男",nil)  forState:UIControlStateNormal];
    
    [_btn_HeadPhoto setImage:[_UserInfo[@"gender"] intValue]==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"]];
    
    if ([NSString isEqualToNull:_UserInfo[@"photoGraph"]]) {
        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:_UserInfo[@"photoGraph"]];
        NSString * nicai = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        if ([NSString isEqualToNull:nicai]) {
            [_btn_HeadPhoto sd_setImageWithURL:[NSURL URLWithString:nicai]];
        }
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btn_HeadImage:)];
    _btn_HeadPhoto.userInteractionEnabled = YES;
    [_btn_HeadPhoto addGestureRecognizer:singleTap];
    
    //设置边框圆角的弧度
    [_btn_HeadPhoto.layer setCornerRadius:38.0];
    //设置边框线的宽
//    [_btn_HeadPhoto.layer setBorderWidth:2];
//    [_btn_HeadPhoto.layer setBorderColor:[(Color_GrayLight_Same_20)CGColor]];
//    //是否设置边框以及是否可见
    [_btn_HeadPhoto.layer setMasksToBounds:YES];
    
    NSArray *userGroup_arr = _UserInfo[@"userGroup"];
    
    NSDictionary *userGroup;
    if (userGroup_arr.count == 0) {
        userGroup = _UserInfo;
    }else{
        userGroup = userGroup_arr[0];;
    }
    
    
    _lab_Department.text = [NSString isEqualToNull:userGroup[@"groupName"]]?userGroup[@"groupName"]:@"";
    _lab_position.text = [NSString isEqualToNull:userGroup[@"jobTitle"]]?userGroup[@"jobTitle"]:@"";
    if ([_UserInfo[@"isMobileHide"] intValue]==1) {
        if ([NSString isEqualToNull:_UserInfo[@"mobile"]]) {
            NSString *phone = _UserInfo[@"mobile"];
            _lab_Phone.text = [NSString stringWithFormat:@"%@********",[phone substringToIndex:3]];
            _btn_phone.hidden = YES;
        }
        else
        {
            _lab_Phone.text = @"";
        }
    }
    else
    {
        _lab_Phone.text = [NSString isEqualToNull:_UserInfo[@"mobile"]]?_UserInfo[@"mobile"]:@"";
    }
    
    _lab_Email.text = [NSString isEqualToNull:_UserInfo[@"email"]]?_UserInfo[@"email"]:@"";
    
    if ([self.userdatas.userId isEqualToString:[NSString stringWithFormat:@"%@",_UserInfo[@"userId"]]]) {
//        _btn_IM.userInteractionEnabled = NO;
        [_btn_IM setHidden:YES];
//        [_btn_IM setTitle:@"不能给自己发起聊天" forState:UIControlStateNormal];
    }
    if (self.userdatas.SystemType == 1) {
        [_btn_IM setHidden:YES];
    }
}

#pragma mark - action
//点击拨打电话
- (IBAction)btn_PhoneClick:(UIButton *)sender {
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息",nil)
                                                    message:Custing(@"该设备不支持电话功能",nil)
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定",nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
        if ([NSString isEqualToNull:_UserInfo[@"mobile"]]) {
            NSString *str = [NSString stringWithFormat:@"%@",_UserInfo[@"mobile"]];
            
            UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"呼叫",nil), nil];
            [lertView show];
        }
    }
}

//跳转到IM 聊天
- (IBAction)btn_IMclick:(UIButton *)sender {
//    //跳转到AIO
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[NSString stringWithFormat:@"%@",_UserInfo[@"photoGraph"]] forKey:@"userHeader"];
//    [userDefaults synchronize];
//    
//    IMAUser *user = [[IMAUser alloc]init];
//    
//    user.userId = [NSString stringWithFormat:@"%@_%@",_UserInfo[@"userId"],@"xibao"];
//    
//    NSDictionary * dics = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_UserInfo[@"photoGraph"]]];
//    if (![dics isKindOfClass:[NSNull class]] && dics != nil && dics.count != 0){
//        user.icon = [NSString stringWithFormat:@"%@",[dics objectForKey:@"filepath"]];
//    }else{
//        user.icon = nil;
//    }
//    
//    user.nickName = _UserInfo[@"userDspName"];
//    user.remark = _UserInfo[@"userDspName"];
//    
//    [[AppDelegate appDelegate] pushToChatViewControllerWith:user];
}

-(void) btn_HeadImage:(UIImageView *)btn
{
    ImageViewController *imageView=[[ImageViewController alloc]init];
    imageView.photoImageArray= [NSMutableArray arrayWithArray:@[_btn_HeadPhoto.image]];
    imageView.index=0;
    [self presentViewController:imageView animated:YES completion:nil];
}


#pragma mark - 代理
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    if ([responceDic[@"success"]intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    _UserInfo = responceDic[@"result"];
    [self setViewInfo];
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //可以调用系统的打电话功能
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _UserInfo[@"mobile"]]];
        [[UIApplication sharedApplication] openURL:url];
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
