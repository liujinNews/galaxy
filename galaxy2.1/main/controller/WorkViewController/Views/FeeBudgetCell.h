//
//  FeeBudgetCell.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormSubChildModel.h"

@interface FeeBudgetCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_name;
@property (nonatomic, strong) UILabel *lab_amount;
@property (nonatomic, strong) UIButton *btn_delete;
@property (nonatomic, strong) UILabel *lab_content;
@property (nonatomic, strong) UILabel *lab_remark;
@property (nonatomic,copy) void(^deleteBtnClickedBlock)(id sender);

-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status;

+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj;

@end
