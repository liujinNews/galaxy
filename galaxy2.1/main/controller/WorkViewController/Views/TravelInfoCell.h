//
//  TravelInfoCell.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormSubChildModel.h"
@interface TravelInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromcity;
@property (weak, nonatomic) IBOutlet UIImageView *imagAllow;
@property (weak, nonatomic) IBOutlet UILabel *backcity;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
@property (weak, nonatomic) IBOutlet UILabel *fromAmt;
@property (weak, nonatomic) IBOutlet UILabel *totalAmt;
@property (weak, nonatomic) IBOutlet UILabel *backAmt;

@property (nonatomic,copy) void(^deleteBtnClickedBlock)(id sender);

-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status;

+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj;

@end
