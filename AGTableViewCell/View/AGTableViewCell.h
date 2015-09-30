//
//  AGTableViewCell.h
//  AGTableViewCell
//
//  Created by Agenric on 15/9/22.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTableViewRowAction.h"

/*!
 * @brief  AGTableViewCell的编辑形式
 */
typedef NS_ENUM(NSInteger, AGTableViewCellStyle){
    /*!
     * 默认为 UITableViewCell 的样式
     */
    AGTableViewCellStyleDefault = 0,
    /*!
     * Cell右边呼出菜单选项模式
     */
    AGTableViewCellStyleRightItems,
    /*!
     * Cell左边呼出菜单选项模式
     */
    AGTableViewCellStyleLeftItems,
    /*!
     * Cell左右均可呼出菜单模式
     */
    AGTableViewCellStyleBoth
};

@protocol AGTableViewCellDelegate <NSObject>

@required
/*!
 * @brief  获取每一行Cell的编辑样式
 *
 * @param tableView 父级tableView
 * @param indexPath 索引
 *
 * @return 编辑样式
 */
- (AGTableViewCellStyle)AGTableView:(UITableView *)tableView editStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
/*!
 * @brief  获取每一行Cell对应的按钮集合
 *
 * @param tableView 父级tableView
 * @param indexPath 索引
 *
 * @return 该行Cell的按钮集合
 */
- (NSArray *)AGTableView:(UITableView *)tableView leftEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)AGTableView:(UITableView *)tableView rightEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 * @brief  每一行Cell的动作触发回调
 *
 * @param tableView 父级tableView
 * @param index     点击按钮集合的动作索引
 * @param indexPath 索引
 */
- (void)AGTableView:(UITableView *)tableView didSelectActionIndex:(NSInteger)index forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface AGTableViewCell : UITableViewCell

/*!
 * @brief  滑动过程中刷新动画的时间间隔，默认值是0.2s
 */
@property (nonatomic, assign) CGFloat dragAnimationDuration;

/**
 * @brief  重置动画的时长，默认值是0.3s
 */
@property (nonatomic, assign) CGFloat resetAnimationDuration;


@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, weak) id<AGTableViewCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withAG_Style:(AGTableViewCellStyle)ag_Style;
@end
