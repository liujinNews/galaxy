//
//  ReleContractCell.h
//  galaxy
//
//  Created by hfk on 2018/4/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleContractCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_Title;
@property (nonatomic, strong) UILabel *lab_Amount;
@property (nonatomic, strong) UILabel *lab_ContractDate;
-(void)configCellWithDict:(NSDictionary *)dict;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
