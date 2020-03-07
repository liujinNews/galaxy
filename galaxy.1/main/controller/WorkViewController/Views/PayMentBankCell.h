//
//  PayMentBankCell.h
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMentBankModel.h"
@interface PayMentBankCell : UITableViewCell
@property (nonatomic,strong)UIImageView  *bankImg;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UIImageView  *selImg;
@property (nonatomic,strong)UIView  *lineView;

@property (nonatomic,strong)PayMentBankModel  *model;

@end
