//
//  PeopleNoInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/8.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PeopleNoInfoViewController.h"

@interface PeopleNoInfoViewController ()<GPClientDelegate>

@end

@implementation PeopleNoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"个人资料", nil) backButton:YES];
    self.view.backgroundColor = Color_White_Same_20;
    
    _lab_name.text = _dic_userId[@"name"];
    _lab_phone.text = _dic_userId[@"mobile"];
    
    NSString *str = _dic_userId[@"name"];
    str = str.length>1?[str substringWithRange:NSMakeRange(str.length-2, 2)]:str;
    [_btn_image setTitle:str forState:UIControlStateNormal];
    [_btn_image setBackgroundColor:_color];
    _btn_image.layer.cornerRadius = 40.0;
    _btn_image.userInteractionEnabled = NO;
    [_btn_image setTintColor:Color_form_TextFieldBackgroundColor];
    [_btn_image.titleLabel setFont:Font_Amount_21_20];
}
-(void)requestInvitationJoin{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",share] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

#pragma mark - action
- (IBAction)btn_Phone_Click:(id)sender {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                    message:@"该设备不支持电话功能"
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定", nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@",_lab_phone.text];
        UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"呼叫", nil), nil];
        [lertView show];
    }
}

- (IBAction)btn_Email_Click:(id)sender {
    [self requestInvitationJoin];
}

#pragma mark - delegate
//alertView的delegate方法（用于打电话）
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //可以调用系统的打电话功能
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _lab_phone.text]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)requestSuccess:(NSDictionary*)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 1) {
        [GPUtils sendSMSMessageWithDelegate:self AndMessages:[NSString stringWithFormat:@"%@%@",responceDic[@"result"][@"shareContent"],responceDic[@"result"][@"shareTargetUrl"]] AndPhoneNum:_lab_phone.text];
    }
}


-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
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
