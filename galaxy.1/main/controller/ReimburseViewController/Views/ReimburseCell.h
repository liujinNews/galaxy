//
//  ReimburseCell.h
//  galaxy
//
//  Created by hfk on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReimburseCell : UITableViewCell
@property (nonatomic,strong)UIView   *mainView;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIImageView *NewMarkImgView;
@property (nonatomic,strong)UILabel  *titleLabel;
@property (nonatomic,strong)UILabel  *currCodeLabel;
@property (nonatomic,strong)UILabel  *moneyLabel;
@property (nonatomic,strong)UILabel  *descriptionLabel;
@property (nonatomic,strong)UIImageView *clickImageView;
@property (nonatomic,strong)UIImageView *linkImageView;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic, strong)userData *userdatas;
- (void)configSectionZeroWithrRow:(NSInteger)row withTolMoney:(NSString *)money withNote:(NSDictionary *)noteDict;
- (void)configSectionOtherWithrIndexPath:(NSIndexPath*)index WithShowArray:(NSMutableArray *)showArray;
@end
