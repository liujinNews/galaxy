//
//  TravelMainCateCell.h
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelMainCateCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView * iconImgView;
@property(nonatomic,strong)UILabel *titleLabel;
-(void)configCollectCellWithDict:(NSDictionary *)dict;
@end
