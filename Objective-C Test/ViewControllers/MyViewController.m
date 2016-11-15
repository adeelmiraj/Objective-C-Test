//
//  MyViewController.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "MyViewController.h"
#import "ContactsManager.h"

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Contact *contact = self.dataSource[indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.number;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[ContactsManager sharedManager]
     contactsWithSameFirstName:^(NSMutableArray *contacts, NSError *error) {
         
         for (CNContact *contact in contacts) {
             
             Contact *unifiedContact = [[Contact alloc] initWithContact:contact];
             [self.dataSource addObject:unifiedContact];
         }
         
         [self.tableView reloadData];
     }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Contact *contact = self.dataSource[indexPath.row];
        [[ContactsManager sharedManager] deleteContactWithIdentifier:contact.identifier];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapBarItem:(UIBarButtonItem *)sender {
    
    [[ContactsManager sharedManager] getContacts:^(NSMutableArray *contacts, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.dataSource = contacts;
                [self.tableView reloadData];
            });
        }
    }];
}

@end
