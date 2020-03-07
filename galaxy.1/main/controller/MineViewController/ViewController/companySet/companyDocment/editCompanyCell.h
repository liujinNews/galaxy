//
//  editCompanyCell.h
//  galaxy
//
//  Created by 赵碚 on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "editCompanyData.h"
@interface editCompanyCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  * industryLa;

- (void)configIndustryViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str;
- (void)configCoscaleViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str;
- (void)configLocationViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str;
@end
