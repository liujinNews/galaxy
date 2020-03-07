//
//  FilterBaseHeadView.h
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterBaseHeadView : UICollectionReusableView
@property (strong, nonatomic) UILabel *titleLabel;
- (void)configHeadViewWith:(NSInteger)index withArray:(NSArray *)arr;
@end
