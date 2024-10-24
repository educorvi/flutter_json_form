- [ ] check for # and not # paths. I think weather the path starts with # or not, it is internally stored without. So the checks in some functions for # should be removed / if this is not possible, every place where a function want to work with a path which has # has to trim it first
- [ ] check for arrays in arrays and objects, there could still be errors
- [ ] array elements cant be moved right now
- [ ] strange state management

- [ ] showOn error: When field is dependent of a value of another field which is not shown, the other field is still shown. But the filed should not be shown
- [ ] Space between fields when they are not shown. There is space rendered which is not needed