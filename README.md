# AGTableViewCell
Simulate iOS8.0 mail skidding to delete messages.

## Usage
* Create can reusable AGTableViewCell

    ```- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:    (NSString *)reuseIdentifier inTableView:(UITableView *)tableView;```
* Implement proxy method for AGTableViewCell - Get a set of buttons for each row of Cell

    ```- (NSArray *)AGTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;```


