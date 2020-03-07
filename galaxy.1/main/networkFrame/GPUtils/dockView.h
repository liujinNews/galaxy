//
//  dockView.h
//  galaxy
//
//  Created by 赵碚 on 15/7/27.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendEmailModel.h"

@protocol DockViewDelegate;
@interface dockView : UIView

@property (weak, nonatomic) id<DockViewDelegate>delegate;
@property BOOL isShow;
@property (nonatomic,strong)SendEmailModel *model_Send;

-(instancetype)initWithDockFrame:(CGRect)frame sendModel:(SendEmailModel *)model;

- (void)showDock;

- (void)removeDock;

@end

@protocol DockViewDelegate <NSObject>

@optional

//type 1:发送邮件 2：复制链接
- (void)actionDockViewClick:(id)obj type:(NSInteger)type;

@required

- (void)dimsissDockPDActionView;

@end
