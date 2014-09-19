//
//  ViewController.m
//  Terry Practice Core Data
//
//  Created by Aditya Narayan on 9/19/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myTableView.delegate = self;
    //remember this step, easy to forget why your tableView is not showing the right cells if you don't set the delegates here
    //also remember to actually populate the array above if you want stuff showing
    self.myTableView.dataSource = self;
    
    if(self){
        [self initModelContext];
        [self loadAllCelebs];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Core Data methods
-(void)initModelContext
{
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    [context setUndoManager:nil];
}


-(NSString*) archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"store.data"];
}

-(void) loadAllCelebs
{
    if(!self.celebs){
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //NSPredicate *p = [NSPredicate predicateWithFormat:@"emp_id >1"];
        //[request setPredicate:p];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Celeb"];
        [request setEntity:e];
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.celebs = [[NSMutableArray alloc]initWithArray:result];
        NSLog(@"Celebs Count %d", [self.celebs count]);
    }
    [self.myTableView reloadData];
}


-(void)deleteCeleb:(int)index
{
    Celeb *celeb = [self.celebs objectAtIndex:index];
    [context deleteObject:celeb];
    [self saveChanges];
    
    [self.celebs removeObjectAtIndex:index];
    [self.myTableView reloadData];
}

#pragma mark IBAction methods

- (IBAction)addButton:(id)sender {
    [self createCeleb:[NSNumber numberWithInteger:self.celebs.count]
                 name:self.nameField.text age:@([self.ageField.text intValue]) ];
}

-(void)createCeleb:(NSNumber*)celeb_id name:(NSString*)name age:(NSNumber*)age;
{
    Celeb *celeb = [NSEntityDescription insertNewObjectForEntityForName:@"Celeb" inManagedObjectContext:context];
    
    celeb.celeb_id = celeb_id;
    celeb.name = name;
    celeb.age = age;
    //    [celeb setEmp_location:age];
    [self saveChanges];
    [self.celebs addObject:celeb];
    [self.myTableView reloadData];
}

-(void) saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
}




#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.celebs.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    Celeb *celeb = [self.celebs objectAtIndex:[indexPath row]];
    cell.textLabel.text = celeb.name;
    cell.detailTextLabel.text = [celeb.age stringValue];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) tableView: (UITableView *)tableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteCeleb:indexPath.row];
}






@end
