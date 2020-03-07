//
//  MyNewFriendsCellViewController.m
//  MyDemo
//
//  Created by wilderliao on 15/8/28.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "MyFriendApplyViewController.h"
#import "MyCommOperation.h"
#import "MyFriendModel.h"
#import "AppDelegate.h"
#import "MyContactsViewController.h"
#import "MyTabBarViewController.h"
#import "MyRecentViewController.h"

@interface MyFriendApplyViewController()
 
@property (nonatomic, strong)MySystemNotifyModel *model;

@property (nonatomic, assign)BOOL acceptState;

@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *applyReason;
@property (nonatomic, strong)UIButton *refuseBtn;
@property (nonatomic, strong)UIButton *acceptBtn;

@property (nonatomic, strong)UIButton *sendMsgBtn;
@property (nonatomic, strong)UILabel *acceptLabel;

@property (nonatomic, strong)UILabel *refuseLabel;

@end

@implementation MyFriendApplyViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"好友申请"];
    [self setupSubViews];
}

- (void)initModel:(MySystemNotifyModel *)model{
    self.model = model;
}

- (void)setupSubViews{

    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat curHeight;
    curHeight = statusHeight+navigationHeight;
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, curHeight, self.view.frame.size.width, 60)];

    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CELL_IMG_SIZE_W, CELL_IMG_SIZE_W)];
    [_headView setImage:[UIImage imageNamed:@"tab_contact_nor" ]];
    CGFloat x,y,width,height;
     x = _headView.frame.origin.x+_headView.frame.size.width+10;
     y = _headView.frame.origin.y;
     width = userInfoView.frame.size.width-_headView.frame.size.width;
     height = _headView.frame.size.height;
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y ,width ,height)];
    _nameLabel.text = _model.user;

    [userInfoView addSubview:_headView];
    [userInfoView addSubview:_nameLabel];
    
    CGPoint startPoint,endPoint;
    startPoint.x = 0;
    startPoint.y = userInfoView.frame.size.height + curHeight;
    endPoint.x = self.view.frame.size.width;
    endPoint.y = userInfoView.frame.size.height + curHeight;
    [self drawLine:userInfoView start:startPoint end:endPoint];
    
    curHeight += userInfoView.frame.size.height;
    UIView *applyReasonView = [[UIView alloc] initWithFrame:CGRectMake(0, curHeight, self.view.frame.size.width, 80)];
    
    _applyReason = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, applyReasonView.frame.size.width-30, applyReasonView.frame.size.height)];
    _applyReason.text = [[NSString alloc] initWithFormat:@"%@请求添加您为好友,(申请理由:%@)",_model.user,_model.wording];
    _applyReason.numberOfLines = 2;
    [applyReasonView addSubview:_applyReason];
    startPoint.x = 0;
    startPoint.y = applyReasonView.frame.size.height + curHeight;
    endPoint.x = self.view.frame.size.width;
    endPoint.y = applyReasonView.frame.size.height + curHeight;
    [self drawLine:applyReasonView start:startPoint end:endPoint];
    
    curHeight += applyReasonView.frame.size.height;
    UIView *optView;
