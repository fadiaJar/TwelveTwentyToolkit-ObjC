// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSManagedObjectContext+TTTBatchManipulation.h"
#import "NSPredicate+TTTConvenience.h"

@implementation NSManagedObjectContext (TTTBatchManipulation)

- (NSArray *)tttAllEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [request setEntity:entity];

    if (sortKey != nil)
    {
        NSSortDescriptor *sortByKey = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
        [request setSortDescriptors:[NSArray arrayWithObject:sortByKey]];
    }

    NSError *error = nil;
    NSArray *result = [self executeFetchRequest:request error:&error];

    if (result == nil)
    {
        NSLog(@"Failed to fetch entities named '%@' due to: %@", entityName, error);
    }

    return result;
}


- (BOOL)tttSetValue:(id)value forKey:(NSString *)key onEntitiesWithName:(NSString *)entityName error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results) return NO;

    for (NSManagedObject *object in results)
    {
        [object setValue:value forKey:key];
    }

    return YES;
}

- (NSInteger)tttDeleteEntitiesNamed:(NSString *)entityName withValue:(id)value forKey:(NSString *)key error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate tttPredicateWithComplexFormat:@"%@ == %%@" innerArguments:@[key] outerArguments:@[value]];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTDeleteFailed;
    }

    NSUInteger count = [results count];
    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return count;
}

- (NSInteger)tttDeleteEntitiesNamed:(NSString *)entityName withNoRelationshipForKey:(NSString *)key error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSRelationshipDescription *relationshipDescription = entityDescription.relationshipsByName[key];
    if (relationshipDescription.isToMany)
    {
        request.predicate = [NSPredicate tttPredicateWithComplexFormat:@"%@ == nil || %@.@count == 0" innerArguments:@[key, key] outerArguments:nil];
    }
    else
    {
        request.predicate = [NSPredicate tttPredicateWithComplexFormat:@"%@ == nil" innerArguments:@[key] outerArguments:nil];
    }

    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTDeleteFailed;
    }

    NSUInteger count = [results count];
    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return count;
}

- (NSInteger)tttDeleteAllEntitiesNamed:(NSString *)entityName error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTDeleteFailed;
    }

    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return [results count];
}

@end