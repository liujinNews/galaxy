//
//  ApproveSetterViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ApproveSetterViewController.h"

@interface ApproveSetterViewController ()<GPClientDelegate>

@end

@implementation ApproveSetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"消息提醒", nil) backButton:YES];
    
    self.view.backgroundColor = Color_White_Same_20;
    
    UIImageView *image = [GPUtils createImageViewFrame:CGRectMake(15, 15, 40, 40) imageName:@"Message_Approve_Setter"];
    [self.view addSubview:image];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(70, 15, Main_Screen_Width-85, 40) text:Custing(@"消息中心", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:lab];
    
//    UIView *View_Content = [[UIView alloc]initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 170)];
    UIView *View_Content = [[UIView alloc]initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 245)];
    View_Content.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:View_Content];
    
    [View_Content addSubview:[self createLineViewOfHeight:0]];
//    [View_Content addSubview:[self createLineViewOfHeight:169.5]];
    [View_Content addSubview:[self createLineViewOfHeight:244.5]];

    UILabel *lab1 = [GPUtils createLable:CGRectMake(15, 10, Main_Screen_Width-30, 25) text:Custing(@"功能介绍", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab1];
    
    UILabel *lab2 = [GPUtils createLable:CGRectMake(15, 35, Main_Screen_Width-30, 25) text:Custing(@"需要我审批的申请", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab2];
    
    UILabel *lab3 = [GPUtils createLable:CGRectMake(15, 60, Main_Screen_Width-30, 25) text:Custing(@"我提交的申请审批完成", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab3];
    
    UILabel *lab4 = [GPUtils createLable:CGRectMake(15, 85, Main_Screen_Width-30, 25) text:Custing(@"我提交的申请支付完成", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab4];
    
    UILabel *lab5 = [GPUtils createLable:CGRectMake(15, 110, Main_Screen_Width-30, 25) text:Custing(@"我提交的申请被退回", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab5];
    
    UILabel *lab6 = [GPUtils createLable:CGRectMake(15, 135, Main_Screen_Width-30, 25) text:Custing(@"我提交的申请被作废", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab6];
    
    UILabel *lab7 = [GPUtils createLable:CGRectMake(15, 160, Main_Screen_Width-30, 25) text:Custing(@"催票提醒", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab7];

    UILabel *lab8 = [GPUtils createLable:CGRectMake(15, 185, Main_Screen_Width-30, 25) text:Custing(@"催款提醒", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab8];

    UILabel *lab9 = [GPUtils createLable:CGRectMake(15, 210, Main_Screen_Width-30, 25) text:Custing(@"公告提醒", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [View_Content addSubview:lab9];
    
//    UIView *view_delete = [[UIView alloc]initWithFrame:CGRectMake(0, 260, Main_Screen_Width, 44)];
    UIView *view_delete = [[UIView alloc]initWithFrame:CGRectMake(0, 335, Main_Screen_Width, 44)];
    view_delete.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view_delete];
    
    [view_delete addSubview:[self createLineViewOfHeight:0]];
    [view_delete addSubview:[self createLineViewOfHeight:43.5]];
    
    UIButton *btn_Delete = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(btn_Click:) delegate:self title:Custing(@"清空消息记录", nil) font:Font_Important_15_20 titleColor:Color_Red_Weak_20];
    [view_delete addSubview:btn_Delete];
}

-(void)btn_Click:(UIButton *)btn{
    [UIAlertView bk_showAlertViewWithTitle:Custing(@"确认清空消息记录吗？", nil) message:@"" cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"确定",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self requestMsgHistDeleteAll];
        }
    }];
}


-(void)requestMsgHistDeleteAll{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:XB_DeletAllMsg Parameters:@{@"CompanyId":self.userdatas.multCompanyId?self.userdatas.multCompanyId:@"0"} Delegate:self SerialNum:3 IfUserCache:NO];
}
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"]intValue]==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:2.0];
        return;
    }
    if (serialNum == 3) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.5];
        [self performBlock:^{
            [self Navback];
        } afterDelay:1.5];
    }
}

//请求失败
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
