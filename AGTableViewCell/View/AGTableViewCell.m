//
//  AGTableViewCell.m
//  AGTableViewCell
//
//  Created by Agenric on 15/9/22.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#define kLog(flag) NSLog(@"%@--%@",(flag),NSStringFromCGPoint([[touches anyObject] locationInView:self.tableView]));
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "AGTableViewCell.h"
#import "UIView+LecarxCategory.h"

@interface AGTableViewCell ()
{
    BOOL _isMoving;
    BOOL _hasMoved;
}
@property (nonatomic, strong) NSMutableArray *rightActionButtons;

@property (nonatomic, assign) CGFloat touchBeganPointX;
@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation AGTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView setBackgroundColor:[UIColor grayColor]];
        self.tableView = tableView;
        self.touchBeganPointX = 0.0f;
        self.dragAnimationDuration = 0.2f;
        self.resetAnimationDuration = 0.3f;
        self.isEditing = NO;
        _isMoving = NO;
        _hasMoved = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if(_isMoving) {
        return;
    }
    [super layoutSubviews];
    
    [self getActionsArray];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    kLog(@"touchesBegan");
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        if (touch.phase == UITouchPhaseBegan) {
            if (self.contentView.left == 0.0f) {
            }
            self.touchBeganPointX = [touch locationInView:touch.view].x;
            _isMoving = YES;
        }
    } else {
        [super touchesEnded:touches withEvent:event];
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled) {
            self.tableView.scrollEnabled = YES;
            [super touchesMoved:touches withEvent:event];
            return;
        }
        else if (touch.phase == UITouchPhaseMoved) {
            self.tableView.scrollEnabled = NO;
            _hasMoved = YES;
            _isEditing = YES;
            
            CGFloat currentLocationX = [touch locationInView:self.tableView].x;
            CGFloat distance = (self.touchBeganPointX - currentLocationX) * 1.1;
            
            if (distance > 0) { // 向左拉
                CGFloat button_addWidth = (distance - (ScreenWidth / 2.0)) / self.rightActionButtons.count;
                [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                    self.contentView.left = -distance;
                    CGFloat t_dis = distance;
                    
                    for (AGTableViewRowAction *action in self.rightActionButtons) {
                        if (distance > ScreenWidth / 2.0f) {
                            if (currentLocationX < 50) {
                                action.left = ScreenWidth - distance;
                                action.width = distance;
                            } else {
                                action.left = ScreenWidth - t_dis;
                                action.width = self.buttonWidth + button_addWidth;
                            }
                        } else  {
                            action.left = ScreenWidth - t_dis;
                        }
                        t_dis = t_dis - distance / self.rightActionButtons.count;
                    }
                }];
            }
            else { // 向右拉
                NSLog(@"向右拉");
            }
        }
        else {
            [super touchesEnded:touches withEvent:event];
        }
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    kLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    kLog(@"touchesEnded");
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        if (touch.tapCount > 1) {
            [super touchesEnded:touches withEvent:event];
            return;
        }
        if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled) {
            CGFloat currentLocationX = [touch locationInView:self.tableView].x;
            CGFloat previousLocationX = [touch previousLocationInView:self.tableView].x;
            AGTableViewRowAction *rightAction = [self.rightActionButtons lastObject];
            if (rightAction.width > ScreenWidth / 2.0f) {
                [UIView animateWithDuration:0.1f animations:^{
                    self.contentView.left = -ScreenWidth;
                    rightAction.left = 0.0f;
                    rightAction.width = ScreenWidth;
                } completion:^(BOOL finished) {
                    [self rightActionDidSelected:rightAction];
                }];
                return;
            }
            
            if (fabs(previousLocationX - currentLocationX) < 3.0f) {
                if (!_isEditing) {
                    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
                    return;
                }
                
                if (self.contentView.left < -ScreenWidth / 2.0f) {
                    if (!_hasMoved) {
                        return;
                    }
                    [self resetButtonsToDisplayPosition];
                } else {
                    [self resetButtonsToOriginPosition];
                }
            } else {
                if (self.contentView.left > ScreenWidth / 2.0f) {
                    [self resetButtonsToOriginPosition];
                } else {
                    if (!_hasMoved) {
                        return;
                    }
                    [self resetButtonsToDisplayPosition];
                }
            }
        }
    } else {
        [super touchesEnded:touches withEvent:event];
        return;
    }
}

- (void)resetButtonsToDisplayPosition {
    [UIView animateWithDuration:self.resetAnimationDuration animations:^{
        self.contentView.left = -ScreenWidth / 2.0;
        
        CGFloat buttonWidth = (ScreenWidth / 2) / self.rightActionButtons.count;
        CGFloat t_dis = ScreenWidth / 2.0;
        for (AGTableViewRowAction *action in self.rightActionButtons) {
            action.left = t_dis;
            t_dis += buttonWidth;
        }
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled = YES;
        _isMoving = NO;
        _hasMoved = YES;
        _isEditing = YES;
    }];
}

- (void)resetButtonsToOriginPosition {
    [UIView animateWithDuration:self.resetAnimationDuration animations:^{
        self.contentView.left = 0.0f;
        
        for (AGTableViewRowAction *action in self.rightActionButtons) {
            action.left = ScreenWidth;
        }
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled = YES;
        _isMoving = NO;
        _hasMoved = NO;
        _isEditing = NO;
    }];
}

- (void)rightActionDidSelected:(AGTableViewRowAction *)action {
    self.indexPath = [self.tableView indexPathForCell:self];
    if([self.delegate respondsToSelector:@selector(AGTableView:didSelectActionIndex:forRowAtIndexPath:)])
    {
        [self.delegate AGTableView:self.tableView didSelectActionIndex:action.index forRowAtIndexPath:self.indexPath];
    }
}

#pragma mark - getActionsArray
- (void)getActionsArray {
    self.indexPath = [self.tableView indexPathForCell:self];
    if ([self.delegate respondsToSelector:@selector(AGTableView:editActionsForRowAtIndexPath:)]) {
        self.rightActionButtons = [[self.delegate AGTableView:self.tableView editActionsForRowAtIndexPath:self.indexPath] mutableCopy];
        CGFloat buttonWidth = (ScreenWidth / 2.0f) / self.rightActionButtons.count;
        self.buttonWidth = buttonWidth;
        for (AGTableViewRowAction *action in self.rightActionButtons) {
            action.frame = CGRectMake(ScreenWidth, 0.0f, buttonWidth, self.height);
            [action addTarget:self action:@selector(rightActionDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:action];
        }
    }}
@end
