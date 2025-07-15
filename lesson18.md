https://gist.github.com/extropyCoder/348528075d856da66f7cedcc7c48226a

issues:
1. the address role is not set, hence is just zero, onlyAdmin modifier can never be satified hence makePayout cant be called
2. use of tx.origin is not safe
3. msg.value == 2 means a person just need 2 Wei instead of 1ETH to join
4. numberInvestors is not incremented in addInvestor