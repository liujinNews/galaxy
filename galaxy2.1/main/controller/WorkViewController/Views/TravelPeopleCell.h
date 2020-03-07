//
//  TravelPeopleCell.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormSubChildModel.h"

@interface TravelPeopleCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_city;
@property (nonatomic, strong) UILabel *lab_name;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_idNum;
@property (nonatomic, strong) UILabel *lab_remark;
@property (nonatomic, strong) UIButton *btn_delete;
@property (nonatomic,copy) void(^deleteBtnClickedBlock)(id sender);

-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status;

+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj;

@end
