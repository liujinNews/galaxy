//
//  PayMentResultCell.h
//  galaxy
//
//  Created by hfk on 2017/6/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMentResultCell : UITableViewCell
@property (nonatomic,strong)UIImageView  *typeImg;
@property (nonatomic,strong)UILabel  * reasonLabel;
@property (nonatomic,strong)UILabel  * noLabel;
@property (nonatomic,strong)UILabel  * statusLabel;
@property (nonatomic,strong)UIImageView  *statusImg;
@property (nonatomic,strong)NSDictionary  *dict;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
