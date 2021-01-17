// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import "MTLModel+Difference.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTLModel (Difference)

- (NSArray<NSString *> *)differenceFrom:(id)object {
  MTLModel *actual = (MTLModel *)object;

  NSAssert2([object isKindOfClass:self.class], @"Expected object of type %@, got : %@",
            self.class, [object class]);

  NSMutableArray<NSString *> *differences = [NSMutableArray array];
  for (NSString *key in self.class.propertyKeys) {
    id expectedValue = [self valueForKey:key];
    id actualValue = [actual valueForKey:key];

    BOOL valuesEqual = ((expectedValue == nil && actualValue == nil) || [expectedValue isEqual:actualValue]);
    if (!valuesEqual) {
      [differences addObject:[NSString stringWithFormat:@"%@:", key]];
      if ([expectedValue respondsToSelector:@selector(differenceFrom:)]) {
        NSArray<NSString *> *diffLines = [expectedValue differenceFrom:actualValue];
        for (NSString *line in diffLines) {
          [differences addObject:[NSString stringWithFormat:@"|\t%@", line]];
        }
      }
      else {
        [differences addObject:[NSString stringWithFormat:@"|\tExpected: %@", expectedValue]];
        [differences addObject:[NSString stringWithFormat:@"|\tActual\t: %@", actualValue]];
      }
    }
  }

  return differences.copy;
}

@end

NS_ASSUME_NONNULL_END
