//
//  HISMasterViewController.m
//  Github To Go
//
//  Created by Tim Hise on 1/27/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISMasterViewController.h"
#import "HISNetworkController.h"
#import "HISDetailViewController.h"

@interface HISMasterViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSString *searchTerm;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) NSString *searchType;

@end

@implementation HISMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (!self.searchType) {
//        self.searchType = @"Repos";
//    }
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (HISDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.searchBar setDelegate:self];
    self.searchBar.placeholder = @"Search Github";
    
}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = [[HISNetworkController sharedController]reposForSearchString:searchBar.text];
    [self.tableView reloadData];

    [self.searchBar resignFirstResponder];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *repoItem = self.searchResults[indexPath.row];
    cell.textLabel.text = [repoItem objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *repoDictionary = [self.searchResults objectAtIndex:indexPath.row];
        NSString *repoString = [repoDictionary objectForKey:@"html_url"];
        NSURL *url = [NSURL URLWithString:repoString];
        
        self.detailViewController.detailItem = url;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[HISDetailViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *repoDictionary = [self.searchResults objectAtIndex:indexPath.row];
        NSString *repoString = [repoDictionary objectForKey:@"html_url"];
        NSURL *url = [NSURL URLWithString:repoString];
        
        HISDetailViewController *destVC = (HISDetailViewController *)segue.destinationViewController;
        destVC.detailItem = url;
    }
}

@end
