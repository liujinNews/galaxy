//
//  MyCollectionHeadView.h
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUtils.h"
@interface MyCollectionHeadView : UICollectionReusableView
@property (strong, nonatomic) UIImageView *stateImgView;
@property (strong, nonatomic) UILabel *titleLabel;
-(void)configHeadViewWithTitle:(NSString *)title;
@end

