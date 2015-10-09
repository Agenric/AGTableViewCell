# AGTableViewCell
---
> 模仿iOS8.0邮件中侧滑效果

### 使用方法
---
* 创建可复用的AGTableViewCell

    ```- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:    (NSString *)reuseIdentifier inTableView:(UITableView *)tableView;```
* 实现AGTableViewCell的代理方法 - 获得每一行Cell对应的按钮集合

    ```- (NSArray *)AGTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;```


