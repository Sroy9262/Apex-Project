@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testWarehouseCalloutService() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        Test.startTest();
        WarehouseCalloutService.func();
        Test.stopTest();
        
        System.assertEquals(1, [SELECT COUNT() FROM Product2]);
    }
}