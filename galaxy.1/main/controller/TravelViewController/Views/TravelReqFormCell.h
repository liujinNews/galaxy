//
//  TravelReqFormCell.h
//  galaxy
//
//  Created by hfk on 2018/5/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelReqFormModel.h"

@interface TravelReqFormCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_cityOne;
@property (nonatomic, strong) UIImageView *img_Allow;
@property (nonatomic, strong) UILabel *lab_cityTwo;
@property (nonatomic, strong) UILabel *lab_SerNo;
@property (nonatomic, strong) UILabel *lab_SubContent;
@property (nonatomic, strong) UILabel *lab_Remark;

-(void)configTravelReqFormCellWithModel:(TravelReqFormModel *)model withIndex:(NSInteger)index;

+ (CGFloat)cellHeightWithObj:(id)obj withIndex:(NSInteger)index;

+(NSString *)getSubContentWithModel:(TravelReqFormModel *)model withIndex:(NSInteger)index;
@end
