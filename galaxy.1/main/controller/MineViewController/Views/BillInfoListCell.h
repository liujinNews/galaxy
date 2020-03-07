//
//  BillInfoListCell.h
//  galaxy
//
//  Created by hfk on 2017/6/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillInfoListCell : UITableViewCell
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UIImageView  *selImg;
@property (nonatomic,strong)UIView  *lineView;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,assign)BOOL HasLine;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