//    if (_model.notifyType == SNSSystemNotifyType_AddFriend) {
//        optView = [self layoutAcceptView:curHeight];
//    }
//    else if(_model.notifyType == SNSSystemNotifyType_addFriendReq){
//        optView = [self layoutPendView:curHeight];
//    }
//    else if (_model.notifyType == SNSSystemNotifyType_addFriendRefuse){
//        optView = [self layoutRefuseView:curHeight];
//    }
     optView = [self layoutPendView:curHeight];

    [self.view addSubview:userInfoView];
    [self.view addSubview:applyReasonView];
    [self.view addSubview:optView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (UIView *)layoutPendView:(CGFloat)curHeight{
    UIView *optView = [[UIView alloc] initWithFrame:CGRectMake(0, curHeight, self.view.frame.size.width, self.view.frame.size.height-curHeight)];
   
    CGFloat x,y,width,height;
    x = 15;
    y = 25;
    width = (optView.frame.size.width-3*x)/2;
    height = 35;
    UIButton *refuseBtn = [self createBtn:CGRectMake(x,y, width, height) btnTitle:@"拒绝" backgroundColor:[UIColor whiteColor]];
    [refuseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [refuseBtn addTarget:self action:@selector(OnRefuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    x = 30+refuseBtn.frame.size.width;
    y = 25;
    width = refuseBtn.frame.size.width;
    height = refuseBtn.frame.size.height;
    UIButton *acceptBtn = [self createBtn:CGRectMake(x,y, width, height) btnTitle:@"同意" backgroundColor:[UIColor blueColor]];
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [acceptBtn addTarget:self action:@selector(OnAcceptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [optView addSubview:refuseBtn];
    [optView addSubview:acceptBtn];
    
    return optView;
}

- (UIView *)layoutAcceptView:(CGFloat)curHeight{
    UIView *optView = [[UIView alloc] initWithFrame:CGRectMake(0, curHeight, self.view.frame.size.width, self.view.frame.size.height-curHeight)];
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = optView.frame.size.width;
    height = 50;
    _acceptLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _acceptLabel.text = @"已同意该申请";
    _acceptLabel.textAlignment = NSTextAlignmentCenter;
    _acceptLabel.font = [UIFont systemFontOfSize:20];
    
    x = 30;
    y = _acceptLabel.frame.size.height;
    width = optView.frame.size.width-2*x;
    height = 60;
    UIButton *sendMsgBtn = [self createBtn:CGRectMake(x,y, width, height) btnTitle:@"发消息" backgroundColor:[UIColor blueColor]];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [sendMsgBtn addTarget:self action:@selector(OnSendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [optView addSubview:_acceptLabel];
    [optView addSubview:sendMsgBtn];
    
    return optView;
}
- (UIView *)layoutRefuseView:(CGFloat)curHeight{
    UIView *optView = [[UIView alloc] initWithFrame:CGRectMake(0, curHeight, self.view.frame.size.width, self.view.frame.size.height-curHeight)];
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = optView.frame.size.width;
    height = 50;
    _refuseLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _refuseLabel.text = @"已拒绝该申请";
    _refuseLabel.textAlignment = NSTextAlignmentCenter;
    _refuseLabel.font = [UIFont systemFontOfSize:20];
    
    [optView addSubview:_refuseLabel];
    
    return optView;
}

- (UIButton *)createBtn:(CGRect)btnRect btnTitle:(NSString*)title backgroundColor:(UIColor*)bgcolor{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.frame = btnRect;
    btn.layer.cornerRadius = 4.5;
    [btn.layer setMasksToBounds:YES];
    [btn.layer setBorderWidth:1];//设置边界的宽度
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0,96,96,1});
    [btn.layer setBorderColor:color];
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpaceRef);
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:bgcolor];
    
    return btn;
}

- (void)drawLine:(UIView*)view start:(CGPoint)startPoint end:(CGPoint)endPoint{
    UIView *navDividingLine = [[UIView alloc] init];
    if (navDividingLine != nil)
    {
        navDividingLine.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 1);
        navDividingLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        [view addSubview:navDividingLine];
    }
}
                                                    
- (void)OnAcceptBtnClick:(id)sender{
    [[MyCommOperation shareInstance] acceptFriendApply:_model.user succ:^(NSArray *data){
        [self showAlert:@"提示" andMsg:@"添加成功"];
        [self.delegate reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        
        //更新联系人
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MyTabBarViewController *tab = app.tabBarViewCntrl;
        MyContactsViewController *contactsViewCtl = tab.contactsViewCntlr;
        [contactsViewCtl updateTable];
     }
     fail:^(int code, NSString *err){
         NSString *showInfo = [[NSString alloc] initWithFormat:@"添加失败，错误码%d,错误信息:%@",code,err];
         [self showAlert:@"提示" andMsg:showInfo];
     }];
}
- (void)OnRefuseBtnClick:(id)sender{
    TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
    response.identifier = _model.user;
    response.responseType = TIM_FRIEND_RESPONSE_REJECT;
    [[MyCommOperation shareInstance] doResponse:@[response]
                                           succ:^(NSArray *data){
                                               [self.delegate reloadData];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           fail:^(int code, NSString *err){
                                               NSString *showInfo = [[NSString alloc] initWithFormat:@"拒绝失败，错误码%d,错误信息:%@",code,err];
                                               [self showAlert:@"提示" andMsg:showInfo];
                                           }];
}

- (void)OnSendMsgBtnClick:(id)sender{
    MyFriendModel* model = (MyFriendModel*)_model;
    MyChatViewController *chatCtl = [[MyChatViewController alloc] initWithC2C:model.user];
    chatCtl.hidesBottomBarWhenPushed = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MyTabBarViewController *tab = app.tabBarViewCntrl;
        [tab.recentViewCntlr.navigationController pushViewController:chatCtl animated:YES];
        tab.selectedViewController = tab.recentViewCntlr.navigationController;
    });
}

- (void)showAlert:(NSString*)title andMsg:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
}

@end