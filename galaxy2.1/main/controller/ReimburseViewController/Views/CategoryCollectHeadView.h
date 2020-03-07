//
//  CategoryCollectHeadView.h
//  galaxy
//
//  Created by hfk on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectHeadView : UICollectionReusableView
@property(nonatomic,strong)UIView *mainView;
@property (strong, nonatomic) UIButton *travelBtn;
@property (strong, nonatomic) UIButton *dailyBtn;
-(void)configHeadViewWith:(NSString *)selectStr;
@end
