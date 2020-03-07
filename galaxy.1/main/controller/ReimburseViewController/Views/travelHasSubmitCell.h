//
//  travelHasSubmitCell.h
//  galaxy
//
//  Created by hfk on 16/5/3.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface travelHasSubmitCell : UITableViewCell

@property (nonatomic,strong)UILabel  *lab_GridOrder;
@property (nonatomic,strong)UILabel  *lab_Type;
@property (nonatomic,strong)UILabel  *lab_Date;
@property (nonatomic,strong)UIImageView  *Img_Attachment;
@property (nonatomic,strong)UILabel  *lab_Money;
@property (nonatomic,strong)UILabel  *lab_Currency;
@property (nonatomic,strong)UIButton  *btn_OverBud;
@property (nonatomic,strong)UILabel  *lab_OverTime;
@property (nonatomic,strong)UIImageView  *img_PayWay;
@property (nonatomic,strong)UIButton  *btn_Sure;
@property (nonatomic,strong)UILabel  *lab_Att_Content;




- (void)configViewWithArray:(NSMutableArray *)array withIndex:(NSInteger)index withNeedSure:(BOOL)needSure withComePlace:(NSString *)place;


+ (CGFloat)cellHeightWithObj:(id)obj;


@end
