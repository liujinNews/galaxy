//
//  FormSignInfoCell.h
//  galaxy
//
//  Created by hfk on 2019/2/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormSignInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

-(void)configCellWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
