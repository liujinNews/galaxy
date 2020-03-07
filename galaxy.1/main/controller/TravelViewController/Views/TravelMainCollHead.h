//
//  TravelMainCollHead.h
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelMainCollHead : UICollectionReusableView
@property (nonatomic,strong)UIView   *mainView;
@property (strong, nonatomic) UIImageView *titleImgView;
@property (strong, nonatomic) UIButton *rightBtn1;
@property (strong, nonatomic) UIButton *rightBtn2;
@property (strong, nonatomic)UIView  *lineView;
@property (nonatomic,copy) void(^RightBtnClickedBlock)(id sender);
-(void)configHeadViewWithDict:(NSDictionary *)dict;
-(void)configHeadViewWithDict:(NSDictionary *)dict WithView:(UIView *)view;
@end
