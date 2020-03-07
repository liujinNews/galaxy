//
//  ExpenseListHeadView.h
//  galaxy
//
//  Created by hfk on 2018/5/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseListHeadView : UICollectionReusableView
@property (strong, nonatomic) UILabel *titleLabel;
- (void)configHeadView;
@end
