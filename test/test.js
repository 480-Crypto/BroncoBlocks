var Test = artifacts.require("./test.sol");
contract('test', function(accounts) {
it("should assert true", function() {
var testcase;
return Test.deployed().then(function(instance){
testcase = instance;
return testcase.isWorking.call();
}).then(function(result) {
console.log("Program working. . .");
assert.isTrue(result);
});
});
});