//
//  dockView.m
//  galaxy
//
//  Created by 赵碚 on 15/7/27.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "dockView.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation dockView
{
    UIView *backgroundView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark 给View添加圆角


-(instancetype)initWithDockFrame:(CGRect)frame sendModel:(SendEmailModel *)model{
    self=[super init];
    
    if (self) {
        
        self.model_Send=model;
        
        self.clipsToBounds = YES;
        frame.size.width = ScreenRect.size.width;
        frame.size.height = Main_Screen_Height;
        frame.origin.x=0;
        frame.origin.y=ApplicationDelegate.window.bounds.size.height;
        self.frame = frame;
        self.isShow=NO;
        self.backgroundColor=[UIColor clearColor];
        //**********************************************************************
        
        
        UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,310, 215)];
        alertView.backgroundColor = Color_form_TextFieldBackgroundColor;
        alertView.layer.cornerRadius = 10.0f;
        [self addSubview:alertView];
        
        UILabel * describeLbl = [GPUtils createLable:CGRectMake(15, 0, WIDTH(alertView)-30, 50) text:Custing(@"在pc端访问下面链接打印报销单", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        describeLbl.backgroundColor = [UIColor clearColor];
        describeLbl.numberOfLines = 0;
        [alertView addSubview:describeLbl];
        
        UILabel * urlLbl = [GPUtils createLable:CGRectMake(15, 50, WIDTH(alertView)-30, 50) text:[NSString stringWithFormat:@"%@%@",Custing(@"链接:", nil),self.model_Send.str_Link] font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        urlLbl.backgroundColor = [UIColor clearColor];
        urlLbl.numberOfLines = 0;
        [alertView addSubview:urlLbl];
        
        
        UILabel * serectLbl = [GPUtils createLable:CGRectMake(15, 100, WIDTH(alertView)-30, 30) text:[NSString stringWithFormat:@"%@%@",Custing(@"密码:", nil),self.model_Send.str_Password] font:Font_Important_15_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
        serectLbl.backgroundColor = [UIColor clearColor];
        [alertView addSubview:serectLbl];
        
        UILabel * tipsLbl = [GPUtils createLable:CGRectMake(15, 130, WIDTH(alertView)-30, 30) text:[NSString stringWithFormat:@"%@",Custing(@"打印链接15分钟内有效", nil)] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        tipsLbl.backgroundColor = [UIColor clearColor];
        [alertView addSubview:tipsLbl];
        
        //
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 169, WIDTH(alertView), 0.5)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [alertView addSubview:lineView];
        
        NSArray * xieArray = @[@{@"nameS":@"发送邮件",@"tags":@"1"},@{@"nameS":@"发送微信",@"tags":@"2"},@{@"nameS":@"发送QQ",@"tags":@"3"},@{@"nameS":@"复制链接",@"tags":@"4"}];
        NSInteger count=xieArray.count;
        for (int j = 0 ; j < count ; j ++ ) {
            UIButton * resiBtn = [GPUtils createButton:CGRectMake(j*WIDTH(alertView)/count, 170, WIDTH(alertView)/count-1, 45) action:@selector(pushWeiXinOrQQ:) delegate:self title:Custing([[xieArray objectAtIndex:j] objectForKey:@"nameS"], nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
            resiBtn.tag = [[[xieArray objectAtIndex:j] objectForKey:@"tags"] integerValue];
            resiBtn.backgroundColor=[UIColor clearColor];
            [alertView addSubview:resiBtn];
            
            if (j>=1&&j< count) {
                UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH(alertView)/count*j, 169.5, 0.5, 45)];
                lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [alertView addSubview:lineView1];
            }
            
        }
        
    }
    return self;
}

-(void)pushWeiXinOrQQ:(UIButton *)sender
{
    [self removeDock];
    switch (sender.tag) {
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionDockViewClick:type:)]) {
                [self.delegate actionDockViewClick:self.model_Send type:1];
            }
        }
            break;
        case 2:
        {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            NSString *text =[NSString stringWithFormat:@"%@%@%@",Custing(@"请使用密码[", nil),self.model_Send.str_Password,Custing(@"]来访问", nil)];
            NSString* thumbURL =self.model_Send.str_Link;
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model_Send.str_Title descr:text thumImage:GPImage(@"shareAvatar.png")];
            shareObject.webpageUrl = thumbURL;
            messageObject.shareObject = shareObject;
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
        }
            break;
        case 3:
        {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //创建网页内容对象
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model_Send.str_Title descr:[NSString stringWithFormat:@"%@%@%@",Custing(@"请使用密码[", nil),self.model_Send.str_Password,Custing(@"]来访问", nil)] thumImage:GPImage(@"shareAvatar.png")];
            //设置网页地址
            shareObject.webpageUrl = self.model_Send.str_Link;
            messageObject.shareObject = shareObject;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
        }
            break;
        case 4:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@%@%@  %@%@",self.model_Send.str_Title,Custing(@"链接:", nil),self.model_Send.str_Link,Custing(@"访问密码:", nil),self.model_Send.str_Password];
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionDockViewClick:type:)]) {
                [self.delegate actionDockViewClick:nil type:2];
            }
        }
            break;
            
        default:
            break;
    }
    
}


-(void)didTap:(id)sender
{
    if (self) {
        [self removeDock];
    }
}
-(void)setBackgroundView
{
    backgroundView = [[UIView alloc]initWithFrame:CGRectIntegral([[UIScreen mainScreen] bounds])];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    [ApplicationDelegate.window addSubview:backgroundView];
}


UIKIT_STATIC_INLINE void
UIViewSetFrameY(UIView *view, CGFloat y) {
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

//显示出来
- (void)showDock
{
    if (!self.isShow) {
        [self setBackgroundView];
        [ApplicationDelegate.window addSubview:self];
        self.frame = CGRectMake(Main_Screen_Width/2-155, 0-Main_Screen_Height, 310, 215);
        [UIView animateWithDuration:0.3 animations:^{
            NSLog(@"%f",Main_Screen_Width/Main_Screen_Height);
            if ((Main_Screen_Width/Main_Screen_Height) >=0.66666) {
                UIViewSetFrameY(self, Main_Screen_Height/5);
            }else{
                UIViewSetFrameY(self, Main_Screen_Height/4);
            }
            
        }];
        self.isShow=YES;
    }
    
}


- (void)removeDock
{
    self.isShow=NO;
    self.alpha=0;
    backgroundView.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        UIViewSetFrameY(self, ApplicationDelegate.window.bounds.size.height);
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dimsissDockPDActionView)]) {
            [self.delegate dimsissDockPDActionView];
        }
        [backgroundView removeFromSuperview];
        backgroundView=nil;
        [self removeFromSuperview];
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
