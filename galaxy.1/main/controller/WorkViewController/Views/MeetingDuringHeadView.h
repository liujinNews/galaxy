//
//  MeetingDuringHeadView.h
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDuringHeadView : UICollectionReusableView
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLabel;
-(void)configHeadViewWithType:(NSInteger)type;
@end
