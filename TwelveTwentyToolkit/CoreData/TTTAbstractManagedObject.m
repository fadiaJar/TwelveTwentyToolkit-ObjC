#import "TTTAbstractManagedObject.h"

@implementation TTTAbstractManagedObject

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[(id) self entityName]];
    request.fetchBatchSize = 100;

    if (sortingKeysWithAscendingFlag)
    {
        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [sortingKeysWithAscendingFlag enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *ascending, BOOL *stop) {
            [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[ascending boolValue]]];
        }];

        request.sortDescriptors = sortDescriptors;
    }

    request.returnsObjectsAsFaults = YES;
    request.includesPendingChanges = NO;

    return request;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName
{
    NSFetchRequest *request = [self fetchRequestWithSortingKeys:sortingKeysWithAscendingFlag];

    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:cacheName];

    return controller;
}

@end