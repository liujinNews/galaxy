//
//  ExmineApproveCollectionViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ExmineApproveCollectionViewCell.h"

@implementation ExmineApproveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initWithModel:(ExmineApproveModel *)model block:(ExmineApproveBlock)block{
    model.view_view.frame = CGRectMake(0, 0, 60, 100);
    model.img_imgView.frame = CGRectMake(0, 15, 52, 52);
    model.img_imgView.layer.cornerRadius = 26;
    model.img_imgView.layer.masksToBounds = YES;
    model.txf_txfView.frame = CGRectMake(0, 75, 52, 17);
    [model.txf_txfView setTextAlignment:NSTextAlignmentCenter];
    model.txf_txfView.font = Font_Important_15_20;
    model.txf_txfView.textColor = Color_form_TextField_20;
    [model.view_view addSubview:model.img_imgView];
    [model.view_view addSubview:model.txf_txfView];
    if (![NSString isEqualToNull:model.str_HandlerUserId]) {
        [model.img_imgView setImage:[UIImage imageNamed:@"share_AddAproval"]];
    }else{
        model.txf_txfView.text = model.str_HandlerUserName;
        if ([NSString isEqualToNull:model.str_HandlerUserNamePhoto]) {
            if ([NSString isEqualToNull:model.str_HandlerUserNamePhoto]) {
                [model.img_imgView sd_setImageWithURL:[NSURL URLWithString:model.str_HandlerUserNamePhoto]];
            }else{
                model.img_imgView.image=model.str_HandlerUserNamegender==1?[UIImage imageNamed:@"Message_Woman"]:[UIImage imageNamed:@"Message_Man"];
            }}
        else{
            model.img_imgView.image=model.str_HandlerUserNamegender==1?[UIImage imageNamed:@"Message_Woman"]:[UIImage imageNamed:@"Message_Man"];
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(44, 7, 16, 16)];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [img setImage:[UIImage imageNamed:@"share_ImageDelete"]];
        [view addSubview:img];
        [model.view_view addSubview:view];
        [view bk_whenTapped:^{
            if (block) {
                block();
            }
        }];
    }
    [self addSubview:model.view_view];
}
#pragma clang diagnostic pop
@end
