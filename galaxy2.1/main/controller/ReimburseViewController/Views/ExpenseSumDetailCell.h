//
//  ExpenseSumDetailCell.h
//  galaxy
//
//  Created by hfk on 2018/4/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ExpenseSumDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_No;
@property (nonatomic, strong) UILabel *lab_Tyep;
@property (nonatomic, strong) UILabel *lab_Date;
@property (nonatomic, strong) UILabel *lab_Des;
@property (nonatomic, strong) UILabel *lab_LocAmount;
@property (nonatomic, strong) UILabel *lab_Amount;
@property (nonatomic, strong) UIView  *view_Line;


-(void)configCellWithModel:(HasSubmitDetailModel *)model WithIndex:(NSInteger)index;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
