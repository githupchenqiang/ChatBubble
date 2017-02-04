//
//  ChatTableViewCell.h
//  ChatMessage
//
//  Created by QAING CHEN on 17/2/4.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIImageView            *BubbleImageView;
@property (nonatomic ,strong)UILabel                *ContentLabel;
@property (nonatomic ,strong)UIImageView            *HeaderImageView;


- (void)refreshCell:(ChatModel *)model;

@end
