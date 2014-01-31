//
//  HISSidebarViewController.m
//  Github To Go
//
//  Created by Tim Hise on 1/27/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISSidebarViewController.h"
#import "HISNetworkController.h"

@interface HISSidebarViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIViewController *topViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchOptions;
@property (strong, nonatomic) NSString *selectedSearchType;

@end

@implementation HISSidebarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchOptions = @[@"Repos", @"Users"];
    self.selectedSearchType = self.searchOptions[0];
    
    [self selectChildViewController];
}

- (void)selectChildViewController
{
    if (self.topViewController) {
        [self.topViewController.view removeFromSuperview];
        [self.topViewController removeFromParentViewController];
    }
    if ([self.selectedSearchType isEqualToString:@"Repos"]) {
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Repos"];
        [self addAndConfigureChildViewController];
        [self openMenu];
        [self closeMenu:nil];
    }
    if ([self.selectedSearchType isEqualToString:@"Users"]) {
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Users"];
        [self addAndConfigureChildViewController];
        [self openMenu];
        [self closeMenu:nil];
    }
}

- (void)addAndConfigureChildViewController
{
    [self addChildViewController:self.topViewController];
    self.topViewController.view.frame = self.view.frame;
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    [self setupPanGesture];
    [self giveShadowToViewController:self.topViewController];
}

- (void)giveShadowToViewController:(UIViewController *)ViewCon
{
    [ViewCon.view.layer setShadowOpacity:0.4];
    [ViewCon.view.layer setShadowOffset:CGSizeMake(-3, 0)];
    [ViewCon.view.layer setShadowColor:[UIColor blackColor].CGColor];
}

- (void)setupPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    panGesture.delegate = self;
    
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    
    [self.topViewController.view addGestureRecognizer:panGesture];
}

- (void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
    
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translation = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.topViewController.view.frame.origin.x + translation.x >= 0) {
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
        }
    }
    [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
            [self openMenu];
        }
        if (self.topViewController.view.frame.origin.x <= self.view.frame.size.width / 3 ) {
            [self closeMenu:nil];
        }
    }
}

- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .85, self.topViewController.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
        [self.topViewController.view  addGestureRecognizer:tap];
    }];
}

- (void)closeMenu:(id)sender
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.topViewController.view removeGestureRecognizer:(UIGestureRecognizer *)sender];
    }];
}

#pragma mark - Search Bar

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSArray *items = [[HISNetworkController sharedController]reposForSearchString:searchBar.text];
//    self.searchResults = items;
//    
//    [self.tableView reloadData];
//    
//    [self.searchBar resignFirstResponder];
//}

#pragma mark - Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    NSDictionary *dictionary = [self.searchResults objectAtIndex:indexPath.row];

    cell.textLabel.text = self.searchOptions[indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return self.searchOptions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSearchType = self.searchOptions[indexPath.row];
    [self selectChildViewController];
}

#pragma mark - Segue

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
////    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//
//    UIViewController *destinationVC = (H)segue.destinationViewController;
//    destinationVC =
//}

@end
