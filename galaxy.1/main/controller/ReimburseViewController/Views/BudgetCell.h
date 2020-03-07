//
//  BudgetCell.h
//  galaxy
//
//  Created by hfk on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *budgetInfoLab;//超预算详情
-(void)configViewWithString:(NSString *)str withCount:(NSInteger)count withIndex:(NSInteger)index;
@end
